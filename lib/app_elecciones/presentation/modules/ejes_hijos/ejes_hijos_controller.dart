part of '../controllers.dart';

class EjesHijosController extends GetxController {
  final loginController = Get.find<LoginController>();
  var peticionServer = false.obs;

  ProcesosOperativosApiImpl _procesosOperativosApiImpl = Get.find();

  DataEjes dataEjes = DataEjes.empty();

  RxList<DataEjes> listDataEjesHijos = <DataEjes>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: Donde la vista ya se presento
    _init();
  }

  _init() async {
    var data = Get.arguments;
    if (data != null) {
      dataEjes = data;

      await consultarEjesHijos(dataEjes.idDgoTipoEje);
    } else {
      DialogosAwesome.getError(
          descripcion: "No se encontro información. vuelva a intentar",
          btnOkOnPress: () {
            Get.back();
          });
    }
  }

  consultarEjesHijos(int idDgoTipoEje) async {
    try {
      peticionServer(true);

      EjesHijosModel data = await _procesosOperativosApiImpl.consultarEjesHijos(
          idDgoTipoEje: idDgoTipoEje);

      listDataEjesHijos.value = data.dataEjesHijos;
      if (listDataEjesHijos.length == 0) {
        DialogosAwesome.getError(
            descripcion: "No existen Ejes. vuelva a intentar",btnOkOnPress: (){
              Get.back();
        });
      }

      peticionServer(false);
    } on ServerException catch (e) {
      peticionServer(false);
      DialogosAwesome.getError(
          descripcion: e.cause,
          btnOkOnPress: () {
            Get.back();
          });
    }
  }

  getPantalla(DataEjes dataEjes){
    Get.toNamed(EleccionesRoutes.INSTALACIONES_RECINTOS_CERCANOS,arguments:dataEjes );
  }
}
