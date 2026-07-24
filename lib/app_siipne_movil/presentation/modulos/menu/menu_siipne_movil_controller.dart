part of '../controllers.dart';

class MenuSiipneMovilController extends GetxController {
  final loginController = Get.find<LoginController>();
  final ModulosUseCase
  modulosUseCase = Get.find();


  RxList<DataModulo> listModulos = <DataModulo>[].obs;


  late UserEntities user;

  RxBool peticionServerState = false.obs;


  @override
  void onInit() async {
    user = loginController.user.value;


    await getModulosPermitidos();

    super.onInit();
  }

  @override
  void onReady() async {
    // TODO: Donde la vista ya se presento

    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose

    super.onClose();
  }

  Future<void> getModulosPermitidos() async {
    peticionServerState(true);
    await ExceptionDialogos.manejarErroresShowDialogo(
      showMsjNodata: false,
      () async {
        GetPermisosModulosRequest request = GetPermisosModulosRequest(
          idGenUsuario: user.idGenUsuario, idGenPersona: user.idGenPersona, showAll: true,
        );
        listModulos.value= await modulosUseCase(
          request: request,
        );


        if(listModulos.length==0){
         print("Sin permisos cerrar");
        }
      },
    );

    peticionServerState(false);
  }

  cerrarSession() {
   // Get.toNamed(AppRoutes.SPLASH_APP);
  }


}
