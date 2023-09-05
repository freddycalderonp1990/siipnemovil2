part of '../bindings.dart';

class EjesUnidadesPolicialesBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => EjesUnidadesPolicialesController(), fenix: true);


  }
}
