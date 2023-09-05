import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/presentation/routes/app_pages.dart';
import '../../../app_elecciones/presentation/routes/elecciones_routes.dart';


class MainElecciones extends StatelessWidget {
  const MainElecciones({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: AppTheme.lightTheme,
      theme: ThemeData(fontFamily: 'Sans'),
      locale: Locale('es'),
      // translations will be displayed in that locale
      fallbackLocale: Locale('es'),
      initialRoute: EleccionesRoutes.HOME,
      //initialBinding: DependencyInjection(),
      getPages: AppPages.getPages(),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Text('Hola'),
          ),
        ),
      ),
    );
  }
}
