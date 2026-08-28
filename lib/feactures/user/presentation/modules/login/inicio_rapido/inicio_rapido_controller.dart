part of '../../controllers.dart';

class InicioRapidoController extends GetxController {
  final LocalStoreUseCase _localStoreUseCase = Get.find<LocalStoreUseCase>();
  final LoginController loginController = Get.find<LoginController>();

  final user = UserEntities.empty().obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyPinCode = GlobalKey<FormState>();

  var controllerUser = TextEditingController();
  var controllerPass = TextEditingController();

  RxBool peticionServerState = false.obs;
  RxBool mostrarAccesoHuella = false.obs;
  RxString valueCode = "".obs;
  RxBool mostrarBtnGuardarPinCode = false.obs;

  int contadorLogin2 = 0;

  RxBool mostrarBtnHome = false.obs;
  RxString namePhone = "".obs;
  RxList<Widget> adWidget = <Widget>[].obs;

  RxBool wgInicioRapidoUserPass = false.obs;
  RxBool wgOcultarInicioRapidoUserPass = false.obs;

  static const maxSeconds = 30;

  RxInt seconds = maxSeconds.obs;
  RxInt seconds2 = 0.obs;
  RxDouble valueRadio = 100.0.obs;

  Timer? timer;

  RxString codigo = "000000".obs;
  var peticionServer = false.obs;

  @override
  void onInit() {
    super.onInit();
    verificarSitieneBiometrico();
  }

  @override
  void onReady() {
    super.onReady();
    _cargarInicio();
  }

  Future<void> _cargarInicio() async {
    await _init();
    await verificarCredenciales();
  }

  @override
  void onClose() {
    timer?.cancel();
    controllerUser.dispose();
    controllerPass.dispose();
    super.onClose();
  }

  Future<void> verificarSitieneBiometrico() async {
    mostrarAccesoHuella.value = await BiometricUtil.checkAccesoBiometrico();
  }

  Future<void> login({required String user, required String pass}) async {
    peticionServerState.value = true;

    try {
      await ExceptionDialogos.manejarErroresShowDialogo(() async {
        UserEntities? userResponse = await loginController.authApp(
          user: user,
          pass: pass,
          localStoreImpl: _localStoreUseCase,
        );

        if (userResponse != null) {
          loginController.user.value = userResponse;
          await InciarPantalla();
        }
      });
    } finally {
      controllerPass.clear();
      peticionServerState.value = false;
    }
  }

  Future<void> ingresoConUsuarioClave() async {
    wgInicioRapidoUserPass.value = true;
    wgOcultarInicioRapidoUserPass.value = true;
  }

  Future<void> ingresoConOtroUsuario() async {
    await _localStoreUseCase.clearAllData();
    Get.offAllNamed(AppRoutes.SPLASH_APP);
  }

  Future<bool> verificarCredenciales() async {
    namePhone.value = await DeviceInfoApp.getDeviceMarca;

    String userLocal = await _localStoreUseCase.getUser();
    String passLocal = await _localStoreUseCase.getPass();

    mostrarAccesoHuella.value = false;

    if (userLocal.isNotEmpty && passLocal.isNotEmpty) {
      print("INICIO RAPIDO: credenciales encontradas");

      user.value = await _localStoreUseCase.getUserModel();
      user.refresh();

      bool configHuella = await _localStoreUseCase.getConfigHuella();

      if (configHuella) {
        mostrarAccesoHuella.value = true;
      }

      return true;
    }

    print("INICIO RAPIDO: sin credenciales");
    return false;
  }

  Future<void> _setBiometrico() async {
    String userLocal = await _localStoreUseCase.getUser();
    String passLocal = await _localStoreUseCase.getPass();

    if (userLocal.isEmpty || passLocal.isEmpty) {
      Get.back();
      return;
    }

    bool resultHuella = await BiometricUtil.biometrico();

    if (resultHuella) {
      DialogosAwesome.getSucess(
        descripcion: "Ha configurado con éxito el acceso biométrico.",
        btnOkOnPress: () async {
          Get.back();

          await _localStoreUseCase.setLoginInit(true);
          await _localStoreUseCase.setConfigHuella(true);

          await login(user: userLocal, pass: passLocal);
        },
      );
    } else {
      DialogosAwesome.getError(
        descripcion: "Error al configurar, su huella no coincide.",
      );
    }
  }

  Future<void> loginConBiometrico() async {
    bool confHuella = await _localStoreUseCase.getConfigHuella();

    if (!confHuella) {
      DialogosAwesome.getWarningSiNo(
        descripcion: "¿Desea configurar el acceso biométrico?",
        btnOkOnPress: () {
          _setBiometrico();
        },
        btnCancelOnPress: () async {
          await _localStoreUseCase.setLoginInit(false);
          await _localStoreUseCase.setConfigHuella(false);
          Get.back();
        },
      );

      return;
    }

    wgInicioRapidoUserPass.value = false;
    wgOcultarInicioRapidoUserPass.value = false;

    bool tieneCredenciales = await verificarCredenciales();

    if (tieneCredenciales) {
      bool result = await BiometricUtil.biometrico();

      if (result) {
        String userLocal = await _localStoreUseCase.getUser();
        String passLocal = await _localStoreUseCase.getPass();

        await login(user: userLocal, pass: passLocal);
      }
    } else {
      DialogosAwesome.getWarning(descripcion: "No existe biométrico");
    }
  }

  Future<void> InciarPantalla() async {
    await _localStoreUseCase.setContadorFallido(0);
    await _localStoreUseCase.setLoginInit(true);

    Get.offAllNamed(AppConfig.showPageBeforeLogin);
  }

  Future<void> _init() async {
    print("AppConfig.plataformIsIos2= ${AppConfig.plataformIsIos}");

    if (Platform.isIOS) {
      mostrarBtnHome.value = true;
    }

    if (!await _localStoreUseCase.getLoginInit()) {
      wgInicioRapidoUserPass.value = true;
      wgOcultarInicioRapidoUserPass.value = true;
    }
  }

  Future<void> getPantalla() async {
    peticionServer.value = true;
    Get.offAllNamed(AppRoutes.HOME_APP_PUBLIC);
    peticionServer.value = false;
  }
}
