part of '../controllers.dart';

class AddPersonalController extends GetxController {
  final loginController = Get.find<LoginController>();
  ProcesosOperativosApiImpl _procesosOperativosApiImpl = Get.find();

  var peticionServer = false.obs;

  RxList<ModelDataCombo> dataComboUnidadesPoliciales = <ModelDataCombo>[].obs;
  Rx<ModelDataCombo> dataSelectUnidadesPoliciales =
      ModelDataCombo(id: 0, titulo: "").obs;

  List<DataInstalacionesRecinto> listUnidadesPoliciales = [];

  Rx<DataPerPolicial> dataPerPolicial = DataPerPolicial.empty().obs;

  //VARIABLES PARA CITACIONES
  final formKey = GlobalKey<FormState>();

  var controllerCedula = new TextEditingController();

  @override
  void onInit() {
    // TODO: el contolloler se ha creado pero la vista no se ha renderizado
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: Donde la vista ya se presento
    _init();
  }

  _init() async {
    var data = Get.arguments;
    await consultarUnidadesPoliciales();
    iniciarSeguimiento();
  }

  List<ModelDataCombo> setDataCombo(
      List<DataInstalacionesRecinto> listUnidadesPoliciales) {
    List<ModelDataCombo> dataComboNovedades = [];
    for (int i = 0; i < listUnidadesPoliciales.length; i++) {
      DataInstalacionesRecinto data = listUnidadesPoliciales[i];
      dataComboNovedades.add(ModelDataCombo(
          imgString: AppImages.iconMenu,
          id: data.idDgoReciElect,
          titulo: data.nomRecintoElec));
    }
    return dataComboNovedades;
  }

  consultarUnidadesPoliciales() async {
    try {
      peticionServer(true);
      dataSelectUnidadesPoliciales.value = ModelDataCombo(id: 0, titulo: "");

      InstalacionesRecintosModel data =
          await _procesosOperativosApiImpl.consultarAllUnidadesPoliciales();

      listUnidadesPoliciales = data.dataInstalacionesRecintos;

      peticionServer(false);

      if (listUnidadesPoliciales.length == 0) {
        DialogosAwesome.getError(
            descripcion: "No existen Unidades Policiales que Mostrar");
        return;
      }
      dataComboUnidadesPoliciales.value = setDataCombo(listUnidadesPoliciales);
    } on ServerException catch (e) {
      peticionServer(false);
      DialogosAwesome.getError(descripcion: e.cause, btnOkOnPress: () {});
    }
  }

  consultarDatosPerPorCedula() async {
    try {

      bool isValid = true;

      isValid = formKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      peticionServer(true);
      dataPerPolicial.value = DataPerPolicial.empty();
      dataSelectUnidadesPoliciales.value = ModelDataCombo(id: 0, titulo: "");

      DataPerPolicial data = await _procesosOperativosApiImpl
          .consultarDatosPerPorCedula(cedula: controllerCedula.text);

      peticionServer(false);
      if (data.idGenPersona == 0) {
        DialogosAwesome.getWarning(
            descripcion: "No existe datos para la cédula ingresada",
            btnOkOnPress: () {});
        return;
      }

      dataPerPolicial.value = data;
    } on ServerException catch (e) {
      peticionServer(false);
      DialogosAwesome.getError(descripcion: e.cause, btnOkOnPress: () {});
    }
  }

  addPersonalIntegrante() async {
    try {

      bool isValid = true;

      isValid = formKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      peticionServer(true);
      String ip = await DeviceInfo.getIp;

      AddPersonalRequest addPersonalRequest = AddPersonalRequest(
          idGenUsuario: loginController.user.value.idGenUsuario,
          idDgoCreaOpReci:
              AppEleccionesConfig.dataProcesosAbierto.idDgoCreaOpReci,
          ip: ip,
          idDgoPerAsigOpe:
              AppEleccionesConfig.dataProcesosAbierto.idDgoPerAsigOpe,
          idDgoTipoEje: 0,
          //no requerido
          idDgoReciElect:
              AppEleccionesConfig.dataProcesosAbierto.idDgoReciElect,
          idGenPersona: dataPerPolicial.value.idGenPersona,
          idRecintoUnidadPolicial: dataSelectUnidadesPoliciales.value.id,
          latitud: AppConfig.ubicacion.value.latitude.toString(),
          longitud: AppConfig.ubicacion.value.longitude.toString());

      bool result = await _procesosOperativosApiImpl.addPersonalIntegrante(
          addPersonalRequest: addPersonalRequest);

      if (result) {
        dataPerPolicial.value = DataPerPolicial.empty();
        dataSelectUnidadesPoliciales.value = ModelDataCombo(id: 0, titulo: "");
        controllerCedula.text="";
        DialogosAwesome.getSucess(descripcion: "Agregado con éxito",btnOkOnPress: (){});
      }

      peticionServer(false);
    } on ServerException catch (e) {
      peticionServer(false);
      DialogosAwesome.getError(descripcion: e.cause, btnOkOnPress: () {});
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
      });
    }
  }
}
