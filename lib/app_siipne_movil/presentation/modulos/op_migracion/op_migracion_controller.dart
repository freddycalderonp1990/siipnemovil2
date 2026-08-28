part of '../controllers.dart';

class OpMigracionController extends GetxController {
  static const int idTipoOperativoMigracion = 21288;

  final LoginController loginController = Get.find<LoginController>();
  final SiipneMovilOpMigracionUseCase siipneMovilOpMigracionUseCase =
      Get.find<SiipneMovilOpMigracionUseCase>();

  late UserEntities user;

  final RxBool peticionServerState = false.obs;
  final RxBool datosOperativoValidos = true.obs;
  final RxBool esOperativoAnexado = false.obs;
  final RxBool esOperativoPendiente = false.obs;
  final RxInt idHdrEventoActual = 0.obs;
  final RxInt idTipoOperativoActual = 0.obs;
  final RxString nombreOperativoActual = ''.obs;
  final RxBool puedeFinalizarOperativo = false.obs;

  final TextEditingController controllerClaveFinalizar =
      TextEditingController();
  final RxBool ocultarClaveFinalizar = true.obs;
  final RxBool autenticandoBiometria = false.obs;
  final RxBool finalizandoOperativo = false.obs;
  String mensajeErrorFinalizar = '';

  final RxList<Integrante> personalOperativo = <Integrante>[].obs;
  String mensajeErrorPersonalOperativo = '';

  final Rxn<ResultadosOperativo> resultadosOperativo =
      Rxn<ResultadosOperativo>();
  final RxBool cargandoResultadosOperativo = false.obs;
  String mensajeErrorResultadosOperativo = '';

  final RxList<DataConsultaPersona> dataPersonaComplementaria =
      <DataConsultaPersona>[].obs;
  final Rxn<DataAntecedentes> datosAntecedentesPersona =
      Rxn<DataAntecedentes>();
  final RxBool fuentesPersonaConsultadas = false.obs;
  final RxBool antecedentesPersonaConsultados = false.obs;
  String mensajeErrorFuentesPersona = '';
  String mensajeErrorAntecedentesPersona = '';

  final TextEditingController controllerDocumento = TextEditingController();
  final TextEditingController controllerNacionalidad = TextEditingController();
  final RxString nombreNacionalidadSeleccionada = ''.obs;
  final FocusNode focusDocumento = FocusNode();
  final FocusNode focusNacionalidad = FocusNode();

  final RxList<VariablesResultado> variablesResultado =
      <VariablesResultado>[].obs;
  final Rxn<VariablesResultado> variableResultadoSeleccionada =
      Rxn<VariablesResultado>();
  final RxBool cargandoVariablesResultado = false.obs;

  final RxList<DataExtranjeroDocumento> extranjerosEncontrados =
      <DataExtranjeroDocumento>[].obs;
  final Rxn<DataExtranjeroDocumento> extranjeroSeleccionado =
      Rxn<DataExtranjeroDocumento>();
  final Rxn<DataMovimientosMigratorios> movimientosMigratorios =
      Rxn<DataMovimientosMigratorios>();
  final Rxn<DataVisaExtranjero> visaExtranjero = Rxn<DataVisaExtranjero>();
  final Rxn<DataVisasElectronicas> visasElectronicas =
      Rxn<DataVisasElectronicas>();
  final Rxn<DataRegistroConsultaMigracion> registroConsulta =
      Rxn<DataRegistroConsultaMigracion>();

  final RxBool cargandoMovimientos = false.obs;
  final RxBool cargandoVisa = false.obs;
  final RxBool cargandoVisaElectronica = false.obs;
  final RxBool registrandoConsulta = false.obs;
  final RxBool movimientosConsultados = false.obs;
  final RxBool visasSimiecConsultadas = false.obs;
  final RxBool visasElectronicasConsultadas = false.obs;
  final RxList<String> advertenciasComplementos = <String>[].obs;

  String mensajeDatosOperativo = '';
  String mensajeErrorConsulta = '';
  String mensajeErrorVariables = '';
  String mensajeErrorMovimientos = '';
  String mensajeErrorVisas = '';
  String mensajeErrorVisasElectronicas = '';
  String _documentoConsultado = '';
  String _nacionalidadConsultada = '';
  String _latitudConsulta = '';
  String _longitudConsulta = '';
  String _ipConsulta = '';

  bool get hayResultado => extranjeroSeleccionado.value != null;

  bool get hayVariosResultados => extranjerosEncontrados.length > 1;

