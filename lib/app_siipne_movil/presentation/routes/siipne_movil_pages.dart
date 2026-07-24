import 'package:get/get.dart';

import '../../../app/presentation/routes/app_pages.dart';
import '../modulos/bindings.dart';

import '../modulos/pages.dart';
import 'siipne_movil_routes.dart';



class SiipneMovilPages {

  //agregar en el archvio de la maplicacion principal los page
  // ruta: lib/app/presentation/routes/app_pages.dart
  static final List<GetPage> pages = [


    AppPages.getPageConfig(
        name: SiipneMovilRoutes.MENU_APP,
        page: () => MenuSiipneMovilPage(),
        binding: MenuSiipneMovilBinding()),





  ];
}
