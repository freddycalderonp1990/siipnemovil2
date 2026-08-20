part of '../controllers.dart';

class OpServicioUrbanoController extends GetxController {
  final LoginController loginController = Get.find<LoginController>();
  final SiipneMovilUseCase siipneMovilUseCase = Get.find();

  late UserEntities user;

  final RxBool peticionServerState = false.obs;
  final ScrollController scrollController = ScrollController();
  final RxBool mostrarIndicador = true.obs;

  final RxBool selectPerson = true.obs;
  final RxBool selectVehiculo = false.obs;

  final TextEditingController controllerCedula = TextEditingController();
  final TextEditingController controllerPlaca = TextEditingController();

  final RxBool tieneOrdenCaptura = false.obs;
  final RxBool vehiculoRobado = false.obs;

  final RxBool ocultarBtnBuscarPersona = false.obs;
  final RxBool ocultarBtnBuscarVehiculo = false.obs;

  final RxList<DataConsultaPersona> dataPersona = <DataConsultaPersona>[].obs;
  final RxList<DataVehiculo> dataVehiculo = <DataVehiculo>[].obs;

  final RxBool paginaPersonasVehiculoLoading = false.obs;

  // ============================================================
  // OPERATIVO
  // ============================================================

  final Rx<DataCreateOp> dataCreateOp = DataCreateOp.empty().obs;

  final RxInt idHdrEventoActual = 0.obs;
  final RxInt idOperativoVariablesActual = 0.obs;
  final RxInt idGenGeoSenpladesActual = 0.obs;

  final RxBool esOperativoPendiente = false.obs;
  final Rxn<Pendiente> operativoPendiente = Rxn<Pendiente>();

  final RxBool datosOperativoValidos = true.obs;
  String mensajeDatosOperativo = '';

  final Rxn<Anexarse> operativoAnexado = Rxn<Anexarse>();
  final RxBool esOperativoAnexado = false.obs;
  // ============================================================
  // RESUMEN DEL OPERATIVO
  // ============================================================

  final Rxn<ResultadosOperativo> resultadosOperativo =
      Rxn<ResultadosOperativo>();

  final RxBool cargandoResultadosOperativo = false.obs;

  String mensajeErrorResultadosOperativo = '';
  // ============================================================
  // VARIABLES RESULTADO
  // ============================================================

  final RxList<VariablesResultado> variablesResultado =
      <VariablesResultado>[].obs;

  final Rxn<VariablesResultado> variableResultadoSeleccionada =
      Rxn<VariablesResultado>();

  final RxBool cargandoVariablesResultado = false.obs;
  final RxBool variablesResultadoCargadas = false.obs;
  final RxBool errorCargaVariables = false.obs;

  String mensajeErrorVariables = '';

  int get idVariableResultadoDefault {
    final List<VariablesResultado> variables = variablesResultadoConsultaActual;

    if (variables.isEmpty) return 0;

    return variables.first.idVariable;
  }

  int get idVariableResultadoSeleccionada =>
      variableResultadoSeleccionada.value?.idVariable ?? 0;

  String get descripcionVariableResultadoSeleccionada =>
      variableResultadoSeleccionada.value?.desHdrTipoResum.trim() ?? '';

  List<VariablesResultado> get variablesResultadoPersona {
    return variablesResultado.where((VariablesResultado item) {
      final String tipo = item.tipoConsulta.trim().toUpperCase();

      return tipo == 'T' || tipo == 'P';
    }).toList();
  }

  List<VariablesResultado> get variablesResultadoVehiculo {
    return variablesResultado.where((VariablesResultado item) {
      final String tipo = item.tipoConsulta.trim().toUpperCase();

      return tipo == 'T' || tipo == 'V';
    }).toList();
  }

  List<VariablesResultado> get variablesResultadoConsultaActual {
    if (selectPerson.value) {
      return variablesResultadoPersona;
    }

    if (selectVehiculo.value) {
      return variablesResultadoVehiculo;
    }

    return <VariablesResultado>[];
  }

  // ============================================================
  // ACTUALIZAR RESULTADO DESPUÉS DE CONSULTAR
  // ============================================================

  final RxBool actualizandoResultado = false.obs;

  /*
   * Variable con la que el registro fue insertado originalmente.
   *
   * La consulta sigue utilizando automáticamente la primera
   * variable disponible. Esto mantiene intacto el flujo actual.
   *
   * Luego el usuario puede seleccionar otra variable y,
   * al presionar NUEVA CONSULTA, se actualiza el registro.
   */
  int idVariableInsertadaPersona = 0;
  int idVariableInsertadaVehiculo = 0;

  String mensajeErrorActualizaResultado = '';

  bool get existeResultadoPersona =>
      dataPersona.isNotEmpty && idHdrEventoResumPersona > 0;

  bool get existeResultadoVehiculo =>
      dataVehiculo.isNotEmpty && idHdrEventoResumVehiculo > 0;

  bool get existeResultadoConsultaActual {
    if (selectPerson.value) {
      return existeResultadoPersona;
    }

    if (selectVehiculo.value) {
      return existeResultadoVehiculo;
    }

    return false;
  }

  // ============================================================
  // CONDUCTOR / OCUPANTES
  // ============================================================

  final Set<String> documentosPersonasVehiculoRegistradas = <String>{};

  String documentoConductorVehiculo = '';

  final List<String> documentosOcupantesVehiculo = <String>[];

  final TextEditingController controllerCedulaVehiculo =
      TextEditingController();

  final RxList<DataConsultaPersona> dataPersona_conductor =
      <DataConsultaPersona>[].obs;

  final RxList<DataConsultaPersona> dataPersona_ocupantes =
      <DataConsultaPersona>[].obs;

  final RxString tipoPersonaVehiculo = 'CONDUCTOR'.obs;

  final RxBool consultandoPersonaVehiculo = false.obs;

  /*
   * Compatibilidad con código anterior.
   */
  final RxList<DataConsultaPersona> dataPersona_acompanante1 =
      <DataConsultaPersona>[].obs;

  final RxList<DataConsultaPersona> dataPersona_acompanante2 =
      <DataConsultaPersona>[].obs;

  final RxList<DataConsultaPersona> dataPersona_acompanante3 =
      <DataConsultaPersona>[].obs;

  final RxList<DataVehiculo> dataVehiculoRelacional = <DataVehiculo>[].obs;

  final RxBool mostrarPanelOcupantes = false.obs;

  String placaConsultadaAnterior = '';
  String placaConsultada = '';

  int idHdrEventoResumPersona = 0;

  int get idHdrEventoResumVehiculo {
    if (dataVehiculo.isEmpty) return 0;

    return dataVehiculo.first.idHdrEventoResum;
  }

  int get cantidadOcupantesVehiculo => dataPersona_ocupantes.length;

  bool get tieneConductorVehiculo => dataPersona_conductor.isNotEmpty;

  // ============================================================
  // FINALIZAR
  // ============================================================

  final TextEditingController controllerClaveFinalizar =
      TextEditingController();

  final RxBool ocultarClaveFinalizar = true.obs;
  final RxBool autenticandoBiometria = false.obs;
  final RxBool finalizandoOperativo = false.obs;

  String mensajeErrorFinalizar = '';

  final RxBool puedeFinalizarOperativo = false.obs;

  // ============================================================
  // CONSULTAS
  // ============================================================

  String mensajeErrorConsulta = '';

  // ============================================================
  // FOCO CONSULTAS
  // ============================================================

  final FocusNode focusCedula = FocusNode();
  final FocusNode focusPlaca = FocusNode();

  // ============================================================
  // PERSONAL DEL OPERATIVO
  // ============================================================

