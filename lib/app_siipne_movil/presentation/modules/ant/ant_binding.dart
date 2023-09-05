part of '../bindings.dart';

class AntBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => AntController(), fenix: true);


  }
}
