part of '../../controllers.dart';

class OperativoRelacionalController extends GetxController
    with SingleGetTickerProviderMixin {
  var peticionServerState = false.obs;

  RxList<PersonaModelData> dataPersona_conductor = <PersonaModelData>[].obs;
  RxList<PersonaModelData> dataPersona_acompanante1 = <PersonaModelData>[].obs;
  RxList<PersonaModelData> dataPersona_acompanante2 = <PersonaModelData>[].obs;
  RxList<PersonaModelData> dataPersona_acompanante3 = <PersonaModelData>[].obs;

  RxList<DataVehiculoAnt> dataVehiculoANT = <DataVehiculoAnt>[].obs;

  RxList<DataVehiculo> dataVehiculo = <DataVehiculo>[].obs;

  final OperativoPolcoController _operativoPolcoController =
      Get.find<OperativoPolcoController>();

  var controllerCedula_Conductor = new TextEditingController();
  var controllerCedula_Acompanante1 = new TextEditingController();
  var controllerCedula_Acompanante2 = new TextEditingController();
  var controllerCedula_Acompanante3 = new TextEditingController();

  var selectPerson = false.obs;

  final GpsController _gpsController = Get.find<GpsController>();

  final loginController = Get.find<LoginController>();
  final OperativosApiImpl _operativosApiImpl =
  Get.find<OperativosApiImpl>();

  int idSubTipoOperativo = 0;
  LatLng? ubicacion = null;

  RxInt idHdrEvento = 0.obs;

  late AnimationController tempAnimationController;
  late Animation<double> animationCarShift;
  late Animation<double> _animationTempShowInfo;
  late Animation<double> _animationCoolGlow;

  List<String> cedulas = [];

  _addCedula(String? cedula) {
    if (cedula != null) {
      if (cedula.length == 10) {
        cedulas.add(cedula);
      }
    }
  }

  bool _verificarCedulas(String cedulaBusca) {
    bool result = false;

    for (int i = 0; i < cedulas.length; i++) {
      if (cedulaBusca == cedulas[i]) {
        result = true;
        break;
      }
    }

    return result;
  }

  void setupTempAnimation() {
    tempAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    animationCarShift = CurvedAnimation(
      parent: tempAnimationController,
      curve: Interval(0.2, 0.4),
    );
    _animationTempShowInfo = CurvedAnimation(
      parent: tempAnimationController,
      curve: Interval(0.45, 0.65),
    );
    _animationCoolGlow = CurvedAnimation(
      parent: tempAnimationController,
      curve: Interval(0.7, 1),
    );
  }

  @override
  void onInit() {


    _gpsController.cancelarSeguimiento();

    iniciarSeguimiento();
    setupTempAnimation();
    super.onInit();
  }

  @override
  void dispose() {
    tempAnimationController.dispose();
    super.dispose();
  }

  @override
  void onReady() {
    getDatos();
    super.onReady();
  }


  Future iniciarSeguimiento() async {
    peticionServerState(true);
    bool gpsListo = await MyGps.verificarGPS();
    if (!gpsListo) {
      return;
    }

    if (AppConfig.positionSubscription == null) {
      print("iniciarSeguimiento");

      final positionStream = myGeolocator.Geolocator.getPositionStream(locationSettings: MyGps.getConfig);
      AppConfig.positionSubscription = positionStream.handleError((error) {
        print("tcambia ubicacion ${error}");
        AppConfig.positionSubscription!.cancel();
        AppConfig.positionSubscription = null;
        MyGps.cancelarSeguimiento();
        peticionServerState(false);
      }).listen((position) {
        AppConfig.ubicacion.value =
            LatLng(position.latitude, position.longitude);
        print(
            "cambia ubicacion ${AppConfig.ubicacion.value.latitude}, ${AppConfig.ubicacion.value.longitude}");
        AppConfig.ubicacionLista.value = true;
        MyGps.cancelarSeguimiento();
        peticionServerState(false);

      });
    }
  }

  getDatos() {
    var data = Get.arguments;
    dataVehiculo.value.clear();
    if (data != null) {
      dataVehiculo.value.add(data);
      dataVehiculoANT
          .add(dataVehiculo.value[0].datosVehiculoAnt.dataVehiculoAnt);

      dataVehiculo.refresh();
    } else {
      DialogosAwesome.getError(descripcion: "Sin datos");
      Get.back();
    }
  }

  Future<PersonaModelData?> consultarPersonaPorCedula(
      {required GlobalKey<FormState> key, required String cedula, required String condutorAcompanante}) async {
    PersonaModelData? dataPersona;
    var isValid = true;

    isValid = key.currentState!.validate();
    int idHdrEventoResum = dataVehiculo.value[0].idHdrEventoResum;

    if (_verificarCedulas(cedula)) {
      isValid = false;
      DialogosAwesome.getInformation(descripcion: "La cédula la existe");
    }

    if (isValid) {
      try {
        peticionServerState(true);

        String detalle=" "+condutorAcompanante;

        DataVehiculoAnt dataVehiculoAnt;
        if (dataVehiculo.value.length > 0) {
          dataVehiculoAnt = dataVehiculoANT.value[0];


          detalle=detalle+" DEL VEHÍCULO DE PLACAS ${dataVehiculoAnt.placaActual}";
        }

        String ip = await DeviceInfo.getIp;

        PersonaModel data = await _operativosApiImpl.consultarPersona(
          ip: ip,
          latitud: AppConfig.ubicacion.value.latitude.toString(),
          longitud: AppConfig.ubicacion.value.longitude.toString(),
            descOcupante: condutorAcompanante,
          detalle:detalle ,
            idHdrEventoResum: idHdrEventoResum,
            idOperativo: _operativoPolcoController.idHdrEvento.value,
            cedula: cedula,
            idGenUsuario: loginController.user.value.idGenUsuario);

        dataPersona = data.data;

        if (dataPersona.ordenCaptura.success) {
          UtilidadesUtil.playAudio(nameAudio: SiipneImages.audio_Alerta);
        }
        if (dataPersona.dataSiipne.success) {
          _addCedula(cedula);
        } else if (dataPersona.dataDinardap.success) {
          _addCedula(cedula);
        }

        peticionServerState(false);

        return dataPersona;
      } on ServerException catch (e) {
        peticionServerState(false);

        DialogosAwesome.getError(descripcion: e.cause);
      }
    }
    return dataPersona;
  }
}
