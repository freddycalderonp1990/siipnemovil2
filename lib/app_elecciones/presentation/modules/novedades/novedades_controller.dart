part of '../controllers.dart';

class NovedadesController extends GetxController {
  final loginController = Get.find<LoginController>();

  var peticionServer = false.obs;

  NovedadesApiImpl _novedadesApiImpl = Get.find();
  int idDgoTipoEje = 0;

  RxList<DataNovedade> listDataNovedadesPadres = <DataNovedade>[].obs;
  RxList<DataNovedade> listDataNovedadesHijas = <DataNovedade>[].obs;

  RxList<ModelDataCombo> dataComboNovedades = <ModelDataCombo>[].obs;
  Rx<ModelDataCombo> dataSelectNovedades =
      ModelDataCombo(id: 0, titulo: "").obs;

  RxList<ModelDataCombo> dataComboNovedadesHijas = <ModelDataCombo>[].obs;
  Rx<ModelDataCombo> dataSelectNovedadesHijas =
      ModelDataCombo(id: 0, titulo: "").obs;

  String? cedula;

  //VARIABLES PARA CITACIONES
  final formKey = GlobalKey<FormState>();

  var controllerCedula = new TextEditingController();
  var controllerTelefono = new TextEditingController();
  var controllerNumBoleta = new TextEditingController();
  var controllerNumCitacion = new TextEditingController();

  var controllerHora = new TextEditingController();
  var controllerMinuto = new TextEditingController();

  var controllerOrganizacion = new TextEditingController();
  var controllerDirigente = new TextEditingController();
  var controllerCantidad = new TextEditingController();

  var controllerNombre = new TextEditingController();
  var controllerCargo = new TextEditingController();
  var controllerGrado = new TextEditingController();
  var controllerMedioComunicacion = new TextEditingController();

  var controllerFuncion = new TextEditingController();
  var controllerDescripcion = new TextEditingController();
  var controllerInstalacion = new TextEditingController();
  var controllerDireccion = new TextEditingController();
  var controllerUnidad = new TextEditingController();

  var controllerMotivo = new TextEditingController();
  var controllerNumericoPersonal = new TextEditingController();

  var controllerNumerico = new TextEditingController();

  bool validarForm = false;
  bool mostrarFoto = false;

  GaleryCameraModel? mGaleryCameraModel;
  RxList<File?> imageFile = <File>[].obs;
  String msjFotos = "No se pudo cargar la foto, por favor vuelva a intentar";

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
    iniciarSeguimiento();
    var data = Get.arguments;
    if (data == null) {
      DialogosAwesome.getWarning(
          descripcion: "No existe información para continuar",
          btnOkOnPress: () {
            Get.back();
          });
    }

    idDgoTipoEje = data["idDgoTipoEje"];

