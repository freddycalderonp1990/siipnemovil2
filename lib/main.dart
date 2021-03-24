import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';


import 'appConfig.dart';
import 'bloc/mapa/mapa_bloc.dart';
import 'bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'pages/pages.dart';
import 'providers/providers.dart';
import 'sharePreferences/preferenciasUsuario.dart';

void main() async {
// add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
}

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
          ChangeNotifierProvider(
            create: (_) => ProcesoOperativoProvider(),
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
            initialRoute: AppConfig.pantallaInicioRapido,
            //cambia el idoama a español
            localizationsDelegates: [GlobalMaterialLocalizations.delegate],
            supportedLocales: [
              const Locale("es"),
            ],
            routes: {
              AppConfig.pantallaPruebas: (context) => AwesomeDialogScreen(),
              AppConfig.pantallaInicioRapido: (context) => InicioRapidoPage(),
              AppConfig.pantallaLogin: (context) => LoginPage(),
              AppConfig.pantallaProcesosOperativos: (context) => ProcesosOperativosPage(),
              AppConfig.pantallaMenuCrearCodigo: (context) => MenuCrearCodigoPage(),
              AppConfig.pantallaTipoEjes: (context) => TipoEjespage(),

              AppConfig.pantallaPrincipal: (context) => HomePage(),
              AppConfig.pantallaVerificarGps: (context) => VerificarGpsPage(),
              AppConfig.pantallaVerificarOperativoRecintoAbierto: (context) => VerificaOpertaivoRecintoAbiertoPage(),
              AppConfig.pantallaMenuUnidadesPolicialesOtros: (context) => MenuUnidadesPolicialesOtrosPage(),
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

              //UNIDADES POLICIALES
              AppConfig.pantallaUnidadesPoliciales: (context) => TipoEjeUnidadesPolicialesPage(),
              AppConfig.pantallaCrearCodigoUnidadesPoliciales: (context) => CrearCodigoUnidadPolicialPage(),

              //TIPO DE EJES OTROS
              AppConfig.pantallaTipoEjeOtros: (context) => TipoEjeOtrosPage(),
              AppConfig.pantallaCrearCodigoOtros: (context) => CrearCodigoOtrosPage(),
            },
          ),
        ));
  }
}
