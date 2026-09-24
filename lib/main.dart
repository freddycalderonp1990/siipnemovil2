import 'dart:io';

import 'package:app_mi_upc/app_mi_upc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../app/di_app.dart';
import 'app/core/app_config.dart';
import 'app/core/seguridades/validate_SSL.dart';
import 'app/main_app.dart';
import 'app/presentation/routes/app_routes.dart';
import 'feactures/gps/presentation/bloc/gps/gps_bloc.dart';
import 'feactures/gps/presentation/location/location_bloc.dart';

// Notificaciones.
import 'package:firebase_core/firebase_core.dart';
import 'feactures/pushNotification/services/bloc/notifications_bloc.dart';
import 'feactures/pushNotification/services/localNotification/local_notification.dart';
import 'firebase_options.dart';
import 'feactures/pushNotification/data/models/models_push_notification.dart';
// Ajustar únicamente a la ubicación real de este archivo.
import 'app_siipne_movil/presentation/modulos/op_servicio_urbano/operativo_push_service.dart';


// Configuración original conservada.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Handler de notificaciones en segundo plano.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Los mensajes con notification ya los muestra el sistema en background.
  if (message.notification != null) return;

  // OperativoPushService usa mensajes notification + data.
  final tipo = message.data['tipo']?.toString();
  if (tipo == 'BOLETA' || tipo == 'VEHICULO_ROBADO') return;

  // Compatibilidad con mensajes antiguos que solo contienen data.
  try {
    final notification = NotificationModel.fromJson(message.data);
    await LocalNotification.initializeLocalNotifications();
    await LocalNotification.showLocalNotification(
      notification: notification,
      segundoPlano: true,
    );
  } catch (e) {
    debugPrint('[PUSH BACKGROUND] Error: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  DependencyInjectionApp();

  await dotenv.load(fileName: ".env");
  AppConfig.init();

  AppRoutesMiUpc.setNameMenu(name: "Home");
  AppRoutesMiUpc.setPageInicio(AppRoutes.SPLASH_APP);

  try {
    // Validación SSL original conservada.
    ValidateSSL validateSSL = ValidateSSL();
    await validateSSL.validarSSl();
  } catch (e) {
    print("error certificados $e");
  }

  // Configuración de notificaciones.
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    if (kDebugMode) {
      debugPrint('[PUSH MAIN] Proyecto: ${Firebase.app().options.projectId}');
    }

    // Conservamos la inicialización del sistema existente.
    try {
      await LocalNotification.initializeLocalNotifications();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      debugPrint('[PUSH MAIN] LocalNotification inicializado');
    } catch (e, stackTrace) {
      debugPrint('[PUSH MAIN] Error en LocalNotification: $e');
      if (kDebugMode) debugPrint('$stackTrace');
    }

    if (OperativoPushService.instance.compatible) {
      try {
        final permiso = await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        debugPrint('[PUSH MAIN] Permiso: ${permiso.authorizationStatus}');
      } catch (e, stackTrace) {
        debugPrint('[PUSH MAIN] Error solicitando permisos: $e');
        if (kDebugMode) debugPrint('$stackTrace');
      }

      try {
        await OperativoPushService.instance.inicializar();
        debugPrint('[PUSH MAIN] OperativoPushService inicializado');
      } catch (e, stackTrace) {
        debugPrint('[PUSH MAIN] Error en OperativoPushService: $e');
        if (kDebugMode) debugPrint('$stackTrace');
      }
    }
  } catch (e, stackTrace) {
    print(" Error en Firebase Notificaciones: ${e.toString()}");
    if (kDebugMode) debugPrint('$stackTrace');
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc()),
        BlocProvider(create: (context) => LocationBloc()),
        BlocProvider(create: (context) => NotificationsBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainApp();
  }
}