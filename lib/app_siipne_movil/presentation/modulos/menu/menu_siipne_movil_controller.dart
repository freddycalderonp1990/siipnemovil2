part of '../controllers.dart';

class MenuSiipneMovilController extends GetxController {
  final loginController = Get.find<LoginController>();
  final SiipneMovilUseCase siipneMovilUseCase = Get.find();

  RxList<DataModulo> listModulos = <DataModulo>[].obs;

  late UserEntities user;

  RxBool peticionServerState = false.obs;

  final ScrollController scrollController = ScrollController();
  final mostrarIndicador = false.obs;

  @override
  void onInit() async {

    user = loginController.user.value;

    scrollController.addListener(actualizarIndicadorScroll);

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

  void actualizarIndicadorScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) {
        mostrarIndicador.value = false;
        return;
      }

      final position = scrollController.position;

      // ¿Realmente existe contenido para hacer scroll?
      final puedeHacerScroll = position.maxScrollExtent > 0;

      // Mostrar únicamente si existe scroll y todavía no llegó al final
      mostrarIndicador.value =
          puedeHacerScroll &&
              position.pixels < position.maxScrollExtent - 5;
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

        );
        listModulos.value = await siipneMovilUseCase.getModulos(request: request);
        // Espera a que el ListView se dibuje
      //  verificarIndicadorScroll();
        if (listModulos.length == 0) {
          print("Sin permisos cerrar");
        }

        actualizarIndicadorScroll();
      },
    );

    peticionServerState(false);
  }

      goToNextPage(DataModulo modulo){
        Get.toNamed(SiipneMovilRoutes.TIPOS_OPERATIVOS,arguments:{"modulo": modulo}  );
      }
}