  final RxList<Integrante> personalOperativo = <Integrante>[].obs;

  String mensajeErrorPersonalOperativo = '';

  // ============================================================
  // INIT
  // ============================================================
  final RxString nombreOperativoActual = ''.obs;
// ============================================================
// ANTECEDENTES PERSONA
// ============================================================

  final Rxn<DataAntecedentes> datosAntecedentesPersona =
  Rxn<DataAntecedentes>();

  final RxBool consultandoAntecedentesPersona = false.obs;

  String mensajeErrorAntecedentesPersona = '';

  bool get tieneAntecedentesPersona =>
      datosAntecedentesPersona.value?.antecedentes.isNotEmpty ?? false;
  @override
  void onInit() {
    super.onInit();

    user = loginController.user.value;

    scrollController.addListener(_onScroll);

    _inicializarPantalla();
  }

  Future<void> _inicializarPantalla() async {
    _cargarDatosOperativo();

    if (!datosOperativoValidos.value) {
      return;
    }

    await cargarVariablesResultado();

    solicitarFocoConsultaActual();
  }

  @override
  void onReady() {
    super.onReady();

    Future.delayed(
      const Duration(milliseconds: 500),
      solicitarFocoConsultaActual,
    );
  }

  // ============================================================
  // CARGAR OPERATIVO
  // ============================================================

  void _cargarDatosOperativo() {
    nombreOperativoActual.value = '';
    datosOperativoValidos.value = true;
    mensajeDatosOperativo = '';

    puedeFinalizarOperativo.value = false;

    final dynamic arguments = Get.arguments;
    final String nombreOperativoArgumento =
    ParseModel.parseToString(
      arguments['nombreOperativo'],
    ).trim();


    debugPrint('==========================================');
    debugPrint('OP SERVICIO URBANO - ARGUMENTOS');
    debugPrint('$arguments');
    debugPrint('TIPO: ${arguments.runtimeType}');
    debugPrint('==========================================');

    if (arguments == null || arguments is! Map) {
      _marcarDatosInvalidos('No se recibieron datos válidos del operativo.');
      return;
    }
    if (nombreOperativoArgumento.isNotEmpty) {
      nombreOperativoActual.value =
          nombreOperativoArgumento;
    }
    final String tipoAcceso = ParseModel.parseToString(
      arguments['tipoAcceso'],
    ).trim().toUpperCase();

    int idEvento = ParseModel.parseToInt(arguments['idHdrEvento']);

    if (idEvento <= 0) {
      idEvento = ParseModel.parseToInt(arguments['numeroOperativo']);
    }

    if (idEvento > 0) {
      idHdrEventoActual.value = idEvento;
    }

    final int idOperativoArgumento = ParseModel.parseToInt(
      arguments['idOperativo'],
    );

    if (idOperativoArgumento > 0) {
      idOperativoVariablesActual.value = idOperativoArgumento;
    }

    final int idGeo = ParseModel.parseToInt(arguments['idGenGeoSenplades']);

    if (idGeo > 0) {
      idGenGeoSenpladesActual.value = idGeo;
    }

    // ==========================================================
    // PENDIENTE
    // ==========================================================

    final dynamic datoPendiente = arguments['pendiente'];

    if (datoPendiente is Pendiente) {
      operativoPendiente.value = datoPendiente;
      nombreOperativoActual.value = datoPendiente.descripcion.trim();
      puedeFinalizarOperativo.value = true;

      esOperativoPendiente.value = true;
      esOperativoAnexado.value = false;

      if (idHdrEventoActual.value <= 0) {
        idHdrEventoActual.value = datoPendiente.idHdrEvento;
      }

      if (idGenGeoSenpladesActual.value <= 0) {
        idGenGeoSenpladesActual.value = datoPendiente.idGenGeoSenplades;
      }

      if (datoPendiente.idTipoOperativo > 0) {
        idOperativoVariablesActual.value = datoPendiente.idTipoOperativo;
      }

      _seleccionarConsultaPorDescripcion(datoPendiente.descripcion);

      debugPrint('------------------------------------------');
      debugPrint('FLUJO: PENDIENTE');
      debugPrint('ID HDR EVENTO: ${datoPendiente.idHdrEvento}');
      debugPrint('ID TIPO OPERATIVO: ${datoPendiente.idTipoOperativo}');
      debugPrint('------------------------------------------');
    }

    // ==========================================================
    // ANEXARSE
    // ==========================================================

    final dynamic datoAnexarse = arguments['anexarse'];

    if (datoAnexarse is Anexarse) {
      operativoAnexado.value = datoAnexarse;

      puedeFinalizarOperativo.value = false;

      esOperativoAnexado.value = true;
      esOperativoPendiente.value = false;

      if (idHdrEventoActual.value <= 0) {
        idHdrEventoActual.value = datoAnexarse.idHdrEvento;
      }
      // NOMBRE DEL OPERATIVO
      nombreOperativoActual.value = datoPendiente.descripcion.trim();
      if (datoAnexarse.idTipoOperativo > 0) {
        idOperativoVariablesActual.value = datoAnexarse.idTipoOperativo;
      }

      _seleccionarConsultaPorDescripcion(datoAnexarse.descripcion);

      debugPrint('------------------------------------------');
      debugPrint('FLUJO: ANEXARSE');
      debugPrint('ID HDR EVENTO: ${datoAnexarse.idHdrEvento}');
      debugPrint('ID TIPO OPERATIVO: ${datoAnexarse.idTipoOperativo}');
      debugPrint('------------------------------------------');
    }

    if (tipoAcceso == 'ANEXARSE' && idHdrEventoActual.value > 0) {
      esOperativoAnexado.value = true;
      esOperativoPendiente.value = false;

      puedeFinalizarOperativo.value = false;
    }

    // ==========================================================
    // NUEVO OPERATIVO
    // ==========================================================

    final dynamic datoNuevo = arguments['dataCreateOp'];

    if (datoNuevo is DataCreateOp) {
      dataCreateOp.value = datoNuevo;

      if (idHdrEventoActual.value <= 0) {
        idHdrEventoActual.value = datoNuevo.idHdrEvento;
      }

      if (idGenGeoSenpladesActual.value <= 0) {
        idGenGeoSenpladesActual.value = datoNuevo.idGenGeoSenplades;
      }

      if (datoNuevo.idTipoOperativo > 0) {
        idOperativoVariablesActual.value = datoNuevo.idTipoOperativo;
      }
      // RESPALDO DEL NOMBRE ENVIADO AL CREAR
      final String nombreArgumento =
      ParseModel.parseToString(
        arguments['nombreOperativo'],
      ).trim();
      if (nombreArgumento.isNotEmpty) {
        nombreOperativoActual.value =
            nombreArgumento;
      }
      esOperativoPendiente.value = false;
      esOperativoAnexado.value = false;

      puedeFinalizarOperativo.value = true;

      debugPrint('------------------------------------------');
      debugPrint('FLUJO: NUEVO OPERATIVO');
      debugPrint('ID HDR EVENTO: ${datoNuevo.idHdrEvento}');
      debugPrint('ID GEO: ${datoNuevo.idGenGeoSenplades}');
      debugPrint('ID TIPO OPERATIVO: ${datoNuevo.idTipoOperativo}');
      debugPrint('------------------------------------------');
    }

    if (idHdrEventoActual.value <= 0) {
      _marcarDatosInvalidos(
        'No fue posible determinar el número del operativo.',
      );
      return;
    }

    if (idOperativoVariablesActual.value <= 0) {
      debugPrint('==========================================');
      debugPrint('ADVERTENCIA');
      debugPrint('NO SE RECIBIÓ idTipoOperativo');
      debugPrint('LAS VARIABLES NO PODRÁN SER CARGADAS');
      debugPrint('==========================================');
    }

    debugPrint('==========================================');
    debugPrint('DATOS OPERATIVO DEFINITIVOS');
    debugPrint('ID HDR EVENTO: ${idHdrEventoActual.value}');
    debugPrint('ID OPERATIVO VARIABLES: ${idOperativoVariablesActual.value}');
    debugPrint('ID GEO: ${idGenGeoSenpladesActual.value}');
    debugPrint('PENDIENTE: ${esOperativoPendiente.value}');
    debugPrint('ANEXADO: ${esOperativoAnexado.value}');
    debugPrint('==========================================');
  }

