part of '../controllers.dart';

class MenuJefeController extends GetxController {
  final loginController = Get.find<LoginController>();


  var peticionServer = false.obs;

  Rx<DataProcesosAbierto> dataProcesosAbierto = DataProcesosAbierto.empty().obs;

  ProcesosOperativosApiImpl _procesosOperativosApiImpl = Get.find();

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
    if (data != null) {
      dataProcesosAbierto.value = data;
    } else {
      DialogosAwesome.getError(
          descripcion: "No se encontro información. vuelva a intentar",
          btnOkOnPress: () {
            Get.back();
          });
    }
  }

  finalizarOperativo() async {
    try {
      peticionServer(true);

      String ip = await DeviceInfo.getIp;

      FinalizarRecintoElectoralRequest finalizarRecintoElectoralRequest =
          FinalizarRecintoElectoralRequest(
              idGenUsuario: loginController.user.value.idGenUsuario,
              idDgoCreaOpReci: dataProcesosAbierto.value.idDgoCreaOpReci,
              ip: ip,
              idDgoPerAsigOpe:dataProcesosAbierto.value. idDgoPerAsigOpe,
              idDgoTipoEje: dataProcesosAbierto.value.idDgoTipoEje);

      bool finalizar = await _procesosOperativosApiImpl.finalizarRecintoElectoral(finalizarRecintoElectoralRequest: finalizarRecintoElectoralRequest);


      if(finalizar){
        DialogosAwesome.getSucess(descripcion: "Operativo finalizado con éxito",btnOkOnPress: (){
          Get.offAllNamed(EleccionesRoutes.HOME);
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


  Future<bool> abandonarRecintoInstalacion() async {
    try {
      peticionServer(true);
      String ip = await DeviceInfo.getIp;

      bool result =
      await _procesosOperativosApiImpl.abandonarRecintoInstalacion(
          idDgoPerAsigOpe: AppEleccionesConfig.dataProcesosAbierto.idDgoPerAsigOpe,
          idGenUsuario: loginController.user.value.idGenUsuario,
          ip: ip);

      if (result) {
        DialogosAwesome.getSucess(descripcion: "Éxito",btnOkOnPress: (){
         Get.offAllNamed(EleccionesRoutes.HOME);
        });
      }
      peticionServer(false);
      return result;


    } on ServerException catch (e) {

      peticionServer(false);
      DialogosAwesome.getError(descripcion: e.cause, btnOkOnPress: () {});
      return false;
    }
  }
}
