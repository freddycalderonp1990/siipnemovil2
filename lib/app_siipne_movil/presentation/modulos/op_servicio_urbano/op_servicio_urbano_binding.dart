part of '../bindings.dart';

class OpServicioUrbanoBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => OpServicioUrbanoController(), fenix: true);

  }
}
