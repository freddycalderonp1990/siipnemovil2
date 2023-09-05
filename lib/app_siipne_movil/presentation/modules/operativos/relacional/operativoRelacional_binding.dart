part of '../../bindings.dart';

class OperativoRelacionalBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
     Get.lazyPut(() => OperativoRelacionalController(), fenix: true);

  }
}
