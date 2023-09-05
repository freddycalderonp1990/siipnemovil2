part of '../../controllers.dart';

class InicioRapidoController extends GetxController {
  final LocalStoreImpl _LocalStoreImpl =
  Get.find<LocalStoreImpl>();
  final AuthApiImpl _apiUserRepository = Get.find<AuthApiImpl>();

  final loginController = Get.find<LoginController>();

  var controllerUser = new TextEditingController();
  var controllerPass = new TextEditingController();

  int contadorLogin2=0;

  final user = User.empty().obs;
  RxList<Widget> adWidget = <Widget>[].obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  RxBool peticionServerState = false.obs;
  RxBool wgInicioRapidoUserPass = false.obs;
  RxBool wgOcultarInicioRapidoUserPass = false.obs;
  RxBool mostrarAccesoHuella = false.obs;

  static const maxSeconds = 30;
  RxInt seconds = maxSeconds.obs;
  RxInt seconds2 = 0.obs;
  RxDouble valueRadio = 100.0.obs;
  Timer? timer;
  RxString codigo = "000000".obs;

  GlobalKey<FormState> formKeyPinCode = GlobalKey<FormState>();
  RxString valueCode = "".obs;
  RxBool mostrarBtnGuardarPinCode = false.obs;

  @override
  void onInit() {
    verificarSitieneBiometrico();
    super.onInit();
  }

  @override
  void onReady() {
    _init();
    verificarCredenciales();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    stopTimer();
    super.onClose();
  }








