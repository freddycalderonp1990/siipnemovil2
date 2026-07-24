part of '../bindings.dart';

class MenuSiipneMovilBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => MenuSiipneMovilController(), fenix: true);

  }
}
