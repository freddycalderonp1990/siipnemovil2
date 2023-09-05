part of '../../controllers.dart';

class OperativoPolcoController extends GetxController {
  var peticionServerState = false.obs;
  var tieneOrdenCaptura = false.obs;
  var vehiculoRobado = false.obs;

  RxList<PersonaModelData> dataPersona = <PersonaModelData>[].obs;
  RxList<DataVehiculo> dataVehiculo = <DataVehiculo>[].obs;

  int idHdrEventoResumPersona = 0;
  int idHdrEventoResumVehiculo = 0;
  int idHdrTipoResum = 0;

  var selectPerson = true.obs;
  var selectVehiculo = false.obs;

  final GpsController _gpsController = Get.find<GpsController>();

  var controllerCedula = new TextEditingController();
  var controllerPlaca = new TextEditingController();
  final loginController = Get.find<LoginController>();

  GlobalKey<FormState> formKeyPass = GlobalKey<FormState>();
  var controllerPass = new TextEditingController();

  final OperativosRepository _operativosRepository =
      Get.find<OperativosRepository>();

  int idSubTipoOperativo = 0;
  LatLng? ubicacion = null;

  RxInt idHdrEvento = 0.obs;

  @override
  void onInit() {
    _gpsController.cancelarSeguimiento();
    super.onInit();
  }

  @override
  void onReady() {
    iniciarSeguimiento();
    _crearOperativo();
    consultarCatalogo();
    super.onReady();
  }

  Future iniciarSeguimiento() async {
    peticionServerState(true);
    bool gpsListo = await MyGps.verificarGPS();
    if (!gpsListo) {
      return;
    }

    if (AppConfig.positionSubscription == null) {
      print("iniciarSeguimiento");

      final positionStream = myGeolocator.Geolocator.getPositionStream(
          locationSettings: MyGps.getConfig);
      AppConfig.positionSubscription = positionStream.handleError((error) {
        print("tcambia ubicacion ${error}");
        AppConfig.positionSubscription!.cancel();
        AppConfig.positionSubscription = null;
        MyGps.cancelarSeguimiento();
        peticionServerState(false);
      }).listen((position) {
        AppConfig.ubicacion.value =
            LatLng(position.latitude, position.longitude);
        print(
            "cambia ubicacion ${AppConfig.ubicacion.value.latitude}, ${AppConfig.ubicacion.value.longitude}");
        AppConfig.ubicacionLista.value = true;
        MyGps.cancelarSeguimiento();
        peticionServerState(false);
      });
    }
  }

  _crearOperativo() async {
    var data = Get.arguments;

    //verificamos si vamos a crear el operativo
    if (data['crearOperativo'] != null) {
      try {
        peticionServerState(true);
        idSubTipoOperativo = data['idSubTipoOperativo'];
        ubicacion = data['ubicacion'];
        print("coordenadas");
        print(
            "${ubicacion!.latitude.toString()},${ubicacion!.longitude.toString()}");

        OperativoCreateRequest operativoCreateRequest =
            new OperativoCreateRequest(
          latitude: ubicacion!.latitude.toString(),
          longitude: ubicacion!.longitude.toString(),
          idSubTipoOperativo: idSubTipoOperativo,
          idGenTipoTipificacion:
              SiipneConfig.idGenTipoTipificacionEcu_OperativoPolco,
          idGenPersona: loginController.user.value.idGenPersona,
          idGenUsuario: loginController.user.value.idGenUsuario,
        );

        String id =
            await _operativosRepository.crearOperativo(operativoCreateRequest);

        peticionServerState(false);

        print("el id es ${id}");
        if (id.toString() == "0") {
          throw ServerException(
              cause: "No pudo crearse el operativo. vuelva a intentar");
        }

        idHdrEvento.value = int.parse(id);
      } on ServerException catch (e) {
        peticionServerState(false);
        Get.back();
        DialogosAwesome.getError(descripcion: e.cause);
      }
    }
    //Verificamos si envian el idHdrEvento
    else if (data['idHdrEvento'] != null) {
      //Tiene operativo pendiente
      idHdrEvento.value = data['idHdrEvento'];
    }
  }

  Future<bool> finalizarOperativo() async {
    bool result = false;

    var isValid = true;

    isValid = formKeyPass.currentState!.validate();

    if (!isValid) {
      return false;
    }

    String pass = controllerPass.text;

    try {
      peticionServerState(true);

      result = await _operativosRepository.finalizarOperativo(
          user: loginController.user.value.nombreUsuario,
          pass: pass,
          idGenPersona: loginController.user.value.idGenPersona,
          idHdrEvento: idHdrEvento.value);

      peticionServerState(false);

      if (!result) {
        throw ServerException(cause: "Credenciales incorrectas");
      } else {
        DialogosAwesome.getSucess(
            descripcion: "Operativo Finalizado con Éxito",
            btnOkOnPress: () {
              Get.offAllNamed(SiipneRoutes.HOME);
            });
      }
    } on ServerException catch (e) {
      peticionServerState(false);
      Get.back();
      DialogosAwesome.getError(descripcion: e.cause);
    }

    return result;
  }

  consultarCatalogo() async {
    try {
      if (SiipneConfig.catalogoTipoConsultaPersonas.length == 0) {
        peticionServerState(true);
        SiipneConfig.catalogoTipoConsultaPersonas = await _operativosRepository
            .consultarCatalogoTipoConsulta(filtro: "P");
      }

      if (SiipneConfig.catalogoTipoConsultaVehiculos.length == 0) {
        peticionServerState(true);
        SiipneConfig.catalogoTipoConsultaVehiculos = await _operativosRepository
            .consultarCatalogoTipoConsulta(filtro: "V");
      }

      peticionServerState(false);
    } on ServerException catch (e) {
      peticionServerState(false);

      DialogosAwesome.getWarning(
          descripcion: "No se pudo cargar el catalogo ${e.cause}",
          btnOkOnPress: () {});
    }
  }