  void startTimer() async{
    final isRunning = timer==null ? false : timer!.isActive;
    String pass = await _LocalStoreImpl.getPass();
    if(!isRunning) {
      codigo.value= AlgoritmoTOTP.getCode(pass);
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        if(seconds>0) {
          seconds.value--;
          seconds2.value++;
          double resultado=seconds.value*100;
          valueRadio.value=resultado/maxSeconds;
          print( valueRadio.value);
          print("seconds 2 ${ seconds2.value}");
        }
        else{
          seconds.value=maxSeconds;
          seconds2.value=0;
          valueRadio.value=100.0;
          codigo.value= AlgoritmoTOTP.getCode(pass);
        }
      });
    }
  }

  void stopTimer(){
    timer?.cancel();
  }












  void verificarSitieneBiometrico() async {
    mostrarAccesoHuella.value = await BiometricUtil.checkAccesoBiometrico();
  }

  Future<bool> login({required String user, required String pass}) async {


    bool result=false;
    bool isAndroid = true;
    int versionCodeApp = 0;
    String imei = 'imei';
    String tipoRed = 'movil';
    String nameRed = 'namered';

    versionCodeApp = int.parse(await UtilidadesUtil.getVersionCode());

    try {
      peticionServerState(true);



      final userResponse = await _apiUserRepository.auth(AuthRequest(
          user: user,
          pass: pass,
          isAndroid: isAndroid,
          versionCodeApp: versionCodeApp,
          imei: imei,
          tipoRed: tipoRed,
          nameRed: nameRed));

      await _LocalStoreImpl.setToken(userResponse.token);
      await _LocalStoreImpl.setUser(user);
      await _LocalStoreImpl.setPass(pass);
      await _LocalStoreImpl.setUserName(userResponse.nombreUsuario);
      await _LocalStoreImpl.setUserModel(userResponse);


      peticionServerState(false);

      if (!userResponse.actualizarApp) {
        InciarPantalla(userResponse.actualizarApp);
        this.user.value = userResponse;
        this.user.refresh();


      } else {
        InciarPantalla(userResponse.actualizarApp);
      }

      return true;

    } on ServerException catch (e) {

      DialogosAwesome.getError(descripcion: e.cause);

      peticionServerState(false);

      return false;
    }
  }


  _init() async {
    /*controllerUser.text="cpfn1206762401";
    controllerPass.text="freddyNCP1990";*/
    if (!await _LocalStoreImpl.getAppInicial()) {
      wgInicioRapidoUserPass.value = true;
      wgOcultarInicioRapidoUserPass.value = true;
    }
  }



  Future<void> ingresoConUsuarioClave() async {
    wgInicioRapidoUserPass.value = true;
    wgOcultarInicioRapidoUserPass.value = true;
  }

  Future<void> ingresoConOtroUsuario() async {
    await _LocalStoreImpl.clearAllData();

    Get.offAllNamed(AppRoutes.SPLASH_APP);
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

  _setBiometrico() async {
    bool verificaCredecniales = false;
    String user = await _LocalStoreImpl.getUser();
    String pass = await _LocalStoreImpl.getPass();

    if (user.length > 0 && pass.length > 0) {
      verificaCredecniales = true;
    } else {
      Get.back();
      return;
    }

    if (verificaCredecniales) {
      bool resultHuella = await BiometricUtil.biometrico();

      if (resultHuella) {
        DialogosAwesome.getSucess(
            descripcion: "Ah configurado con éxito el acceso biométrico.",
            btnOkOnPress: () async {
              Get.back();
              _LocalStoreImpl.setAppInicial(true);
              _LocalStoreImpl.setConfigHuella(true);
              _LocalStoreImpl.setFoto("foto");

              await login(user: user, pass: pass);
            });
      } else {
        DialogosAwesome.getError(
            descripcion: "Error al configurar, su huella no coincide.",
            btnOkOnPress: () {
              Get.back();
            });
      }
    }
  }

  Future<void> loginConBiometrico() async {
    //verificamos si tiene configurado el biometrico
    bool confHuella = await _LocalStoreImpl.getConfigHuella();

    if (!confHuella) {
      DialogosAwesome.getInformationSiNo(
          descripcion: "¿Desea configurar el acceso biometrico.?",
          btnOkOnPress: () {
            _setBiometrico();
          },
          btnCancelOnPress: () async {
            _LocalStoreImpl.setAppInicial(false);
            _LocalStoreImpl.setConfigHuella(false);
            _LocalStoreImpl.setFoto('');
            Get.back();
          });
    } else {
      wgInicioRapidoUserPass.value = false;
      wgOcultarInicioRapidoUserPass.value = false;

      bool verificarCredenciales = await this.verificarCredenciales();

      if (verificarCredenciales) {
        wgInicioRapidoUserPass.value = false;
        wgOcultarInicioRapidoUserPass.value = false;

        bool result = await BiometricUtil.biometrico();
        if (result) {
          String user = await _LocalStoreImpl.getUser();
          String pass = await _LocalStoreImpl.getPass();

          await login(user: user, pass: pass);
        }
      } else {
        DialogosAwesome.getWarning(
            descripcion: "No existe biometrico", btnOkOnPress: () {});
      }
    }
  }

  InciarPantalla(bool actualizarApp) async {
    await _LocalStoreImpl.setContadorFallido(0);
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
    valueCode.value="";
    mostrarBtnGuardarPinCode(false);
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
        onTapGuardar: () => verificarPinCode(),
        title: "Ingresar"));

    DialogosDesingWidget.getDialogoX(title: "PIN CODE", contenido:wg);
  }

  Future<void> verificarPinCode() async {
    String user = await _LocalStoreImpl.getUser();
    String pass = await _LocalStoreImpl.getPass();

    if (user.length > 0 && pass.length > 0) {
    } else {
      Get.back();
      return;
    }

    //Verificamos que el codigo sea el mismo

    String code = valueCode.value;

    String codeBD = await _LocalStoreImpl.getPinCode();
    code = EncriptarUtil.generateSha512(code);
    print("${codeBD} == ${code}");

    if (codeBD != code) {
      verificarIntentosFallidos(msj: "El Pin Code ingresado es incorrecto");

    } else {
      Get.back();

      await login(user: user, pass: pass);
    }
  }

  void verificarIntentosFallidos({String? msj}) async {
    //Obtenemos el contenedor de intentos fallidos
    int contadorfallido = await _LocalStoreImpl.getContadorFallido();
    contadorfallido = contadorfallido + 1;

    if (contadorfallido >= SiipneConfig.intentosFallidos) {
      await _LocalStoreImpl.clearAllData();
      DialogosAwesome.getWarning(
          descripcion: "Ah excedido el número de intentos permitidos",
          btnOkOnPress: () {
            Get.offAllNamed(AppRoutes.SPLASH_APP);
          });
    } else {
      if (msj != null) {
        DialogosAwesome.getWarning(
            descripcion: msj,
            btnOkOnPress: () async {
              clearCodePin();

              await _LocalStoreImpl.setContadorFallido(contadorfallido);
            });
      } else {
        await _LocalStoreImpl.setContadorFallido(contadorfallido);
      }
    }
  }
}
