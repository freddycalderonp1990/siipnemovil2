part of '../controllers.dart';

class ProcesosOperativosEleccionesController extends GetxController {
  final loginController = Get.find<LoginController>();
  var peticionServer = false.obs;

  ProcesosOperativosApiImpl _procesosOperativosApiImpl = Get.find();

  RxList<DataProcesosDisponible> listDataProcesosDisponibles =
      <DataProcesosDisponible>[].obs;

  @override
  void onInit() {
    iniciarSeguimiento();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    MyGps.cancelarSeguimiento();
    super.onReady();
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
        consultarProcesosOperativos(
            latitud: position.latitude.toString(),
            longitud: position.longitude.toString());
      });
    }
  }

  consultarProcesosOperativos(
      {required String latitud, required String longitud}) async {
    try {
      peticionServer(true);

      ProcesosOperativosDisponiblesModel data = await _procesosOperativosApiImpl
          .consultarProcesosOperativosDisponibles(
              latitud: latitud, longitud: longitud);

      listDataProcesosDisponibles.value = data.dataProcesosDisponibles;

      peticionServer(false);
      if (listDataProcesosDisponibles.length == 0) {
        DialogosAwesome.getWarning(
            descripcion: "No existen Procesos disponibles",
            btnOkOnPress: () {
              Get.back();
            });
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

  getPantalla(DataProcesosDisponible data) {
    AppEleccionesConfig.dataProcesosDisponible = data;

    Get.toNamed(EleccionesRoutes.TIPO_SERVICIOS_ELECCIONES, arguments: data);
  }
}
