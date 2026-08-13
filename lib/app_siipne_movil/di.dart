

import 'package:get/get.dart';

import 'data/datasources/datasource_impl_siipne_movil.dart';
import 'data/repositories/data_repositories_siipne_movil.dart';
import 'domain/repository/repository_siipne_movil.dart';
import 'domain/use_cases/siipne_movil_use_case.dart';



class DependencyInjectionSiipneMovil extends Bindings{

  //  agregar las dependencias en la ruta: lib/app/di_app.dart

  static ini(){

    // Use cases
    Get.lazyPut<SiipneMovilUseCase>(()=>SiipneMovilUseCase(repository: Get.find()),fenix: true);


    // Repository
    Get.lazyPut<SiipneMovilRepository>(() =>
        SiipneMovilRepositoryImpl(siipneMovilRemoteDataSource: Get.find()), fenix: true);


    // Data sources
    Get.lazyPut<SiipneMovilRemoteDataSource>(() => SiipneMovilRemoteDataSourceImpl(),
        fenix: true);


  }

  @override
  void dependencies() {
    print('DependencyInjection');
    ini();

  }


}