part of '../bindings.dart';

class NovedadesBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => NovedadesController(), fenix: true);


  }
}