  void _seleccionarConsultaPorDescripcion(String descripcion) {
    final String valor = descripcion.trim().toUpperCase();

    if (valor.contains('VEHICULO') || valor.contains('VEHÍCULO')) {
      selectPerson.value = false;
      selectVehiculo.value = true;
      return;
    }

    selectPerson.value = true;
    selectVehiculo.value = false;
  }

  void _marcarDatosInvalidos(String mensaje) {
    idHdrEventoActual.value = 0;

    datosOperativoValidos.value = false;

    mensajeDatosOperativo = mensaje;

    debugPrint('OP SERVICIO URBANO -> $mensaje');
  }

  // ============================================================
  // VARIABLES RESULTADO
  // ============================================================

  Future<bool> cargarVariablesResultado({bool forzar = false}) async {
    if (cargandoVariablesResultado.value) {
      return false;
    }

    if (variablesResultadoCargadas.value && !forzar) {
      return true;
    }

    mensajeErrorVariables = '';

    errorCargaVariables.value = false;

    final int idOperativo = idOperativoVariablesActual.value;

    if (idOperativo <= 0) {
      variablesResultado.clear();

      variableResultadoSeleccionada.value = null;

      variablesResultadoCargadas.value = false;

      errorCargaVariables.value = true;

      mensajeErrorVariables =
          'No se recibió el identificador de configuración del operativo.';

      return false;
    }

    cargandoVariablesResultado.value = true;

    try {
      final List<VariablesResultado> resultado = await siipneMovilUseCase
          .consultarVariblesResultado(
            request: GetVariablesResultadosRequest(idOperativo: idOperativo),
          );

      variablesResultado.assignAll(resultado);

      final List<VariablesResultado> variablesDisponibles =
          variablesResultadoConsultaActual;

      /*
       * Se mantiene internamente la primera variable
       * para poder realizar la inserción inicial.
       *
       * YA NO se muestra en pantalla antes de consultar.
       */
      variableResultadoSeleccionada.value = variablesDisponibles.isNotEmpty
          ? variablesDisponibles.first
          : null;

      variablesResultadoCargadas.value = true;
      errorCargaVariables.value = false;

      debugPrint('==========================================');
      debugPrint('VARIABLES RESULTADO CARGADAS');
      debugPrint('CANTIDAD: ${variablesResultado.length}');

      for (final VariablesResultado variable in variablesResultado) {
        debugPrint(
          '${variable.idVariable} | '
          '${variable.desHdrTipoResum} | '
          '${variable.tipoConsulta}',
        );
      }

      debugPrint('==========================================');

      return true;
    } catch (e, stackTrace) {
      variablesResultado.clear();

      variableResultadoSeleccionada.value = null;

      variablesResultadoCargadas.value = false;

      errorCargaVariables.value = true;

      mensajeErrorVariables =
          'No fue posible obtener las variables configuradas para el operativo.';

      debugPrint('ERROR VARIABLES RESULTADO: $e');

      debugPrint('$stackTrace');

      return false;
    } finally {
      cargandoVariablesResultado.value = false;
    }
  }

  Future<bool> recargarVariablesResultado() async {
    return cargarVariablesResultado(forzar: true);
  }

  void seleccionarVariableResultado(VariablesResultado? variable) {
    variableResultadoSeleccionada.value = variable;
  }

  void limpiarVariableResultado() {
    variableResultadoSeleccionada.value = null;
  }

  // ============================================================
  // ACTUALIZAR RESULTADO
  // ============================================================

  Future<bool> actualizarResultadoRegistro({
    required int idHdrEventoResum,
    required int idVariableOriginal,
  }) async {
    if (actualizandoResultado.value || peticionServerState.value) {
      return false;
    }

    mensajeErrorActualizaResultado = '';

    if (idHdrEventoResum <= 0) {
      mensajeErrorActualizaResultado =
          'No existe un registro válido para actualizar.';
      return false;
    }

    final VariablesResultado? variable = variableResultadoSeleccionada.value;

    if (variable == null || variable.idVariable <= 0) {
      mensajeErrorActualizaResultado = 'Seleccione una variable de resultado.';
      return false;
    }

    final int idVariableNueva = variable.idVariable;

    /*
     * Si el resultado elegido es exactamente el mismo
     * con el cual se insertó originalmente el registro,
     * no necesitamos ejecutar el PUT.
     */
    if (idVariableOriginal > 0 && idVariableNueva == idVariableOriginal) {
      debugPrint('==========================================');
      debugPrint('RESULTADO SIN CAMBIOS');
      debugPrint('ID HDR EVENTO RESUM: $idHdrEventoResum');
      debugPrint('VARIABLE: $idVariableNueva');
      debugPrint('NO ES NECESARIO EJECUTAR PUT');
      debugPrint('==========================================');

      return true;
    }

    actualizandoResultado.value = true;

    /*
     * También activamos el loading general
     * para evitar dobles pulsaciones.
     */
    peticionServerState.value = true;

    try {
      debugPrint('==========================================');
      debugPrint('ACTUALIZANDO RESULTADO');
      debugPrint('ID HDR EVENTO RESUM: $idHdrEventoResum');
      debugPrint('VARIABLE ORIGINAL: $idVariableOriginal');
      debugPrint('VARIABLE NUEVA: $idVariableNueva');
      debugPrint('==========================================');

      final ActualizaResultado resultado = await siipneMovilUseCase
          .actualizaResultado(
            request: ActualizarResultadoRequest(
              idHdrEventoResum: idHdrEventoResum,
              idHdrTipoResum: idVariableNueva,
            ),
          );

      if (resultado.idHdrEventoResum <= 0) {
        mensajeErrorActualizaResultado =
            'El servidor no confirmó la actualización del resultado.';
        return false;
      }

      if (resultado.idHdrEventoResum != idHdrEventoResum) {
        mensajeErrorActualizaResultado =
            'El registro confirmado por el servidor no corresponde a la consulta actual.';
        return false;
      }

      debugPrint('==========================================');
      debugPrint('RESULTADO ACTUALIZADO CORRECTAMENTE');
      debugPrint('ID HDR EVENTO RESUM: ${resultado.idHdrEventoResum}');
      debugPrint('ID VARIABLE: $idVariableNueva');
      debugPrint('==========================================');

      return true;
    } catch (e, stackTrace) {
      mensajeErrorActualizaResultado =
          'No fue posible actualizar el resultado de la consulta.';

      debugPrint('==========================================');
      debugPrint('ERROR ACTUALIZANDO RESULTADO');
      debugPrint('$e');
      debugPrint('$stackTrace');
      debugPrint('==========================================');

      return false;
    } finally {
      actualizandoResultado.value = false;
      peticionServerState.value = false;
    }
  }

  // ============================================================
  // VALIDAR DOCUMENTOS PERSONAS VEHÍCULO
  // ============================================================

