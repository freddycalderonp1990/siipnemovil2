part of '../bindings.dart';

class TipoServiciosBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => TipoServiciosController(), fenix: true);


  }
}