    await consultarNovedades();
  }

  String getObservacion() {
    String novedadesPadres = dataSelectNovedades.value.titulo;

    int idDgoNovedadesElect = dataSelectNovedadesHijas.value.id;
    ObservacionModel observacionModel =
        ObservacionModel(idDgoNovedadesElect: idDgoNovedadesElect);
    switch (novedadesPadres.trim().toUpperCase()) {
      case "NOVEDADES":
        cedula = null;
        observacionModel = getObservacionNovedades(idDgoNovedadesElect);
        break;
      case "DELITOS":
        cedula = controllerCedula.text;
        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            cedula: controllerCedula.text);
        break;
      case "DETENIDOS":
        cedula = controllerCedula.text;
        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            cedula: controllerCedula.text,
            numBoleta: controllerNumBoleta.text);
        break;
      case "CITACIONES":
        cedula = controllerCedula.text;
        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            cedula: controllerCedula.text,
            numCitacion: controllerNumCitacion.text);

        break;

      case "UMO":
        //mostrarFoto = true;

        //wg = wgTxtCedulaCitacion(responsive);
        break;

      default:
    }

    return observacionModel.toJson();
  }

  ObservacionModel getObservacionNovedades(int idDgoNovedadesElect) {
    ObservacionModel observacionModel =
        ObservacionModel(idDgoNovedadesElect: idDgoNovedadesElect);

    switch (idDgoNovedadesElect) {
      case 17:
        break;
      case 18:
        break;
      case 19:
        //3. RECINTO ELECTORAL INSTALADO CON RETARDO POR DIFERENTES CAUSAS
        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            hora: "${controllerHora.text}:${controllerMinuto.text}");

        break;
      case 20:
        //4. RECINTOS ELECTORALES SUSPENDIDO POR DIFERENTES CAUSAS

        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            motivo: controllerMotivo.text);

        break;
      case 21:
        //5. AGRESIONES A SERVIDORES POLICIALES

        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            cedula: controllerCedula.text);

        break;
      case 22:
        //6. PRESENCIA DE MANIFESTANTES / CONCENTRACIONES / MARCHAS

        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            organizacion: controllerOrganizacion.text,
            dirigente: controllerDirigente.text,
            cantidad: int.parse(controllerCantidad.text));
        break;
      case 23:
        //7. QUEMA DE URNAS / PAPELETAS

        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            organizacion: controllerOrganizacion.text,
            dirigente: controllerDirigente.text,
            cantidad: int.parse(controllerCantidad.text));

        break;
      case 28:
        //8. TOMA DE RECINTOS / DELEGACIONES / BODEGAS / INSTALACIONES DEL CNE

        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            organizacion: controllerOrganizacion.text,
            dirigente: controllerDirigente.text,
            cantidad: int.parse(controllerCantidad.text));

        break;
      case 29:
        //9. PRESENCIA DE VENTAS AMBULANTES

        break;
      case 30:
        //10. ATENCIÓN MÉDICA POR DIFERENTES CAUSAS

        observacionModel = ObservacionModel(
          idDgoNovedadesElect: idDgoNovedadesElect,
          cedula: controllerCedula.text,
          telefono: controllerTelefono.text,
        );
        break;
      case 31:
        //11. SERVIDORES POLICIALES INFECTADOS (SOSPECHA/POSITIVO)

        observacionModel = ObservacionModel(
          idDgoNovedadesElect: idDgoNovedadesElect,
          cedula: controllerCedula.text,
        );

        break;

      case 32:
        observacionModel = ObservacionModel(
          idDgoNovedadesElect: idDgoNovedadesElect,
          numerico: int.parse(controllerNumerico.text),
        );

        break;

      /******************************** UMO ******************************************/
      case 33:
        //1. NUMERICO DE PERSONAL

        observacionModel = ObservacionModel(
          idDgoNovedadesElect: idDgoNovedadesElect,
          cantidad: int.parse(controllerNumericoPersonal.text),
        );

        break;
      case 34:
        //2. PLANTONES

        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            organizacion: controllerOrganizacion.text,
            dirigente: controllerDirigente.text,
            cantidad: int.parse(controllerCantidad.text));

        break;
      case 35:
        //3. MARCHAS
        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            organizacion: controllerOrganizacion.text,
            dirigente: controllerDirigente.text,
            cantidad: int.parse(controllerCantidad.text));

        break;

      case 36:
        //4. CIERRE DE VIAS
        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            organizacion: controllerOrganizacion.text,
            dirigente: controllerDirigente.text,
            cantidad: int.parse(controllerCantidad.text));

        break;

      case 37:
        //5. TOMA DE ENTIDADES
        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            organizacion: controllerOrganizacion.text,
            dirigente: controllerDirigente.text,
            cantidad: int.parse(controllerCantidad.text));

        break;

      /******************************** AEROPOLICIAL ******************************************/
      case 45:
        //1. DESPLAZAMIENTO DE AUTORIDADES

        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            nombre: controllerNombre.text,
            cargo: controllerCargo.text,
            grado: controllerGrado.text);

        break;
      case 46:
        //2. DESPLAZAMIENTO DE SERVIDORES PÚBLICOS

        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            nombre: controllerNombre.text,
            cargo: controllerCargo.text,
            grado: controllerGrado.text);

        break;
      case 47:
        //3. APOYO AÉREO A MEDIOS DE COMUNICACIÓN

        observacionModel = ObservacionModel(
          idDgoNovedadesElect: idDgoNovedadesElect,
          nombre: controllerNombre.text,
          medioComunicacion: controllerMedioComunicacion.text,
        );

        break;

      case 48:
        //4. TRASLADO DE RECURSOS LOGÍSTICOS

        break;

      /******************************** GOE - GIR ******************************************/

      case 41:
        //1. SEGURIDAD DE PERSONAS IMPORTANTES

        observacionModel = ObservacionModel(
          idDgoNovedadesElect: idDgoNovedadesElect,
          funcion: controllerFuncion.text,
          nombre: controllerNombre.text,
        );

        break;
      case 42:
        //2. SEGURIDAD DE INSTALACIONES

        observacionModel = ObservacionModel(
          idDgoNovedadesElect: idDgoNovedadesElect,
          instalacion: controllerInstalacion.text,
          descripcion: controllerDescripcion.text,
        );

        break;
      case 43:
        //3. REGISTRO DE EXPLOSIVOS

        observacionModel = ObservacionModel(
          idDgoNovedadesElect: idDgoNovedadesElect,
          direccion: controllerDireccion.text,
          descripcion: controllerDescripcion.text,
        );

        break;

      case 44:
        //4. APOYO A UNIDADES POLICIALES

        observacionModel = ObservacionModel(
          idDgoNovedadesElect: idDgoNovedadesElect,
          unidad: controllerUnidad.text,
        );
        break;

      /******************************** UMO - CRACK- UER ******************************************/

      case 49:
        observacionModel = ObservacionModel(
          idDgoNovedadesElect: idDgoNovedadesElect,
          numerico: int.parse(controllerNumerico.text),
        );
        break;

      case 50:
        observacionModel = ObservacionModel(
          idDgoNovedadesElect: idDgoNovedadesElect,
          numerico: int.parse(controllerNumerico.text),
        );
        break;
      case 51:
        observacionModel = ObservacionModel(
          idDgoNovedadesElect: idDgoNovedadesElect,
          numerico: int.parse(controllerNumerico.text),
        );
        break;
      case 52:
        observacionModel = ObservacionModel(
          idDgoNovedadesElect: idDgoNovedadesElect,
          numerico: int.parse(controllerNumerico.text),
        );
        break;
      case 54:
        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            hora: "${controllerHora.text}:${controllerMinuto.text}");

        break;

      case 55:
        observacionModel = ObservacionModel(
            idDgoNovedadesElect: idDgoNovedadesElect,
            hora: "${controllerHora.text}:${controllerMinuto.text}");

        break;

      default:
    }

    return observacionModel;
  }

  consultarNovedades() async {
    try {
      peticionServer(true);

      NovedadesModel data = await _novedadesApiImpl.consultarNovedades(
          idDgoTipoEje: idDgoTipoEje);

      listDataNovedadesPadres.value = data.dataNovedades;
      peticionServer(false);
      if (listDataNovedadesPadres.length == 0) {
        DialogosAwesome.getWarning(
            descripcion: "No existen novedades asignadas",
            btnOkOnPress: () {
              Get.back();
            });
      } else {
        dataSelectNovedadesHijas.value = ModelDataCombo(id: 0, titulo: "");
        listDataNovedadesHijas.clear();

        dataComboNovedades.value = setDataCombo(data.dataNovedades);
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

  consultarNovedadesHijas({required int idNovedadesPadre}) async {
    try {
      peticionServer(true);
      dataSelectNovedadesHijas.value=ModelDataCombo(id: 0, titulo: "");

      NovedadesModel data = await _novedadesApiImpl.consultarNovedadesHijas(
          idNovedadesPadre: idNovedadesPadre, idDgoTipoEje: idDgoTipoEje);

      listDataNovedadesHijas.value = data.dataNovedades;
      peticionServer(false);
      if (listDataNovedadesHijas.length == 0) {
        DialogosAwesome.getWarning(
            descripcion: "No existen novedades asignadas",
            btnOkOnPress: () {
              Get.back();
            });
      } else {
        dataComboNovedadesHijas.value = setDataCombo(data.dataNovedades);
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

  List<ModelDataCombo> setDataCombo(List<DataNovedade> listDataNovedades) {
    List<ModelDataCombo> dataComboNovedades = [];
    for (int i = 0; i < listDataNovedades.length; i++) {
      DataNovedade data = listDataNovedades[i];
      dataComboNovedades.add(ModelDataCombo(
          imgString: AppImages.iconMenu,
          id: data.idDgoNovedadesElect,
          titulo: data.descripcion));
    }
    return dataComboNovedades;
  }

  Future iniciarSeguimiento() async {
    peticionServer(true);
    bool gpsListo = await MyGps.verificarGPS();
    if (!gpsListo) {
      return;
    }

    if (AppConfig.positionSubscription == null) {
      print("iniciarSeguimiento");
      final positionStream = myGeolocator.Geolocator.getPositionStream(locationSettings:
      MyGps.getConfig);
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

  registrarNovedades() async {
    try {
      bool isValid = true;
      if (validarForm) {
        isValid = formKey.currentState!.validate();
      }
      if (!isValid) {
        return;
      }

      String ip = await DeviceInfo.getIp;
      String observacion = getObservacion();
      print(observacion);
      File? image;
      String? nameImg;

      if (mostrarFoto) {
        if (mGaleryCameraModel == null || imageFile.length == 0) {
          DialogosAwesome.getWarning(
              descripcion: "La imagen no puede estar vacia");
          return;
        }
        image = imageFile.value[0];
        nameImg = mGaleryCameraModel!.nombreImg;
      }

      peticionServer(true);
      NovedadesCreateRequest novedadesCreateRequest = NovedadesCreateRequest(
          idGenUsuario: loginController.user.value.idGenUsuario,
          ip: ip,
          latitud: AppConfig.ubicacion.value.latitude.toString(),
          longitud: AppConfig.ubicacion.value.longitude.toString(),
          idDgoProcElec: AppEleccionesConfig.dataProcesosAbierto.idDgoProcElec,
          idDgoPerAsigOpe:
              AppEleccionesConfig.dataProcesosAbierto.idDgoPerAsigOpe,
          idDgoNovedadesElect: dataSelectNovedadesHijas.value.id,
          documento: cedula,
          nameImg: nameImg,
          image: image,
          observacion: observacion);

      bool result = await _novedadesApiImpl.registrarNovedadesRecintoElectoral(
          novedadesCreateRequest: novedadesCreateRequest);

      if (result) {
        DialogosAwesome.getSucess(
            descripcion: "Registro con éxito",
            btnOkOnPress: () {
              Get.back();
            });
      }

      peticionServer(false);
    } on ServerException catch (e) {
      peticionServer(false);
      DialogosAwesome.getError(descripcion: e.cause, btnOkOnPress: () {});
    }
  }



  Future getImageCamera() async {
    try {
      peticionServer(true);
      mGaleryCameraModel = await FotografiaUtil.getImageCamera(AppEleccionesConfig.dataProcesosAbierto.descProcElecc);

      if (mGaleryCameraModel != null) {
        imageFile.clear();
        imageFile.value.add(mGaleryCameraModel!.imageFile);
      }
      peticionServer(false);
    } catch (e) {
      peticionServer(false);
      DialogosAwesome.getWarning(descripcion: msjFotos);
    }
  }

  Future getImageGallery() async {
    try {
      peticionServer(true);
      mGaleryCameraModel = await FotografiaUtil.getImageGallery(AppEleccionesConfig.dataProcesosAbierto.descProcElecc);

      if (mGaleryCameraModel != null) {
        imageFile.clear();
        imageFile.value.add(mGaleryCameraModel!.imageFile);
      }
      peticionServer(false);
    } catch (e) {
      peticionServer(false);
      DialogosAwesome.getWarning(descripcion: msjFotos);
    }
  }
}
