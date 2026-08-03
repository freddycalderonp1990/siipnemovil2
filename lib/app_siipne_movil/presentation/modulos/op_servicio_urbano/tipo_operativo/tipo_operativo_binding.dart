part of '../../bindings.dart';

class TipoOperativoBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => TipoOperativoController(), fenix: true);

  }
}
