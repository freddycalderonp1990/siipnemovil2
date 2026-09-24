import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Android/iOS. Inicializar una sola vez después de Firebase.initializeApp().
// API de flutter_local_notifications 19.5.0.
class OperativoPushService {
  OperativoPushService._();
  static final instance = OperativoPushService._();
  static const _key = 'siipne_push_topics_pendientes';
  static const _channel = AndroidNotificationChannel(
    'alertas_operativo',
    'Alertas del operativo',
    description: 'Avisos de boletas y vehículos robados',
    importance: Importance.max,
  );
  final _local = FlutterLocalNotificationsPlugin();
  final estado = ValueNotifier<String>('Notificaciones sin activar');
  final aperturaPendiente = ValueNotifier<Map<String, dynamic>?>(null);
  final Set<String> _vistos = <String>{};
  final Set<String> _topics = <String>{};
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _storageLista = false;
  Future<void>? _init;
  Future<void> _cola = Future<void>.value();
  int _deseado = 0;
  bool _sesionResuelta = false;
  Timer? _retry;
  bool get compatible =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  Future<void> inicializar() => _init ??= _inicializar().catchError((Object e) {
    _init = null;
    throw e;
  });
  Future<void> _inicializar() async {
    if (!compatible) return;
    await _cargarTopics();
    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_operativo'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        try {
          final decoded = jsonDecode(payload);
          if (decoded is Map) {
            aperturaPendiente.value = Map<String, dynamic>.from(decoded);
          }
        } catch (_) {
          debugPrint('No se pudo interpretar el contenido de la notificación');
        }
      },
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
    // En primer plano mostramos una sola notificación local también en iOS.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: false,
          badge: false,
          sound: false,
        );
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) aperturaPendiente.value = initial.data;
    final launch = await _local.getNotificationAppLaunchDetails();
    final payload = launch?.notificationResponse?.payload;
    if (launch?.didNotificationLaunchApp == true && payload != null) {
      try {
        aperturaPendiente.value = Map<String, dynamic>.from(
          jsonDecode(payload) as Map,
        );
      } catch (_) {}
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
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
        if (kDebugMode) {
          debugPrint('[PUSH] Error en _mostrar: $e');
          debugPrint('$stackTrace');
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      aperturaPendiente.value = message.data;
    });
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (_) {
        _confirmado = '';
        unawaited(_programar());
      },
      onError: (Object e) {
        estado.value = 'No se pudo actualizar el token push';
      },
    );
    // Reintenta altas/bajas fallidas por desconexión o APNs aún no disponible.
    _retry?.cancel();
    _retry = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(_programar());
    });
  }

  Future<void> _cargarTopics() async {
    _storageLista = false;
    final raw = await _storage.read(key: _key);
    final Set<String> guardados = <String>{};
    if (raw != null) {
      final decoded = jsonDecode(raw);
      if (decoded is! List || decoded.any((item) => item is! String)) {
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
    await _storage.write(key: _key, value: jsonEncode(_topics.toList()));
  }

  Future<void> activarOperativo(int idHdrEvento) async {
    if (idHdrEvento <= 0) {
      throw ArgumentError.value(idHdrEvento, 'idHdrEvento');
    }
    _deseado = idHdrEvento;
    _sesionResuelta = true;
    String etapa = 'inicialización';

    try {
      debugPrint('[PUSH] Iniciando operativo_$idHdrEvento');
      await inicializar();
      debugPrint('[PUSH] Inicialización completada');

      if (!compatible) {
        estado.value = 'Push implementado para Android/iOS';
        return;
      }

      etapa = 'solicitud de permisos';
      final permission = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('[PUSH] Permiso: ${permission.authorizationStatus}');

      if (permission.authorizationStatus == AuthorizationStatus.denied) {
        estado.value = 'Permiso de notificaciones denegado';
        return;
      }

      etapa = 'sincronización del topic';
      await _programar();
    } catch (e, stackTrace) {
      estado.value = 'Error push en $etapa';
      debugPrint('[PUSH] ERROR EN $etapa: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  // Ejecutar al cerrar sesión o abandonar/finalizar el operativo, no al cerrar una vista.
  Future<void> salirOperativo() async {
    _deseado = 0;
    _sesionResuelta = true;
    aperturaPendiente.value = null;
    try {
      await inicializar();
      await _local.cancelAll();
      await _programar();
    } catch (_) {
      estado.value = 'Baja push pendiente; se reintentará';
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

  String _confirmado = '';
  Future<void> _sincronizar() async {
    if (!compatible || !_storageLista || !_sesionResuelta) return;
    final target = _deseado > 0 ? 'operativo_$_deseado' : '';
    final messaging = FirebaseMessaging.instance;
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        await messaging.getAPNSToken() == null) {
      estado.value = 'Esperando registro APNs';
      return;
    }
    for (final topic in _topics.toList()) {
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
    // Registrar antes de la llamada permite limpiar incluso si la app muere durante el alta.
    _topics.add(target);
    await _guardarTopics();
    await messaging.subscribeToTopic(target);
    _confirmado = target;
    estado.value = 'Suscrito a $target';
  }

  Future<void> _mostrar(RemoteMessage message) async {
    final data = message.data;
    if (_deseado <= 0 ||
        data['idHdrEvento']?.toString() != '$_deseado') return;

    final tipo = data['tipo']?.toString();
    if (tipo != 'BOLETA' && tipo != 'VEHICULO_ROBADO') return;

    final alertaId = data['alertaId']?.toString().trim();
    final key = alertaId != null && alertaId.isNotEmpty
        ? alertaId
        : message.messageId;
    if (key == null || key.isEmpty || !_vistos.add(key)) return;

    var id = 0;
    for (final c in key.codeUnits) {
      id = ((id * 31) + c) & 0x7fffffff;
    }

    final tituloRecibido = message.notification?.title?.trim() ?? '';
    final mensajeRecibido = message.notification?.body?.trim() ?? '';
    final titulo = tituloRecibido.isNotEmpty
        ? tituloRecibido
        : 'Operativo #$_deseado · Alerta';
    final mensaje = mensajeRecibido.isNotEmpty
        ? mensajeRecibido
        : 'Consulte la información en la aplicación.';

    try {
      await _local.show(
        id: id,
        title: titulo,
        body: mensaje,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'alertas_operativo',
            'Alertas del operativo',
            channelDescription: 'Avisos de boletas y vehículos robados',
            importance: Importance.max,
            priority: Priority.high,
            visibility: NotificationVisibility.private,
            icon: 'ic_stat_operativo',
            tag: key,
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
      if (_vistos.length > 300) _vistos.remove(_vistos.first);
    } catch (_) {
      _vistos.remove(key);
      rethrow;
    }
  }
  Future<String?> obtenerTokenDispositivo() async {
    if (!compatible) return null;
    try {
      final messaging = FirebaseMessaging.instance;
      final permiso = await messaging.requestPermission(
        alert: true, badge: true, sound: true,
      );
      if (permiso.authorizationStatus == AuthorizationStatus.denied) {
        estado.value = 'Permiso de notificaciones denegado';
        return null;
      }
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await messaging.getAPNSToken();
        if (apnsToken == null) {
          estado.value = 'Esperando registro APNs; vuelva a intentar';
          return null;
        }
      }
      final token = await messaging.getToken();
      if (token == null || token.isEmpty) {
        estado.value = 'No se pudo obtener el token FCM';
        return null;
      }
      return token;
    } catch (e) {
      debugPrint('Error obteniendo token FCM: $e');
      return null;
    }
  }
  Future<void> probarNotificacionLocal() async {
    if (!kDebugMode || !compatible) return;
    try {
      await inicializar();
      final permiso = await FirebaseMessaging.instance.requestPermission(
        alert: true, badge: true, sound: true,
      );
      if (permiso.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('[PUSH PRUEBA] Permiso denegado');
        return;
      }
      await _local.show(
        id: 990001,
        title: 'PRUEBA LOCAL · SIIPNE Móvil',
        body: 'Prueba de visualización. No corresponde a una alerta real.',
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'alertas_operativo', 'Alertas del operativo',
            channelDescription: 'Avisos de boletas y vehículos robados',
            importance: Importance.max,
            priority: Priority.high,
            icon: 'ic_stat_operativo',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true,
          ),
        ),
      );
      debugPrint('[PUSH PRUEBA] Solicitud de visualización completada');
    } catch (e, stackTrace) {
      debugPrint('[PUSH PRUEBA] ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
