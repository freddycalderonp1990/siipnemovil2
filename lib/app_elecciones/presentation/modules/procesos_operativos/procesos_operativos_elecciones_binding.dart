part of '../bindings.dart';

class ProcesosOperativosEleccionesBinding extends Bindings{
  @override
  void dependencies() {

    print("HomeBinding-ok");
    //Inyeccion de dependencias
    Get.lazyPut(() => ProcesosOperativosEleccionesController());





  }

}