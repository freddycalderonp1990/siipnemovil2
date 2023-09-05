


import 'package:get/get.dart';
import '../../../app_elecciones/data/providers/providers_impl_elecciones.dart';
import '../../../app_elecciones/data/repository/data_repositories.dart';
import '../../../app_elecciones/domain/repositories/domain_repositories.dart';

import 'presentation/modules/controllers.dart';


class DependencyInjectionElecciones extends Bindings{

  static ini(){
    //APIS
    Get.lazyPut<ProcesosOperativosRepository> (() => ProcesosOperativosApiImpl(), fenix: true);
    Get.lazyPut<NovedadesRepository> (() => NovedadesApiImpl(), fenix: true);

    Get.lazyPut<ProcesosOperativosApiImpl> (() => ProcesosOperativosApiImpl(), fenix: true);
    Get.lazyPut<NovedadesApiImpl> (() => NovedadesApiImpl(), fenix: true);

    //Providers
    Get.lazyPut<ProcesosOperatviosApiProviderImpl> (() => ProcesosOperatviosApiProviderImpl(), fenix: true);
    Get.lazyPut<NovedadesApiProviderImpl> (() => NovedadesApiProviderImpl(), fenix: true);

    //Get.put(HomeEleccionesController());



  }

  @override
  void dependencies() {
    print('DependencyInjection');
    ini();
  }


}