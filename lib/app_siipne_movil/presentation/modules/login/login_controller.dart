part of '../controllers.dart';

class LoginController extends GetxController {
  final LocalStoreImpl _LocalStoreImpl = Get.find<LocalStoreImpl>();
  final AuthApiImpl _apiUserRepository = Get.find<AuthApiImpl>();
  final user = User.empty().obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyPinCode = GlobalKey<FormState>();

  var controllerUser = new TextEditingController();
  var controllerPass = new TextEditingController();
  RxBool peticionServerState = false.obs;
  RxBool wgLoginUserPass = false.obs;
  RxBool wgOcultarLoginUserPass = false.obs;
  RxBool mostrarAccesoHuella = false.obs;

  static const maxSeconds = 30;
  RxInt seconds = maxSeconds.obs;
  RxInt seconds2 = 0.obs;
  RxDouble valueRadio = 100.0.obs;
  Timer? timer;
  RxString codigo = "000000".obs;

  RxString valueCode = "".obs;

  RxBool mostrarBtnGuardarPinCode = false.obs;

  int contadorLogin2 = 0;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    controllerUser.text = "cpfn1206762401";
    controllerPass.text = "freddyNCP1990";

    _init();
    verificarCredenciales();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose

    super.onClose();
  }

  Future<void> login() async {
    var isValid = true;

    if (formKey.currentState == null) {
      formKey = GlobalKey<FormState>();
      isValid = true;
    } else {
      isValid = formKey.currentState!.validate();
    }

    if (!isValid) {
      return;
    }

    final _user = this.controllerUser.text;
    final _pass = this.controllerPass.text;
    bool isAndroid = GetPlatform.isAndroid;
    int versionCodeApp = 0;
    String imei = 'imei';
    String tipoRed = 'movil';
    String nameRed = 'namered';

    versionCodeApp = int.parse(await UtilidadesUtil.getVersionCode());

    try {
      peticionServerState(true);
      //Encryptamos la clave
      String clave = EncriptarUtil.generateSha512(_pass);

      final userResponse = await _apiUserRepository.auth(AuthRequest(
          user: _user,
          pass: clave,
          isAndroid: isAndroid,
          versionCodeApp: versionCodeApp,
          imei: imei,
          tipoRed: tipoRed,
          nameRed: nameRed));

      await _LocalStoreImpl.setToken(userResponse.token);
      await _LocalStoreImpl.setUser(_user);
      await _LocalStoreImpl.setPass(clave);
      await _LocalStoreImpl.setUserName(userResponse.nombreUsuario);
      await _LocalStoreImpl.setUserModel(userResponse);

      peticionServerState(false);

      if (!userResponse.actualizarApp) {
        print('esperando mostrar biometrico es:');

        // _setCodePin();
        await _setBiometrico(
            actualizarApp: this.user.value.actualizarApp,
            foto: "userResponse.foto.fotoBase64");

        this.user.value = userResponse;
        this.user.refresh();
      } else {
        InciarPantalla(userResponse.actualizarApp);
      }
    } on ServerException catch (e) {
      peticionServerState(false);
      DialogosAwesome.getError(descripcion: e.cause);
    }
  }

  _init() async {
    /*controllerUser.text="cpfn1206762401";
    controllerPass.text="freddyNCP1990";*/
    if (!await _LocalStoreImpl.getAppInicial()) {
      wgLoginUserPass.value = true;
      wgOcultarLoginUserPass.value = true;
    }
  }

  Future<bool> verificarCredenciales() async {
    String user = await _LocalStoreImpl.getUser();
    String pass = await _LocalStoreImpl.getPass();

    mostrarAccesoHuella.value = false;

    if (user.length > 0 && pass.length > 0) {
      print('mostrar huella');

      this.user.value = await _LocalStoreImpl.getUserModel();
      this.user.refresh();

      bool configHuella = await _LocalStoreImpl.getConfigHuella();
      if (configHuella) {
        mostrarAccesoHuella.value = true;
      }

      return true;
    } else {
      return false;
    }
  }

  Future<void> verificarBiometrico() async {
    bool verificarCredenciales = await this.verificarCredenciales();

    if (verificarCredenciales) {
      wgLoginUserPass.value = false;
      wgOcultarLoginUserPass.value = false;

      bool result = await BiometricUtil.biometrico();
      if (result) {
        String user = await _LocalStoreImpl.getUser();
        String pass = await _LocalStoreImpl.getUser();

        controllerUser.text = user;
        controllerPass.text = pass;

        print('user: ${user}--pass: ${pass}');
        login();
      }
    }
  }

  _setCodePin() {
    DialogosAwesome.getInformationSi(
        descripcion:
            "Configure un código.\n\nCon este codigo  usted podra ingresar de manera más facil al sistema",
        btnOkOnPress: () {
          PinCode();
        });
  }

  _setBiometrico({bool actualizarApp = false, required String foto}) async {
    print("userResponse.setbione");

    //_UserProvider.setUser = datosUser;
    bool checkAccesoBiometrico = await BiometricUtil.checkAccesoBiometrico();
    bool verificaCredecniales = false;

    String user = await _LocalStoreImpl.getUser();
    String pass = await _LocalStoreImpl.getPass();

    if (user.length > 0 && pass.length > 0) {
      verificaCredecniales = true;
    }
    print('acceso biometrico es: {$checkAccesoBiometrico}');
    print('verificaCredecniales es: {$verificaCredecniales}');

    if (checkAccesoBiometrico) {
      if (verificaCredecniales) {
        DialogosAwesome.getInformationSiNo(
          descripcion: "¿Desea configurar el acceso biometrico.?",
          btnCancelOnPress: () async {
            _LocalStoreImpl.setAppInicial(false);
            _LocalStoreImpl.setConfigHuella(false);
            _LocalStoreImpl.setFoto('');
            Get.back();
            InciarPantalla(actualizarApp);
          },
          btnOkOnPress: () async {
            bool resultHuella = await BiometricUtil.biometrico();

            if (resultHuella) {
              DialogosAwesome.getSucess(
                  descripcion: "A configurado con éxito el acceso biométrico.",
                  btnOkOnPress: () {
                    Get.back();
                    _LocalStoreImpl.setAppInicial(true);
                    _LocalStoreImpl.setConfigHuella(true);
                    _LocalStoreImpl.setFoto(foto);

                    InciarPantalla(actualizarApp);
                  });
            } else {
              DialogosAwesome.getError(
                  descripcion: "Error al configurar, su huella no coincide.",
                  btnOkOnPress: () {
                    _LocalStoreImpl.setAppInicial(false);
                    _LocalStoreImpl.setConfigHuella(false);
                    _LocalStoreImpl.setFoto('');
                    Get.back();
                    InciarPantalla(actualizarApp);
                  });
            }
          },
        );
      } else {
        InciarPantalla(actualizarApp);
      }
    } else {
      InciarPantalla(actualizarApp);
    }
  }

  InciarPantalla(bool actualizarApp) {
    if (actualizarApp) {
      DialogosAwesome.getWarning(
          title: "ACTUALIZAR LA APP",
          descripcion: "Nueva Versión Disponible"
              "\n\nPara continuar utilizando la aplicación es necesario que descargue la última versión."
              "\n\nSi tiene Problemas intente desinstalar y volver a instalarla.",
          btnOkOnPress: () {
            Get.back();
            if (GetPlatform.isAndroid) {
              UtilidadesUtil.abrirUrl(SiipneConfig.linkAppAndroid);
              print('App Android');
            } else {
              UtilidadesUtil.abrirUrl(SiipneConfig.linkAppIos);
              print('App Ios');
            }
          });
    } else {
      Get.offAllNamed(AppRoutes.HOME_APP);
    }
  }

  void clearCodePin() {
    valueCode.value = "";
    mostrarBtnGuardarPinCode(false);
  }

  void mostrarBtnPinCode() {
    mostrarBtnGuardarPinCode(true);
  }

  void guardarPinCode() {
    DialogosAwesome.getInformationSiNo(
        descripcion:
            "Ingreso el código: [${valueCode.value}], desea continuar?",
        btnOkOnPress: () async {
          Get.back();
          String code = EncriptarUtil.generateSha512(valueCode.value);

          await _LocalStoreImpl.setPinCode(code);
          await _setBiometrico(
              actualizarApp: this.user.value.actualizarApp,
              foto: "userResponse.foto.fotoBase64");
        },
        btnCancelOnPress: () {});
  }

  String getName() {
    String nombre = user.value.apenom;
    String res = user.value.sexoPerson == "HOMBRE"
        ? "Bienvenido: " + nombre
        : "Bienvenida: " + nombre;

    return res.toUpperCase();
  }

  PinCode() {
    clearCodePin();

    Widget wg = Obx(() => PinCodeWidget(
        value: valueCode.value,
        valueCode: valueCode,
        mostrarBtnGuardarPinCode: mostrarBtnGuardarPinCode,
        onChanged: (value) {
          print(value);
        },
        onTapGuardar: () => guardarPinCode(),
        title: "Guardar"));

    DialogosDesingWidget.getDialogoX(title: "PIN CODE", contenido: wg);
  }
}
