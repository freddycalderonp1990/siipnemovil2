part of '../controllers.dart';

class MenuSiipneMovilController extends GetxController {
  final loginController = Get.find<LoginController>();
  final ModulosUseCase modulosUseCase = Get.find();

  RxList<DataModulo> listModulos = <DataModulo>[].obs;

  late UserEntities user;

  RxBool peticionServerState = false.obs;

  final ScrollController scrollController = ScrollController();
  final mostrarIndicador = true.obs;

  @override
  void onInit() async {

    user = loginController.user.value;

    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      final maxScroll = scrollController.position.maxScrollExtent;

      if (maxScroll <= 0) {
        mostrarIndicador.value = false;
        return;
      }

      // Solo mostrar cuando está arriba
      mostrarIndicador.value = scrollController.offset <= 5;
    });

    await getModulosPermitidos();

    super.onInit();
  }

  void verificarIndicadorScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      mostrarIndicador.value =
          scrollController.position.maxScrollExtent > 0;
    });
  }

  @override
  void onReady() async {
    // TODO: Donde la vista ya se presento

    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    scrollController.dispose();
    super.onClose();
  }

  Future<void> getModulosPermitidos() async {
    peticionServerState(true);
    await ExceptionDialogos.manejarErroresShowDialogo(
      showMsjNodata: false,
      () async {
        GetPermisosModulosRequest request = GetPermisosModulosRequest(
          idGenUsuario: user.idGenUsuario,
          idGenPersona: user.idGenPersona,
          showAll: true,
        );
        listModulos.value = await modulosUseCase(request: request);
        // Espera a que el ListView se dibuje
        verificarIndicadorScroll();
        if (listModulos.length == 0) {
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
