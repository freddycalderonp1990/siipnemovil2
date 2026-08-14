part of '../../bindings.dart';

class InicioRapidoBinding extends Bindings {
  @override
  void dependencies(){
    if(!Get.isRegistered<LoginController>()){
      Get.lazyPut<LoginController>(
            ()=>LoginController(),
        fenix:true,
      );
    }

    Get.lazyPut<InicioRapidoController>(
          ()=>InicioRapidoController(),
      fenix:true,
    );
  }
}