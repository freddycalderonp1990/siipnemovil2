part of '../bindings.dart';

class PersonalAsignadoBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => PersonalAsignadoController(), fenix: true);


  }
}