  String _normalizarDocumentoPersonaVehiculo(String documento) {
    return documento.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  }

  bool documentoPersonaVehiculoRegistrado(String documento) {
    final String valor = _normalizarDocumentoPersonaVehiculo(documento);

    if (valor.isEmpty) {
      return false;
    }

    return documentosPersonasVehiculoRegistradas.contains(valor);
  }

  // ============================================================
  // SELECCIONAR PERSONA
  // ============================================================

  void seleccionarPersona() {
    if (peticionServerState.value || actualizandoResultado.value) {
      return;
    }
    if (dataPersona.isNotEmpty || dataVehiculo.isNotEmpty) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    selectPerson.value = true;
    selectVehiculo.value = false;
    final List<VariablesResultado> variables = variablesResultadoPersona;
    variableResultadoSeleccionada.value = variables.isNotEmpty
        ? variables.first
        : null;

    solicitarFocoPersona();
  }

  // ============================================================
  // SELECCIONAR VEHÍCULO
  // ============================================================

  void seleccionarVehiculo() {
    if (peticionServerState.value || actualizandoResultado.value) {
      return;
    }

    if (dataPersona.isNotEmpty || dataVehiculo.isNotEmpty) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    selectPerson.value = false;
    selectVehiculo.value = true;

    final List<VariablesResultado> variables = variablesResultadoVehiculo;

    variableResultadoSeleccionada.value = variables.isNotEmpty
        ? variables.first
        : null;

    solicitarFocoVehiculo();
  }

  // ============================================================
  // SCROLL
  // ============================================================

  void _onScroll() {
    if (!scrollController.hasClients) {
      return;
    }

    final double maxScroll = scrollController.position.maxScrollExtent;

    if (maxScroll <= 0) {
      mostrarIndicador.value = false;
      return;
    }

    mostrarIndicador.value = scrollController.offset <= 5;
  }

