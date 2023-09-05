import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/presentation/routes/app_pages.dart';


import 'presentation/routes/siipne_routes.dart';

class MainSiipneMovil extends StatelessWidget {
  const MainSiipneMovil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: AppTheme.lightTheme,
      theme:  new ThemeData(
          fontFamily: 'Sans',
        primarySwatch: Colors.grey,
        primaryTextTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.white
            )
        )
    ),
      locale: Locale('es'),
      // translations will be displayed in that locale
      fallbackLocale: Locale('es'),
      initialRoute: SiipneRoutes.SPLASH,
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
