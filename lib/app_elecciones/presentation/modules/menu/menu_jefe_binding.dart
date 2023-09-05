part of '../bindings.dart';

class MenuJefeBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => MenuJefeController(), fenix: true);


  }
}
