


import '../app_siipne_movil/presentation/gps/gps_impl_helper.dart';
import '../app_siipne_movil/presentation/modules/controllers.dart';

import 'data/repository/data_repositories.dart';


import 'data/providers/providers_impl.dart';
import 'domain/repositories/domain_repositories.dart';

import 'package:get/get.dart';


class DependencyInjectionSiipne extends Bindings{

  static ini(){


    //DATA
    Get.lazyPut<LocalStorageRepository> (() => LocalStoreProviderImpl(), fenix: true);
    Get.lazyPut<LocalStoreProviderImpl> (() => LocalStoreProviderImpl(), fenix: true);



    Get.lazyPut<LocalStoreImpl> (() => LocalStoreImpl(), fenix: true);

    //Domain
    Get.lazyPut<AuthApiImpl> (() => AuthApiImpl(), fenix: true);






    Get.lazyPut<AuthRepository> (() => AuthApiImpl(), fenix: true);
    Get.lazyPut<ModulosRepository> (() => ModulosApiImpl(), fenix: true);
    Get.lazyPut<OperativosRepository> (() => OperativosApiImpl(), fenix: true);




    Get.lazyPut<OperativosApiImpl> (() => OperativosApiImpl(), fenix: true);





    //Providers
    Get.lazyPut<AuthApiProviderImpl> (() => AuthApiProviderImpl(), fenix: true);
    Get.lazyPut<ModulosApiProviderImpl> (() => ModulosApiProviderImpl(), fenix: true);
    Get.lazyPut<OperativosApiProviderImpl> (() => OperativosApiProviderImpl(), fenix: true);




    //realizo la inyecto para utilizarla enm toda la aplicacion
    Get.put(LoginController());


    Get.put(GpsController());


    //Get.create<GpsController> (() => GpsController());

  }

  @override
  void dependencies() {
    print('DependencyInjection');
    ini();

    /* Get.lazyPut<Dio>(() => Dio(BaseOptions(baseUrl: 'http://192.168.80.90')));
    Get.lazyPut<LoginApi>(() => LoginApi());
    Get.lazyPut<LoginRepository>(() => LoginRepository());*/
  }


}