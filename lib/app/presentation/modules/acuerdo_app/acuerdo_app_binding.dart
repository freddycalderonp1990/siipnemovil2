part of '../bindings.dart';

class AcuerdoAppBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => AcuerdoAppController(), fenix: true);


  }
}
