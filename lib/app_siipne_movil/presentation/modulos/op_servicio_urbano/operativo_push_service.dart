import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'operativo_push_identity.dart';
import 'consulta_persona_push_guard.dart';

class OperativoPushService {
  OperativoPushService._();
  static final OperativoPushService instance = OperativoPushService._();

  static const String _keyOperativo = 'siipne_push_operativo_activo';
  static const String _key = 'siipne_push_topics_pendientes';
  static const String _channelId = 'alertas_operativo_v2';
  static const String _channelName = 'Alertas críticas del operativo';
  static const Duration _duracionAlertaCritica = Duration(seconds: 4);

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    _channelId,
    _channelName,
    description: 'Alertas críticas de boletas y vehículos robados',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    enableLights: true,
  );

  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final ValueNotifier<String> estado = ValueNotifier<String>('Notificaciones sin activar');
  final ValueNotifier<Map<String, dynamic>?> aperturaPendiente = ValueNotifier<Map<String, dynamic>?>(null);

  /// Mientras este valor sea diferente de null, la interfaz puede mostrar
  /// una alerta visual roja sobre el operativo.
  final ValueNotifier<Map<String, dynamic>?> alertaCritica = ValueNotifier<Map<String, dynamic>?>(null);

  final Set<String> _vistos = <String>{};
  final ConsultaPersonaPushGuard consultasPersona = ConsultaPersonaPushGuard();
  final Set<String> _topics = <String>{};

  Future<void>? _init;
  Future<void> _cola = Future<void>.value();
  StreamSubscription<RemoteMessage>? _mensajes;
  StreamSubscription<RemoteMessage>? _aperturas;
  StreamSubscription<String>? _tokens;
  Timer? _retry;
  Timer? _timerAlertaCritica;

  int _deseado = 0;
  bool _storageLista = false;
  bool _sesionResuelta = false;
  String _confirmado = '';

  bool get compatible =>
      !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> inicializar() => _init ??= _inicializar().catchError((Object e) {
    _init = null;
    throw e;
  });

  Future<void> _inicializar({bool segundoPlano = false}) async {
    if (!compatible) return;

    await _cargarTopics();
    if (segundoPlano) {
      _deseado = int.tryParse(await _storage.read(key: _keyOperativo) ?? '') ?? 0;
      _sesionResuelta = true;
    }

    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_operativo'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: _procesarRespuestaNotificacion,
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      await _local
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }

    if (segundoPlano) return;

    /*
     * Evitamos que Firebase muestre automáticamente una segunda notificación
     * cuando la aplicación está en primer plano.
     * La notificación visible la controla _mostrar().
     */
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    await _procesarAperturaInicial();

    _mensajes ??= FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (kDebugMode) {
        debugPrint('[PUSH] MENSAJE RECIBIDO');
        debugPrint('[PUSH] messageId: ${message.messageId}');
        debugPrint('[PUSH] idHdrEvento: ${message.data['idHdrEvento']}');
        debugPrint('[PUSH] tipo: ${message.data['tipo']}');
        debugPrint('[PUSH] alertaId: ${message.data['alertaId']}');
      }

      try {
        await _mostrar(message);
      } catch (e, stackTrace) {
        estado.value = 'Error mostrando la notificación';
        debugPrint('[PUSH] Error en _mostrar: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
    });

    _aperturas ??= FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      aperturaPendiente.value = <String, dynamic>{
        ...message.data,
        '_pushId': operativoPushIdentity(message),
      };
    });

    _tokens ??= FirebaseMessaging.instance.onTokenRefresh.listen(
          (_) {
        _confirmado = '';
        unawaited(_programar());
      },
      onError: (Object e) {
        estado.value = 'No se pudo actualizar el token push';
        debugPrint('[PUSH] Error actualizando token: $e');
      },
    );

    _retry?.cancel();
    _retry = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(_programar());
    });
  }

  void _procesarRespuestaNotificacion(NotificationResponse response) {
    final String? payload = response.payload;
    if (payload == null || payload.trim().isEmpty) return;

    try {
      final dynamic decoded = jsonDecode(payload);
      if (decoded is Map) {
        aperturaPendiente.value = Map<String, dynamic>.from(decoded);
      }
    } catch (e) {
      debugPrint('[PUSH] No se pudo interpretar el payload: $e');
    }
  }

  Future<void> _procesarAperturaInicial() async {
    final RemoteMessage? initial = await FirebaseMessaging.instance.getInitialMessage();

    if (initial != null) {
      aperturaPendiente.value = <String, dynamic>{
        ...initial.data,
        '_pushId': operativoPushIdentity(initial),
      };
    }

    final NotificationAppLaunchDetails? launch = await _local.getNotificationAppLaunchDetails();
    final String? payload = launch?.notificationResponse?.payload;

    if (launch?.didNotificationLaunchApp == true &&
        payload != null &&
        payload.trim().isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(payload);
        if (decoded is Map) {
          aperturaPendiente.value = Map<String, dynamic>.from(decoded);
        }
      } catch (e) {
        debugPrint('[PUSH] Error procesando notificación inicial: $e');
      }
    }
  }

  Future<void> _cargarTopics() async {
    _storageLista = false;

    final String? raw = await _storage.read(key: _key);
    final Set<String> guardados = <String>{};

    if (raw != null && raw.trim().isNotEmpty) {
      final dynamic decoded = jsonDecode(raw);

      if (decoded is! List || decoded.any((dynamic item) => item is! String)) {
        throw const FormatException('Formato inválido de topics guardados');
      }

      guardados.addAll(decoded.cast<String>());
    }

    _topics
      ..clear()
      ..addAll(guardados);

    _storageLista = true;
  }

  Future<void> _guardarTopics() async {
    await _storage.write(
      key: _key,
      value: jsonEncode(_topics.toList()),
    );
  }

  Future<void> activarOperativo(int idHdrEvento) async {
    if (idHdrEvento <= 0) throw ArgumentError.value(idHdrEvento, 'idHdrEvento');

    _deseado = idHdrEvento;
    _sesionResuelta = true;
    String etapa = 'inicialización';

    try {
      debugPrint('[PUSH] Iniciando operativo_$idHdrEvento');
      if (compatible) {
        await _storage.write(key: _keyOperativo, value: '$idHdrEvento');
      }
      await inicializar();

      if (!compatible) {
        estado.value = 'Push disponible únicamente en Android/iOS';
        return;
      }

      etapa = 'permisos';
      final bool autorizado = await solicitarPermisoNotificaciones();

      if (!autorizado) {
        estado.value = 'Notificaciones no autorizadas';
        debugPrint('[PUSH] Permiso no autorizado');
        return;
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        etapa = 'registro APNs';

        final String? apnsToken = await _esperarTokenApns();

        if (apnsToken == null) {
          estado.value = 'Esperando registro APNs';
          debugPrint('[PUSH][iOS] APNs token todavía no disponible');
          return;
        }

        debugPrint('[PUSH][iOS] APNs disponible: SI');
      }

      etapa = 'sincronización del topic';
      await _programar();

      if (kDebugMode) {
        final String? token = await FirebaseMessaging.instance.getToken();
        debugPrint('[PUSH] FCM TOKEN: ${token != null && token.isNotEmpty ? 'DISPONIBLE' : 'NO DISPONIBLE'}');
        debugPrint('[PUSH] ESTADO FINAL: ${estado.value}');
      }
    } catch (e, stackTrace) {
      estado.value = 'Error push en $etapa';
      debugPrint('[PUSH] ERROR EN $etapa: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<String?> _esperarTokenApns({
    Duration timeout = const Duration(seconds: 8),
  }) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return '';

    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final DateTime limite = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(limite)) {
      try {
        final String? token = await messaging.getAPNSToken();

        if (token != null && token.trim().isNotEmpty) {
          return token;
        }
      } catch (e) {
        debugPrint('[PUSH][iOS] Error consultando APNs: $e');
      }

      await Future.delayed(const Duration(milliseconds: 400));
    }

    return null;
  }
  /// Ejecutar al abandonar/finalizar el operativo o cerrar sesión.
  Future<void> salirOperativo() async {
    _deseado = 0;
    _sesionResuelta = true;
    consultasPersona.limpiar();

    aperturaPendiente.value = null;
    limpiarAlertaCritica();

    try {
      if (compatible) await _storage.delete(key: _keyOperativo);
      await inicializar();
      _vistos.clear();
      await _local.cancelAll();
      await _programar();
    } catch (e) {
      estado.value = 'Baja push pendiente; se reintentará';
      debugPrint('[PUSH] Error saliendo del operativo: $e');
    }
  }

  Future<void> _programar() {
    _cola = _cola.then((_) => _sincronizar()).catchError(
          (Object e, StackTrace stackTrace) {
        estado.value = 'Sincronización push pendiente; se reintentará';
        debugPrint('[PUSH] ERROR SINCRONIZANDO TOPIC: $e');
        debugPrintStack(stackTrace: stackTrace);
      },
    );

    return _cola;
  }

  Future<void> _sincronizar() async {
    if (!compatible || !_storageLista || !_sesionResuelta) return;

    final String target = _deseado > 0 ? 'operativo_$_deseado' : '';
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final String? apnsToken = await messaging.getAPNSToken();

      if (apnsToken == null) {
        estado.value = 'Esperando registro APNs';
        return;
      }
    }

    for (final String topic in _topics.toList()) {
      if (topic == target) continue;

      await messaging.unsubscribeFromTopic(topic);
      _topics.remove(topic);
      await _guardarTopics();
    }

    if (target.isEmpty) {
      _confirmado = '';
      estado.value = 'Sin operativo suscrito';
      return;
    }

    if (_confirmado == target) return;

    _topics.add(target);
    await _guardarTopics();

    try {
      await messaging.subscribeToTopic(target);
      _confirmado = target;
      estado.value = 'Suscrito a $target';
    } catch (_) {
      /*
       * Se mantiene el topic localmente para que el reintento pueda
       * sincronizarlo posteriormente.
       */
      rethrow;
    }
  }

  /// Se ejecuta en el isolate de Firebase para mensajes operativos solo data.
  Future<void> mostrarEnSegundoPlano(RemoteMessage message) async {
    if (!compatible || message.notification != null) return;
    await _inicializar(segundoPlano: true);
    await _mostrar(message, segundoPlano: true);
  }

  Future<void> _mostrar(RemoteMessage message, {bool segundoPlano = false}) async {
    final Map<String, dynamic> data =
    Map<String, dynamic>.from(message.data);

    if (_deseado <= 0 ||
        data['idHdrEvento']?.toString() != '$_deseado') {
      return;
    }

    final String tipo =
        data['tipo']?.toString().trim().toUpperCase() ?? '';

    if (tipo != 'BOLETA' && tipo != 'VEHICULO_ROBADO') {
      return;
    }

    if (!await consultasPersona.permitirAlerta(data)) return;
    // La sesión puede cambiar mientras esperamos la respuesta HTTP.
    if (_deseado <= 0 || data['idHdrEvento']?.toString() != '$_deseado') return;

    final String key = operativoPushIdentity(message);
    data['_pushId'] = key;

    if (!_vistos.add(key)) {
      return;
    }

    try {
      final int id = _generarIdNotificacion(key);

      final String tituloRecibido =
          message.notification?.title?.trim() ?? data['title']?.toString().trim() ?? '';

      final String mensajeRecibido =
          message.notification?.body?.trim() ?? data['body']?.toString().trim() ?? '';

      final String titulo = tituloRecibido.isNotEmpty
          ? tituloRecibido
          : _tituloPorTipo(tipo);

      final String mensaje = mensajeRecibido.isNotEmpty
          ? mensajeRecibido
          : _mensajePorTipo(tipo, data);

      /*
       * Activa el overlay rojo de la aplicación.
       * Solo se visualizará si la UI está actualmente disponible.
       */
      if (!segundoPlano) {
        _activarAlertaCritica(data: data, titulo: titulo, mensaje: mensaje);
      }

      await _local.show(
        id: id,
        title: titulo,
        body: mensaje,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription:
            'Alertas críticas de boletas y vehículos robados',
            importance: Importance.max,
            priority: Priority.max,
            visibility: NotificationVisibility.public,
            icon: 'ic_stat_operativo',
            tag: key,
            playSound: true,
            enableVibration: true,
            enableLights: true,
            vibrationPattern: Int64List.fromList(
              <int>[0, 500, 200, 500, 200, 800],
            ),
            styleInformation: BigTextStyleInformation(
              mensaje,
              contentTitle: titulo,
            ),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(data),
      );

      if (_vistos.length > 300) {
        _vistos.remove(_vistos.first);
      }
    } catch (e) {
      _vistos.remove(key);
      debugPrint('[PUSH] Error mostrando alerta: $e');
      rethrow;
    }
  }

  int _generarIdNotificacion(String key) {
    int id = 0;

    for (final int c in key.codeUnits) {
      id = ((id * 31) + c) & 0x7fffffff;
    }

    return id == 0 ? 1 : id;
  }

  String _tituloPorTipo(String tipo) {
    switch (tipo) {
      case 'VEHICULO_ROBADO':
        return 'ALERTA · VEHÍCULO';
      case 'BOLETA':
        return 'ALERTA · PERSONA';
      default:
        return 'Operativo #$_deseado · Alerta';
    }
  }

  String _mensajePorTipo(
      String tipo,
      Map<String, dynamic> data,
      ) {
    if (tipo == 'VEHICULO_ROBADO') {
      final String placa =
          data['placa']?.toString().trim().toUpperCase() ?? '';

      return placa.isNotEmpty
          ? 'Vehículo $placa registra una alerta. Revise la información.'
          : 'Se registró una alerta de vehículo durante el operativo.';
    }

    final String cedula =
        data['cedula']?.toString().trim() ?? '';

    return cedula.isNotEmpty
        ? 'La persona $cedula registra una alerta. Revise la información.'
        : 'Se registró una alerta de persona durante el operativo.';
  }

  void _activarAlertaCritica({
    required Map<String, dynamic> data,
    required String titulo,
    required String mensaje,
  }) {
    _timerAlertaCritica?.cancel();

    final Map<String, dynamic> alerta = <String, dynamic>{
      ...data,
      '_titulo': titulo,
      '_mensaje': mensaje,
      '_fechaRecepcion': DateTime.now().toIso8601String(),
    };

    alertaCritica.value = alerta;

    _timerAlertaCritica = Timer(
      _duracionAlertaCritica,
          () {
        if (identical(alertaCritica.value, alerta)) {
          alertaCritica.value = null;
        }
      },
    );
  }

  void limpiarAlertaCritica() {
    _timerAlertaCritica?.cancel();
    _timerAlertaCritica = null;
    alertaCritica.value = null;
  }

  void limpiarAperturaPendiente() {
    aperturaPendiente.value = null;
  }

  Future<String?> obtenerTokenDispositivo() async {
    if (!compatible) return null;

    try {
      final FirebaseMessaging messaging =
          FirebaseMessaging.instance;

      final NotificationSettings settings =
      await messaging.getNotificationSettings();

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        estado.value = 'Notificaciones no autorizadas';
        return null;
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final String? apnsToken = await messaging.getAPNSToken();

        if (apnsToken == null) {
          estado.value =
          'Esperando registro APNs; vuelva a intentar';
          return null;
        }
      }

      final String? token = await messaging.getToken();

      if (token == null || token.isEmpty) {
        estado.value = 'No se pudo obtener el token FCM';
        return null;
      }

      return token;
    } catch (e) {
      debugPrint('[PUSH] Error obteniendo token FCM: $e');
      return null;
    }
  }

  Future<bool> solicitarPermisoNotificaciones() async {
    if (!compatible) return true;

    try {
      final FirebaseMessaging messaging =
          FirebaseMessaging.instance;

      final NotificationSettings actual =
      await messaging.getNotificationSettings();

      if (actual.authorizationStatus == AuthorizationStatus.authorized ||
          actual.authorizationStatus == AuthorizationStatus.provisional) {
        return true;
      }

      if (actual.authorizationStatus == AuthorizationStatus.denied) {
        estado.value = 'Permiso de notificaciones denegado';
        return false;
      }

      final NotificationSettings permission =
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final bool autorizado =
          permission.authorizationStatus == AuthorizationStatus.authorized ||
              permission.authorizationStatus == AuthorizationStatus.provisional;

      estado.value = autorizado
          ? 'Notificaciones activadas'
          : 'Permiso de notificaciones denegado';

      return autorizado;
    } catch (e) {
      debugPrint('[PUSH] Error solicitando permiso: $e');
      return false;
    }
  }

  Future<void> probarNotificacionLocal() async {
    if (!kDebugMode || !compatible) return;

    try {
      await inicializar();

      final bool autorizado =
      await solicitarPermisoNotificaciones();

      if (!autorizado) {
        debugPrint('[PUSH PRUEBA] Permiso no disponible');
        return;
      }

      final Map<String, dynamic> data = <String, dynamic>{
        'idHdrEvento': '$_deseado',
        'tipo': 'BOLETA',
        'alertaId':
        'PRUEBA_${DateTime.now().millisecondsSinceEpoch}',
        'cedula': 'PRUEBA',
      };

      _activarAlertaCritica(
        data: data,
        titulo: 'PRUEBA · ALERTA OPERATIVA',
        mensaje:
        'Prueba de visualización y vibración. No corresponde a una alerta real.',
      );

      await _local.show(
        id: 990001,
        title: 'PRUEBA · ALERTA OPERATIVA',
        body:
        'Prueba de visualización y vibración. No corresponde a una alerta real.',
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription:
            'Alertas críticas de boletas y vehículos robados',
            importance: Importance.max,
            priority: Priority.max,
            visibility: NotificationVisibility.public,
            icon: 'ic_stat_operativo',
            playSound: true,
            enableVibration: true,
            enableLights: true,
            vibrationPattern: Int64List.fromList(
              <int>[0, 500, 200, 500, 200, 800],
            ),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(data),
      );

      debugPrint(
        '[PUSH PRUEBA] Notificación local enviada correctamente',
      );
    } catch (e, stackTrace) {
      debugPrint('[PUSH PRUEBA] ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void dispose() {
    consultasPersona.limpiar();
    unawaited(_mensajes?.cancel());
    unawaited(_aperturas?.cancel());
    unawaited(_tokens?.cancel());
    _retry?.cancel();
    _timerAlertaCritica?.cancel();

    _retry = null;
    _timerAlertaCritica = null;

    estado.dispose();
    aperturaPendiente.dispose();
    alertaCritica.dispose();
  }
}
