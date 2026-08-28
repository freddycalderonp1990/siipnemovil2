import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../app/di_app.dart';
import '../../../../../app/presentation/routes/app_routes.dart';
import 'package:country_utils/country_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'presentation/routes/app_pages.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('es'),

      supportedLocales: const <Locale>[
        Locale('es'),
        Locale('en'),
      ],

      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // translations will be displayed in that locale
      fallbackLocale: Locale('es'),
      initialRoute: AppRoutes.SPLASH_APP,
      initialBinding: DependencyInjectionApp(),
      getPages: AppPages.getPages(),
      home: Scaffold(
        body: SafeArea(child: Center(child: Text(''))),
      ),
    );
  }
}
