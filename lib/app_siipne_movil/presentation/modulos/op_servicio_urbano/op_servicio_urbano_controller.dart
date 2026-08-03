part of '../controllers.dart';

class OpServicioUrbanoController extends GetxController {
  final loginController = Get.find<LoginController>();
  final SiipneMovilUseCase siipneMovilUseCase = Get.find();



  late UserEntities user;

  RxBool peticionServerState = false.obs;

  final ScrollController scrollController = ScrollController();
  final mostrarIndicador = true.obs;


  var selectPerson = true.obs;
  var selectVehiculo = false.obs;

  var controllerCedula = new TextEditingController();
  var controllerPlaca = new TextEditingController();


  var tieneOrdenCaptura = false.obs;
  var vehiculoRobado = false.obs;

  RxBool ocultarBtnBuscarPersona = false.obs;
  RxBool ocultarBtnBuscarVehiculo = false.obs;

  RxList<OpePersonaModelData> dataPersona = <OpePersonaModelData>[].obs;
  RxList<DataVehiculo> dataVehiculo = <DataVehiculo>[].obs;

  // Datos para la consulta con ocupantes
  RxList<DataVehiculo> dataVehiculoRelacional = <DataVehiculo>[].obs;
  RxList<OpePersonaModelData> dataPersona_conductor =
      <OpePersonaModelData>[].obs;
  RxList<OpePersonaModelData> dataPersona_acompanante1 =
      <OpePersonaModelData>[].obs;
  RxList<OpePersonaModelData> dataPersona_acompanante2 =
      <OpePersonaModelData>[].obs;
  RxList<OpePersonaModelData> dataPersona_acompanante3 =
      <OpePersonaModelData>[].obs;
  String placaConsultadaAnterior="";
  String placaConsultada="";

  // end datos para la consulta con ocupantes


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



  cerrarSession() {
    // Get.toNamed(AppRoutes.SPLASH_APP);
  }
}