  void verificarIndicadorScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed || !scrollController.hasClients) {
        return;
      }

      mostrarIndicador.value = scrollController.position.maxScrollExtent > 0;
    });
  }

  // ============================================================
  // CONSULTAR PERSONA
  // ============================================================

  Future<bool> consultarPersonaPorCedula({
    required GlobalKey<FormState> key,
  }) async {
    if (peticionServerState.value) {
      return false;
    }

    mensajeErrorConsulta = '';
    mensajeErrorActualizaResultado = '';

    final bool isValid = key.currentState?.validate() ?? false;

    if (!isValid) {
      debugPrint('CONSULTA PERSONA -> FORMULARIO INVÁLIDO');
      return false;
    }

    if (idHdrEventoActual.value <= 0) {
      mensajeErrorConsulta =
          'No existe un operativo válido para realizar la consulta.';
      return false;
    }

    final String cedula = controllerCedula.text.trim();

    if (cedula.isEmpty) {
      mensajeErrorConsulta = 'Ingrese un documento válido.';
      return false;
    }

    /*
     * IMPORTANTE:
     *
     * La primera variable compatible se utiliza
     * SOLAMENTE para mantener intacta la inserción
     * actual de la consulta.
     */
    final List<VariablesResultado> variablesDisponibles =
        variablesResultadoPersona;

    final int idVariable = variablesDisponibles.isNotEmpty
        ? variablesDisponibles.first.idVariable
        : 0;

    if (idVariable <= 0) {
      mensajeErrorConsulta =
          'No existen variables configuradas para la consulta de persona.';
      return false;
    }

    peticionServerState.value = true;

    try {
      final LocationBloc locationBloc = BlocProvider.of<LocationBloc>(
        Get.context!,
      );

      final LatLng pos = await locationBloc.getCurrentPosition();

      final String ip = await DeviceInfoApp.getIp;

      final ConsultarPersonaRequest request = ConsultarPersonaRequest(
        idOperativo: idHdrEventoActual.value,
        documento: cedula,
        latitud: pos.latitude,
        longitud: pos.longitude,
        ip: ip,
        idGenUsuario: user.idGenUsuario,
        idVariableResultado: idVariable,
      );

      dataPersona.clear();

      tieneOrdenCaptura.value = false;

      idHdrEventoResumPersona = 0;

      idVariableInsertadaPersona = 0;

      final DataConsultaPersona data = await siipneMovilUseCase
          .consultarPersona(request: request);

      dataPersona.assignAll(<DataConsultaPersona>[data]);

      if (dataPersona.isEmpty) {
        mensajeErrorConsulta =
            'No se obtuvieron datos para la consulta realizada.';

        ocultarBtnBuscarPersona.value = false;

        return false;
      }

      /*
       * ID REAL DEL REGISTRO INSERTADO.
       */
      idHdrEventoResumPersona = data.idHdrEventoResum;

      /*
       * Guardamos la variable con la cual fue
       * insertado inicialmente.
       */
      idVariableInsertadaPersona = idVariable;

      /*
       * Después de consultar recién queda disponible
       * para selección visible en la Page.
       */
      variableResultadoSeleccionada.value = variablesDisponibles.first;

      if (data.ordenCaptura.success) {
        tieneOrdenCaptura.value = true;

        try {
          await UtilidadesUtil.playAudio(
            nameAudio: AppSiipneMovilImages.audio_Alerta,
          );
        } catch (e) {
          debugPrint('No fue posible reproducir el audio de alerta: $e');
        }
      }

      ocultarBtnBuscarPersona.value = true;

      controllerCedula.clear();

      debugPrint('==========================================');
      debugPrint('CONSULTA PERSONA CORRECTA');
      debugPrint('ID HDR EVENTO RESUM: $idHdrEventoResumPersona');
      debugPrint('VARIABLE INSERCIÓN: $idVariableInsertadaPersona');
      debugPrint('==========================================');

      return true;
    } catch (e, stackTrace) {
      mensajeErrorConsulta = UrlApiProviderAppCenso.mensajeException(
        e,
        fallback: 'No fue posible realizar la consulta de la persona.',
      );

      ocultarBtnBuscarPersona.value = false;

      debugPrint('ERROR CONSULTA PERSONA: $mensajeErrorConsulta');

      debugPrint('$stackTrace');

      return false;
    } finally {
      peticionServerState.value = false;
    }
  }

  // ============================================================
  // NUEVA CONSULTA PERSONA
  // ============================================================

  Future<bool> nuevaConsultaPersona() async {
    if (peticionServerState.value || actualizandoResultado.value) {
      return false;
    }

    mensajeErrorActualizaResultado = '';

    FocusManager.instance.primaryFocus?.unfocus();

    /*
     * Antes de borrar los datos actualizamos el
     * resultado seleccionado.
     */
    if (dataPersona.isNotEmpty && idHdrEventoResumPersona > 0) {
      final bool actualizado = await actualizarResultadoRegistro(
        idHdrEventoResum: idHdrEventoResumPersona,
        idVariableOriginal: idVariableInsertadaPersona,
      );

      if (!actualizado) {
        /*
         * MUY IMPORTANTE:
         *
         * Si falla el PUT NO limpiamos la consulta.
         * Así el usuario no pierde el resultado.
         */
        return false;
      }
    }

    controllerCedula.clear();
    dataPersona.clear();
    idHdrEventoResumPersona = 0;
    idVariableInsertadaPersona = 0;
    tieneOrdenCaptura.value = false;
    ocultarBtnBuscarPersona.value = false;
    final List<VariablesResultado> variables = variablesResultadoPersona;
    variableResultadoSeleccionada.value = variables.isNotEmpty
        ? variables.first
        : null;

    solicitarFocoPersona();
    return true;
  }

  // ============================================================
  // CONSULTAR VEHÍCULO
  // ============================================================

  Future<bool> consultarVehiculoPorPlaca({
    required GlobalKey<FormState> key,
  }) async {
    if (peticionServerState.value) {
      return false;
    }

    mensajeErrorConsulta = '';
    mensajeErrorActualizaResultado = '';

    final bool isValid = key.currentState?.validate() ?? false;

    if (!isValid) {
      debugPrint('CONSULTA VEHÍCULO -> FORMULARIO INVÁLIDO');
      return false;
    }

    if (idHdrEventoActual.value <= 0) {
      mensajeErrorConsulta =
          'No existe un operativo válido para realizar la consulta.';
      return false;
    }

    final String placa = controllerPlaca.text.trim().toUpperCase();

    if (placa.isEmpty) {
      mensajeErrorConsulta = 'Ingrese una placa válida.';
      return false;
    }

    final List<VariablesResultado> variablesDisponibles =
        variablesResultadoVehiculo;

    /*
     * Se utiliza la primera variable para mantener
     * intacta la inserción actual.
     */
    final int idVariable = variablesDisponibles.isNotEmpty
        ? variablesDisponibles.first.idVariable
        : 0;

    if (idVariable <= 0) {
      mensajeErrorConsulta =
          'No existen variables configuradas para la consulta de vehículo.';
      return false;
    }

    peticionServerState.value = true;

    try {
      final LocationBloc locationBloc = BlocProvider.of<LocationBloc>(
        Get.context!,
      );

      final LatLng pos = await locationBloc.getCurrentPosition();

      final String ip = await DeviceInfoApp.getIp;

      final ConsultarVehiculoRequest request = ConsultarVehiculoRequest(
        idOperativo: idHdrEventoActual.value,
        placa: placa,
        latitud: pos.latitude,
        longitud: pos.longitude,
        ip: ip,
        idGenUsuario: user.idGenUsuario,
        idVariableResultado: idVariable,
      );

      debugPrint('==========================================');
      debugPrint('INICIANDO CONSULTA VEHÍCULO');
      debugPrint('ID HDR EVENTO: ${idHdrEventoActual.value}');
      debugPrint('PLACA: $placa');
      debugPrint('ID VARIABLE INSERCIÓN: $idVariable');
      debugPrint('==========================================');

      dataVehiculo.clear();

      vehiculoRobado.value = false;

      idVariableInsertadaVehiculo = 0;

      _limpiarPersonasVehiculo();

      final DataVehiculo data = await siipneMovilUseCase.consultarVehiculo(
        request: request,
      );

      if (!data.datosVehiculoSiipne.success) {
        mensajeErrorConsulta =
            'No se obtuvieron datos válidos para el vehículo consultado.';

        ocultarBtnBuscarVehiculo.value = false;

        return false;
      }

      dataVehiculo.assignAll(<DataVehiculo>[data]);

      /*
       * Guardamos la variable técnica con la cual
       * se insertó el registro.
       */
      idVariableInsertadaVehiculo = idVariable;

      /*
       * Después de consultar queda disponible
       * para que el usuario seleccione el resultado.
       */
      variableResultadoSeleccionada.value = variablesDisponibles.first;

      placaConsultadaAnterior = placaConsultada;

      placaConsultada = placa;

      vehiculoRobado.value = data.restriccionPj.data.robado;

      ocultarBtnBuscarVehiculo.value = true;

      controllerPlaca.clear();

      if (vehiculoRobado.value) {
        try {
          await UtilidadesUtil.playAudio(
            nameAudio: AppSiipneMovilImages.audio_Alerta,
          );
        } catch (e) {
          debugPrint('No fue posible reproducir el audio de alerta: $e');
        }
      }

      debugPrint('==========================================');
      debugPrint('CONSULTA VEHÍCULO CORRECTA');
      debugPrint('ID HDR EVENTO RESUM: $idHdrEventoResumVehiculo');
      debugPrint('VARIABLE INSERCIÓN: $idVariableInsertadaVehiculo');
      debugPrint('==========================================');

      return true;
    } catch (e, stackTrace) {
      mensajeErrorConsulta = UrlApiProviderAppCenso.mensajeException(
        e,
        fallback: 'No fue posible realizar la consulta del vehículo.',
      );

      ocultarBtnBuscarVehiculo.value = false;

      debugPrint('ERROR CONSULTA VEHÍCULO: $mensajeErrorConsulta');

      debugPrint('$stackTrace');

      return false;
    } finally {
      peticionServerState.value = false;
    }
  }

  // ============================================================
  // NUEVA CONSULTA VEHÍCULO
  // ============================================================

  Future<bool> nuevaConsultaVehiculo() async {
    if (peticionServerState.value || actualizandoResultado.value) {
      return false;
    }

    mensajeErrorActualizaResultado = '';

    FocusManager.instance.primaryFocus?.unfocus();

    /*
     * Primero actualizamos la clasificación
     * del vehículo actual.
     */
    if (dataVehiculo.isNotEmpty && idHdrEventoResumVehiculo > 0) {
      final bool actualizado = await actualizarResultadoRegistro(
        idHdrEventoResum: idHdrEventoResumVehiculo,
        idVariableOriginal: idVariableInsertadaVehiculo,
      );

      if (!actualizado) {
        return false;
      }
    }

    controllerPlaca.clear();

    dataVehiculo.clear();

    idVariableInsertadaVehiculo = 0;

    vehiculoRobado.value = false;

    ocultarBtnBuscarVehiculo.value = false;

    placaConsultadaAnterior = placaConsultada;

    placaConsultada = '';

    _limpiarPersonasVehiculo();

    final List<VariablesResultado> variables = variablesResultadoVehiculo;

    variableResultadoSeleccionada.value = variables.isNotEmpty
        ? variables.first
        : null;

    solicitarFocoVehiculo();

    return true;
  }

  // ============================================================
  // SELECCIÓN CONDUCTOR / OCUPANTE
  // ============================================================

  void seleccionarTipoPersonaVehiculo(String tipo) {
    if (peticionServerState.value || consultandoPersonaVehiculo.value) {
      return;
    }

    final String valor = tipo.trim().toUpperCase();

    if (valor == 'CONDUCTOR') {
      if (dataPersona_conductor.isNotEmpty) {
        return;
      }

      tipoPersonaVehiculo.value = 'CONDUCTOR';

      return;
    }

    tipoPersonaVehiculo.value = 'OCUPANTE';
  }

  // ============================================================
  // CONSULTAR PERSONA RELACIONADA AL VEHÍCULO
  // ============================================================

  Future<bool> consultarPersonaRelacionadaVehiculo({
    required GlobalKey<FormState> key,
  }) async {
    if (consultandoPersonaVehiculo.value) {
      return false;
    }

    mensajeErrorConsulta = '';

    final bool isValid = key.currentState?.validate() ?? false;

    if (!isValid) {
      debugPrint('PERSONA VEHÍCULO -> FORMULARIO INVÁLIDO');

      return false;
    }

    if (dataVehiculo.isEmpty) {
      mensajeErrorConsulta = 'Primero debe consultar un vehículo.';

      return false;
    }

    final int idPadre = idHdrEventoResumVehiculo;

    if (idPadre <= 0) {
      mensajeErrorConsulta =
          'El vehículo no posee un identificador válido para relacionar personas.';

      return false;
    }

    final String cedula = controllerCedulaVehiculo.text.trim();

    if (cedula.isEmpty) {
      mensajeErrorConsulta = 'Ingrese un documento válido.';

      return false;
    }

    final String documentoNormalizado = _normalizarDocumentoPersonaVehiculo(
      cedula,
    );

    if (documentoNormalizado.isEmpty) {
      mensajeErrorConsulta = 'Ingrese un documento válido.';

      return false;
    }

    // ==========================================================
    // EVITAR DUPLICADOS
    // ==========================================================

    if (documentosPersonasVehiculoRegistradas.contains(documentoNormalizado)) {
      mensajeErrorConsulta =
          'La persona con documento $cedula ya se encuentra registrada en este vehículo.';

      debugPrint('==========================================');
      debugPrint('PERSONA DUPLICADA');
      debugPrint('DOCUMENTO: $cedula');
      debugPrint('NORMALIZADO: $documentoNormalizado');
      debugPrint(
        'DOCUMENTOS REGISTRADOS: '
        '$documentosPersonasVehiculoRegistradas',
      );
      debugPrint('==========================================');

      return false;
    }

    final bool esConductor = tipoPersonaVehiculo.value == 'CONDUCTOR';

    if (esConductor && dataPersona_conductor.isNotEmpty) {
      mensajeErrorConsulta = 'Este vehículo ya tiene un conductor registrado.';

      return false;
    }

    final List<VariablesResultado> variablesDisponibles =
        variablesResultadoPersona;

    final VariablesResultado? seleccionada =
        variableResultadoSeleccionada.value;

    final bool seleccionCompatible =
        seleccionada != null &&
        variablesDisponibles.any(
          (VariablesResultado item) =>
              item.idVariable == seleccionada.idVariable,
        );

    final int idVariable = seleccionCompatible
        ? seleccionada.idVariable
        : variablesDisponibles.isNotEmpty
        ? variablesDisponibles.first.idVariable
        : 0;

    consultandoPersonaVehiculo.value = true;

    try {
      debugPrint('==========================================');
      debugPrint('CONSULTANDO PERSONA RELACIONADA');
      debugPrint('ROL: ${esConductor ? 'CONDUCTOR' : 'OCUPANTE'}');
      debugPrint('DOCUMENTO: $cedula');
      debugPrint('DOCUMENTO NORMALIZADO: $documentoNormalizado');
      debugPrint('HDR VEHÍCULO: $idPadre');
      debugPrint('VARIABLE: $idVariable');
      debugPrint('==========================================');

      final BuildContext? context = Get.context;

      if (context == null) {
        mensajeErrorConsulta =
            'No existe contexto disponible para realizar la consulta.';

        return false;
      }

      final LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);

      final LatLng pos = await locationBloc.getCurrentPosition();

      final String ip = await DeviceInfoApp.getIp;

      final ConsultarPersonaRequest request = ConsultarPersonaRequest(
        idOperativo: idHdrEventoActual.value,
        documento: cedula,
        latitud: pos.latitude,
        longitud: pos.longitude,
        ip: ip,
        idGenUsuario: user.idGenUsuario,
        idVariableResultado: idVariable,
        hdrIdHdrResum: idPadre,
        tipoRelacion: esConductor ? 'CONDUCTOR' : 'OCUPANTE',
      );

      final DataConsultaPersona persona = await siipneMovilUseCase
          .consultarPersona(request: request);

      debugPrint('RESPUESTA PERSONA VEHÍCULO RECIBIDA');

      debugPrint('PERSONA: ${persona.toJson()}');

      FocusManager.instance.primaryFocus?.unfocus();

      if (documentosPersonasVehiculoRegistradas.contains(
        documentoNormalizado,
      )) {
        mensajeErrorConsulta =
            'La persona con documento $cedula ya se encuentra registrada en este vehículo.';

        return false;
      }

      if (esConductor) {
        dataPersona_conductor.assignAll(<DataConsultaPersona>[persona]);

        documentoConductorVehiculo = documentoNormalizado;
      } else {
        dataPersona_ocupantes.add(persona);

        documentosOcupantesVehiculo.add(documentoNormalizado);
      }

      documentosPersonasVehiculoRegistradas.add(documentoNormalizado);

      idHdrEventoResumPersona = persona.idHdrEventoResum;

      controllerCedulaVehiculo.clear();

      if (esConductor) {
        tipoPersonaVehiculo.value = 'OCUPANTE';
      }

      if (persona.ordenCaptura.success) {
        try {
          await UtilidadesUtil.playAudio(
            nameAudio: AppSiipneMovilImages.audio_Alerta,
          );
        } catch (e) {
          debugPrint('No fue posible reproducir audio: $e');
        }
      }

      debugPrint('==========================================');
      debugPrint('PERSONA AGREGADA CORRECTAMENTE');
      debugPrint('DOCUMENTO: $documentoNormalizado');
      debugPrint('CONDUCTOR: ${dataPersona_conductor.length}');
      debugPrint('OCUPANTES: ${dataPersona_ocupantes.length}');
      debugPrint(
        'DOCUMENTOS REGISTRADOS: '
        '$documentosPersonasVehiculoRegistradas',
      );
      debugPrint('==========================================');

      return true;
    } catch (e, stackTrace) {
      mensajeErrorConsulta = UrlApiProviderAppCenso.mensajeException(
        e,
        fallback:
            'No fue posible consultar o relacionar la persona con el vehículo.',
      );

      debugPrint('==========================================');
      debugPrint('ERROR PERSONA VEHÍCULO');
      debugPrint(mensajeErrorConsulta);
      debugPrint('$stackTrace');
      debugPrint('==========================================');

      return false;
    } finally {
      consultandoPersonaVehiculo.value = false;
    }
  }

  // ============================================================
  // ELIMINACIÓN LOCAL
  // ============================================================

  void eliminarConductorVehiculoLocal() {
    if (peticionServerState.value || consultandoPersonaVehiculo.value) {
      return;
    }

    if (documentoConductorVehiculo.isNotEmpty) {
      documentosPersonasVehiculoRegistradas.remove(documentoConductorVehiculo);
    }

    documentoConductorVehiculo = '';

    dataPersona_conductor.clear();

    tipoPersonaVehiculo.value = 'CONDUCTOR';
  }

  void eliminarOcupanteVehiculoLocal(int index) {
    if (peticionServerState.value || consultandoPersonaVehiculo.value) {
      return;
    }

    if (index < 0 || index >= dataPersona_ocupantes.length) {
      return;
    }

    if (index >= 0 && index < documentosOcupantesVehiculo.length) {
      final String documento = documentosOcupantesVehiculo[index];

      documentosPersonasVehiculoRegistradas.remove(documento);

      documentosOcupantesVehiculo.removeAt(index);
    }

    dataPersona_ocupantes.removeAt(index);
  }

  // ============================================================
  // LIMPIAR PERSONAS VEHÍCULO
  // ============================================================

  void _limpiarPersonasVehiculo() {
    controllerCedulaVehiculo.clear();

    dataPersona_conductor.clear();
    dataPersona_ocupantes.clear();

    documentosPersonasVehiculoRegistradas.clear();

    documentoConductorVehiculo = '';

    documentosOcupantesVehiculo.clear();

    dataPersona_acompanante1.clear();
    dataPersona_acompanante2.clear();
    dataPersona_acompanante3.clear();

    tipoPersonaVehiculo.value = 'CONDUCTOR';

    idHdrEventoResumPersona = 0;
  }

  // ============================================================
  // COMPATIBILIDAD PANEL ANTERIOR
  // ============================================================

  void abrirRegistroOcupantes() {
    if (peticionServerState.value || dataVehiculo.isEmpty) {
      return;
    }

    if (idHdrEventoResumVehiculo <= 0) {
      mensajeErrorConsulta =
          'El vehículo no posee un idHdrEventoResum válido para relacionar personas.';

      return;
    }

    mostrarPanelOcupantes.value = true;

    tipoPersonaVehiculo.value = dataPersona_conductor.isEmpty
        ? 'CONDUCTOR'
        : 'OCUPANTE';

    controllerCedulaVehiculo.clear();
  }

  void cerrarRegistroOcupantes() {
    if (peticionServerState.value) {
      return;
    }

    mostrarPanelOcupantes.value = false;

    controllerCedulaVehiculo.clear();
  }

  // ============================================================
  // FINALIZAR - CLAVE
  // ============================================================

  void cambiarVisibilidadClaveFinalizar() {
    ocultarClaveFinalizar.value = !ocultarClaveFinalizar.value;
  }

  void limpiarClaveFinalizar() {
    controllerClaveFinalizar.clear();

    ocultarClaveFinalizar.value = true;
  }

  Future<bool> validarClaveFinalizar() async {
    final String clave = controllerClaveFinalizar.text;

    if (clave.trim().isEmpty) {
      return false;
    }

    try {
      return await loginController.validarPass(clave);
    } catch (e) {
      debugPrint('ERROR VALIDANDO CLAVE: $e');

      return false;
    }
  }

  // ============================================================
  // BIOMETRÍA
  // ============================================================

  Future<bool> autenticarBiometriaFinalizar() async {
    if (autenticandoBiometria.value) {
      return false;
    }

    autenticandoBiometria.value = true;

    try {
      final LocalAuthentication auth = LocalAuthentication();

      final bool soportado = await auth.isDeviceSupported();

      if (!soportado) {
        return false;
      }

      final bool disponible = await auth.canCheckBiometrics;

      if (!disponible) {
        return false;
      }

      final List<BiometricType> biometricos = await auth
          .getAvailableBiometrics();

      if (biometricos.isEmpty) {
        return false;
      }

      return await auth.authenticate(
        localizedReason:
            'Confirme su identidad para finalizar el operativo ${idHdrEventoActual.value}',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR BIOMETRÍA: $e');

      debugPrint('$stackTrace');

      return false;
    } finally {
      autenticandoBiometria.value = false;
    }
  }

  // ============================================================
  // FINALIZAR
  // ============================================================

  Future<bool> finalizarOperativo() async {
    if (finalizandoOperativo.value || peticionServerState.value) {
      return false;
    }

    mensajeErrorFinalizar = '';

    final int idEvento = idHdrEventoActual.value;

    if (idEvento <= 0) {
      mensajeErrorFinalizar = 'No existe un operativo válido para finalizar.';

      return false;
    }

    finalizandoOperativo.value = true;

    peticionServerState.value = true;

    try {
      final Finalizar resultado = await siipneMovilUseCase.finalizaOperativo(
        request: FinalizarOperativoRequest(idHdrEvento: idEvento),
      );

      if (resultado.idHdrEvento <= 0) {
        mensajeErrorFinalizar =
            'El servidor no confirmó la finalización del operativo.';

        return false;
      }

      if (resultado.idHdrEvento != idEvento) {
        mensajeErrorFinalizar =
            'El operativo confirmado por el servidor no corresponde al operativo actual.';

        return false;
      }

      return true;
    } catch (e, stackTrace) {
      mensajeErrorFinalizar =
          'No fue posible finalizar el operativo. Intente nuevamente.';

      debugPrint('ERROR FINALIZANDO: $e');

      debugPrint('$stackTrace');

      return false;
    } finally {
      finalizandoOperativo.value = false;
      peticionServerState.value = false;
    }
  }

  // ============================================================
  // VOLVER
  // ============================================================

  void volverMenu() {
    if (peticionServerState.value) {
      return;
    }

    Get.offAllNamed(SiipneMovilRoutes.MENU_APP);
  }

  // ============================================================
  // PERSONAS VEHÍCULO
  // ============================================================

  void prepararPantallaPersonasVehiculo() {
    FocusManager.instance.primaryFocus?.unfocus();

    controllerCedulaVehiculo.clear();

    consultandoPersonaVehiculo.value = false;

    paginaPersonasVehiculoLoading.value = false;

    /*
     * NO limpiar información consultada.
     */
    tipoPersonaVehiculo.value = dataPersona_conductor.isEmpty
        ? 'CONDUCTOR'
        : 'OCUPANTE';
  }

  // ============================================================
  // CERRAR SESIÓN
  // ============================================================

  void cerrarSesionOperativo() {
    if (peticionServerState.value) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    debugPrint('==========================================');
    debugPrint('CERRANDO SESIÓN DESDE OPERATIVO');
    debugPrint('ID HDR EVENTO: ${idHdrEventoActual.value}');
    debugPrint('ANEXADO: ${esOperativoAnexado.value}');
    debugPrint('PUEDE FINALIZAR: ${puedeFinalizarOperativo.value}');
    debugPrint('==========================================');

    Get.offAllNamed(AppRoutes.SPLASH_APP);
  }

  // ============================================================
  // CONSULTAR PERSONAL DEL OPERATIVO
  // ============================================================

  Future<bool> consultarPersonalOperativo() async {
    if (peticionServerState.value) {
      return false;
    }

    mensajeErrorPersonalOperativo = '';

    final int idEvento = idHdrEventoActual.value;

    if (idEvento <= 0) {
      mensajeErrorPersonalOperativo =
          'No existe un operativo válido para consultar el personal.';

      return false;
    }

    peticionServerState.value = true;

    try {
      debugPrint('==========================================');
      debugPrint('CONSULTANDO PERSONAL DEL OPERATIVO');
      debugPrint('ID HDR EVENTO: $idEvento');
      debugPrint('==========================================');

      final List<Integrante> resultado = await siipneMovilUseCase
          .consultarPersonalOperativo(
            request: GetDatosPoliciasOperativoRequest(idHdrEvento: idEvento),
          );

      personalOperativo.assignAll(resultado);

      debugPrint('PERSONAL RECIBIDO: ${personalOperativo.length}');

      if (personalOperativo.isEmpty) {
        mensajeErrorPersonalOperativo =
            'No existen servidores policiales registrados en este operativo.';

        return false;
      }

      return true;
    } catch (e, stackTrace) {
      personalOperativo.clear();

      mensajeErrorPersonalOperativo =
          'No fue posible consultar el personal del operativo.';

      debugPrint('==========================================');
      debugPrint('ERROR CONSULTANDO PERSONAL');
      debugPrint('$e');
      debugPrint('$stackTrace');
      debugPrint('==========================================');

      return false;
    } finally {
      peticionServerState.value = false;
    }
  }

  // ============================================================
  // FOCO CONSULTAS
  // ============================================================

  void solicitarFocoConsultaActual() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (isClosed) return;

      if (selectPerson.value) {
        solicitarFocoPersona();
      } else if (selectVehiculo.value) {
        solicitarFocoVehiculo();
      }
    });
  }

  void solicitarFocoPersona() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (isClosed) return;

      if (selectPerson.value &&
          !ocultarBtnBuscarPersona.value &&
          focusCedula.canRequestFocus) {
        debugPrint('==============================');
        debugPrint('SOLICITANDO FOCO PERSONA');
        debugPrint('CAN REQUEST: ${focusCedula.canRequestFocus}');
        debugPrint('HAS FOCUS ANTES: ${focusCedula.hasFocus}');
        debugPrint('==============================');

        focusCedula.requestFocus();

        debugPrint('HAS FOCUS DESPUÉS: ${focusCedula.hasFocus}');
      }
    });
  }

  void solicitarFocoVehiculo() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (isClosed) return;
      if (selectVehiculo.value &&
          !ocultarBtnBuscarVehiculo.value &&
          focusPlaca.canRequestFocus) {
        focusPlaca.requestFocus();
      }
    });
  }

  // ============================================================
  // GUARDAR RESULTADO PENDIENTE ANTES DE FINALIZAR
  // ============================================================

  Future<bool> guardarResultadoPendienteAntesFinalizar() async {
    if (peticionServerState.value || actualizandoResultado.value) {
      return false;
    }

    mensajeErrorActualizaResultado = '';

    /*
   * PERSONA visible actualmente.
   */
    if (selectPerson.value &&
        dataPersona.isNotEmpty &&
        idHdrEventoResumPersona > 0) {
      return await actualizarResultadoRegistro(
        idHdrEventoResum: idHdrEventoResumPersona,
        idVariableOriginal: idVariableInsertadaPersona,
      );
    }

    /*
   * VEHÍCULO visible actualmente.
   */
    if (selectVehiculo.value &&
        dataVehiculo.isNotEmpty &&
        idHdrEventoResumVehiculo > 0) {
      return await actualizarResultadoRegistro(
        idHdrEventoResum: idHdrEventoResumVehiculo,
        idVariableOriginal: idVariableInsertadaVehiculo,
      );
    }

    /*
   * No hay ningún resultado pendiente.
   */
    return true;
  }
  // ============================================================
  // CONSULTAR RESUMEN DEL OPERATIVO
  // ============================================================

  Future<bool> consultarResultadosOperativo() async {
    if (peticionServerState.value || cargandoResultadosOperativo.value) {
      return false;
    }

    mensajeErrorResultadosOperativo = '';

    final int idEvento = idHdrEventoActual.value;

    if (idEvento <= 0) {
      mensajeErrorResultadosOperativo =
          'No existe un operativo válido para consultar el resumen.';
      return false;
    }
    cargandoResultadosOperativo.value = true;
    peticionServerState.value = true;
    try {
      debugPrint('==========================================');
      debugPrint('CONSULTANDO RESUMEN DEL OPERATIVO');
      debugPrint('ID HDR EVENTO: $idEvento');
      debugPrint('==========================================');
      final ResultadosOperativo resultado = await siipneMovilUseCase
          .getDatosResultadosOperativo(
            request: ResultadosOperativoRequest(idHdrEvento: idEvento),
          );
      if (resultado.idHdrEvento <= 0) {
        mensajeErrorResultadosOperativo =
            'El servidor no devolvió información válida del operativo.';
        resultadosOperativo.value = null;
        return false;
      }
      if (resultado.idHdrEvento != idEvento) {
        mensajeErrorResultadosOperativo =
            'La información recibida no corresponde al operativo actual.';
        resultadosOperativo.value = null;
        return false;
      }

      resultadosOperativo.value = resultado;

      debugPrint('==========================================');
      debugPrint('RESUMEN OPERATIVO RECIBIDO');
      debugPrint('OPERATIVO: ${resultado.idHdrEvento}');
      debugPrint('TIPO: ${resultado.tipoOperativo}');
      debugPrint('TOTAL CONSULTAS: ${resultado.totalConsultas}');
      debugPrint('PERSONAS: ${resultado.totalPersonas}');
      debugPrint('VEHÍCULOS: ${resultado.totalVehiculos}');
      debugPrint('ALERTAS: ${resultado.totalAlertas}');
      debugPrint('CONDUCTORES: ${resultado.totalConductores}');
      debugPrint('OCUPANTES: ${resultado.totalOcupantes}');
      debugPrint('==========================================');

      return true;
    } catch (e, stackTrace) {
      resultadosOperativo.value = null;

      mensajeErrorResultadosOperativo = UrlApiProviderAppCenso.mensajeException(
        e,
        fallback: 'No fue posible obtener el resumen del operativo.',
      );

      debugPrint('==========================================');
      debugPrint('ERROR RESUMEN OPERATIVO');
      debugPrint(mensajeErrorResultadosOperativo);
      debugPrint('$stackTrace');
      debugPrint('==========================================');

      return false;
    } finally {
      cargandoResultadosOperativo.value = false;
      peticionServerState.value = false;
    }
  }
  // ============================================================
