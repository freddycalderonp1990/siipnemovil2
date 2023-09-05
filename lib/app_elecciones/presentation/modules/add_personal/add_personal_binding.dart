part of '../bindings.dart';

class AddPersonalBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => AddPersonalController(), fenix: true);


  }
}
