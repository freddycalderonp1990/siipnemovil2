part of '../bindings.dart';

class EjesHijosBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => EjesHijosController(), fenix: true);


  }
}
