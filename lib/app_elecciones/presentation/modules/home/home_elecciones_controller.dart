part of '../controllers.dart';

class HomeEleccionesController extends GetxController {
  final loginController = Get.find<LoginController>();

  ProcesosOperativosApiImpl _procesosOperativosApiImpl = Get.find();

  var peticionServer = false.obs;

  DataProcesosAbierto dataProcesosAbierto = DataProcesosAbierto.empty();

  @override
  void onInit() {
    print("holaaaaaa014");
    super.onInit();
  }

  @override
  void onReady() {
    print("holaaaaaa");
    _verificarPersonalEncargadoAsignadoRecElectPorIdGenPersona();
    super.onReady();
  }

  getPageProcesosOperativos() {
    Get.toNamed(EleccionesRoutes.PROCESOS_OPERATIVOS);
  }

  Future<void>
      _verificarPersonalEncargadoAsignadoRecElectPorIdGenPersona() async {
    try {
      peticionServer(true);

      ProcesosRecAbiertoModel    data = await _procesosOperativosApiImpl
          .verificarPersonalEncargadoAsignadoRecElectPorIdGenPersona(
              idGenPersona: loginController.user.value.idGenPersona);
      peticionServer(false);
      if(data.dataProcesosAbierto.idDgoCreaOpReci==0){
        return;
      }

      dataProcesosAbierto=data.dataProcesosAbierto;

      AppEleccionesConfig.dataProcesosAbierto=dataProcesosAbierto;




        if(dataProcesosAbierto.isJefe) {
          Get.offAllNamed(EleccionesRoutes.MENU_JEFE, arguments: dataProcesosAbierto,parameters: {"isJefe":"true"});
        }
        else{
          //Menu integrante
          Get.offAllNamed(EleccionesRoutes.MENU_JEFE, arguments: dataProcesosAbierto,parameters: {"isJefe":"false"});
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