  bool get consultaRegistrada {
    final DataRegistroConsultaMigracion? registro = registroConsulta.value;
    return registro != null &&
        registro.idGenPersona > 0 &&
        registro.idHdrEventoResum > 0;
  }

  bool get cargandoComplementos =>
      cargandoMovimientos.value ||
      cargandoVisa.value ||
      cargandoVisaElectronica.value ||
      registrandoConsulta.value;

  bool get tieneConsultaPersonaComplementaria =>
      dataPersonaComplementaria.isNotEmpty;

  bool get tieneAntecedentesPersona =>
      datosAntecedentesPersona.value?.antecedentes.isNotEmpty ?? false;

  int get idVariableResultado =>
      variableResultadoSeleccionada.value?.idVariable ?? 0;

  DatosBiograficosMigracion? get datosBiograficos {
    return extranjeroSeleccionado.value?.datosBiograficosPrincipal;
  }

  List<MovimientoMigratorio> get listaMovimientos {
    return movimientosMigratorios.value?.movimientos ??
        <MovimientoMigratorio>[];
  }

  List<VisaSimiecMigracion> get listaVisasSimiec {
    return visaExtranjero.value?.visasSimiec.visas ??
        <VisaSimiecMigracion>[];
  }

  List<VisaElectronicaMigracion> get listaVisasElectronicas {
    return visasElectronicas.value?.datosVisa ??
        <VisaElectronicaMigracion>[];
  }

