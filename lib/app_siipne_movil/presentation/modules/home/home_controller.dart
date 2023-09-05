part of '../controllers.dart';

class HomeController extends GetxController {
  var peticionServerState = false.obs;
  final ModulosRepository _modulosRepository = Get.find<ModulosRepository>();


  final GpsController _gpsController = Get.find<GpsController>();

  final loginController = Get.find<LoginController>();
  User user = User.empty();
  List<TipoOperativo> tipoOperativos = [];

  int idSubTipoOperativo = 0;

  final OperativosRepository _operativosRepository =
      Get.find<OperativosRepository>();

  final LocalStorageRepository _localStorageRepository =
      Get.find<LocalStorageRepository>();

  RxList<Modulo> modulos = <Modulo>[].obs;

  RxList<OperativoPendiente> operativosPendientes = <OperativoPendiente>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {

    user=loginController.user.value;
    getOperativospendientes();

    super.onReady();
  }

  getModulos() async {
    try {
      peticionServerState(true);

      modulos.value = await _modulosRepository.getModulos(idGenPersona: user.idGenPersona ,idGenUsuario: user.idGenUsuario);

      modulos.refresh();

      peticionServerState(false);
    } on ServerException catch (e) {
      peticionServerState(false);

      _verifiSitieneAccesoModulos(  e.cause);
    }
  }

  _verifiSitieneAccesoModulos(String msj) async {
    if (modulos.value.length == 0) {

      Get.offAllNamed(AppRoutes.HOME_APP);
      DialogosAwesome.getWarning(
          descripcion: "Sin permisos o sin acceso a los modulos",btnOkOnPress: (){
      });
    }
    else{
      DialogosAwesome.getError(descripcion: msj);
    }
  }

  getTipoOperativos({required int idTipoOperativo}) async {
    try {
      peticionServerState(true);

      tipoOperativos =
          await await _operativosRepository.getTipoOperativos(idTipoOperativo);

      if (tipoOperativos.length > 0) {
        getDialogo(tipoOperativos);
      } else {
        DialogosAwesome.getWarning(
            descripcion: "No existen tipos de operativos");
      }

      peticionServerState(false);
    } on ServerException catch (e) {
      peticionServerState(false);

      DialogosAwesome.getError(descripcion: e.cause);
    }
  }

  getOperativospendientes() async {
    try {
      operativosPendientes = <OperativoPendiente>[].obs;
      peticionServerState(true);

      operativosPendientes.value =
          await _operativosRepository.getOperativosPendientes(
        idGenUsuario: loginController.user.value.idGenUsuario,
        idGenPersona: loginController.user.value.idGenPersona,
      );

      if (operativosPendientes.length > 0) {
        DialogosAwesome.getInformationSiNo(
            descripcion:
                "Tiene un operativo pendiente de \n\nFECHA: ${operativosPendientes[0].fechaEvento}. \n\n ¿Desea continuar?",
            btnOkOnPress: () {
              Get.back();
              Get.toNamed(SiipneRoutes.OPERATIVOS_POLCO, arguments: {
                'idHdrEvento': operativosPendientes[0].idHdrEvento
              });
            });
      } else {
        getModulos();
      }

      peticionServerState(false);
    } on ServerException catch (e) {
      peticionServerState(false);

      DialogosAwesome.getError(descripcion: e.cause);
    }
  }

  getPantallaOperativos(int idGenModulo) async {
    switch (idGenModulo) {
      //44 operativo polco Desarrollo
      //37 Pruebas Produccion
      case SiipneConfig.idGenModulo_OperativoPolco:
        //Verificamos si no existe operativos abiertos
        _verificarOperativosAbiertos();

        break;

      case SiipneConfig.idGenModulo_OperativoUer:
      //Verificamos si no existe operativos abiertos
        _verificarOperativosAbiertos();

        break;// The switch statement must be told to exit, or it will execute every case.

      default:
        DialogosDesingWidget.getDialogoX(
            title: "Información", contenido: Text("Modulo en mantenimiento"));
    }
  }

