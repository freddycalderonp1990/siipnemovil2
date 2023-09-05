part  of '../../bindings.dart';

class OperativoPolcoBinding extends Bindings {
  @override
  void dependencies() {
    //Inyeccion de dependencias
    Get.lazyPut(() => OperativoPolcoController(), fenix: true);

  }
}
