part of '../controllers.dart';

class PersonalAsignadoController extends GetxController {
  final loginController = Get.find<LoginController>();
  ProcesosOperativosApiImpl _procesosOperativosApiImpl = Get.find();

  var peticionServer = false.obs;

  RxList<DataPerAsignado> _listDataPerAsigando = <DataPerAsignado>[].obs;
  RxList<DataPerAsignado> listDataPerAsigandoActivo = <DataPerAsignado>[].obs;
  Rx<DataPerAsignado> dataPerJefe = DataPerAsignado.empty().obs;

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
    await consultarPersonalAsigando();
  }

  consultarPersonalAsigando() async {
    try {
      peticionServer(true);
      listDataPerAsigandoActivo.clear();

      _listDataPerAsigando.value =
          await _procesosOperativosApiImpl.consultarPersonalAsignado(
              idDgoCreaOpReci:
                  AppEleccionesConfig.dataProcesosAbierto.idDgoCreaOpReci);

      if (_listDataPerAsigando.length == 0) {
        DialogosAwesome.getError(descripcion: "No existe personal asigando");
      } else {
        for (int i = 0; i < _listDataPerAsigando.length; i++) {
          DataPerAsignado data = _listDataPerAsigando[i];
          if (!data.isJefe) {
            if (data.personalActivo) {
              listDataPerAsigandoActivo.add(data);
            }
          } else {
            dataPerJefe.value = data;
          }
        }
      }

      peticionServer(false);
    } on ServerException catch (e) {
      peticionServer(false);
      DialogosAwesome.getError(descripcion: e.cause, btnOkOnPress: () {});
    }
  }

 Future<bool> abandonarRecintoInstalacion(int idDgoPerAsigOpe) async {
    try {
      peticionServer(true);
      String ip = await DeviceInfo.getIp;

      bool result =
          await _procesosOperativosApiImpl.abandonarRecintoInstalacion(
              idDgoPerAsigOpe: idDgoPerAsigOpe,
              idGenUsuario: loginController.user.value.idGenUsuario,
              ip: ip);

      if (result) {
        DialogosAwesome.getSucess(descripcion: "Inactivado con éxito",btnOkOnPress: (){
          consultarPersonalAsigando();
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
