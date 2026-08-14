part of '../controllers.dart';

class SplashController extends GetxController {
  final LocalStoreUseCase _localStoreImpl=Get.find<LocalStoreUseCase>();
  VerificarUpdateUseCase verificarUpdateUseCase=Get.find();

  String tag="SplashController";
  RxBool peticionServerState=true.obs;
  bool _iniciado=false;

  @override
  void onInit(){
    super.onInit();
    verificarPlataformaIos();
  }

  @override
  void onReady(){
    super.onReady();

    if(!_iniciado){
      _iniciado=true;
      verificarActualizacionApp();
    }
  }

  Future<void> verificarActualizacionApp() async{
    peticionServerState.value=true;

    try{
      String nemonico=dotenv.env['NEMONICO_APP_SIIPNE_MOVIL']??'';
      bool isAndroid=GetPlatform.isAndroid;
      int versionCodeApp=int.parse(await DeviceInfoApp.getVersionCode);

      VerificarUpdateRequest request=VerificarUpdateRequest(
        versionCodeApp:versionCodeApp,
        isAndroid:isAndroid,
        nemonico:nemonico,
      );

      await verificarUpdateUseCase(request:request);

      peticionServerState.value=false;
      await msjActualizarApp(false);
    }on UpdateAppException catch(e){
      peticionServerState.value=false;
      await msjActualizarApp(true);
    }catch(e){
      peticionServerState.value=false;

      PrintsMsj.myLog(
        tag:tag,
        title:"ServerException",
        detalle:e.toString(),
      );

      await msjActualizarApp(false);
    }
  }

  Future<void> _verifiToken() async{
    print("SPLASH: verificando token");

    final UserEntities userModel=await _localStoreImpl.getUserModel();
    final String token=userModel.token;

    if(token.isNotEmpty){
      print("SPLASH: tenemos token valido");

      String user=await _localStoreImpl.getUser();
      String pass=await _localStoreImpl.getPass();

      if(user.isNotEmpty&&pass.isNotEmpty){
        await _cargarPantallaLogin_InicioRapido();
      }else{
        await _cargarPantallaLogin_InicioRapido();
      }
    }else{
      print("SPLASH: token no valido");
      await _cargarPantallaLogin_InicioRapido();
    }
  }

  Future<void> _cargarPantallaLogin_InicioRapido() async{
    await Future.delayed(const Duration(milliseconds:150));

    bool confHuella=await _localStoreImpl.getConfigHuella();
    String codePin=await _localStoreImpl.getPinCode();

    if(confHuella||codePin.length>2){
      print("SPLASH: CARGAR INICIO RAPIDO");
      Get.offAllNamed(UserRoutes.LOGIN_RAPIDO);
    }else{
      print("SPLASH: CARGAR LOGIN");
      Get.offAllNamed(UserRoutes.LOGIN);
    }
  }

  void verificarPlataformaIos(){
    if(UtilidadesUtil.plataformaIsIos){
      AppConfig.plataformIsIos=true;
    }
  }

  Future<void> msjActualizarApp(bool actualizarApp) async{
    if(actualizarApp){
      DialogosAwesome.getWarning(
        title:"ACTUALIZAR LA APP",
        descripcion:MensajesString.msjNuevaVersionApp,
        btnOkOnPress:()async{
          String url=AppConfig.linkAppIos;

          if(GetPlatform.isAndroid){
            url=AppConfig.linkAppAndroid;
          }

          await UtilidadesUtil.abrirUrl(url);
          exit(0);
        },
      );
    }else{
      await vericarIdAppPublic();
    }
  }

  Future<void> vericarIdAppPublic() async{
    verificarPlataformaIos();

    String pageAppsSelect=await _localStoreImpl.getAppPagePublic();

    print("AppConfig.plataformIsIos= ${AppConfig.plataformIsIos}");
    print("pageAppsSelect= $pageAppsSelect");

    if(AppConfig.plataformIsIos){
      if(pageAppsSelect==PageAppsSelect.Bienvenida.toString()){
        print("unooo");
        Get.offAllNamed(AppRoutes.BIENVENIDO);
      }else if(pageAppsSelect==PageAppsSelect.Public.toString()){
        print("dosss");
        Get.offAllNamed(AppRoutes.HOME_APP_PUBLIC);
      }else{
        print("tress");
        await _verifiToken();
      }
    }else{
      print("cuatroo");
      await _verifiToken();
    }
  }
}