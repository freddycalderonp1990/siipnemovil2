part of '../controllers.dart';

class TipoServiciosController extends GetxController {
  final loginController = Get.find<LoginController>();
  var peticionServer = false.obs;

  ProcesosOperativosApiImpl _procesosOperativosApiImpl = Get.find();

   DataProcesosDisponible dataProcesosDisponible=DataProcesosDisponible.empty();

   Rx<DataEjesAsignados> dataEjesAsignados=DataEjesAsignados(tipoEjeRecintos: false, tipoEjeUnidadesPoliciales: false, tipoEjeOtros: false).obs;

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

      dataProcesosDisponible=data;

      await consultarEjesAsignados(dataProcesosDisponible.idDgoProcElec);
    }
    else{
      DialogosAwesome.getError(descripcion: "No se encontro información. vuelva a intentar",btnOkOnPress: (){
        Get.back();
      });
    }

  }

  consultarEjesAsignados(int idDgoProcElec) async{
    try {
      peticionServer(true);

      bool existe=true;

      EjesAsigandosModel data = await _procesosOperativosApiImpl
          .consultarEjesAsigandosAlProceso(idDgoProcElec: idDgoProcElec);


      dataEjesAsignados.value = data.dataEjesAsignados;
      if (dataEjesAsignados==null ) {
        existe=false;
      }
      else{
        if(!dataEjesAsignados.value.tipoEjeOtros && !dataEjesAsignados.value.tipoEjeRecintos && !dataEjesAsignados.value.tipoEjeUnidadesPoliciales ){
          existe=false;
        }

      }

      peticionServer(false);
      if (!existe) {
        DialogosAwesome.getWarning(
            descripcion: "No existen Ejes Asignados", btnOkOnPress: () {
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




}