// CONSULTAR ANTECEDENTES PERSONA
// ============================================================

// ============================================================
// CONSULTAR ANTECEDENTES PERSONA
// ============================================================

  Future<bool> consultarAntecedentesPersona({
    DataConsultaPersona? personaConsulta,
  }) async {
    if (consultandoAntecedentesPersona.value) {
      return false;
    }

    mensajeErrorAntecedentesPersona = '';
    datosAntecedentesPersona.value = null;

    /*
   * Si recibimos una persona específica:
   * conductor / ocupante.
   *
   * Si NO recibimos persona:
   * mantenemos intacta la consulta principal.
   */
    DataConsultaPersona? persona = personaConsulta;

    if (persona == null) {
      if (dataPersona.isEmpty) {
        mensajeErrorAntecedentesPersona =
        'Primero debe realizar la consulta de una persona.';

        return false;
      }

      persona = dataPersona.first;
    }

    String documento = '';

    // ============================================================
    // SIIPNE
    // ============================================================

    if (persona.dataSiipne.success) {
      documento =
          persona.dataSiipne.datosSiipne.documento.trim();
    }

    // ============================================================
    // DINARDAP COMO RESPALDO
    // ============================================================

    if (documento.isEmpty) {
      final dynamic dinardap =
          persona.dataDinardap.datosDinardap;

      if (dinardap != null) {
        try {
          documento =
              (dinardap.cedula ?? '')
                  .toString()
                  .trim();
        } catch (_) {
          documento = '';
        }
      }
    }

    if (documento.isEmpty) {
      mensajeErrorAntecedentesPersona =
      'No fue posible determinar el documento de la persona consultada.';

      return false;
    }

    consultandoAntecedentesPersona.value = true;

    try {
      debugPrint('==========================================');
      debugPrint('CONSULTANDO ANTECEDENTES');
      debugPrint('DOCUMENTO: $documento');
      debugPrint(
        'ORIGEN: ${personaConsulta != null ? 'PERSONA VEHÍCULO' : 'CONSULTA PRINCIPAL'}',
      );
      debugPrint('==========================================');

      final DataAntecedentes resultado =
      await siipneMovilUseCase.getDatosAntecedentes(
        request: AntecedentesRequest(
          documento: documento,
        ),
      );

      datosAntecedentesPersona.value = resultado;

      debugPrint('==========================================');
      debugPrint('ANTECEDENTES CONSULTADOS');
      debugPrint(
        'CANTIDAD: ${resultado.antecedentes.length}',
      );
      debugPrint('==========================================');

      return true;
    } catch (e, stackTrace) {
      datosAntecedentesPersona.value = null;

      mensajeErrorAntecedentesPersona =
          UrlApiProviderAppCenso.mensajeException(
            e,
            fallback:
            'No fue posible consultar los antecedentes de la persona.',
          );

      debugPrint('==========================================');
      debugPrint('ERROR CONSULTANDO ANTECEDENTES');
      debugPrint(mensajeErrorAntecedentesPersona);
      debugPrint('$stackTrace');
      debugPrint('==========================================');

      return false;
    } finally {
      consultandoAntecedentesPersona.value = false;
    }
  }


  // ============================================================
  // CLOSE
  // ============================================================

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);

    scrollController.dispose();

    controllerCedula.dispose();
    controllerPlaca.dispose();
    controllerCedulaVehiculo.dispose();
    controllerClaveFinalizar.dispose();

    focusCedula.dispose();
    focusPlaca.dispose();

    super.onClose();
  }

}
