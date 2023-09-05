part of '../controllers.dart';

class VerificarOpertaivoRecintoAbiertoController extends GetxController {
  final LocalStorageRepository _localStorageRepository =
      Get.find<LocalStorageRepository>();

  @override
  void onInit() {
    // TODO: el contolloler se ha creado pero la vista no se ha renderizado
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: Donde la vista ya se presento
    _init();
  }

  _init() async {
    print(Get.deviceLocale.toString());

  }




}
