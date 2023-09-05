part of '../controllers.dart';

class SplashController extends GetxController {
  final LocalStoreImpl _localStoreImpl =
      Get.find<LocalStoreImpl>();

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
    _verifiToken();
  }





  _verifiToken() async {
    print("SPLASH: verificando token");

    final token = await _localStoreImpl.getToken();

    //verificamos si el token aun esta valido
    if (token != null) {
      print("SPLASH: tenemos token valido");
      //Tenemos token aun valido que no expira
      //vamos al login

      //se realiza el login
      String user = await _localStoreImpl.getUser();
      String pass = await _localStoreImpl.getPass();

    //  bool resul = await _localStoreImpl.login(user: user, pass: pass);

      bool resul=false;
      if (!resul) {
        print("SPLASH: LOGIN ERROR");
        await _cargarPantallaLogin_InicioRapido();
      }
    } else {
      print("SPLASH: tenemos token no es valido");
      await _cargarPantallaLogin_InicioRapido();
    }
  }

  _cargarPantallaLogin_InicioRapido() async {

    bool confHuella = await _localStoreImpl.getConfigHuella();
    String codePin = await _localStoreImpl.getPinCode();
    if (confHuella || codePin.length > 2) {
      print('SPLASH: CARGAR INICIO RAPIDO');
      // Get.offAllNamed(AppRoutes.LOGIN_RAPIDO);
      Get.offAllNamed(SiipneRoutes.LOGIN_RAPIDO);
    } else {
      print('SPLASH: CARGAR LOGIN');
      Get.offAllNamed(SiipneRoutes.LOGIN);
    }
  }


  _verifiTokenq() async {
    print("verificando token");

    final token = await _localStoreImpl.getToken();
    Uint8List? foto = await _localStoreImpl.getFoto();

    if (foto != null && foto != '') {
      print('si hay foto');
      Get.offAllNamed(SiipneRoutes.LOGIN_RAPIDO);

    } else {
      print('_verifiToken si hay foto');
      if (token != null) {
        //Tenemos token aun valido que no expira
        Get.offAllNamed(SiipneRoutes.LOGIN);
      } else {
        Get.offAllNamed(SiipneRoutes.LOGIN);
      }
    }
  }

}
