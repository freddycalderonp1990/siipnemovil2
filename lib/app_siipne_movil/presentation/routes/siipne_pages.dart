import 'package:get/get.dart';
import '../../../app/presentation/routes/app_pages.dart';

import '../../presentation/gps/gps_impl_helper.dart';
import '../modules/bindings.dart';
import '../modules/pages.dart';
import '../routes/siipne_routes.dart';

class SiipnePages {
  static final List<GetPage> pages = [
    

     AppPages.getPageConfig(
        name: SiipneRoutes.HOME,
        page: () => HomePage(),
        binding: HomeBinding()),
     AppPages.getPageConfig(
        name: SiipneRoutes.LOGIN,
        page: () => LoginPage(),
        binding: LoginBinding()),
     AppPages.getPageConfig(
        name: SiipneRoutes.LOGIN_RAPIDO,
        page: () => InicioRapidoPage(),
        binding: InicioRapidoBinding()),
     AppPages.getPageConfig(
        name: SiipneRoutes.OPERATIVOS_POLCO,
        page: () => OperativoPolcoPage(),
        binding: OperativoPolcoBinding()),
     AppPages.getPageConfig(
        name: SiipneRoutes.OPERATIVOS_POLCO_RELACIONAL,
        page: () => OperativoRelacionalPage(),
        binding: OperativoRelacionalBinding()),
     AppPages.getPageConfig(
        name: SiipneRoutes.ANT, page: () => AntPage(), binding: AntBinding()),
     AppPages.getPageConfig(
        name: SiipneRoutes.GPS_VERIFICATE,
        page: () => GpsVerificatePage(),
        binding: GpsBinding()),
  ];
}
