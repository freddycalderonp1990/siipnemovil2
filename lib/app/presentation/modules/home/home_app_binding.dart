part of '../bindings.dart';

class HomeAppBinding extends Bindings{
  @override
  void dependencies() {

    print("HomeBinding-ok");
    //Inyeccion de dependencias
    Get.lazyPut(() => HomeAppController());





  }

}