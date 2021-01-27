import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'pages/pruebas.dart';

import 'appConfig.dart';
import 'bloc/mapa/mapa_bloc.dart';
import 'bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'pages/pages.dart';
import 'providers/providers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => RecintoAbiertoProvider(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => MiUbicacionBloc()),
            BlocProvider(create: (_) => MapaBloc()),
          ],
          child: MaterialApp(
            color: Colors.red,
            title: AppConfig.nameApp,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: AppConfig.pantallaLogin,
            //cambia el idoama a español
            localizationsDelegates: [GlobalMaterialLocalizations.delegate],
            supportedLocales: [
              const Locale("es"),
            ],
            routes: {
              AppConfig.pantallaPruebas: (context) => AwesomeDialogScreen(),
              AppConfig.pantallaLogin: (context) => LoginPage(),
              AppConfig.pantallaPrincipal: (context) => HomePage(),
              AppConfig.pantallaVerificarGps: (context) => VerificarGpsPage(),
              //SISTEMA DE ALERTAS TEMPRANAS
              AppConfig.pantallaMenuSat: (context) => MenuSatPage(),
              AppConfig.pantallaSatRegistroVictima: (context) =>
                  SatRegistroVictimaPage(),
              AppConfig.pantallaSatMapasRegistroVictimas: (context) => SatMapaRegistroVictimasPage(),
              AppConfig.pantallaSatMapasVisitasVictimas: (context) => SatMapaVisitasVictimasPage(),
              AppConfig.pantallaSatRegistroVisitasVictimas: (context) => SatRegistroVisitaVictimaPage(),
              AppConfig.pantallaSatRegistroParte: (context) => SatRegistroParte(),

              //SISTEMA RECINTO ELECTORAL
              AppConfig.pantallaMenuRecintoElectoral: (context) => MenuRecintoElectoral(),
              AppConfig.pantallaRecElecAbrir: (context) => RecElecAbrir(),
              AppConfig.pantallaRecElecRegistrarseRecintoElectoral: (context) => RecElecRegistrarse(),
              AppConfig.pantallaRecElecRegistrarNovedades: (context) => RecElecRegistrarNovedades(),
              AppConfig.pantallaRecElecAddPersonal: (context) => RecElecAddPersonal(),
              AppConfig.pantallaRecElecPersonalDetalle: (context) => RecElectPersonalDetalle(),
              AppConfig.pantallaRecElecNovedadesDetalle: (context) => RecElectNovedadesDetalle(),
            },
          ),
        ));
  }
}
