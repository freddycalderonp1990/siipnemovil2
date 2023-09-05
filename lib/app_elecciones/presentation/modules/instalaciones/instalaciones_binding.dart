part of '../bindings.dart';

class InstalacionesBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => InstalacionesController(), fenix: true);


  }
}
