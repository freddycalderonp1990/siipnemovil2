part of '../bindings.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {

    print("HomeBinding-ok");
    //Inyeccion de dependencias
    Get.lazyPut(() => HomeController());





  }

}