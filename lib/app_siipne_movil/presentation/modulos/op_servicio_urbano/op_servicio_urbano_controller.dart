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

  Rx<DataCreateOp> dataCreateOp=DataCreateOp.empty().obs;

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


  Future<void> getDataToPage() async {
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments.containsKey('dataCreateOp')) {
      try {
        dataCreateOp.value = arguments['dataCreateOp'] as DataCreateOp;
       // await getTipoOperativos();
      } catch (e) {
        print('Error getDataToPage: $e');
      }
    }
    else{
      DialogosAwesome.getWarning(
          descripcion: "No se recibieron datos válidos. Vuelva a intentarlo.",
          btnOkOnPress: (){
        Get.offAllNamed(SiipneMovilRoutes.MENU_APP);
      }
      );
    }
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
    await getDataToPage();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    scrollController.dispose();
    super.onClose();
  }


  Future<void> consultarPersonaPorDocumento() async {
    peticionServerState(true);

    await ExceptionDialogos.manejarErroresShowDialogo(
      showMsjNodata: false,
          () async {

            final locationBloc = BlocProvider.of<LocationBloc>(Get.context!);
            LatLng pos = await locationBloc.getCurrentPosition();

            String ip = await DeviceInfoApp.getIp;

            ConsultarPersonaRequest request = ConsultarPersonaRequest(
                idOperativo: dataCreateOp.value.idHdrEvento,
                documento: '',
                latitud: pos.latitude,
                longitud: pos.longitude,
                ip: ip, idGenUsuario: user.idGenUsuario,
                idVariableResultado: 56

        );

            dataPersona.clear();
            peticionServerState(true);
            tieneOrdenCaptura(false);

            OpePersonaModelData data =   await siipneMovilUseCase.consultarPersona(
          request: request,
        );








      },
    );

    peticionServerState(false);
  }


  cerrarSession() {
    // Get.toNamed(AppRoutes.SPLASH_APP);
  }
}
