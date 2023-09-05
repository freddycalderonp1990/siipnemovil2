import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import '../../../../../app_elecciones/presentation/routes/elecciones_pages.dart';
import '../../../../../app_siipne_movil/presentation/routes/siipne_pages.dart';

import '../modules/bindings.dart';
import '../modules/pages.dart';
import 'app_routes.dart';

class AppPages {
  static final _transition = Transition.rightToLeft;
  static final _transitionDuration = const Duration(milliseconds: 400);
  static final _curve = Curves.fastOutSlowIn;
  static List<GetPage> _pages = [];

  static GetPage getPageConfig(
      {required String name,
      required GetPageBuilder page,
      required Bindings binding}) {
    return GetPage(
        transition: _transition,
        transitionDuration: _transitionDuration,
        curve: _curve,
        name: name,
        page: page,
        binding: binding);
  }

  static List<GetPage> getPages() {
    _pages = [
      getPageConfig(
          name: AppRoutes.HOME_APP,
          page: () => HomeAppPage(),
          binding: HomeAppBinding()),
      getPageConfig(
          name: AppRoutes.SPLASH_APP,
          page: () => SplashPage(),
          binding: SplashBinding()),
      getPageConfig(
          name: AppRoutes.PDFVIEW,
          page: () => PdfViewPage(),
          binding: PdfViewBinding()),
    ];

    //agregamos las paguinas de cada app
    _pages.addAll(SiipnePages.pages);

    _pages.addAll(EleccionesPages.pages);
    return _pages;
  }
}