  @override
  void onInit() {
    super.onInit();
    user = loginController.user.value;
    _cargarDatosOperativo();

    if (datosOperativoValidos.value) {
      cargarVariablesResultado();
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (datosOperativoValidos.value) {
      Future<void>.delayed(const Duration(milliseconds: 350), () {
        if (!isClosed) focusDocumento.requestFocus();
      });
    }
  }

  void _cargarDatosOperativo() {
    puedeFinalizarOperativo.value = false;
    final dynamic arguments = Get.arguments;

    if (arguments is! Map) {
      _marcarOperativoInvalido(
        'No se recibieron datos válidos del operativo.',
      );
      return;
    }

    final String tipoAcceso = _string(arguments['tipoAcceso']).toUpperCase();
    final dynamic pendiente = arguments['pendiente'];
    final dynamic anexarse = arguments['anexarse'];
    final dynamic nuevo = arguments['dataCreateOp'];

    int idEvento = _entero(arguments['idHdrEvento']);
    if (idEvento <= 0) idEvento = _entero(arguments['numeroOperativo']);

    int idTipo = _entero(arguments['idOperativo']);
    if (idTipo <= 0) idTipo = _entero(arguments['idTipoOperativo']);

    final dynamic moduloArgumento = arguments['modulo'];

    final String nombreModulo = _primerTexto(<dynamic>[
      arguments['nombreModulo'],
      moduloArgumento is DataModulo ? moduloArgumento.descripcion : null,
    ]);

    String nombre = _primerTexto(<dynamic>[
      arguments['nombreOperativo'],
      arguments['tipoOperativo'],
      arguments['descripcionOperativo'],
    ]);

    if (pendiente is Pendiente) {
      esOperativoPendiente.value = true;
      idEvento = pendiente.idHdrEvento > 0 ? pendiente.idHdrEvento : idEvento;
      idTipo = pendiente.idTipoOperativo > 0
          ? pendiente.idTipoOperativo
          : idTipo;
      nombre = pendiente.descripcion.trim().isNotEmpty
          ? pendiente.descripcion.trim()
          : nombre;
      puedeFinalizarOperativo.value = true;
    }

    if (anexarse is Anexarse) {
      esOperativoAnexado.value = true;
      esOperativoPendiente.value = false;
      idEvento = anexarse.idHdrEvento > 0 ? anexarse.idHdrEvento : idEvento;
      idTipo = anexarse.idTipoOperativo > 0
          ? anexarse.idTipoOperativo
          : idTipo;
      nombre = anexarse.descripcion.trim().isNotEmpty
          ? anexarse.descripcion.trim()
          : nombre;
      puedeFinalizarOperativo.value = false;
    }

    if (tipoAcceso == 'ANEXARSE') {
      esOperativoAnexado.value = true;
      esOperativoPendiente.value = false;
      puedeFinalizarOperativo.value = false;
    }

    if (nuevo is DataCreateOp) {
      idEvento = nuevo.idHdrEvento > 0 ? nuevo.idHdrEvento : idEvento;
      idTipo = nuevo.idTipoOperativo > 0 ? nuevo.idTipoOperativo : idTipo;
      puedeFinalizarOperativo.value = true;
    }

    if (idEvento <= 0) {
      _marcarOperativoInvalido(
        'No fue posible determinar el identificador del operativo.',
      );
      return;
    }

    final String tipoModulo =
        nombreModulo.isNotEmpty ? nombreModulo : nombre;

    final bool tipoMigracionPorId = idTipo == idTipoOperativoMigracion;
    final bool tipoMigracionPorDescripcion =
        _esTipoMovilMigracion(tipoModulo);

    if (!tipoMigracionPorId && !tipoMigracionPorDescripcion) {
      _marcarOperativoInvalido(
        tipoModulo.isEmpty
            ? 'No se recibió el tipo del operativo. Esta pantalla solo está disponible para Móvil Migración.'
            : 'El módulo "$tipoModulo" no corresponde a Móvil Migración.',
      );
      return;
    }

    idHdrEventoActual.value = idEvento;
    idTipoOperativoActual.value = idTipo;
    nombreOperativoActual.value =
        nombre.isNotEmpty ? nombre : nombreModulo;
  }

  bool _esTipoMovilMigracion(String value) {
    final String tipo = _normalizar(value);
    return tipo == 'MOVIL MIGRACION' ||
        tipo == 'OPERATIVO MOVIL MIGRACION';
  }

  String _normalizar(String value) {
    return value
        .trim()
        .toUpperCase()
        .replaceAll('Á', 'A')
        .replaceAll('É', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  String _primerTexto(List<dynamic> values) {
    for (final dynamic value in values) {
      final String text = _string(value);
      if (text.isNotEmpty) return text;
    }
    return '';
  }

  String _string(dynamic value) => value?.toString().trim() ?? '';

  int _entero(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(_string(value)) ?? 0;
  }

  void _marcarOperativoInvalido(String mensaje) {
    datosOperativoValidos.value = false;
    mensajeDatosOperativo = mensaje;
    idHdrEventoActual.value = 0;
  }

  Future<bool> cargarVariablesResultado({bool forzar = false}) async {
    if (cargandoVariablesResultado.value) return false;
    if (variablesResultado.isNotEmpty && !forzar) return true;

    final int idTipo = idTipoOperativoActual.value;
    mensajeErrorVariables = '';

    if (idTipo <= 0) {
      mensajeErrorVariables =
          'No se recibió el identificador del tipo de operativo.';
      return false;
    }

    cargandoVariablesResultado.value = true;

    try {
      final List<VariablesResultado> resultado =
          await siipneMovilOpMigracionUseCase.consultarVariblesResultado(
        request: GetVariablesResultadosRequest(idOperativo: idTipo),
      );

      variablesResultado.assignAll(resultado);
      variableResultadoSeleccionada.value =
          resultado.isEmpty ? null : resultado.first;

      if (resultado.isEmpty) {
        mensajeErrorVariables =
            'No existen variables de resultado configuradas para este operativo.';
        return false;
      }

      return true;
    } catch (e) {
      variablesResultado.clear();
      variableResultadoSeleccionada.value = null;
      mensajeErrorVariables = _mensajeExcepcion(
        e,
        'No fue posible cargar las variables del operativo.',
      );
      return false;
    } finally {
      cargandoVariablesResultado.value = false;
    }
  }

  void seleccionarVariableResultado(VariablesResultado? value) {
    if (peticionServerState.value || hayResultado) return;
    variableResultadoSeleccionada.value = value;
  }

  void seleccionarNacionalidad({
    required String nombre,
    required String codigoAlpha3,
  }) {
    if (peticionServerState.value || hayResultado) return;

    final String codigo = codigoAlpha3.trim().toUpperCase();

    if (codigo.length != 3) return;

    controllerNacionalidad.text = codigo;
    nombreNacionalidadSeleccionada.value = nombre.trim();
    focusNacionalidad.unfocus();
  }

  Future<bool> consultarExtranjero({
    required GlobalKey<FormState> formKey,
  }) async {
    if (peticionServerState.value) return false;

    mensajeErrorConsulta = '';
    advertenciasComplementos.clear();

    if (!(formKey.currentState?.validate() ?? false)) return false;

    if (!datosOperativoValidos.value || idHdrEventoActual.value <= 0) {
      mensajeErrorConsulta =
          'No existe un operativo Móvil Migración válido.';
      return false;
    }

    if (idVariableResultado <= 0) {
      mensajeErrorConsulta =
          'Seleccione una variable de resultado antes de consultar.';
      return false;
    }

    _documentoConsultado = controllerDocumento.text.trim().toUpperCase();
    _nacionalidadConsultada =
        controllerNacionalidad.text.trim().toUpperCase();

    if (_nacionalidadConsultada.length != 3) {
      mensajeErrorConsulta = 'Seleccione una nacionalidad válida.';
      return false;
    }

    peticionServerState.value = true;
    _limpiarResultados(mantenerCriterios: true);

    try {
      final BuildContext? context = Get.context;
      if (context == null) {
        mensajeErrorConsulta =
            'No fue posible acceder al contexto de ubicación.';
        return false;
      }

      final LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
      final LatLng posicion = await locationBloc.getCurrentPosition();
      _latitudConsulta = posicion.latitude.toString();
      _longitudConsulta = posicion.longitude.toString();
      _ipConsulta = await DeviceInfoApp.getIp;

      final List<DataExtranjeroDocumento> resultado =
          await siipneMovilOpMigracionUseCase.getDatosExtranjeroDocumento(
        request: GetDatosExtranjeroDocumentoRequest(
          documento: _documentoConsultado,
          nacionalidad: _nacionalidadConsultada,
          idGenPersonaUsuario: user.idGenPersona,
        ),
      );

      extranjerosEncontrados.assignAll(resultado);

      if (resultado.isEmpty) {
        mensajeErrorConsulta = 'No se encontraron datos migratorios.';
        return false;
      }

      if (resultado.length == 1) {
        await _cargarDetalleExtranjero(resultado.first);
      }

      return true;
    } catch (e, stackTrace) {
      debugPrint('ERROR CONSULTA MIGRACIÓN: $e');
      debugPrint('$stackTrace');
      mensajeErrorConsulta = _mensajeExcepcion(
        e,
        'No fue posible consultar la información migratoria.',
      );
      return false;
    } finally {
      peticionServerState.value = false;
    }
  }

  Future<void> seleccionarExtranjero(DataExtranjeroDocumento extranjero) async {
    if (peticionServerState.value) return;
    peticionServerState.value = true;
    advertenciasComplementos.clear();

    try {
      await _cargarDetalleExtranjero(extranjero);
    } finally {
      peticionServerState.value = false;
    }
  }

  Future<void> _cargarDetalleExtranjero(
    DataExtranjeroDocumento extranjero,
  ) async {
    extranjeroSeleccionado.value = extranjero;
    movimientosMigratorios.value = null;
    visaExtranjero.value = null;
    visasElectronicas.value = null;
    registroConsulta.value = null;
    dataPersonaComplementaria.clear();
    datosAntecedentesPersona.value = null;
    movimientosConsultados.value = false;
    visasSimiecConsultadas.value = false;
    visasElectronicasConsultadas.value = false;
    fuentesPersonaConsultadas.value = false;
    antecedentesPersonaConsultados.value = false;
    mensajeErrorMovimientos = '';
    mensajeErrorVisas = '';
    mensajeErrorVisasElectronicas = '';
    mensajeErrorFuentesPersona = '';
    mensajeErrorAntecedentesPersona = '';

    await _registrarConsulta(extranjero);
  }

  Future<bool> consultarMovimientosMigratorios() async {
    if (cargandoMovimientos.value || peticionServerState.value) return false;

    final DataExtranjeroDocumento? extranjero = extranjeroSeleccionado.value;
    if (extranjero == null || extranjero.idCiudadano.trim().isEmpty) {
      mensajeErrorMovimientos =
          'No existe un ciudadano seleccionado para realizar la consulta.';
      return false;
    }
    if (!consultaRegistrada) {
      mensajeErrorMovimientos =
          'La consulta inicial todavía no ha sido registrada.';
      return false;
    }
    if (movimientosConsultados.value) return true;

    mensajeErrorMovimientos = '';
    cargandoMovimientos.value = true;
    peticionServerState.value = true;
    try {
      movimientosMigratorios.value =
          await siipneMovilOpMigracionUseCase.getMovimientosMigratorios(
        request: GetMovimientosMigratoriosRequest(
          idCiudadano: extranjero.idCiudadano,
          idGenPersonaUsuario: user.idGenPersona,
        ),
      );
      movimientosConsultados.value = true;
      return true;
    } catch (e) {
      movimientosMigratorios.value = null;
      mensajeErrorMovimientos = _mensajeExcepcion(
        e,
        'No fue posible consultar los movimientos migratorios.',
      );
      return false;
    } finally {
      cargandoMovimientos.value = false;
      peticionServerState.value = false;
    }
  }

  Future<bool> consultarVisasSimiec() async {
    if (cargandoVisa.value || peticionServerState.value) return false;

    final DataExtranjeroDocumento? extranjero = extranjeroSeleccionado.value;
    if (extranjero == null || extranjero.idCiudadano.trim().isEmpty) {
      mensajeErrorVisas =
          'No existe un ciudadano seleccionado para realizar la consulta.';
      return false;
    }
    if (!consultaRegistrada) {
      mensajeErrorVisas = 'La consulta inicial todavía no ha sido registrada.';
      return false;
    }
    if (visasSimiecConsultadas.value) return true;

    mensajeErrorVisas = '';
    cargandoVisa.value = true;
    peticionServerState.value = true;
    try {
      visaExtranjero.value =
          await siipneMovilOpMigracionUseCase.getVisaExtranjero(
        request: GetVisaExtranjeroRequest(
          idCiudadano: extranjero.idCiudadano,
          idGenPersonaUsuario: user.idGenPersona,
        ),
      );
      visasSimiecConsultadas.value = true;
      return true;
    } catch (e) {
      visaExtranjero.value = null;
      mensajeErrorVisas = _mensajeExcepcion(
        e,
        'No fue posible consultar las visas SIMIEC.',
      );
      return false;
    } finally {
      cargandoVisa.value = false;
      peticionServerState.value = false;
    }
  }

  Future<bool> consultarVisasElectronicas() async {
    if (cargandoVisaElectronica.value || peticionServerState.value) {
      return false;
    }

    final DataExtranjeroDocumento? extranjero = extranjeroSeleccionado.value;
    if (extranjero == null) {
      mensajeErrorVisasElectronicas =
          'No existe un ciudadano seleccionado para realizar la consulta.';
      return false;
    }
    if (!consultaRegistrada) {
      mensajeErrorVisasElectronicas =
          'La consulta inicial todavía no ha sido registrada.';
      return false;
    }
    if (visasElectronicasConsultadas.value) return true;

    final DatosBiograficosMigracion? bio =
        extranjero.datosBiograficosPrincipal;

    if (bio == null) {
      mensajeErrorVisasElectronicas =
          'No existen datos biográficos para consultar visas electrónicas.';
      return false;
    }

    mensajeErrorVisasElectronicas = '';
    cargandoVisaElectronica.value = true;
    peticionServerState.value = true;
    try {
      visasElectronicas.value =
          await siipneMovilOpMigracionUseCase.getVisasElectronicas(
        request: GetVisasElectronicasRequest(
          apellidos: bio.apellidos,
          nombres: bio.nombres,
          fechaNacimiento: bio.fechaNacimiento,
          nacionalidad: _nacionalidadConsultada,
        ),
      );
      visasElectronicasConsultadas.value = true;
      return true;
    } catch (e, stackTrace) {
      visasElectronicas.value = null;
      debugPrint('ERROR VISAS ELECTRÓNICAS: $e');
      debugPrint('$stackTrace');
      mensajeErrorVisasElectronicas = _mensajeExcepcion(
        e,
        'No fue posible consultar las visas electrónicas.',
      );
      return false;
    } finally {
      cargandoVisaElectronica.value = false;
      peticionServerState.value = false;
    }
  }

  /// Consulta las mismas fuentes nacionales usadas por Servicio Urbano.
  ///
  /// Se ejecuta únicamente cuando el usuario abre el detalle institucional;
  /// así la consulta migratoria inicial continúa siendo independiente.
  Future<bool> consultarFuentesPersona() async {
    if (peticionServerState.value) return false;

    final DataExtranjeroDocumento? extranjero = extranjeroSeleccionado.value;
    if (extranjero == null || !consultaRegistrada) {
      mensajeErrorFuentesPersona =
          'Primero debe completar y registrar la consulta migratoria.';
      return false;
    }
    if (fuentesPersonaConsultadas.value &&
        dataPersonaComplementaria.isNotEmpty) {
      return true;
    }

    final DocumentoExtranjeroMigracion? documento =
        _documentoCoincidente(extranjero.documentos);
    final String numero = documento?.numeroDocumento.trim().isNotEmpty == true
        ? documento!.numeroDocumento.trim()
        : _documentoConsultado;

    if (numero.isEmpty) {
      mensajeErrorFuentesPersona =
          'No fue posible determinar el documento de la persona.';
      return false;
    }

    mensajeErrorFuentesPersona = '';
    peticionServerState.value = true;
    try {
      final DataConsultaPersona resultado =
          await siipneMovilOpMigracionUseCase.consultarPersona(
        request: ConsultarPersonaRequest(
          idOperativo: idHdrEventoActual.value,
          documento: numero,
          latitud: double.tryParse(_latitudConsulta) ?? 0,
          longitud: double.tryParse(_longitudConsulta) ?? 0,
          ip: _ipConsulta,
          idGenUsuario: user.idGenUsuario,
          idVariableResultado: idVariableResultado,
        ),
      );
      dataPersonaComplementaria.assignAll(<DataConsultaPersona>[resultado]);
      fuentesPersonaConsultadas.value = true;
      return true;
    } catch (e, stackTrace) {
      dataPersonaComplementaria.clear();
      debugPrint('ERROR FUENTES PERSONA MIGRACIÓN: $e');
      debugPrint('$stackTrace');
      mensajeErrorFuentesPersona = _mensajeExcepcion(
        e,
        'No fue posible consultar Registro Civil, ANT y boletas.',
      );
      return false;
    } finally {
      peticionServerState.value = false;
    }
  }

  Future<bool> consultarAntecedentesPersona() async {
    if (peticionServerState.value) return false;

    final DataExtranjeroDocumento? extranjero = extranjeroSeleccionado.value;
    if (extranjero == null || !consultaRegistrada) {
      mensajeErrorAntecedentesPersona =
          'Primero debe completar y registrar la consulta migratoria.';
      return false;
    }
    if (antecedentesPersonaConsultados.value &&
        datosAntecedentesPersona.value != null) {
      return true;
    }

    final DocumentoExtranjeroMigracion? documento =
        _documentoCoincidente(extranjero.documentos);
    final String numero = documento?.numeroDocumento.trim().isNotEmpty == true
        ? documento!.numeroDocumento.trim()
        : _documentoConsultado;

    if (numero.isEmpty) {
      mensajeErrorAntecedentesPersona =
          'No fue posible determinar el documento de la persona.';
      return false;
    }

    mensajeErrorAntecedentesPersona = '';
    peticionServerState.value = true;
    try {
      datosAntecedentesPersona.value =
          await siipneMovilOpMigracionUseCase.getDatosAntecedentes(
        request: AntecedentesRequest(documento: numero),
      );
      antecedentesPersonaConsultados.value = true;
      return true;
    } catch (e, stackTrace) {
      datosAntecedentesPersona.value = null;
      debugPrint('ERROR ANTECEDENTES MIGRACIÓN: $e');
      debugPrint('$stackTrace');
      mensajeErrorAntecedentesPersona = _mensajeExcepcion(
        e,
        'No fue posible consultar los antecedentes de la persona.',
      );
      return false;
    } finally {
      peticionServerState.value = false;
    }
  }

  Future<bool> consultarPersonalOperativo() async {
    if (peticionServerState.value) return false;

    final int idEvento = idHdrEventoActual.value;
    if (idEvento <= 0) {
      mensajeErrorPersonalOperativo =
          'No existe un operativo válido para consultar el personal.';
      return false;
    }

    mensajeErrorPersonalOperativo = '';
    peticionServerState.value = true;
    try {
      debugPrint('==========================================');
      debugPrint('CONSULTANDO PERSONAL OPERATIVO MIGRACIÓN');
      debugPrint('ID HDR EVENTO: $idEvento');
      final List<Integrante> resultado =
          await siipneMovilOpMigracionUseCase.consultarPersonalOperativo(
        request: GetDatosPoliciasOperativoRequest(idHdrEvento: idEvento),
      );
      debugPrint('INTEGRANTES RECIBIDOS: ${resultado.length}');
      debugPrint('==========================================');
      personalOperativo.assignAll(resultado);
      if (resultado.isEmpty) {
        mensajeErrorPersonalOperativo =
            'No existen servidores policiales registrados en este operativo.';
        return false;
      }
      return true;
    } catch (e, stackTrace) {
      personalOperativo.clear();
      debugPrint('ERROR PERSONAL OPERATIVO MIGRACIÓN: $e');
      debugPrint('$stackTrace');
      mensajeErrorPersonalOperativo = _mensajeExcepcion(
        e,
        'No fue posible consultar el personal del operativo.',
      );
      return false;
    } finally {
      peticionServerState.value = false;
    }
  }

  Future<bool> consultarResultadosOperativo() async {
    if (peticionServerState.value || cargandoResultadosOperativo.value) {
      return false;
    }

    final int idEvento = idHdrEventoActual.value;
    if (idEvento <= 0) {
      mensajeErrorResultadosOperativo =
          'No existe un operativo válido para consultar el resumen.';
      return false;
    }

    mensajeErrorResultadosOperativo = '';
    resultadosOperativo.value = null;
    cargandoResultadosOperativo.value = true;
    peticionServerState.value = true;

    try {
      debugPrint('==========================================');
      debugPrint('CONSULTANDO RESUMEN OPERATIVO MIGRACIÓN');
      debugPrint('ID HDR EVENTO: $idEvento');

      final ResultadosOperativo resultado =
          await siipneMovilOpMigracionUseCase.getDatosResultadosOperativo(
        request: ResultadosOperativoRequest(idHdrEvento: idEvento),
      );

      if (!resultado.tieneDatos || resultado.idHdrEvento != idEvento) {
        mensajeErrorResultadosOperativo =
            'El servidor no devolvió un resumen válido del operativo.';
        return false;
      }

      resultadosOperativo.value = resultado;
      debugPrint('TOTAL CONSULTAS: ${resultado.totalConsultas}');
      debugPrint('==========================================');
      return true;
    } catch (e, stackTrace) {
      resultadosOperativo.value = null;
      debugPrint('ERROR RESUMEN OPERATIVO MIGRACIÓN: $e');
      debugPrint('$stackTrace');
      mensajeErrorResultadosOperativo = _mensajeExcepcion(
        e,
        'No fue posible obtener el resumen del operativo.',
      );
      return false;
    } finally {
      cargandoResultadosOperativo.value = false;
      peticionServerState.value = false;
    }
  }

  void cambiarVisibilidadClaveFinalizar() {
    ocultarClaveFinalizar.value = !ocultarClaveFinalizar.value;
  }

  void limpiarClaveFinalizar() {
    controllerClaveFinalizar.clear();
    ocultarClaveFinalizar.value = true;
  }

  Future<bool> validarClaveFinalizar() async {
    if (peticionServerState.value) return false;
    final String clave = controllerClaveFinalizar.text.trim();
    if (clave.isEmpty) return false;

    peticionServerState.value = true;
    try {
      return await loginController.validarPass(clave);
    } catch (e) {
      debugPrint('ERROR VALIDANDO CLAVE MIGRACIÓN: $e');
      return false;
    } finally {
      peticionServerState.value = false;
    }
  }

  Future<bool> autenticarBiometriaFinalizar() async {
    if (peticionServerState.value || autenticandoBiometria.value) return false;

    autenticandoBiometria.value = true;
    peticionServerState.value = true;
    try {
      final LocalAuthentication auth = LocalAuthentication();
      if (!await auth.isDeviceSupported() || !await auth.canCheckBiometrics) {
        return false;
      }
      if ((await auth.getAvailableBiometrics()).isEmpty) return false;
      return await auth.authenticate(
        localizedReason:
            'Confirme su identidad para finalizar el operativo ${idHdrEventoActual.value}',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR BIOMETRÍA MIGRACIÓN: $e');
      debugPrint('$stackTrace');
      return false;
    } finally {
      autenticandoBiometria.value = false;
      peticionServerState.value = false;
    }
  }

  Future<bool> finalizarOperativo() async {
    if (peticionServerState.value || finalizandoOperativo.value) return false;
    if (!puedeFinalizarOperativo.value) {
      mensajeErrorFinalizar =
          'Los servidores anexados no pueden finalizar el operativo.';
      return false;
    }

    final int idEvento = idHdrEventoActual.value;
    if (idEvento <= 0) {
      mensajeErrorFinalizar = 'No existe un operativo válido para finalizar.';
      return false;
    }

    mensajeErrorFinalizar = '';
    finalizandoOperativo.value = true;
    peticionServerState.value = true;
    try {
      final Finalizar resultado =
          await siipneMovilOpMigracionUseCase.finalizaOperativo(
        request: FinalizarOperativoRequest(idHdrEvento: idEvento),
      );
      if (resultado.idHdrEvento != idEvento) {
        mensajeErrorFinalizar =
            'El servidor no confirmó la finalización del operativo actual.';
        return false;
      }
      return true;
    } catch (e, stackTrace) {
      debugPrint('ERROR FINALIZANDO MIGRACIÓN: $e');
      debugPrint('$stackTrace');
      mensajeErrorFinalizar = _mensajeExcepcion(
        e,
        'No fue posible finalizar el operativo.',
      );
      return false;
    } finally {
      finalizandoOperativo.value = false;
      peticionServerState.value = false;
    }
  }

  void volverMenu() {
    if (!peticionServerState.value) {
      Get.offAllNamed(SiipneMovilRoutes.MENU_APP);
    }
  }

  void cerrarSesionOperativo() {
    if (!peticionServerState.value) {
      FocusManager.instance.primaryFocus?.unfocus();
      Get.offAllNamed(AppRoutes.SPLASH_APP);
    }
  }

  Future<void> _registrarConsulta(DataExtranjeroDocumento extranjero) async {
    final DatosBiograficosMigracion? bio =
        extranjero.datosBiograficosPrincipal;

    if (bio == null) {
      advertenciasComplementos.add(
        'La consulta no pudo registrarse porque no tiene datos biográficos.',
      );
      return;
    }

    registrandoConsulta.value = true;
    try {
      final DocumentoExtranjeroMigracion? documento =
          _documentoCoincidente(extranjero.documentos);

      final String nacionalidad =
          documento?.nacionalidadDocumento.trim().isNotEmpty == true
              ? documento!.nacionalidadDocumento.trim()
              : bio.paisNacimiento.trim().isNotEmpty
                  ? bio.paisNacimiento.trim()
                  : _nacionalidadConsultada;

      final DataRegistroConsultaMigracion registro =
          await siipneMovilOpMigracionUseCase.registrarConsultaMigracion(
        request: RegistroConsultaMigracionRequest(
          documento: _documentoConsultado,
          nombres: bio.nombresCompletos.trim().isNotEmpty
              ? bio.nombresCompletos
              : '${bio.apellidos} ${bio.nombres}'.trim(),
          fechaNacimiento: bio.fechaNacimiento,
          idCiudadano: extranjero.idCiudadano,
          nacionalidad: nacionalidad,
          sexo: bio.genero,
          estadoCivil: bio.estadoCivil,
          profesion: bio.profesion,
          idOperativo: idHdrEventoActual.value,
          idGenUsuario: user.idGenUsuario,
          idGenPersonaUsuario: user.idGenPersona,
          latitud: _latitudConsulta,
          longitud: _longitudConsulta,
          ip: _ipConsulta,
          idVariableResultado: idVariableResultado,
          // hdrEventoResum.detalle es una columna JSON. Nunca debe enviarse
          // una cadena vacía porque MySQL la rechaza con el error 3140.
          detalle: '{"tipoConsulta":"MIGRACION"}',
        ),
      );

      if (registro.idGenPersona <= 0 || registro.idHdrEventoResum <= 0) {
        registroConsulta.value = null;
        advertenciasComplementos.add(
          'El servidor no confirmó el registro de la consulta migratoria.',
        );
        return;
      }

      registroConsulta.value = registro;
    } catch (e) {
      advertenciasComplementos.add(
        _mensajeExcepcion(e, 'No fue posible registrar la consulta migratoria.'),
      );
    } finally {
      registrandoConsulta.value = false;
    }
  }

  DocumentoExtranjeroMigracion? _documentoCoincidente(
    List<DocumentoExtranjeroMigracion> documentos,
  ) {
    for (final DocumentoExtranjeroMigracion item in documentos) {
      if (item.numeroDocumento.trim().toUpperCase() == _documentoConsultado) {
        return item;
      }
    }
    return documentos.isEmpty ? null : documentos.first;
  }

  String _mensajeExcepcion(dynamic error, String fallback) {
    return UrlApiProviderAppCenso.mensajeException(error, fallback: fallback);
  }

  void nuevaConsulta() {
    if (peticionServerState.value) return;
    _limpiarResultados();
    controllerDocumento.clear();
    focusDocumento.requestFocus();
  }

  void _limpiarResultados({bool mantenerCriterios = false}) {
    extranjerosEncontrados.clear();
    extranjeroSeleccionado.value = null;
    movimientosMigratorios.value = null;
    visaExtranjero.value = null;
    visasElectronicas.value = null;
    registroConsulta.value = null;
    dataPersonaComplementaria.clear();
    datosAntecedentesPersona.value = null;
    fuentesPersonaConsultadas.value = false;
    antecedentesPersonaConsultados.value = false;
    movimientosConsultados.value = false;
    visasSimiecConsultadas.value = false;
    visasElectronicasConsultadas.value = false;
    advertenciasComplementos.clear();
    mensajeErrorConsulta = '';
    mensajeErrorMovimientos = '';
    mensajeErrorVisas = '';
    mensajeErrorVisasElectronicas = '';
    mensajeErrorFuentesPersona = '';
    mensajeErrorAntecedentesPersona = '';

    if (!mantenerCriterios) {
      _documentoConsultado = '';
      _nacionalidadConsultada = '';
      _latitudConsulta = '';
      _longitudConsulta = '';
      _ipConsulta = '';
    }
  }

  @override
  void onClose() {
    controllerDocumento.dispose();
    controllerNacionalidad.dispose();
    focusDocumento.dispose();
    focusNacionalidad.dispose();
    controllerClaveFinalizar.dispose();
    super.onClose();
  }
}
