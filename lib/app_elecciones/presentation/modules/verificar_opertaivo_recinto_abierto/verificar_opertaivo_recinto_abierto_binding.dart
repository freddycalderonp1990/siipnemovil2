part of '../bindings.dart';

class VerificarOpertaivoRecintoAbiertoBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => VerificarOpertaivoRecintoAbiertoController(), fenix: true);


  }
}