  _verificarOperativosAbiertos() async {
    try {
      await getOperativospendientes();

      if (operativosPendientes.value.length > 0) {
        DialogosAwesome.getInformationSiNo(
            descripcion:
                "Tiene un operativo pendiente de fecha: ${operativosPendientes[0].fechaEvento}. \n\n ¿Desea continuar?",
            btnOkOnPress: () {
              Get.back();
              Get.toNamed(SiipneRoutes.OPERATIVOS_POLCO, arguments: {
                'idHdrEvento': operativosPendientes[0].idHdrEvento
              });
            });
      } else {
        await getTipoOperativos(
            idTipoOperativo:
                SiipneConfig.idGenTipoTipificacionEcu_OperativoPolco);
      }
    } on ServerException catch (e) {
      DialogosAwesome.getError(descripcion: e.cause);
    }
  }

  getDialogo(List<TipoOperativo> tiposOperativos) {
    if (tiposOperativos.length == 0) {
      return null;
    }

    return DialogosDesingWidget.getDialogoX(
        title: "Tipos de Operativos",
        contenido: getComboSubTipoOperativo(tiposOperativos),
        botones: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                child: BtnIconWidget(
                  select: true,
                  stringImg: SiipneImages.icon_consult_person,
                  titulo: "Crear",
                  onPressed: () {
                    _getPantallaOperativo();
                  },
                ),
              ),
            ),
          ],
        ));
  }

  _getPantallaOperativo() {
    if (idSubTipoOperativo > 0) {
      Get.back();
      Get.toNamed(SiipneRoutes.OPERATIVOS_POLCO, arguments: {
        'idSubTipoOperativo': idSubTipoOperativo,
        'crearOperativo': true,
        'ubicacion': _gpsController.ubicacion.value
      });
    } else {
      DialogosAwesome.getWarning(
          descripcion: "No ah selecciona un tipo de operativo");
    }
  }

  getComboSubTipoOperativo(List<TipoOperativo> tiposOperativos) {
    final _openDropDownProgKey = GlobalKey<DropdownSearchState<String>>();

    List<ModelDataCombo> data = [];

    for (int i = 0; i < tiposOperativos.length; i++) {
      data.add(ModelDataCombo(
          id: tiposOperativos[i].idGenTipoTipificacion,
          titulo: tiposOperativos[i].descripcion));
    }

    return ContenedorDesingWidget(
        child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
            child: ComboConBusqueda(
              complete: (data) {
                idSubTipoOperativo = data.id;
                print("el dato seleccionado es id ${idSubTipoOperativo}");
              },
              data: data,
            )));

    /*  return ContenedorDesingWidget(
        child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
            child: ComboConBusqueda(
              openDropDownProgKey: _openDropDownProgKey,
              showClearButton: false,
              selectValue: datosString.length > 0 ? datosString[0] : "",
              title: "Tipos de Operativos",
              searchHint: 'Buscar...',
              datos: datosString,
              complete: (descripcion) {
                print("el dato seleccionado es ${descripcion}");
                _setidSubTipoOperativo(descripcion);
              },
            )));*/
  }

  verificarGps(Modulo modulo) async {
    //se verifica si el GPS del dispositivo seta activo y tiene permisos

    bool verificarGps = await _gpsController.verificarGPS();
    if (verificarGps) {
      _gpsController.iniciarSeguimiento();
      if (!_gpsController.ubicacionLista.value) {
        DialogosAwesome.getInformation(
            descripcion: "Las coordenas aun no estan lista vuelva a intentar");
      } else {
        DialogosAwesome.getWarningSiNo(
            descripcion:
                "Esta seguro de iniciar el Operativo: " + modulo.descripcion,
            btnCancelOnPress: (){},
            btnOkOnPress: () {
              _gpsController.cancelarSeguimiento();
              getPantallaOperativos(int.parse(modulo.idGenModulo));
            });
      }
    }
  }
}
