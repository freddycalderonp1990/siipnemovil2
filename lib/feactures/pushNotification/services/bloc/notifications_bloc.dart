import 'dart:io';
import 'dart:math';
import 'package:api_provider/core/api_config.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../app/core/utils/device_info_app.dart';
import 'dart:async';
import '../../../../app/domain/enums/enums.dart';
import '../../data/models/models_push_notification.dart';
import '../../domain/request/request_push_notification.dart';
import '../../domain/use_cases/insert_token_fcm.dart';
import '../localNotification/local_notification.dart';
import 'package:permission_handler/permission_handler.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

/// Handler para mensajes recibidos en segundo plano o cuando la app está cerrada
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Random random = Random();
  var id = random.nextInt(1000000);
  var mensaje = message.data;

  var body = mensaje['body'];
  var title = mensaje['title'];

  print("firebaseMessagingBackgroundHandler : $mensaje");
  final notification = NotificationModel.fromJson(message.data);

  print('accion: ${notification.accion}');
  print('appName: ${notification.appName}');
  print('idAccion: ${notification.idAccion}');
  print('body: ${notification.body}');
  print('title: ${notification.title}');
  print('clickAction: ${notification.clickAction}');

  LocalNotification.showLocalNotification(notification: notification);
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // La excepción ahora depende SOLO de iOS, no del usuario ni de su ID.
  bool get notificacionesOpcionales => Platform.isIOS;
  final RxBool omitirEnEstaSesion = false.obs;
  final RxBool solicitandoPermiso = false.obs;
  final RxBool inicializandoPermiso = true.obs;
  final RxBool requiereConfiguracion = false.obs;
  final RxString errorPermiso = ''.obs;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _keyRechazo = 'siipne_push_permiso_rechazado_v2';
  bool _rechazoGuardado = false;
  bool _abriendoConfiguracion = false;
  bool _volviendoDeAjustes = false;
  bool _refrescarAlTerminar = false;
  NamApps? _appPendiente;
  int? _usuarioPendiente;
  List<String>? _topicsPendientes;
  late final Future<void> _inicializacion;
  Future<void>? _comprobacionEnCurso;

  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>((event, emit) {
      emit(state.copyWith(status: event.status));
    });
    _inicializacion = _inicializarPermiso();
    _onForegroundMessage();
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    _listenTokenRefresh();
  }

  Future<void> _inicializarPermiso() async {
    try {
      _rechazoGuardado =
          await _storage.read(key: _keyRechazo).timeout(
              const Duration(seconds: 5)) == 'true';
    } catch (e) {
      print('[PUSH] No se pudo leer la preferencia: $e');
    }
    try {
      await _checkPermissionStatus();
    } finally {
      inicializandoPermiso.value = false;
    }
  }

  void _publicar(AuthorizationStatus status) {
    if (!isClosed) add(NotificationStatusChanged(_mapStatus(status)));
  }

  bool _autorizado(AuthorizationStatus status) =>
      status == AuthorizationStatus.authorized ||
          status == AuthorizationStatus.provisional;

  Future<void> _guardarRechazo(bool value) async {
    _rechazoGuardado = value;
    try {
      await _storage.write(key: _keyRechazo, value: '$value')
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      print('[PUSH] No se pudo persistir la decisión: $e');
      errorPermiso.value =
      'No se pudo guardar la preferencia para el próximo inicio.';
    }
  }

  void noPermitir() {
    if (!Platform.isIOS || isClosed || solicitandoPermiso.value) return;
    // Cambia la vista inmediatamente. No navega a una ruta inventada:
    // NotificationsAccessScreen devuelve su contenido original.
    omitirEnEstaSesion.value = true;
    requiereConfiguracion.value = true;
    unawaited(_guardarRechazo(true));
  }

  void restablecerOmisionPermiso() {
    omitirEnEstaSesion.value = false;
  }

  Future<bool> _debeAbrirAjustes(AuthorizationStatus status) async {
    if (_autorizado(status)) return false;
    if (_rechazoGuardado ||
        (Platform.isIOS && status == AuthorizationStatus.denied)) return true;
    if (Platform.isAndroid) {
      try {
        return await Permission.notification.isPermanentlyDenied
            .timeout(const Duration(seconds: 5));
      } catch (_) {
        // Si no hay evidencia de rechazo previo, se intenta el diálogo nativo.
      }
    }
    return false;
  }

  Future<void> _checkPermissionStatus() async {
    try {
      final settings = await messaging.getNotificationSettings()
          .timeout(const Duration(seconds: 10));
      requiereConfiguracion.value =
      await _debeAbrirAjustes(settings.authorizationStatus);
      _publicar(settings.authorizationStatus);
    } catch (e) {
      errorPermiso.value = 'No se pudo comprobar el permiso. Intente nuevamente.';
      if (!isClosed) {
        add(const NotificationStatusChanged(
            NotificationPermissionStatus.notDetermined));
      }
      print('[PUSH] Error comprobando permiso: $e');
    }
  }

  Future<void> refreshPermissionStatus() {
    if (solicitandoPermiso.value) {
      _refrescarAlTerminar = true;
      return Future<void>.value();
    }
    // Los wrappers anidados pueden recibir resumed simultáneamente.
    return _comprobacionEnCurso ??= _refrescar().catchError((Object error) {
      errorPermiso.value = 'No se pudo comprobar el permiso al volver.';
      print('[PUSH] Error al volver: $error');
    }).whenComplete(() {
      _comprobacionEnCurso = null;
    });
  }

  Future<void> _refrescar() async {
    await _inicializacion;
    if (isClosed || solicitandoPermiso.value) return;
    await _checkPermissionStatus();
    if (_volviendoDeAjustes) {
      _volviendoDeAjustes = false;
      final settings = await messaging.getNotificationSettings()
          .timeout(const Duration(seconds: 10));
      _publicar(settings.authorizationStatus);
      if (_autorizado(settings.authorizationStatus)) {
        requiereConfiguracion.value = false;
        unawaited(_guardarRechazo(false));
        _registrarTokenPendiente();
      } else {
        errorPermiso.value = Platform.isIOS
            ? 'Puede continuar con NO PERMITIR o activarlas en Configuración.'
            : 'Active Notificaciones dentro de la configuración de esta aplicación.';
      }
    }
  }

  void _registrarTokenPendiente() {
    final app = _appPendiente;
    final id = _usuarioPendiente;
    if (app == null || id == null || id <= 0 || isClosed) return;
    // El registro del token no bloquea el acceso tras autorizar el permiso.
    unawaited(_getFCMtoken(
      topics: _topicsPendientes, appName: app, idGenUsuario: id,
    ).catchError((Object error) {
      print('[PUSH] No se pudo registrar el token: $error');
    }));
  }

  Future<bool> abrirConfiguracion({NamApps? appName, int? idGenUsuario}) async {
    if (_abriendoConfiguracion || isClosed) return false;
    _abriendoConfiguracion = true;
    if (appName != null) {
      _appPendiente = appName;
      _usuarioPendiente = idGenUsuario;
      _topicsPendientes = null;
    }
    errorPermiso.value = '';
    try {
      _volviendoDeAjustes = true;
      final abierto = await openAppSettings().timeout(const Duration(seconds: 10));
      if (!abierto) {
        _volviendoDeAjustes = false;
        errorPermiso.value =
        'No se pudo abrir Configuración. Abra los ajustes de esta app manualmente.';
      }
      return abierto;
    } catch (e) {
      _volviendoDeAjustes = false;
      errorPermiso.value = 'No se pudo abrir Configuración. Intente nuevamente.';
      print('[PUSH] Error abriendo ajustes: $e');
      return false;
    } finally {
      _abriendoConfiguracion = false;
    }
  }

  NotificationPermissionStatus _mapStatus(AuthorizationStatus status) {
    switch (status) {
      case AuthorizationStatus.authorized:
        return NotificationPermissionStatus.authorized;
      case AuthorizationStatus.denied:
        return NotificationPermissionStatus.denied;
      case AuthorizationStatus.provisional:
        return NotificationPermissionStatus.provisional;
      case AuthorizationStatus.notDetermined:
      default:
        return NotificationPermissionStatus.notDetermined;
    }
  }

  void _listenTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("🔄 TOKEN ACTUALIZADO: $newToken");

      // Aquí debes enviarlo a tu backend
      // insertToken(newToken);
    });
  }

  /// Solicitar permisos para notificaciones

  Future<NotificationPermissionStatus?> requestPermission({
    List<String>? topics,
    required NamApps appName,
    required int idGenUsuario,
    bool mostrarAvisoSiDenegado = true, // Compatibilidad con llamadas existentes.
  }) async {
    if (solicitandoPermiso.value || isClosed) return null;
    solicitandoPermiso.value = true;
    errorPermiso.value = '';
    try {
      await _inicializacion;
      _appPendiente = appName;
      _usuarioPendiente = idGenUsuario;
      _topicsPendientes = topics;
      final actual = await messaging.getNotificationSettings()
          .timeout(const Duration(seconds: 10));
      if (_autorizado(actual.authorizationStatus)) {
        _publicar(actual.authorizationStatus);
        requiereConfiguracion.value = false;
        unawaited(_guardarRechazo(false));
        _registrarTokenPendiente();
        return _mapStatus(actual.authorizationStatus);
      }
      if (await _debeAbrirAjustes(actual.authorizationStatus)) {
        requiereConfiguracion.value = true;
        await abrirConfiguracion();
        return null;
      }

      // Primera solicitud: se presenta el diálogo nativo cuando el SO lo permite.
      final settings = await messaging.requestPermission(
        alert: true, badge: true, sound: true,
      );
      _publicar(settings.authorizationStatus);
      if (_autorizado(settings.authorizationStatus)) {
        requiereConfiguracion.value = false;
        unawaited(_guardarRechazo(false));
        _registrarTokenPendiente();
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        requiereConfiguracion.value = true;
        // iOS continúa incluso al rechazar el diálogo del sistema.
        if (Platform.isIOS) omitirEnEstaSesion.value = true;
        unawaited(_guardarRechazo(true));
        errorPermiso.value = Platform.isIOS
            ? ''
            : 'Permiso no concedido. Pulse ABRIR CONFIGURACIÓN para activarlo.';
      }
      return _mapStatus(settings.authorizationStatus);
    } catch (e) {
      errorPermiso.value = 'No se pudo solicitar el permiso. Intente nuevamente.';
      print('[PUSH] Error solicitando permiso: $e');
      return null;
    } finally {
      solicitandoPermiso.value = false;
      if (_refrescarAlTerminar && !isClosed) {
        _refrescarAlTerminar = false;
        unawaited(refreshPermissionStatus());
      }
    }
  }

  // Obtener el token de FCM y suscribirse a topics
  Future<void> _getFCMtoken({
    List<String>? topics,
    required NamApps appName,
    required int idGenUsuario,
  }) async {
    const String TAG = "[FCM]";

    final settings = await messaging.getNotificationSettings();

    print("$TAG ======================================");
    print("$TAG INICIO PROCESO NOTIFICACIONES");
    print("$TAG TOPIC: ${appName.nameString}");
    print("$TAG AuthorizationStatus: ${settings.authorizationStatus}");
    print("$TAG ======================================");

    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      print("$TAG ❌ Usuario no autorizó notificaciones");

      return;
    }

    String? token;

    try {
      // Solo para diagnóstico en iOS
      if (Platform.isIOS) {
        try {
          final apnsToken = await FirebaseMessaging.instance.getAPNSToken();

          print("$TAG 🍎 APNS TOKEN: $apnsToken");

          if (apnsToken == null) {
            print(
              "$TAG ⚠️ APNS TOKEN es NULL. "
                  "Posiblemente estás en simulador "
                  "o APNs no está configurado.",
            );
          }
        } catch (e) {
          print("$TAG ❌ Error obteniendo APNS TOKEN: $e");
        }
      }

      token = await FirebaseMessaging.instance.getToken();

      print("$TAG 🔥 FCM TOKEN: $token");
    } catch (e, stackTrace) {
      print("$TAG ❌ Error obteniendo FCM TOKEN");
      print("$TAG ERROR: $e");
      print("$TAG STACKTRACE: $stackTrace");

      return;
    }

    try {
      await FirebaseMessaging.instance.subscribeToTopic(appName.nameString);

      print("$TAG ✅ Suscrito al topic: ${appName.nameString}");
    } catch (e) {
      print("$TAG ❌ Error suscribiendo al topic: $e");
    }

    if (topics != null && topics.isNotEmpty) {
      for (final topic in topics) {
        try {
          await FirebaseMessaging.instance.subscribeToTopic(topic);

          print("$TAG ✅ Suscrito al topic adicional: $topic");
        } catch (e) {
          print("$TAG ❌ Error suscribiendo al topic $topic: $e");
        }
      }
    }

    if (token != null && token.isNotEmpty) {
      try {
        insertToken(
          tokenFcm: token,
          appName: appName.nameString,
          idGenUsuario: idGenUsuario,
        );

        print("$TAG ✅ Token enviado al backend");
      } catch (e) {
        print("$TAG ❌ Error guardando token en backend: $e");
      }
    }

    print("$TAG ======================================");
    print("$TAG FIN PROCESO NOTIFICACIONES");
    print("$TAG ======================================");
  }

  Future<void> updateTopics(List<String>? topics) async {
    if (topics == null || topics.isEmpty) {
      return;
    }
    for (final topicName in topics) {
      // Desuscribirse para evitar duplicados
      await FirebaseMessaging.instance.unsubscribeFromTopic(topicName);

      // Suscripción al topic correspondiente
      await FirebaseMessaging.instance.subscribeToTopic(topicName);
    }
  }

  /// Enviar token al backend
  void insertToken({
    required String tokenFcm,
    required String appName,
    required int idGenUsuario,
  }) async {
    final InsertTokenFcmUseCase _insertTokenFcmUseCase =
    Get.find<InsertTokenFcmUseCase>();

    try {
      String ip = await DeviceInfoApp.getIp;
      String plataforma = await DeviceInfoApp.getOnlyPlataforma;

      PushTokenRequest request = PushTokenRequest(
        idGenUsuario: idGenUsuario,
        appName: appName,
        plataforma: plataforma,
        tokenFcm: tokenFcm,
        usuario: idGenUsuario,
        ip: ip,
      );

      if (ApiConfig.token.length > 10) {
        print("tengo autorizacion para insertar token");
        final result = await _insertTokenFcmUseCase.call(request: request);
      } else {
        print("Nooo tengo autorizacion para insertar token");
      }
    } catch (ex) {
      print("Print error al insertar token en el server ${ex.toString()}");
    }
  }
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  /// Mensajes recibidos en primer plano
  void _onForegroundMessage() {
    if (_foregroundSubscription != null) return;
    _foregroundSubscription = FirebaseMessaging.onMessage.listen(
      handleRemoteMessage,
    );
  }
  // Mensajes recibidos en minimizado
  void _onMessageOpenedApp(RemoteMessage message) {
    print("========= onMessageOpenedApp =========");

    print(message.data);

    final notification = NotificationModel.fromJson(message.data);

    print('accion: ${notification.accion}');
    print('appName: ${notification.appName}');
    print('idAccion: ${notification.idAccion}');
    print('body: ${notification.body}');
    print('title: ${notification.title}');
  }

  /// Manejo de mensajes en cualquier estado
  void handleRemoteMessage(RemoteMessage message) async {
    final tipo = message.data['tipo']?.toString();

    // Estas alertas las muestra exclusivamente OperativoPushService.
    if (tipo == 'BOLETA' || tipo == 'VEHICULO_ROBADO') return;

    try {
      var notification = NotificationModel.fromJson(message.data);
      notification = notification.copyWith(
        title: message.notification?.title ?? notification.title,
        body: message.notification?.body ?? notification.body,
      );
      await LocalNotification.showLocalNotification(
        notification: notification,
      );
    } catch (e) {
      print('[PUSH GENERAL] Error procesando notificación: $e');
    }
  }
  @override
  Future<void> close() async {
    await _foregroundSubscription?.cancel();
    _foregroundSubscription = null;
    await super.close();
  }
}
