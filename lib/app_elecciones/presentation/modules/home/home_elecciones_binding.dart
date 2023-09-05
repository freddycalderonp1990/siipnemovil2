part of '../bindings.dart';

class HomeEleccionesBinding extends Bindings{
  @override
  void dependencies() {
    print("HomeBinding-HomeEleccionesBinding");
    //Inyeccion de dependencias
    Get.lazyPut(() => HomeEleccionesController());





  }

}