  Future<void> consultarPersonaPorCedula(
      {required GlobalKey<FormState> key}) async {
    final _cedula = controllerCedula.text;

    var isValid = true;

    isValid = key.currentState!.validate();

    if (!isValid) {
      return;
    }
    DialogosAwesome.getWarningSiNo(
        descripcion:
            "Usted ha ingresado la cédula:\n${_cedula} \n¿Desea continuar con la consulta?",
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          try {
            String ip = await DeviceInfo.getIp;

            UtilidadesUtil.ocultarTeclado(Get.context!);
            dataPersona.value.clear();
            peticionServerState(true);
            tieneOrdenCaptura(false);
            PersonaModel data = await _operativosRepository.consultarPersona(
                latitud: AppConfig.ubicacion.value.latitude.toString(),
                longitud: AppConfig.ubicacion.value.longitude.toString(),
                ip: ip,
                idOperativo: idHdrEvento.value,
                cedula: _cedula,
                idGenUsuario: loginController.user.value.idGenUsuario);

            dataPersona.value.add(data.data);

            if (dataPersona.length > 0) {
              idHdrEventoResumPersona = dataPersona.value[0].idHdrEventoResum;

              if (dataPersona.value[0].ordenCaptura.success) {
                UtilidadesUtil.playAudio(nameAudio: SiipneImages.audio_Alerta);
                tieneOrdenCaptura(true);
              }
            } else {
              idHdrEventoResumPersona = 0;
            }

            dataPersona.refresh();

            peticionServerState(false);
          } on ServerException catch (e) {
            peticionServerState(false);

            DialogosAwesome.getError(descripcion: e.cause);
          }
        });
  }

  Future<void> consultarVehiculoPorPlaca(
      {required GlobalKey<FormState> key}) async {
    final _placa = controllerPlaca.text;

    var isValid = true;

    isValid = key.currentState!.validate();

    if (!isValid) {
      return;
    }

    DialogosAwesome.getWarningSiNo(
        descripcion:
            "Usted ha ingresado la placa:\n${_placa} \n¿Desea continuar con la consulta?",
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          try {
            String ip = await DeviceInfo.getIp;

            UtilidadesUtil.ocultarTeclado(Get.context!);
            dataVehiculo.value.clear();
            peticionServerState(true);
            vehiculoRobado(false);
            DataVehiculo data = await _operativosRepository.consultarVehiculo(
                latitud: AppConfig.ubicacion.value.latitude.toString(),
                longitud: AppConfig.ubicacion.value.longitude.toString(),
                ip: ip,
                idOperativo: idHdrEvento.value,
                placa: _placa,
                idGenUsuario: loginController.user.value.idGenUsuario);

            dataVehiculo.value.add(data);

            if (dataVehiculo.value.length > 0) {
              idHdrEventoResumVehiculo = dataVehiculo.value[0].idHdrEventoResum;

              if (dataVehiculo.value[0].restriccionPj.robado) {
                UtilidadesUtil.playAudio(nameAudio: SiipneImages.audio_Alerta);
                vehiculoRobado(true);
              }
            } else {
              idHdrEventoResumVehiculo = 0;
            }

            dataVehiculo.refresh();

            peticionServerState(false);
          } on ServerException catch (e) {
            peticionServerState(false);

            DialogosAwesome.getError(descripcion: e.cause);
          }
        });
  }

  Future<void> updateResumenConsulta({required int idHdrTipoResum}) async {
    try {
      int idHdrEventoResum = 0;

      if (selectPerson.value) {
        idHdrEventoResum = idHdrEventoResumPersona;
      } else {
        idHdrEventoResum = idHdrEventoResumVehiculo;
      }

      if (idHdrEventoResum == 0) {
        DialogosAwesome.getWarning(
            descripcion: "Vuelva a Ejecutar la consulta");
        return;
      }

      bool update = await _operativosRepository.updateResumenConsultas(
          idHdrEventoResum: idHdrEventoResum, idHdrTipoResum: idHdrTipoResum);

      if (update) {
        DialogosAwesome.getSucess(descripcion: "Proceso realizado con éxito");
      }

      peticionServerState(false);
    } on ServerException catch (e) {
      peticionServerState(false);

      DialogosAwesome.getError(descripcion: e.cause);
    }
  }

  Future<void> getResumenConsulta() async {
    try {
      peticionServerState(true);

      ResumenConsultaModel data = await _operativosRepository
          .getResumenConsulta(idHdrEvento_idOperativo: idHdrEvento.value);

      if (data.dataResumenConsulta.length == 0) {
        peticionServerState(false);
        DialogosAwesome.getWarning(
            descripcion: "No existe información que mostrar",btnOkOnPress: (){});
        return;
      }



      String? ruta =
          await PdfResumenConsulta.generatePDF(data.dataResumenConsulta,idHdrEvento.value,loginController.user.value.apenom);



      if (ruta != null) {
        Get.toNamed(AppRoutes.PDFVIEW, arguments: {
          'pathPdf': ruta,
        });
      } else {
        DialogosAwesome.getWarning(
            descripcion: "No se pudo generar el PDF, vuelva a intentar");
      }

      peticionServerState(false);
    } on ServerException catch (e) {
      peticionServerState(false);

      DialogosAwesome.getError(descripcion: e.cause);
    }
  }
}
