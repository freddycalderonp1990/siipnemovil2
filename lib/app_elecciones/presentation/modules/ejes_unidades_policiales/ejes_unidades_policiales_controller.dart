part of '../controllers.dart';

class EjesUnidadesPolicialesController extends GetxController {
  final loginController = Get.find<LoginController>();
  var peticionServer = false.obs;

  ProcesosOperativosApiImpl _procesosOperativosApiImpl = Get.find();

  DataProcesosDisponible dataProcesosDisponible=DataProcesosDisponible.empty();

  RxList<DataEjes> listDataEjesUnidadesPoliciales =<DataEjes>[].obs;

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

    consultarEjesUnidadesPoliciales();

  }

  consultarEjesUnidadesPoliciales() async{
    try {
      peticionServer(true);



      EjesUnidadesPolicialesModel data = await _procesosOperativosApiImpl
          .consultarEjesUnidadesPoliciales();


      listDataEjesUnidadesPoliciales.value = data.dataEjesUnidadesPoliciales;
      if (listDataEjesUnidadesPoliciales.length==0 ) {
        DialogosAwesome.getError(descripcion: "No existen Ejes. vuelva a intentar");


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




}
