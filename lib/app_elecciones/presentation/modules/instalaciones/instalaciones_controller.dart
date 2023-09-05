part of '../controllers.dart';

class InstalacionesController extends GetxController {
  final loginController = Get.find<LoginController>();
  var peticionServer = false.obs;

  ProcesosOperativosApiImpl _procesosOperativosApiImpl = Get.find();

  RxList<DataInstalacionesRecinto> listDataInstalacionesRecinto =
      <DataInstalacionesRecinto>[].obs;

  Rx<DataProcesosAbierto> dataProcesosAbierto = DataProcesosAbierto.empty().obs;

  DataEjes dataEjes = DataEjes.empty();
  final formKey = GlobalKey<FormState>();
  var controllerTelefono = new TextEditingController();

  RxList<ModelDataCombo> dataCombo = <ModelDataCombo>[].obs;
  Rx<ModelDataCombo> dataSelect = ModelDataCombo(id: 0, titulo: "").obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    _init();
  }

  @override
  void onClose() {
    MyGps.cancelarSeguimiento();
    super.onReady();
  }

  _init() async {
    var data = Get.arguments;
    if (data != null) {
      dataEjes = data;

      iniciarSeguimiento();
    } else {
      DialogosAwesome.getError(
          descripcion: "No se encontro información. vuelva a intentar",
          btnOkOnPress: () {
            Get.back();
          });
    }
  }

  Future iniciarSeguimiento() async {
    peticionServer(true);
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
        peticionServer(false);
      }).listen((position) {
        AppConfig.ubicacion.value =
            LatLng(position.latitude, position.longitude);
        print(
            "cambia ubicacion ${AppConfig.ubicacion.value.latitude}, ${AppConfig.ubicacion.value.longitude}");
        AppConfig.ubicacionLista.value = true;
        MyGps.cancelarSeguimiento();
        peticionServer(false);
        consultarInstalacionesCercanas(
            latitud: position.latitude.toString(),
            longitud: position.longitude.toString());
      });
    }
  }

  consultarInstalacionesCercanas(
      {required String latitud, required String longitud}) async {
    try {
      peticionServer(true);

      InstalacionesRecintosModel data = await _procesosOperativosApiImpl
          .consultarInstalacionesRecintosCercanos(
              latitud: latitud,
              longitud: longitud,
              idDgoProcElec:
                  AppEleccionesConfig.dataProcesosDisponible.idDgoProcElec,
              idDgoTipoEje: dataEjes.idDgoTipoEje);

      listDataInstalacionesRecinto.value = data.dataInstalacionesRecintos;
      peticionServer(false);
      if (listDataInstalacionesRecinto.length == 0) {
        DialogosAwesome.getWarning(
            descripcion: "No existen instalaciones cercanas",
            btnOkOnPress: () {
              Get.back();
            });
      } else {
        setDataCombo();
      }
    } on ServerException catch (e) {
      peticionServer(false);
      DialogosAwesome.getError(
          descripcion: e.cause,
          btnOkOnPress: () {
            Get.back();
          });
    }
  }

  setDataCombo() {
    for (int i = 0; i < listDataInstalacionesRecinto.length; i++) {
      DataInstalacionesRecinto data = listDataInstalacionesRecinto[i];
      dataCombo.add(ModelDataCombo(
          imgString: AppImages.iconMenu,
          id: data.idDgoReciElect,
          titulo:
              "${data.nomRecintoElec} -${data.nomRecintoElec}- (DISTANCIA ${data.distance}m)"));
    }
  }

  crearCodigo() async {
    try {

      bool isValid = formKey.currentState!.validate();
      if (!isValid) {
        return;
      }




      peticionServer(true);
      String ip = await DeviceInfo.getIp;

      OperativoCreateRequest operativoCreateRequest = OperativoCreateRequest(
          idGenUsuario: loginController.user.value.idGenUsuario,
          idGenPersona: loginController.user.value.idGenPersona,
          idDgoReciElect: dataSelect.value.id,
          ip: ip,
          latitud: AppConfig.ubicacion.value.latitude.toString(),
          longitud: AppConfig.ubicacion.value.longitude.toString(),
          idDgoProcElec:
              AppEleccionesConfig.dataProcesosDisponible.idDgoProcElec,
          idDgoReciUnidadPolicial: dataSelect.value.id,
          telefono: controllerTelefono.text);

      GenerarCodeModel data = await _procesosOperativosApiImpl.crearCodigo(
          operativoCreateRequest: operativoCreateRequest);

      dataProcesosAbierto.value = data.dataProcesosAbierto;
      peticionServer(false);
      if (data.dataProcesosAbierto.crearCodigo) {
        DialogosAwesome.getSucess(
            descripcion:
                "El código para que el personal se anexe es:\n\n${dataProcesosAbierto.value.codigoRecinto}",
            btnOkOnPress: () {
              Get.offAllNamed(EleccionesRoutes.HOME);
            });
      } else {
        DialogosAwesome.getWarning(
            descripcion: "La Unidad Policial\n"
                "${dataProcesosAbierto.value.nomRecintoElec}"
                "\n\nTiene asignado el CÓDIGO: ${dataProcesosAbierto.value.codigoRecinto}"
                "\nFECHA INICIO: ${dataProcesosAbierto.value.fechaIni}"
                "\n\nSi usted necesita abrir la misma Unidad Policial el encargado [${dataProcesosAbierto.value.encargado}] debe  finalizar o eliminar el código.",
            btnOkOnPress: () {});
      }
    } on ServerException catch (e) {
      peticionServer(false);
      DialogosAwesome.getError(
          descripcion: e.cause,
          btnOkOnPress: () {
            Get.back();
          });
    }
  }
}
