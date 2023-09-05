part of '../controllers.dart';

class HomeAppController extends GetxController {
  final loginController = Get.find<LoginController>();
  var peticionServer = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  getPageSiipne() async {
    getPantalla(SiipneRoutes.HOME);
  }

  getPageElecciones() {
    getPantalla(EleccionesRoutes.HOME);
  }

  getPantalla(String pantalla) async {
    peticionServer(true);
    bool resultGps = await MyGps.verificarGPS();
    if (resultGps) {
      Get.toNamed(pantalla);
    }
    peticionServer(false);
  }
}
