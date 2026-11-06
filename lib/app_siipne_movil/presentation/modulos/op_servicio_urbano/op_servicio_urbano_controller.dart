part of '../controllers.dart';

class OpServicioUrbanoController extends GetxController {
  final LoginController loginController = Get.find<LoginController>();
  final SiipneMovilUseCase siipneMovilUseCase = Get.find();
  late UserEntities user;
  final RxBool peticionServerState = false.obs;
  final ScrollController scrollController = ScrollController();
  final RxBool mostrarIndicador = true.obs;
  final RxBool dialogoConsultaAbierto = false.obs;
  final RxBool selectPerson = false.obs;
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
  final RxBool internetPublicoDisponible = false.obs;
  final Set<String> _documentosConOrdenCapturaConfirmada = <String>{};
  bool _verificandoInternetPublico = false;
  bool _pushOperativoActivado = false;
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
  // Variable activa utilizada por las vistas principales existentes.
  // Se conserva para compatibilidad con los mixins actuales.
  final Rxn<VariablesResultado> variableResultadoSeleccionada =
  Rxn<VariablesResultado>();
  // Selecciones independientes por tipo de registro. Evitan que una variable
  // seleccionada para persona/conductor/ocupante modifique el resultado del
  // vehículo, o viceversa.
  final Rxn<VariablesResultado> variableResultadoPersonaSeleccionada =
  Rxn<VariablesResultado>();
  final Rxn<VariablesResultado> variableResultadoVehiculoSeleccionada =
  Rxn<VariablesResultado>();
  final Rxn<VariablesResultado> variableResultadoPersonaVehiculoSeleccionada =
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
    final List<VariablesResultado> lista = variablesResultado.where((
        VariablesResultado item,
        ) {
      final String tipo = item.tipoConsulta.trim().toUpperCase();
      return tipo == 'T' || tipo == 'P';
    }).toList();
    // PRIORIZAR "PERSONAS REGISTRADAS"
    final int index = lista.indexWhere((item) {
      final String desc = item.desHdrTipoResum.trim().toUpperCase();
      return desc == 'PERSONAS REGISTRADAS' || desc == 'PERSONA REGISTRADA';
    });
    if (index > 0) {
      final VariablesResultado item = lista.removeAt(index);
      lista.insert(0, item);
    }
    return lista;
  }

  List<VariablesResultado> get variablesResultadoVehiculo {
    final List<VariablesResultado> lista = variablesResultado.where((
        VariablesResultado item,
        ) {
      final String tipo = item.tipoConsulta.trim().toUpperCase();
      return tipo == 'T' || tipo == 'V';
    }).toList();
    // PRIORIZAR "VEHICULO REVISADOS"
    final int index = lista.indexWhere((item) {
      final String desc = item.desHdrTipoResum.trim().toUpperCase();
      return desc == 'VEHICULO REVISADOS' ||
          desc == 'VEHÍCULOS REVISADOS' ||
          desc == 'VEHICULOS REVISADOS' ||
          desc == 'VEHICULO REVISADO' ||
          desc == 'VEHÍCULO REVISADO';
    });
    if (index > 0) {
      final VariablesResultado item = lista.removeAt(index);
      lista.insert(0, item);
    }
    return lista;
  }

  VariablesResultado? get variableDefaultPersona {
    final List<VariablesResultado> lista = variablesResultadoPersona;
    if (lista.isEmpty) return null;
    for (final VariablesResultado item in lista) {
      final String descripcion = _normalizarTextoOperativo(
        item.desHdrTipoResum,
      );
      if (descripcion == 'PERSONAS REGISTRADAS' ||
          descripcion == 'PERSONA REGISTRADA') {
        return item;
      }
    }
    return lista.first;
  }

  VariablesResultado? get variableDefaultVehiculo {
    final List<VariablesResultado> lista = variablesResultadoVehiculo;
    if (lista.isEmpty) return null;
    for (final VariablesResultado item in lista) {
      final String descripcion = _normalizarTextoOperativo(
        item.desHdrTipoResum,
      );
      if (descripcion == 'VEHICULOS REVISADOS' ||
          descripcion == 'VEHICULO REVISADO') {
        return item;
      }
    }
    return lista.first;
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
  final Set<String> _documentosConsultadosOperativo = <String>{};
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
  final RxBool conductorRegistradoEnBaseDeDatos = false.obs;
  final Rxn<ConductorVehiculo> conductorDesdeBase = Rxn<ConductorVehiculo>();
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
  bool consultaRepetida = false;
  bool _ultimaConsultaPersonaRecuperadaPorTimeout = false;
  int get idHdrEventoResumVehiculo {
    if (dataVehiculo.isEmpty) return 0;
    return dataVehiculo.first.idHdrEventoResum;
  }

  int get cantidadOcupantesVehiculo => dataPersona_ocupantes.length;
  bool get tieneConductorVehiculo => conductorRegistradoEnBaseDeDatos.value;
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
  // PERSONAL DEL OPERATIVO
  // ============================================================
  final RxList<Integrante> personalOperativo = <Integrante>[].obs;
  String mensajeErrorPersonalOperativo = '';
  // ============================================================
  // INIT
  // ============================================================
  final RxString nombreOperativoActual = ''.obs;
  final RxString nombreModuloActual = ''.obs;
  final RxBool requiereConductorDesdeConfiguracion = false.obs;
  String _normalizarTextoOperativo(String value) {
    return value
        .trim()
        .toUpperCase()
        .replaceAll('Á', 'A')
        .replaceAll('É', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll('Ü', 'U')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  bool get esModuloOperativosPreventivos {
    final String modulo = _normalizarTextoOperativo(nombreModuloActual.value);
    return modulo.contains('OPERATIVO') && modulo.contains('PREVENTIV');
  }

  bool get requiereConductorObligatorio =>
      requiereConductorDesdeConfiguracion.value ||
          esModuloOperativosPreventivos;
  bool _nombreModuloGenerico(String value) {
    final String modulo = _normalizarTextoOperativo(value);
    return modulo.isEmpty ||
        modulo == 'SERVICIO URBANO' ||
        modulo == 'MOVIL SERVICIO URBANO' ||
        modulo == 'MOVILES SERVICIO URBANO';
  }

  Future<void> _resolverModuloOperativoActual() async {
    final int idTipoOperativo = idOperativoVariablesActual.value;
    if (idTipoOperativo <= 0 || isClosed) return;
    if (esModuloOperativosPreventivos) {
      requiereConductorDesdeConfiguracion.value = true;
      return;
    }
    if (!esOperativoPendiente.value &&
        !_nombreModuloGenerico(nombreModuloActual.value))
      return;
    try {
      final List<DataModulo> modulos = await siipneMovilUseCase.getModulos(
        request: GetPermisosModulosRequest(
          idGenUsuario: user.idGenUsuario,
          idGenPersona: user.idGenPersona,
        ),
      );
      for (final DataModulo modulo in modulos) {
        if (isClosed) return;
        try {
          final List<DataTipoOperativo> tipos = await siipneMovilUseCase
              .getTipoOperativos(
            request: GetTipoOperativosRequest(
              idGenModulo: modulo.idGenModulo,
            ),
          );
          final bool pertenece = tipos.any(
                (DataTipoOperativo item) => item.idOperativo == idTipoOperativo,
          );
          if (!pertenece) continue;
          final String nombreReal = modulo.descripcion.trim();
          if (nombreReal.isNotEmpty) nombreModuloActual.value = nombreReal;
          final String moduloNormalizado = _normalizarTextoOperativo(
            nombreReal,
          );
          requiereConductorDesdeConfiguracion.value =
              moduloNormalizado.contains('OPERATIVO') &&
                  moduloNormalizado.contains('PREVENTIV');
          debugPrint('==========================================');
          debugPrint('MÓDULO OPERATIVO RESUELTO');
          debugPrint('ID TIPO OPERATIVO: $idTipoOperativo');
          debugPrint('MÓDULO REAL: ${nombreModuloActual.value}');
          debugPrint(
            'CONDUCTOR OBLIGATORIO: ${requiereConductorObligatorio ? 'SI' : 'NO'}',
          );
          debugPrint('==========================================');
          return;
        } catch (e) {
          debugPrint(
            'No fue posible validar el módulo ${modulo.descripcion}: $e',
          );
        }
      }
      debugPrint(
        'No fue posible asociar el tipo operativo $idTipoOperativo a un módulo permitido.',
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR RESOLVIENDO MÓDULO DEL OPERATIVO: $e');
      debugPrint('$stackTrace');
    }
  }

  String _leerNombreModuloDesdeObjeto(dynamic objeto) {
    if (objeto == null) return '';
    dynamic valor;
    try {
      valor = objeto.nombreModulo;
    } catch (_) {}
    if (ParseModel.parseToString(valor).trim().isEmpty) {
      try {
        valor = objeto.descripcionModulo;
      } catch (_) {}
    }
    if (ParseModel.parseToString(valor).trim().isEmpty) {
      try {
        valor = objeto.modulo;
      } catch (_) {}
    }
    if (ParseModel.parseToString(valor).trim().isEmpty) {
      try {
        final dynamic jsonDinamico = objeto.toJson();
        if (jsonDinamico is Map) {
          final Map<String, dynamic> json = Map<String, dynamic>.from(
            jsonDinamico,
          );
          valor =
              json['nombreModulo'] ??
                  json['descripcionModulo'] ??
                  json['desModulo'] ??
                  json['modulo'];
        }
      } catch (_) {}
    }
    return ParseModel.parseToString(valor).trim();
  }

  void _cargarNombreModulo(Map<dynamic, dynamic> arguments) {
    nombreModuloActual.value = '';
    final List<String> claves = <String>[
      'nombreModulo',
      'descripcionModulo',
      'desModulo',
    ];
    for (final String clave in claves) {
      final String valor = ParseModel.parseToString(arguments[clave]).trim();
      if (valor.isNotEmpty) {
        nombreModuloActual.value = valor;
        break;
      }
    }
    if (nombreModuloActual.value.isEmpty) {
      final dynamic modulo = arguments['modulo'];
      final String desdeModulo = _leerNombreModuloDesdeObjeto(modulo);
      if (desdeModulo.isNotEmpty) {
        nombreModuloActual.value = desdeModulo;
      }
    }
  }

  // ============================================================
  // ANTECEDENTES PERSONA
  // ============================================================
  final Rxn<DataAntecedentes> datosAntecedentesPersona =
  Rxn<DataAntecedentes>();
  final RxBool consultandoAntecedentesPersona = false.obs;
  String mensajeErrorAntecedentesPersona = '';
  bool get tieneAntecedentesPersona =>
      datosAntecedentesPersona.value?.antecedentes.isNotEmpty ?? false;
  final Set<String> _alertasPushMostradas = <String>{};
  Future<void> _colaDialogosPush = Future<void>.value();
  @override
  void onInit() {
    super.onInit();
    user = loginController.user.value;
    scrollController.addListener(_onScroll);
    _inicializarPantalla();
  }

  final RxString estadoNotificaciones = 'Notificaciones sin activar'.obs;
  void _estadoPushActualizado() {
    final estado = OperativoPushService.instance.estado.value;
    if (!isClosed) estadoNotificaciones.value = estado;
    if (kDebugMode) debugPrint('[PUSH] Estado: $estado');
  }

  Future<void> _activarNotificacionesOperativo() async {
    if (isClosed) {
      return;
    }
    final int idEvento = idHdrEventoActual.value;
    if (idEvento <= 0) {
      debugPrint('[PUSH] No existe un ID de operativo válido');
      return;
    }
    /*
   * Si ya fue activado correctamente no volver
   * a tocar Firebase.
   */
    if (_pushOperativoActivado) {
      debugPrint('[PUSH] Notificaciones ya activadas para el operativo.');
      return;
    }
    /*
   * ============================================================
   * VALIDAR INTERNET PÚBLICO ANTES DE FIREBASE
   * ============================================================
   *
   * MUY IMPORTANTE:
   *
   * Esto ocurre ANTES de acceder a:
   *
   * OperativoPushService.instance
   * FirebaseMessaging.instance
   * getToken()
   * subscribeToTopic()
   * getAPNSToken()
   */
    final bool tieneInternet = await _hayInternetPublico();
    if (!tieneInternet) {
      if (!isClosed) {
        estadoNotificaciones.value =
        'Notificaciones omitidas - sin Internet público';
      }
      debugPrint('==========================================');
      debugPrint('[PUSH] OMITIDO');
      debugPrint('[PUSH] No existe acceso a Internet público.');
      debugPrint('[PUSH] Las consultas SIIPNE continuarán normalmente.');
      debugPrint('[PUSH] NO se accederá a Firebase.');
      debugPrint('==========================================');
      return;
    }
    if (isClosed) {
      return;
    }
    /*
   * Recién aquí obtenemos el servicio PUSH.
   */
    final OperativoPushService push = OperativoPushService.instance;
    push.estado.removeListener(_estadoPushActualizado);
    push.alertaCritica.removeListener(_alertaPushActualizada);
    push.aperturaPendiente.removeListener(_alertaPushActualizada);
    push.estado.addListener(_estadoPushActualizado);
    push.alertaCritica.addListener(_alertaPushActualizada);
    push.aperturaPendiente.addListener(_alertaPushActualizada);
    try {
      debugPrint('==========================================');
      debugPrint('[PUSH] INTERNET PÚBLICO DISPONIBLE');
      debugPrint('[PUSH] ACTIVANDO NOTIFICACIONES');
      debugPrint('[PUSH] Topic esperado: operativo_$idEvento');
      debugPrint('==========================================');
      /*
     * FIREBASE SOLO SE EJECUTA AQUÍ.
     */
      await push.activarOperativo(idEvento).timeout(const Duration(seconds: 8));
      if (isClosed) {
        return;
      }
      _pushOperativoActivado = true;
      _estadoPushActualizado();
      _alertaPushActualizada();
      /*
     * Información únicamente para DEBUG.
     */
      if (kDebugMode) {
        try {
          final String? token = await push.obtenerTokenDispositivo().timeout(
            const Duration(seconds: 5),
          );
          debugPrint('==========================================');
          debugPrint('[PUSH] ESTADO: ${push.estado.value}');
          debugPrint(
            '[PUSH] FCM TOKEN: '
                '${token != null && token.isNotEmpty ? 'SI' : 'NO'}',
          );
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            try {
              final String? apnsToken = await FirebaseMessaging.instance
                  .getAPNSToken()
                  .timeout(const Duration(seconds: 5));
              debugPrint(
                '[PUSH] APNs TOKEN: '
                    '${apnsToken != null && apnsToken.isNotEmpty ? 'SI' : 'NO'}',
              );
            } catch (e) {
              debugPrint('[PUSH] No fue posible consultar APNs: $e');
            }
          }
          debugPrint('==========================================');
        } catch (e) {
          debugPrint('[PUSH] No fue posible obtener token: $e');
        }
      }
    } catch (e, stackTrace) {
      /*
     * Un problema con Firebase JAMÁS debe
     * convertirse en un problema de consulta SIIPNE.
     */
      _pushOperativoActivado = false;
      if (!isClosed) {
        estadoNotificaciones.value = 'Notificaciones no disponibles';
      }
      debugPrint('==========================================');
      debugPrint('[PUSH] FIREBASE NO DISPONIBLE');
      debugPrint('[PUSH] $e');
      debugPrint('[PUSH] El operativo continúa sin notificaciones.');
      debugPrintStack(stackTrace: stackTrace);
      debugPrint('==========================================');
    }
  }

  Future<void> _inicializarPantalla() async {
    _cargarDatosOperativo();
    if (!datosOperativoValidos.value) return;
    await _resolverModuloOperativoActual();
    if (isClosed) return;
    _activarNotificacionesOperativo();
    await cargarVariablesResultado();
  }

  // ============================================================
  // CARGAR OPERATIVO
  // ============================================================
  void _cargarDatosOperativo() {
    nombreOperativoActual.value = '';
    nombreModuloActual.value = '';
    datosOperativoValidos.value = true;
    mensajeDatosOperativo = '';
    puedeFinalizarOperativo.value = false;
    final dynamic arguments = Get.arguments;
    debugPrint('==========================================');
    debugPrint('OP SERVICIO URBANO - ARGUMENTOS');
    debugPrint('$arguments');
    debugPrint('TIPO: ${arguments.runtimeType}');
    debugPrint('==========================================');
    if (arguments == null || arguments is! Map) {
      _marcarDatosInvalidos('No se recibieron datos válidos del operativo.');
      return;
    }
    _cargarNombreModulo(arguments);
    final dynamic requiereConductorArgumento =
    arguments['requiereConductorObligatorio'];
    if (requiereConductorArgumento is bool) {
      requiereConductorDesdeConfiguracion.value = requiereConductorArgumento;
    } else {
      final String valor = ParseModel.parseToString(requiereConductorArgumento)
          .trim()
          .toUpperCase();
      requiereConductorDesdeConfiguracion.value =
          valor == 'TRUE' || valor == '1' || valor == 'SI' || valor == 'SÍ';
    }
    if (esModuloOperativosPreventivos)
      requiereConductorDesdeConfiguracion.value = true;
    final String nombreOperativoArgumento = ParseModel.parseToString(
      arguments['nombreOperativo'],
    ).trim();
    if (nombreOperativoArgumento.isNotEmpty) {
      nombreOperativoActual.value = nombreOperativoArgumento;
    }
    final String tipoAcceso = ParseModel.parseToString(arguments['tipoAcceso'])
        .trim()
        .toUpperCase();
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
      if (nombreModuloActual.value.isEmpty) {
        final String moduloPendiente = _leerNombreModuloDesdeObjeto(
          datoPendiente,
        );
        if (moduloPendiente.isNotEmpty) {
          nombreModuloActual.value = moduloPendiente;
        }
      }
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
      if (nombreModuloActual.value.isEmpty) {
        final String moduloAnexado = _leerNombreModuloDesdeObjeto(datoAnexarse);
        if (moduloAnexado.isNotEmpty) {
          nombreModuloActual.value = moduloAnexado;
        }
      }
      puedeFinalizarOperativo.value = false;
      esOperativoAnexado.value = true;
      esOperativoPendiente.value = false;
      if (idHdrEventoActual.value <= 0) {
        idHdrEventoActual.value = datoAnexarse.idHdrEvento;
      }
      // NOMBRE DEL OPERATIVO
      final String nombreAnexado = datoAnexarse.descripcion.trim();
      if (nombreAnexado.isNotEmpty) {
        nombreOperativoActual.value = nombreAnexado;
      }
      if (datoAnexarse.idTipoOperativo > 0) {
        idOperativoVariablesActual.value = datoAnexarse.idTipoOperativo;
      }
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
      final String nombreArgumento = ParseModel.parseToString(
        arguments['nombreOperativo'],
      ).trim();
      if (nombreArgumento.isNotEmpty) {
        nombreOperativoActual.value = nombreArgumento;
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
    debugPrint('MÓDULO: ${nombreModuloActual.value}');
    debugPrint('PREVENTIVO POR NOMBRE: $esModuloOperativosPreventivos');
    debugPrint(
      'PREVENTIVO POR CONFIGURACIÓN: ${requiereConductorDesdeConfiguracion.value}',
    );
    debugPrint(
      'CONDUCTOR OBLIGATORIO: ${requiereConductorObligatorio ? 'SI' : 'NO'}',
    );
    debugPrint('PENDIENTE: ${esOperativoPendiente.value}');
    debugPrint('ANEXADO: ${esOperativoAnexado.value}');
    debugPrint('==========================================');
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
      variableResultadoPersonaSeleccionada.value = null;
      variableResultadoVehiculoSeleccionada.value = null;
      variableResultadoPersonaVehiculoSeleccionada.value = null;
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
      final VariablesResultado? defaultPersona = variableDefaultPersona;
      final VariablesResultado? defaultVehiculo = variableDefaultVehiculo;
      variableResultadoPersonaSeleccionada.value = defaultPersona;
      variableResultadoVehiculoSeleccionada.value = defaultVehiculo;
      variableResultadoPersonaVehiculoSeleccionada.value = defaultPersona;
      if (selectPerson.value) {
        variableResultadoSeleccionada.value = defaultPersona;
      } else if (selectVehiculo.value) {
        variableResultadoSeleccionada.value = defaultVehiculo;
      } else {
        variableResultadoSeleccionada.value = null;
      }
      variablesResultadoCargadas.value = true;
      errorCargaVariables.value = false;
      debugPrint('==========================================');
      debugPrint('VARIABLES RESULTADO CARGADAS');
      debugPrint('CANTIDAD: ${variablesResultado.length}');
      debugPrint(
        'DEFAULT PERSONA: ${defaultPersona?.idVariable} | '
            '${defaultPersona?.desHdrTipoResum}',
      );
      debugPrint(
        'DEFAULT VEHÍCULO: ${defaultVehiculo?.idVariable} | '
            '${defaultVehiculo?.desHdrTipoResum}',
      );
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
      variableResultadoPersonaSeleccionada.value = null;
      variableResultadoVehiculoSeleccionada.value = null;
      variableResultadoPersonaVehiculoSeleccionada.value = null;
      variablesResultadoCargadas.value = false;
      errorCargaVariables.value = true;
      mensajeErrorVariables = 'No fue posible obtener las variables configuradas para el operativo.';
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
    if (selectPerson.value) {
      variableResultadoPersonaSeleccionada.value = variable;
      debugPrint(
        'VARIABLE PERSONA SELECCIONADA: '
            '${variable?.idVariable} | ${variable?.desHdrTipoResum}',
      );
      return;
    }
    if (selectVehiculo.value) {
      variableResultadoVehiculoSeleccionada.value = variable;
      debugPrint(
        'VARIABLE VEHÍCULO SELECCIONADA: '
            '${variable?.idVariable} | ${variable?.desHdrTipoResum}',
      );
    }
  }

  void seleccionarVariableResultadoPersonaVehiculo(
      VariablesResultado? variable,
      ) {
    variableResultadoPersonaVehiculoSeleccionada.value = variable;
    debugPrint(
      'VARIABLE PERSONA VEHÍCULO SELECCIONADA: '
          '${variable?.idVariable} | ${variable?.desHdrTipoResum}',
    );
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
    VariablesResultado? variableSeleccionada,
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
    final VariablesResultado? variable =
        variableSeleccionada ?? variableResultadoSeleccionada.value;
    if (variable == null || variable.idVariable <= 0) {
      mensajeErrorActualizaResultado = 'Seleccione un resultado preliminar.';
      return false;
    }
    final int idVariableNueva = variable.idVariable;
    debugPrint('==========================================');
    debugPrint('VERIFICANDO ACTUALIZACIÓN RESULTADO');
    debugPrint('ID HDR EVENTO RESUM: $idHdrEventoResum');
    debugPrint('VARIABLE ORIGINAL: $idVariableOriginal');
    debugPrint('VARIABLE NUEVA: $idVariableNueva');
    debugPrint('DESCRIPCIÓN: ${variable.desHdrTipoResum}');
    debugPrint('==========================================');
    if (idVariableOriginal > 0 && idVariableNueva == idVariableOriginal) {
      debugPrint('RESULTADO SIN CAMBIOS - NO SE EJECUTA PUT');
      return true;
    }
    actualizandoResultado.value = true;
    peticionServerState.value = true;
    try {
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
        mensajeErrorActualizaResultado = 'El registro confirmado por el servidor no corresponde a la consulta actual.';
        return false;
      }
      debugPrint('==========================================');
      debugPrint('RESULTADO ACTUALIZADO CORRECTAMENTE');
      debugPrint('ID HDR EVENTO RESUM: ${resultado.idHdrEventoResum}');
      debugPrint('ID VARIABLE: $idVariableNueva');
      debugPrint('DESCRIPCIÓN: ${variable.desHdrTipoResum}');
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
  String normalizarDocumentoPersonaVehiculo(String documento) {
    return documento.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  }

  bool documentoPersonaVehiculoRegistrado(String documento) {
    final String valor = normalizarDocumentoPersonaVehiculo(documento);
    if (valor.isEmpty) {
      return false;
    }
    return documentosPersonasVehiculoRegistradas.contains(valor);
  }

  bool _documentoConsultadoEnOperativo(String documento) {
    final String valor = normalizarDocumentoPersonaVehiculo(documento);
    return valor.isNotEmpty && _documentosConsultadosOperativo.contains(valor);
  }

  void _registrarDocumentoConsultadoOperativo(String documento) {
    final String valor = normalizarDocumentoPersonaVehiculo(documento);
    if (valor.isNotEmpty) _documentosConsultadosOperativo.add(valor);
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
    String nacionalidad = 'ECU',
  }) async {
    if (peticionServerState.value || isClosed) {
      return false;
    }
    mensajeErrorConsulta = '';
    mensajeErrorActualizaResultado = '';
    consultaRepetida = false;
    final String nacionalidadNormalizada = nacionalidad.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(nacionalidadNormalizada)) {
      mensajeErrorConsulta = 'Seleccione una nacionalidad válida.';
      return false;
    }
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
    if (_documentoConsultadoEnOperativo(cedula)) {
      consultaRepetida = true;
      controllerCedula.clear();
      mensajeErrorConsulta = 'La persona ya fue consultada dentro de este operativo. Realice la consulta con otro documento.';
      debugPrint('==========================================');
      debugPrint('CONSULTA PERSONA BLOQUEADA LOCALMENTE');
      debugPrint('DOCUMENTO: ${normalizarDocumentoPersonaVehiculo(cedula)}');
      debugPrint('OPERATIVO: ${idHdrEventoActual.value}');
      debugPrint('NO SE ENVÍA NUEVO REQUEST AL SERVIDOR');
      debugPrint('==========================================');
      return false;
    }
    final VariablesResultado? variableDefault = variableDefaultPersona;
    final int idVariable = variableDefault?.idVariable ?? 0;
    if (idVariable <= 0) {
      mensajeErrorConsulta =
      'No existen variables configuradas para la consulta de persona.';
      return false;
    }
    peticionServerState.value = true;
    OperativoPushService? push;
    dynamic consultaPush;
    bool pushFinalizado = false;
    if (_pushOperativoActivado && internetPublicoDisponible.value) {
      push = OperativoPushService.instance;
      consultaPush = push.consultasPersona.iniciar(
        idOperativo: idHdrEventoActual.value,
        documento: cedula,
      );
    }
    try {
      final BuildContext? context = Get.context;
      if (context == null) {
        mensajeErrorConsulta =
        'No existe contexto disponible para realizar la consulta.';
        return false;
      }
      final LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
      final LatLng pos = await locationBloc.getCurrentPosition();
      if (isClosed) {
        return false;
      }
      final String ip = await DeviceInfoApp.getIp;
      if (isClosed) {
        return false;
      }
      final String consultadoPor = user.nombres;
      final ConsultarPersonaRequest request = ConsultarPersonaRequest(
        consultadoPor: consultadoPor,
        idOperativo: idHdrEventoActual.value,
        documento: cedula,
        siglasNacionalidad: nacionalidadNormalizada,
        latitud: pos.latitude,
        longitud: pos.longitude,
        ip: ip,
        idGenUsuario: user.idGenUsuario,
        idVariableResultado: idVariable,
        idGenPersona: user.idGenPersona,
      );
      debugPrint('==========================================');
      debugPrint('INICIANDO CONSULTA PERSONA');
      debugPrint('OPERATIVO: ${idHdrEventoActual.value}');
      debugPrint('DOCUMENTO: $cedula');
      debugPrint('VARIABLE: $idVariable');
      debugPrint('==========================================');
      /*
     * Limpiamos únicamente la visualización actual.
     *
     * NO limpiamos:
     *
     * _documentosConOrdenCapturaConfirmada
     *
     * porque sirve para proteger las consultas repetidas.
     */
      dataPersona.clear();
      tieneOrdenCaptura.value = false;
      idHdrEventoResumPersona = 0;
      idVariableInsertadaPersona = 0;
      /*
     * No activar Firebase aquí.
     *
     * Las consultas SIIPNE deben funcionar
     * independientemente de las notificaciones.
     */
      if (isClosed) {
        return false;
      }
      /*
     * Consulta principal con recuperación
     * automática en timeout.
     */
      final DataConsultaPersona data = await _consultarPersonaServidor(
        request: request,
      );
      if (isClosed) {
        return false;
      }
      final bool consultaRecuperadaPorTimeout =
          _ultimaConsultaPersonaRecuperadaPorTimeout;
      consultaRepetida = data.consultaRepetida;
      final bool consultaRepetidaReal =
          data.consultaRepetida && !consultaRecuperadaPorTimeout;
      /*
     * Finalizamos control interno PUSH.
     */
      if (push != null && consultaPush != null) {
        push.consultasPersona.finalizar(
          consultaPush,
          consultaRepetida: data.consultaRepetida,
          idHdrEventoResum: data.idHdrEventoResum,
        );
        pushFinalizado = true;
      }
      debugPrint('==========================================');
      debugPrint('RESPUESTA CONSULTA PERSONA');
      debugPrint('DOCUMENTO: $cedula');
      debugPrint('CONSULTA REPETIDA SERVIDOR: ${data.consultaRepetida}');
      debugPrint('RECUPERADA POR TIMEOUT: $consultaRecuperadaPorTimeout');
      debugPrint('CONSULTA REPETIDA REAL: $consultaRepetidaReal');
      debugPrint('ID HDR EVENTO RESUM: ${data.idHdrEventoResum}');
      debugPrint('ORDEN CAPTURA SERVIDOR: ${data.ordenCaptura.success}');
      debugPrint('==========================================');
      if (data.idHdrEventoResum <= 0) {
        dataPersona.clear();
        mensajeErrorConsulta = 'El servidor respondió la consulta, pero no devolvió el identificador del registro realizado.';
        ocultarBtnBuscarPersona.value = false;
        return false;
      }
      if (consultaRepetidaReal) {
        debugPrint('==========================================');
        debugPrint('CONSULTA PERSONA REPETIDA - BLOQUEADA');
        debugPrint('DOCUMENTO: $cedula');
        debugPrint('OPERATIVO: ${idHdrEventoActual.value}');
        debugPrint('ID HDR EVENTO RESUM: ${data.idHdrEventoResum}');
        debugPrint('SE DEBE CONSULTAR OTRO DOCUMENTO');
        debugPrint('==========================================');
        dataPersona.clear();
        tieneOrdenCaptura.value = false;
        idHdrEventoResumPersona = 0;
        idVariableInsertadaPersona = 0;
        ocultarBtnBuscarPersona.value = false;
        controllerCedula.clear();
        _registrarDocumentoConsultadoOperativo(cedula);
        mensajeErrorConsulta = 'La persona ya fue consultada dentro de este operativo. Realice la consulta con otro documento.';
        return false;
      }
      if (data.consultaRepetida && consultaRecuperadaPorTimeout) {
        debugPrint('CONSULTA PERSONA RECUPERADA POR TIMEOUT - NO SE BLOQUEA');
      }
      _registrarDocumentoConsultadoOperativo(cedula);
      dataPersona.assignAll(<DataConsultaPersona>[data]);
      idHdrEventoResumPersona = data.idHdrEventoResum;
      idVariableInsertadaPersona = idVariable;
      variableResultadoPersonaSeleccionada.value = variableDefault;
      variableResultadoSeleccionada.value = variableDefault;
      /*
     * ============================================================
     * ORDEN DE CAPTURA
     * ============================================================
     *
     * Esta función:
     *
     * - verifica respuesta actual;
     * - verifica consulta repetida;
     * - recupera una alerta confirmada durante esta sesión;
     * - reproduce audio.
     */
      final bool tieneBoleta = await _procesarOrdenCapturaPersona(
        persona: data,
        documento: cedula,
        actualizarConsultaPrincipal: true,
        origen: consultaRepetida
            ? 'PERSONA - CONSULTA REPETIDA'
            : 'PERSONA - CONSULTA NUEVA',
      );
      debugPrint('==========================================');
      debugPrint('ESTADO FINAL PERSONA');
      debugPrint('DOCUMENTO: $cedula');
      debugPrint('TIENE ORDEN CAPTURA: $tieneBoleta');
      debugPrint('RX tieneOrdenCaptura: ${tieneOrdenCaptura.value}');
      debugPrint('CONSULTA REPETIDA: $consultaRepetida');
      debugPrint('==========================================');
      ocultarBtnBuscarPersona.value = true;
      controllerCedula.clear();
      mensajeErrorConsulta = '';
      return true;
    } catch (e, stackTrace) {
      mensajeErrorConsulta = UrlApiProviderAppCenso.mensajeException(
        e,
        fallback: 'No fue posible realizar la consulta de la persona.',
      );
      ocultarBtnBuscarPersona.value = false;
      debugPrint('==========================================');
      debugPrint('ERROR CONSULTA PERSONA');
      debugPrint(mensajeErrorConsulta);
      debugPrint('$e');
      debugPrint('$stackTrace');
      debugPrint('==========================================');
      return false;
    } finally {
      if (!pushFinalizado && push != null && consultaPush != null)
        push.consultasPersona.finalizar(consultaPush);
      peticionServerState.value = false;
    }
  }

  // ============================================================
  // NUEVA CONSULTA PERSONA
  // ============================================================
  Future<bool> nuevaConsultaPersona() async {
    if (peticionServerState.value || actualizandoResultado.value || isClosed) {
      return false;
    }
    mensajeErrorActualizaResultado = '';
    FocusManager.instance.primaryFocus?.unfocus();
    /*
   * Guardar resultado actual antes de limpiar.
   */
    if (dataPersona.isNotEmpty && idHdrEventoResumPersona > 0) {
      final bool actualizado = await actualizarResultadoRegistro(
        idHdrEventoResum: idHdrEventoResumPersona,
        idVariableOriginal: idVariableInsertadaPersona,
        variableSeleccionada: variableResultadoPersonaSeleccionada.value,
      );
      if (!actualizado) {
        return false;
      }
    }
    controllerCedula.clear();
    dataPersona.clear();
    idHdrEventoResumPersona = 0;
    idVariableInsertadaPersona = 0;
    /*
   * Limpiamos únicamente la pantalla.
   *
   * NO limpiamos:
   *
   * _documentosConOrdenCapturaConfirmada
   */
    tieneOrdenCaptura.value = false;
    ocultarBtnBuscarPersona.value = false;
    variableResultadoPersonaSeleccionada.value = variableDefaultPersona;
    limpiarSeleccionConsulta();
    return true;
  }

  // ============================================================
  // CONSULTAR VEHÍCULO
  // ============================================================
  Future<bool> consultarVehiculoPorPlaca({
    required GlobalKey<FormState> key,
  }) async {
    if (peticionServerState.value || isClosed) {
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
    final VariablesResultado? variableDefault = variableDefaultVehiculo;
    final int idVariable = variableDefault?.idVariable ?? 0;
    if (idVariable <= 0) {
      mensajeErrorConsulta =
      'No existen variables configuradas para la consulta de vehículo.';
      return false;
    }
    DataVehiculo? vehiculoParaAdvertencia;
    FocusManager.instance.primaryFocus?.unfocus();
    peticionServerState.value = true;
    try {
      final BuildContext? context = Get.context;
      if (context == null || !context.mounted) {
        mensajeErrorConsulta =
        'No fue posible acceder a la pantalla del operativo.';
        return false;
      }
      final LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
      final LatLng pos = await locationBloc.getCurrentPosition();
      if (isClosed) {
        return false;
      }
      final String ip = await DeviceInfoApp.getIp;
      if (isClosed) {
        return false;
      }
      final String consultadoPor = user.nombres;
      final ConsultarVehiculoRequest request = ConsultarVehiculoRequest(
        consultadoPor: consultadoPor,
        idOperativo: idHdrEventoActual.value,
        placa: placa,
        latitud: pos.latitude,
        longitud: pos.longitude,
        ip: ip,
        idGenUsuario: user.idGenUsuario,
        userName: user.nombreUsuario,
        idVariableResultado: idVariable,
      );
      debugPrint('==========================================');
      debugPrint('INICIANDO CONSULTA VEHÍCULO');
      debugPrint('ID HDR EVENTO: ${idHdrEventoActual.value}');
      debugPrint('PLACA: $placa');
      debugPrint('ID VARIABLE INSERCIÓN: $idVariable');
      debugPrint('==========================================');
      /*
     * Limpiar resultado anterior.
     */
      dataVehiculo.clear();
      vehiculoRobado.value = false;
      idVariableInsertadaVehiculo = 0;
      _limpiarPersonasVehiculo();
      // await _activarNotificacionesOperativo();
      if (isClosed) {
        return false;
      }
      /*
     * ============================================================
     * CONSULTA CON RECUPERACIÓN
     * ============================================================
     *
     * Si ocurre timeout, vuelve a consultar UNA sola vez.
     *
     * Si el primer request sí persistió en servidor,
     * el segundo debe devolver el registro existente.
     */
      final DataVehiculo data = await _consultarVehiculoServidor(
        request: request,
      );
      if (isClosed) {
        return false;
      }
      /*
     * El vehículo debe contener datos.
     *
     * IMPORTANTE:
     * que haya sido consultado anteriormente NO constituye
     * un error si el servidor devuelve la información.
     */
      if (!data.datosVehiculo.success) {
        mensajeErrorConsulta = 'El servidor respondió, pero no devolvió los datos del vehículo consultado.';
        ocultarBtnBuscarVehiculo.value = false;
        return false;
      }
      /*
     * Validar que exista el registro persistido.
     */
      if (data.idHdrEventoResum <= 0) {
        mensajeErrorConsulta =
        'El servidor devolvió los datos del vehículo, '
            'pero no confirmó el registro de la consulta.';
        ocultarBtnBuscarVehiculo.value = false;
        return false;
      }
      /*
     * ============================================================
     * SIEMPRE MOSTRAR EL VEHÍCULO
     * ============================================================
     */
      dataVehiculo.assignAll(<DataVehiculo>[data]);
      idVariableInsertadaVehiculo = idVariable;
      variableResultadoVehiculoSeleccionada.value = variableDefault;
      variableResultadoSeleccionada.value = variableDefault;
      placaConsultadaAnterior = placaConsultada;
      placaConsultada = placa;
      vehiculoRobado.value = data.restriccionPj.data.robado;
      ocultarBtnBuscarVehiculo.value = true;
      controllerPlaca.clear();
      /*
     * La duplicidad del vehículo es una ADVERTENCIA.
     * Nunca debe impedir visualizar los datos.
     */
      final DatosConsultaDuplicadoOperativo duplicado =
          data.datosConsultaDuplicadoOperativo;
      final bool vehiculoConsultadoAnteriormente = duplicado.idHdrEvento > 0;
      if (vehiculoConsultadoAnteriormente) {
        debugPrint('==========================================');
        debugPrint('VEHÍCULO CONSULTADO ANTERIORMENTE');
        debugPrint('PLACA: $placa');
        debugPrint('OPERATIVO ANTERIOR: ${duplicado.idHdrEvento}');
        debugPrint('SE MOSTRARÁ LA INFORMACIÓN NORMALMENTE');
        debugPrint('==========================================');
      }
      if (requiereConductorObligatorio) {
        final bool conductorExistente =
        await _sincronizarConductorVehiculoServidor(placa: placa);
        if (isClosed) return false;
        debugPrint('==========================================');
        debugPrint('SINCRONIZACIÓN CONDUCTOR AL CONSULTAR VEHÍCULO');
        debugPrint('OPERATIVO: ${idHdrEventoActual.value}');
        debugPrint('PLACA: $placa');
        debugPrint(
          'VEHÍCULO CONSULTADO ANTERIORMENTE: $vehiculoConsultadoAnteriormente',
        );
        debugPrint('CONDUCTOR EXISTENTE: ${conductorExistente ? 'SI' : 'NO'}');
        debugPrint('==========================================');
      }
      /*
     * ALERTA VEHÍCULO ROBADO.
     */
      if (vehiculoRobado.value) {
        try {
          await UtilidadesUtil.playAudio(
            nameAudio: AppSiipneMovilImages.audio_Alerta,
          );
        } catch (e) {
          debugPrint('No fue posible reproducir el audio de alerta: $e');
        }
      }
      if (isClosed) {
        return false;
      }
      mensajeErrorConsulta = '';
      debugPrint('==========================================');
      debugPrint('CONSULTA VEHÍCULO CORRECTA');
      debugPrint('ID HDR EVENTO RESUM: ${data.idHdrEventoResum}');
      debugPrint('VARIABLE INSERCIÓN: $idVariableInsertadaVehiculo');
      debugPrint('DUPLICADO/ANTERIOR: $vehiculoConsultadoAnteriormente');
      debugPrint('==========================================');
      /*
     * Después de retirar loading se mostrará
     * la advertencia de duplicidad/matrícula.
     */
      vehiculoParaAdvertencia = data;
      return true;
    } catch (e, stackTrace) {
      if (!isClosed) {
        mensajeErrorConsulta = UrlApiProviderAppCenso.mensajeException(
          e,
          fallback: 'No fue posible realizar la consulta del vehículo.',
        );
        ocultarBtnBuscarVehiculo.value = false;
        debugPrint('==========================================');
        debugPrint('ERROR CONSULTA VEHÍCULO');
        debugPrint(mensajeErrorConsulta);
        debugPrint('$e');
        debugPrint('$stackTrace');
        debugPrint('==========================================');
      }
      return false;
    } finally {
      if (!isClosed) {
        peticionServerState.value = false;
        final DataVehiculo? dataAdvertencia = vehiculoParaAdvertencia;
        if (dataAdvertencia != null) {
          try {
            await WidgetsBinding.instance.endOfFrame;
            if (!isClosed) {
              _mostrarAlertasVehiculo(dataAdvertencia);
            }
          } catch (e, stackTrace) {
            debugPrint('ERROR MOSTRANDO ADVERTENCIA VEHÍCULO: $e');
            debugPrint('$stackTrace');
          }
        }
      }
    }
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
    String nacionalidad = 'ECU',
  }) async {
    if (consultandoPersonaVehiculo.value ||
        peticionServerState.value ||
        isClosed) {
      return false;
    }
    mensajeErrorConsulta = '';
    consultaRepetida = false;
    final String nacionalidadNormalizada = nacionalidad.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(nacionalidadNormalizada)) {
      mensajeErrorConsulta = 'Seleccione una nacionalidad válida.';
      return false;
    }
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
      mensajeErrorConsulta = 'El vehículo no posee un identificador válido para relacionar personas.';
      return false;
    }
    final String cedula = controllerCedulaVehiculo.text.trim();
    if (cedula.isEmpty) {
      mensajeErrorConsulta = 'Ingrese un documento válido.';
      return false;
    }
    final String documentoNormalizado = normalizarDocumentoPersonaVehiculo(
      cedula,
    );
    if (documentoNormalizado.isEmpty) {
      mensajeErrorConsulta = 'Ingrese un documento válido.';
      return false;
    }
    final bool esConductor = tipoPersonaVehiculo.value == 'CONDUCTOR';
    if (_documentoConsultadoEnOperativo(documentoNormalizado)) {
      consultaRepetida = true;
      controllerCedulaVehiculo.clear();
      mensajeErrorConsulta = esConductor
          ? 'La persona ya fue consultada dentro de este operativo. Realice la consulta del conductor con otro documento.'
          : 'La persona ya fue consultada dentro de este operativo. Realice la consulta del ocupante con otro documento.';
      debugPrint('==========================================');
      debugPrint('${esConductor ? 'CONDUCTOR' : 'OCUPANTE'} BLOQUEADO LOCALMENTE');
      debugPrint('DOCUMENTO: $documentoNormalizado');
      debugPrint('OPERATIVO: ${idHdrEventoActual.value}');
      debugPrint('NO SE ENVÍA NUEVO REQUEST AL SERVIDOR');
      debugPrint('SE CONSERVA EL REGISTRO Y LA ALERTA EXISTENTE');
      debugPrint('==========================================');
      return false;
    }
    /*
   * ============================================================
   * DUPLICADO LOCAL
   * ============================================================
   *
   * Este bloqueo únicamente evita agregar DOS VECES
   * la misma persona que YA se encuentra visible en el front.
   *
   * No tiene relación con consultaRepetida del servidor.
   */
    if (documentosPersonasVehiculoRegistradas.contains(documentoNormalizado)) {
      mensajeErrorConsulta =
      'La persona con documento $cedula ya se encuentra registrada en este vehículo.';
      debugPrint('==========================================');
      debugPrint('PERSONA YA VISIBLE EN EL VEHÍCULO');
      debugPrint('DOCUMENTO: $cedula');
      debugPrint('OPERATIVO: ${idHdrEventoActual.value}');
      debugPrint('==========================================');
      return false;
    }
    if (esConductor && dataPersona_conductor.isNotEmpty) {
      mensajeErrorConsulta = 'Este vehículo ya tiene un conductor registrado.';
      return false;
    }
    final List<VariablesResultado> variablesDisponibles =
        variablesResultadoPersona;
    final VariablesResultado? seleccionada =
        variableResultadoPersonaVehiculoSeleccionada.value;
    final bool seleccionCompatible =
        seleccionada != null &&
            variablesDisponibles.any(
                  (VariablesResultado item) =>
              item.idVariable == seleccionada.idVariable,
            );
    final VariablesResultado? variableUsar = seleccionCompatible
        ? seleccionada
        : variableDefaultPersona;
    final int idVariable = variableUsar?.idVariable ?? 0;
    if (idVariable <= 0) {
      mensajeErrorConsulta =
      'No existen variables configuradas para registrar la persona.';
      return false;
    }
    /*
   * Bloquear resto de operaciones mientras
   * se registra conductor/ocupante.
   */
    consultandoPersonaVehiculo.value = true;
    peticionServerState.value = true;
    paginaPersonasVehiculoLoading.value = true;
    OperativoPushService? push;
    dynamic consultaPush;
    bool pushFinalizado = false;
    if (_pushOperativoActivado && internetPublicoDisponible.value) {
      push = OperativoPushService.instance;
      consultaPush = push.consultasPersona.iniciar(
        idOperativo: idHdrEventoActual.value,
        documento: cedula,
        relacionadaVehiculo: true,
      );
    }
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
      if (isClosed) {
        return false;
      }
      final String ip = await DeviceInfoApp.getIp;
      if (isClosed) {
        return false;
      }
      final String consultadoPor = user.nombres;
      final ConsultarPersonaRequest request = ConsultarPersonaRequest(
        consultadoPor: consultadoPor,
        idOperativo: idHdrEventoActual.value,
        documento: cedula,
        siglasNacionalidad: nacionalidadNormalizada,
        latitud: pos.latitude,
        longitud: pos.longitude,
        ip: ip,
        idGenUsuario: user.idGenUsuario,
        idVariableResultado: idVariable,
        hdrIdHdrResum: idPadre,
        tipoRelacion: esConductor ? 'CONDUCTOR' : 'OCUPANTE',
        idGenPersona: user.idGenPersona,
      );
      //await _activarNotificacionesOperativo();
      if (isClosed) {
        return false;
      }
      /*
     * ============================================================
     * CONSULTA CON RECUPERACIÓN AUTOMÁTICA
     * ============================================================
     *
     * Utiliza EL MISMO helper de personas.
     *
     * Si el primer POST llegó al servidor pero
     * la respuesta sufrió timeout:
     *
     *   1. esperamos 900 ms;
     *   2. consultamos nuevamente;
     *   3. servidor puede devolver consultaRepetida=true;
     *   4. si fue recuperación técnica por timeout, NO se bloquea.
     */
      final DataConsultaPersona persona = await _consultarPersonaServidor(
        request: request,
      );
      if (isClosed) {
        return false;
      }
      final bool consultaRecuperadaPorTimeout =
          _ultimaConsultaPersonaRecuperadaPorTimeout;
      consultaRepetida = persona.consultaRepetida;
      final bool consultaRepetidaReal =
          persona.consultaRepetida && !consultaRecuperadaPorTimeout;
      if (push != null && consultaPush != null) {
        push.consultasPersona.finalizar(
          consultaPush,
          consultaRepetida: persona.consultaRepetida,
          idHdrEventoResum: persona.idHdrEventoResum,
        );
        pushFinalizado = true;
      }
      FocusManager.instance.primaryFocus?.unfocus();
      /*
     * Debemos tener el registro persistido.
     */
      if (persona.idHdrEventoResum <= 0) {
        mensajeErrorConsulta =
        'El servidor respondió la consulta, pero no devolvió '
            'el identificador del registro realizado.';
        return false;
      }
      if (consultaRepetidaReal) {
        final String rol = esConductor ? 'CONDUCTOR' : 'OCUPANTE';
        debugPrint('==========================================');
        debugPrint('$rol YA CONSULTADO - BLOQUEADO');
        debugPrint('DOCUMENTO: $documentoNormalizado');
        debugPrint('OPERATIVO: ${idHdrEventoActual.value}');
        debugPrint('ID HDR EVENTO RESUM: ${persona.idHdrEventoResum}');
        debugPrint('SE DEBE CONSULTAR OTRO DOCUMENTO');
        debugPrint('==========================================');
        controllerCedulaVehiculo.clear();
        _registrarDocumentoConsultadoOperativo(documentoNormalizado);
        mensajeErrorConsulta = esConductor
            ? 'La persona ya fue consultada dentro de este operativo. Realice la consulta del conductor con otro documento.'
            : 'La persona ya fue consultada dentro de este operativo. Realice la consulta del ocupante con otro documento.';
        return false;
      }
      if (persona.consultaRepetida && consultaRecuperadaPorTimeout) {
        debugPrint(
          '${esConductor ? 'CONDUCTOR' : 'OCUPANTE'} RECUPERADO POR TIMEOUT - NO SE BLOQUEA',
        );
      }
      /*
     * Validación local nuevamente por seguridad.
     *
     * Esto protege contra dos respuestas concurrentes
     * después de aplicar la validación restrictiva del servidor.
     */
      if (documentosPersonasVehiculoRegistradas.contains(
        documentoNormalizado,
      )) {
        debugPrint('PERSONA YA INCORPORADA LOCALMENTE DURANTE LA CONSULTA');
        return true;
      }
      /*
     * ============================================================
     * MOSTRAR SIEMPRE LOS DATOS
     * ============================================================
     */
      if (esConductor) {
        dataPersona_conductor.assignAll(<DataConsultaPersona>[persona]);
        documentoConductorVehiculo = documentoNormalizado;
      } else {
        dataPersona_ocupantes.add(persona);
        documentosOcupantesVehiculo.add(documentoNormalizado);
      }
      documentosPersonasVehiculoRegistradas.add(documentoNormalizado);
      _registrarDocumentoConsultadoOperativo(documentoNormalizado);
      idHdrEventoResumPersona = persona.idHdrEventoResum;
      controllerCedulaVehiculo.clear();
      /*
     * Una vez registrado conductor,
     * pasar automáticamente a ocupante.
     */
      if (esConductor) {
        tipoPersonaVehiculo.value = 'OCUPANTE';
      }
      /*
     * ORDEN DE CAPTURA
     *
     * Se procesa únicamente cuando la consulta puede continuar.
     * Una repetición real de conductor/ocupante se bloquea antes.
     */
      final bool tieneBoleta = await _procesarOrdenCapturaPersona(
        persona: persona,
        documento: cedula,
        actualizarConsultaPrincipal: false,
        origen: esConductor ? 'CONDUCTOR' : 'OCUPANTE',
      );
      if (tieneBoleta) {
        debugPrint('==========================================');
        debugPrint('ALERTA PERSONA RELACIONADA AL VEHÍCULO');
        debugPrint('OPERATIVO: ${idHdrEventoActual.value}');
        debugPrint(
          'VEHÍCULO: '
              '${dataVehiculo.first.datosVehiculo.data.placa}',
        );
        debugPrint('DOCUMENTO: $cedula');
        debugPrint('TIPO: ${esConductor ? 'CONDUCTOR' : 'OCUPANTE'}');
        debugPrint('CONSULTA REPETIDA: ${persona.consultaRepetida}');
        debugPrint('ORDEN CAPTURA: SI');
        debugPrint('==========================================');
      }
      variableResultadoPersonaVehiculoSeleccionada.value =
          variableDefaultPersona;
      mensajeErrorConsulta = '';
      debugPrint('==========================================');
      if (persona.consultaRepetida) {
        debugPrint('PERSONA RELACIONADA RECUPERADA CORRECTAMENTE');
      } else {
        debugPrint('PERSONA RELACIONADA REGISTRADA CORRECTAMENTE');
      }
      debugPrint('DOCUMENTO: $documentoNormalizado');
      debugPrint('ID HDR EVENTO RESUM: ${persona.idHdrEventoResum}');
      debugPrint('CONDUCTOR: ${dataPersona_conductor.length}');
      debugPrint('OCUPANTES: ${dataPersona_ocupantes.length}');
      debugPrint('CONSULTA REPETIDA: ${persona.consultaRepetida}');
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
      debugPrint('$e');
      debugPrint('$stackTrace');
      debugPrint('==========================================');
      return false;
    } finally {
      /*
     * Evitamos finalizar dos veces el control PUSH.
     */
      if (!pushFinalizado && push != null && consultaPush != null)
        push.consultasPersona.finalizar(consultaPush);
      consultandoPersonaVehiculo.value = false;
      peticionServerState.value = false;
      paginaPersonasVehiculoLoading.value = false;
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
    conductorRegistradoEnBaseDeDatos.value = false;
    conductorDesdeBase.value = null;
    tipoPersonaVehiculo.value = 'CONDUCTOR';
    idHdrEventoResumPersona = 0;
    variableResultadoPersonaVehiculoSeleccionada.value = variableDefaultPersona;
  }

  // ============================================================
  // COMPATIBILIDAD PANEL ANTERIOR
  // ============================================================
  void abrirRegistroOcupantes() async {
    if (peticionServerState.value || dataVehiculo.isEmpty) {
      return;
    }
    if (idHdrEventoResumVehiculo <= 0) {
      mensajeErrorConsulta = 'El vehículo no posee un idHdrEventoResum válido para relacionar personas.';
      return;
    }
    await consultarExistenciaConductor();
    mostrarPanelOcupantes.value = true;
    controllerCedulaVehiculo.clear();
  }

  Future<bool> _sincronizarConductorVehiculoServidor({
    required String placa,
    bool registrarError = false,
  }) async {
    final String placaNormalizada = placa.trim().toUpperCase();
    if (placaNormalizada.isEmpty || idHdrEventoActual.value <= 0) {
      conductorRegistradoEnBaseDeDatos.value = false;
      conductorDesdeBase.value = null;
      tipoPersonaVehiculo.value = 'CONDUCTOR';
      if (registrarError)
        mensajeErrorConsulta = placaNormalizada.isEmpty
            ? 'No fue posible determinar la placa del vehículo.'
            : 'No existe un operativo válido para verificar el conductor.';
      return false;
    }
    try {
      final ConductorVehiculo? resultado = await siipneMovilUseCase
          .getDatosConductorVehiculo(
        request: ConductorVehiculoRequest(
          idHdrEvento: idHdrEventoActual.value,
          placa: placaNormalizada,
        ),
      );
      if (isClosed) return false;
      if (resultado == null ||
          resultado.cedula.trim().isEmpty ||
          resultado.cedula.trim() == '0') {
        conductorRegistradoEnBaseDeDatos.value = false;
        conductorDesdeBase.value = null;
        tipoPersonaVehiculo.value = 'CONDUCTOR';
        debugPrint('CONDUCTOR SERVIDOR [$placaNormalizada]: NO REGISTRADO');
        return false;
      }
      conductorRegistradoEnBaseDeDatos.value = true;
      conductorDesdeBase.value = resultado;
      tipoPersonaVehiculo.value = 'OCUPANTE';
      final String documento = normalizarDocumentoPersonaVehiculo(
        resultado.cedula,
      );
      if (documento.isNotEmpty) {
        documentoConductorVehiculo = documento;
        documentosPersonasVehiculoRegistradas.add(documento);
        _registrarDocumentoConsultadoOperativo(documento);
      }
      debugPrint('==========================================');
      debugPrint('CONDUCTOR RECUPERADO DESDE SERVIDOR');
      debugPrint('OPERATIVO: ${idHdrEventoActual.value}');
      debugPrint('PLACA: $placaNormalizada');
      debugPrint('DOCUMENTO: ${resultado.cedula}');
      debugPrint('CONDUCTOR: ${resultado.conductor}');
      debugPrint('==========================================');
      return true;
    } catch (e, stackTrace) {
      conductorRegistradoEnBaseDeDatos.value = false;
      conductorDesdeBase.value = null;
      tipoPersonaVehiculo.value = 'CONDUCTOR';
      if (registrarError) mensajeErrorConsulta = 'No fue posible verificar el conductor del vehículo. Intente nuevamente.';
      debugPrint('ERROR CONSULTANDO CONDUCTOR [$placaNormalizada]: $e');
      debugPrint('$stackTrace');
      return false;
    }
  }

  Future<bool> consultarExistenciaConductor() async {
    if (dataVehiculo.isEmpty) {
      mensajeErrorConsulta = 'No existe un vehículo consultado.';
      return false;
    }
    final String placa = dataVehiculo.first.datosVehiculo.data.placa
        .trim()
        .toUpperCase();
    if (placa.isEmpty) {
      mensajeErrorConsulta = 'No fue posible determinar la placa del vehículo.';
      return false;
    }
    peticionServerState.value = true;
    paginaPersonasVehiculoLoading.value = true;
    mensajeErrorConsulta = '';
    try {
      return await _sincronizarConductorVehiculoServidor(
        placa: placa,
        registrarError: true,
      );
    } finally {
      peticionServerState.value = false;
      paginaPersonasVehiculoLoading.value = false;
    }
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
        mensajeErrorFinalizar = 'El operativo confirmado por el servidor no corresponde al operativo actual.';
        return false;
      }
      // No convertir un fallo push en fallo de finalización ya confirmada.
      if (_pushOperativoActivado) {
        OperativoPushService.instance.salirOperativo();
        _pushOperativoActivado = false;
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
    controllerCedulaVehiculo.clear();
    paginaPersonasVehiculoLoading.value = false;
    tipoPersonaVehiculo.value = conductorRegistradoEnBaseDeDatos.value
        ? 'OCUPANTE'
        : 'CONDUCTOR';
    // La pantalla de conductor/ocupantes maneja su propia variable y nunca
    // debe modificar la selección pendiente del vehículo principal.
    variableResultadoPersonaVehiculoSeleccionada.value = variableDefaultPersona;
  }

  // ============================================================
  // CERRAR SESIÓN
  // ============================================================
  Future<void> cerrarSesionOperativo() async {
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
    if (_pushOperativoActivado) {
      await OperativoPushService.instance.salirOperativo();
      _pushOperativoActivado = false;
    }
    if (!isClosed) Get.offAllNamed(AppRoutes.SPLASH_APP);
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
        variableSeleccionada: variableResultadoPersonaSeleccionada.value,
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
        variableSeleccionada: variableResultadoVehiculoSeleccionada.value,
      );
    }
    /*
   * No hay ningún resultado pendiente.
   */
    return true;
  }

  void _mostrarAlertasVehiculo(DataVehiculo data) {
    final DatosConsultaDuplicadoOperativo duplicado =
        data.datosConsultaDuplicadoOperativo;
    final bool vehiculoDuplicado = duplicado.idHdrEvento > 0;
    final bool alertaMatricula = data.datospropietario.data.alertaMatricula;
    // Si no existe ninguna alerta, no mostrar nada.
    if (!vehiculoDuplicado && !alertaMatricula) return;
    final List<String> alertas = <String>[];
    // --------------------------------------------------
    // ALERTA: VEHÍCULO YA CONSULTADO
    // --------------------------------------------------
    if (vehiculoDuplicado) {
      final List<String> ubicacion = <String>[
        duplicado.zona.trim(),
        duplicado.subzona.trim(),
        duplicado.distrito.trim(),
        duplicado.circuito.trim(),
        duplicado.subcircuito.trim(),
      ].where((String valor) => valor.isNotEmpty).toList();
      final String placa = data.datosVehiculo.data.placa.trim();
      alertas.add(
        "VEHÍCULO CONSULTADO\n"
            "El vehículo${placa.isNotEmpty ? ' con placa $placa' : ''} "
            "ya fue consultado en otro operativo."
            "${ubicacion.isNotEmpty ? '\n\nUbicación registrada:\n${ubicacion.join(' · ')}' : ''}"
            "${duplicado.fecha.trim().isNotEmpty ? '\n\nFecha de consulta:\n${duplicado.fecha.trim()}' : ''}",
      );
    }
    // --------------------------------------------------
    // ALERTA: MATRÍCULA
    // --------------------------------------------------
    if (alertaMatricula) {
      alertas.add(
        "ADVERTENCIA DE MATRÍCULA\n"
            "${data.datospropietario.data.mensajeMatricula}",
      );
    }
    // --------------------------------------------------
    // MOSTRAR UNA SOLA ALERTA
    // --------------------------------------------------
    DialogosAwesome.getWarning(
      title: "ADVERTENCIAS DEL VEHÍCULO",
      descripcion: alertas.join("\n\n────────────────────\n\n"),
    );
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
      documento = persona.dataSiipne.datosSiipne.documento.trim();
    }
    // ============================================================
    // DINARDAP COMO RESPALDO
    // ============================================================
    if (documento.isEmpty) {
      final dynamic dinardap = persona.dataDinardap.datosDinardap;
      if (dinardap != null) {
        try {
          documento = (dinardap.cedula ?? '').toString().trim();
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
    peticionServerState.value = true;
    paginaPersonasVehiculoLoading.value = true;
    try {
      debugPrint('==========================================');
      debugPrint('CONSULTANDO ANTECEDENTES');
      debugPrint('DOCUMENTO: $documento');
      debugPrint(
        'ORIGEN: ${personaConsulta != null ? 'PERSONA VEHÍCULO' : 'CONSULTA PRINCIPAL'}',
      );
      debugPrint('==========================================');
      final DataAntecedentes resultado = await siipneMovilUseCase
          .getDatosAntecedentes(
        request: AntecedentesRequest(documento: documento),
      );
      datosAntecedentesPersona.value = resultado;
      debugPrint('==========================================');
      debugPrint('ANTECEDENTES CONSULTADOS');
      debugPrint('CANTIDAD: ${resultado.antecedentes.length}');
      debugPrint('==========================================');
      return true;
    } catch (e, stackTrace) {
      datosAntecedentesPersona.value = null;
      mensajeErrorAntecedentesPersona = UrlApiProviderAppCenso.mensajeException(
        e,
        fallback: 'No fue posible consultar los antecedentes de la persona.',
      );
      debugPrint('==========================================');
      debugPrint('ERROR CONSULTANDO ANTECEDENTES');
      debugPrint(mensajeErrorAntecedentesPersona);
      debugPrint('$stackTrace');
      debugPrint('==========================================');
      return false;
    } finally {
      consultandoAntecedentesPersona.value = false;
      peticionServerState.value = false;
      paginaPersonasVehiculoLoading.value = false;
    }
  }

  // ============================================================
  // CLOSE
  // ============================================================
  @override
  void onClose() {
    if (_pushOperativoActivado) {
      final OperativoPushService push = OperativoPushService.instance;
      push.estado.removeListener(_estadoPushActualizado);
      push.alertaCritica.removeListener(_alertaPushActualizada);
      push.aperturaPendiente.removeListener(_alertaPushActualizada);
    }
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    controllerCedula.dispose();
    controllerPlaca.dispose();
    controllerCedulaVehiculo.dispose();
    controllerClaveFinalizar.dispose();
    super.onClose();
  }

  // ============================================================
  // BIOMETRÍA
  // ============================================================
  Future<bool> biometriaConfiguradaEnApp() async {
    try {
      return await loginController.biometriaConfiguradaEnApp();
    } catch (e) {
      debugPrint('[CIERRE BIOMETRIA] Error verificando configuración: $e');
      return false;
    }
  }

  Future<bool> autenticarBiometriaFinalizar() async {
    if (autenticandoBiometria.value) return false;
    // 1. La biometría debe estar habilitada DENTRO de SIIPNE Móvil.
    final bool configuradaApp = await biometriaConfiguradaEnApp();
    if (!configuradaApp) {
      debugPrint(
        '[CIERRE BIOMETRIA] No habilitada en preferencias de SIIPNE Móvil',
      );
      return false;
    }
    autenticandoBiometria.value = true;
    try {
      final LocalAuthentication auth = LocalAuthentication();
      // 2. Validar soporte del dispositivo.
      final bool soportado = await auth.isDeviceSupported();
      if (!soportado) {
        debugPrint('[CIERRE BIOMETRIA] Dispositivo sin soporte biométrico');
        return false;
      }
      // 3. Validar disponibilidad biométrica.
      final bool disponible = await auth.canCheckBiometrics;
      if (!disponible) {
        debugPrint('[CIERRE BIOMETRIA] Biometría no disponible');
        return false;
      }
      // 4. Verificar que exista biometría registrada.
      final List<BiometricType> biometricos = await auth
          .getAvailableBiometrics();
      if (biometricos.isEmpty) {
        debugPrint('[CIERRE BIOMETRIA] No existen biométricos registrados');
        return false;
      }
      debugPrint('==========================================');
      debugPrint('AUTENTICACIÓN BIOMÉTRICA PARA CIERRE');
      debugPrint('CONFIGURADA EN APP: SI');
      debugPrint('DISPOSITIVO SOPORTADO: SI');
      debugPrint('BIOMÉTRICOS: $biometricos');
      debugPrint('OPERATIVO: ${idHdrEventoActual.value}');
      debugPrint('==========================================');
      final bool autenticado = await auth.authenticate(
        localizedReason:
        'Confirme su identidad para finalizar el operativo '
            '${idHdrEventoActual.value}',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      if (!autenticado) {
        debugPrint('[CIERRE BIOMETRIA] Autenticación no completada');
        return false;
      }
      debugPrint('[CIERRE BIOMETRIA] Identidad confirmada correctamente');
      return true;
    } on LocalAuthException catch (e) {
      // Cancelar el diálogo biométrico NO es un error del sistema.
      if (e.code == LocalAuthExceptionCode.userCanceled) {
        debugPrint('[CIERRE BIOMETRIA] Autenticación cancelada por el usuario');
        return false;
      }
      debugPrint(
        '[CIERRE BIOMETRIA] LocalAuthException: '
            '${e.code} - ${e.description}',
      );
      return false;
    } catch (e, stackTrace) {
      debugPrint('[CIERRE BIOMETRIA] Error inesperado: $e');
      debugPrint('$stackTrace');
      return false;
    } finally {
      autenticandoBiometria.value = false;
    }
  }

  void _alertaPushActualizada() {
    if (isClosed) return;
    final OperativoPushService push = OperativoPushService.instance;
    final Map<String, dynamic>? data =
        push.alertaCritica.value ?? push.aperturaPendiente.value;
    if (data == null || data.isEmpty) return;
    final int idEvento =
        int.tryParse(data['idHdrEvento']?.toString() ?? '') ?? 0;
    if (idEvento <= 0 || idEvento != idHdrEventoActual.value) return;
    final String tipo = data['tipo']?.toString().trim().toUpperCase() ?? '';
    if (tipo != 'BOLETA' && tipo != 'VEHICULO_ROBADO') return;
    final String alertaId =
        data['_pushId']?.toString().trim() ??
            data['alertaId']?.toString().trim() ??
            '${idEvento}_${data['idHdrEventoResum']}_${tipo}';
    if (alertaId.isEmpty || _alertasPushMostradas.contains(alertaId)) {
      return;
    }
    _alertasPushMostradas.add(alertaId);
    if (_alertasPushMostradas.length > 100) {
      _alertasPushMostradas.remove(_alertasPushMostradas.first);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed) return;
      _colaDialogosPush = _colaDialogosPush
          .then((_) async {
        if (!await push.consultasPersona.permitirAlerta(data)) return;
        if (isClosed) return;
        await _mostrarDialogoAlertaPush(data);
      })
          .catchError((Object error, StackTrace stackTrace) {
        _alertasPushMostradas.remove(alertaId);
        debugPrint('[PUSH] Error mostrando diálogo: $error');
        debugPrintStack(stackTrace: stackTrace);
      });
      if (identical(push.alertaCritica.value, data)) {
        push.limpiarAlertaCritica();
      }
      if (identical(push.aperturaPendiente.value, data)) {
        push.limpiarAperturaPendiente();
      }
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  Future<void> _mostrarDialogoAlertaPush(Map<String, dynamic> data) async {
    final String tipo = data['tipo']?.toString().trim().toUpperCase() ?? '';
    final bool esVehiculo = tipo == 'VEHICULO_ROBADO';
    String valor(String key) => data[key]?.toString().trim() ?? '';
    final String mensaje = valor('_mensaje').isNotEmpty
        ? valor('_mensaje')
        : esVehiculo
        ? 'Se ha detectado un vehículo con alerta durante el operativo.'
        : 'Se ha detectado una persona con alerta durante el operativo.';
    final String placa = valor('placa').toUpperCase();
    final String cedula = valor('cedula');
    final String identificacion = esVehiculo ? placa : cedula;
    final String consultadoPor = valor('consultadoPor').isNotEmpty
        ? valor('consultadoPor')
        : valor('usuario');
    final String hora = valor('hora');
    final String titulo = esVehiculo ? 'VEHÍCULO ROBADO' : 'ORDEN DE CAPTURA';
    await Get.dialog(
      Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 440),
          decoration: BoxDecoration(
            color: const Color(0xFF07111F),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFD71920).withOpacity(.80),
              width: 1.2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: const Color(0xFFD71920).withOpacity(.28),
                blurRadius: 35,
                spreadRadius: 2,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(.55),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -80,
                right: -60,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        const Color(0xFFD71920).withOpacity(.22),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -80,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        const Color(0xFF005CA9).withOpacity(.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 5,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF700000),
                          Color(0xFFFF1E26),
                          Color(0xFFFF5252),
                          Color(0xFFFF1E26),
                          Color(0xFF700000),
                        ],
                      ),
                    ),
                  ),
                  // ============================================================
                  // CABECERA
                  // ============================================================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Color(0xFFFF3038),
                                Color(0xFFB00010),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(.18),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: const Color(0xFFFF1E26).withOpacity(.40),
                                blurRadius: 20,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            esVehiculo
                                ? Icons.directions_car_filled_rounded
                                : Icons.person_search_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  _chipAlertaPush(
                                    texto: 'ALERTA CRÍTICA',
                                    icono: Icons.warning_amber_rounded,
                                  ),
                                  const SizedBox(width: 7),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF162439),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(.08),
                                      ),
                                    ),
                                    child: const Text(
                                      'SIIPNE MÓVIL 2',
                                      style: TextStyle(
                                        color: Color(0xFF95A8C0),
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: .7,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 9),
                              Text(
                                titulo,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  height: 1.05,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: .2,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                esVehiculo
                                    ? 'ALERTA DETECTADA EN CONSULTA VEHICULAR'
                                    : 'ALERTA DETECTADA EN CONSULTA DE PERSONA',
                                style: const TextStyle(
                                  color: Color(0xFF8CA0B8),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: .8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Línea tipo escáner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.transparent,
                          const Color(0xFFFF1E26).withOpacity(.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // ============================================================
                  // MENSAJE PRINCIPAL
                  // ============================================================
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 15, 18, 8),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  const Color(0xFFD71920).withOpacity(.16),
                                  const Color(0xFF101D2E),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: const Color(0xFFD71920).withOpacity(.35),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD71920)
                                        .withOpacity(.18),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.notifications_active_rounded,
                                    color: Color(0xFFFF5252),
                                    size: 21,
                                  ),
                                ),
                                const SizedBox(width: 11),
                                Expanded(
                                  child: Text(
                                    mensaje,
                                    style: const TextStyle(
                                      color: Color(0xFFE9EEF5),
                                      fontSize: 13,
                                      height: 1.42,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (consultadoPor.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 9),
                            _datoAlertaPush(
                              icono: Icons.person_outline_rounded,
                              titulo: 'CONSULTADO POR',
                              valor: consultadoPor,
                              anchoCompleto: true,
                            ),
                          ],
                          if (hora.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 9),
                            _datoAlertaPush(
                              icono: Icons.access_time_rounded,
                              titulo: 'HORA DE LA ALERTA',
                              valor: hora,
                              anchoCompleto: true,
                            ),
                          ],
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D1928),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF24364C),
                              ),
                            ),
                            child: const Row(
                              children: <Widget>[
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Color(0xFF6EA7DA),
                                  size: 17,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Verifique la información y aplique el procedimiento institucional correspondiente.',
                                    style: TextStyle(
                                      color: Color(0xFFAFC0D2),
                                      fontSize: 10.5,
                                      height: 1.35,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ============================================================
                  // PIE / ACCIÓN
                  // ============================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF091421),
                      border: Border(
                        top: BorderSide(color: Colors.white.withOpacity(.06)),
                      ),
                    ),
                    child: SizedBox(
                      height: 47,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFFD71920),
                          foregroundColor: Colors.white,
                          shadowColor: const Color(0xFFD71920),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.verified_user_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'CONFIRMAR ALERTA',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: .7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.82),
    );
  }

  Widget _chipAlertaPush({required String texto, required IconData icono}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFD71920).withOpacity(.17),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFF3B43).withOpacity(.42)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icono, color: const Color(0xFFFF5258), size: 13),
          const SizedBox(width: 5),
          Text(
            texto,
            style: const TextStyle(
              color: Color(0xFFFF7A7E),
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              letterSpacing: .7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _datoAlertaPush({
    required IconData icono,
    required String titulo,
    required String valor,
    bool destacado = false,
    bool anchoCompleto = false,
  }) {
    return Container(
      width: anchoCompleto ? double.infinity : null,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFF101C2B),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: destacado
              ? const Color(0xFFD71920).withOpacity(.40)
              : const Color(0xFF25374B),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: destacado
                  ? const Color(0xFFD71920).withOpacity(.15)
                  : const Color(0xFF17283B),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icono,
              size: 18,
              color: destacado
                  ? const Color(0xFFFF4D55)
                  : const Color(0xFF78A9D4),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF778BA2),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  valor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: destacado
                        ? const Color(0xFFFF6B70)
                        : const Color(0xFFE6EDF5),
                    fontSize: destacado ? 14 : 12.5,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void limpiarSeleccionConsulta() {
    FocusManager.instance.primaryFocus?.unfocus();
    selectPerson.value = false;
    selectVehiculo.value = false;
    variableResultadoSeleccionada.value = null;
    consultaRepetida = false;
  }

  // ============================================================
  // SELECCIONAR PERSONA
  // ============================================================
  Future<void> seleccionarPersona() async {
    if (cargandoVariablesResultado.value ||
        peticionServerState.value ||
        actualizandoResultado.value ||
        isClosed)
      return;
    FocusManager.instance.primaryFocus?.unfocus();
    // ==========================================================
    // YA ESTAMOS EN PERSONA -> NUEVA CONSULTA PERSONA
    // ==========================================================
    if (selectPerson.value && dataPersona.isNotEmpty) {
      final bool continuar = await nuevaConsultaPersona();
      if (!continuar || isClosed) {
        _mostrarErrorCambioConsulta();
        return;
      }
    }
    // ==========================================================
    // VENIMOS DE VEHÍCULO -> VALIDAR VEHÍCULO ANTES DE CAMBIAR
    // ==========================================================
    if (selectVehiculo.value && dataVehiculo.isNotEmpty) {
      final bool continuar = await nuevaConsultaVehiculo();
      // nuevaConsultaVehiculo() valida conductor contra servidor.
      // Si NO existe conductor, NO se permite cambiar a PERSONA.
      if (!continuar || isClosed) {
        _mostrarErrorCambioConsulta();
        return;
      }
    }
    if (isClosed) return;
    selectPerson.value = true;
    selectVehiculo.value = false;
    final VariablesResultado? variable =
        variableResultadoPersonaSeleccionada.value ?? variableDefaultPersona;
    variableResultadoPersonaSeleccionada.value = variable;
    variableResultadoSeleccionada.value = variable;
  }

  // ============================================================
  // SELECCIONAR VEHÍCULO
  // ============================================================
  Future<void> seleccionarVehiculo() async {
    if (cargandoVariablesResultado.value ||
        peticionServerState.value ||
        actualizandoResultado.value ||
        isClosed)
      return;
    FocusManager.instance.primaryFocus?.unfocus();
    // ==========================================================
    // VENIMOS DE PERSONA -> GUARDAR RESULTADO ANTES DE CAMBIAR
    // ==========================================================
    if (selectPerson.value && dataPersona.isNotEmpty) {
      final bool continuar = await nuevaConsultaPersona();
      if (!continuar || isClosed) {
        _mostrarErrorCambioConsulta();
        return;
      }
    }
    // ==========================================================
    // YA ESTAMOS EN VEHÍCULO -> NUEVA CONSULTA VEHÍCULO
    // ==========================================================
    if (selectVehiculo.value && dataVehiculo.isNotEmpty) {
      final bool continuar = await nuevaConsultaVehiculo();
      // También valida conductor antes de permitir otro vehículo.
      if (!continuar || isClosed) {
        _mostrarErrorCambioConsulta();
        return;
      }
    }
    if (isClosed) return;
    selectPerson.value = false;
    selectVehiculo.value = true;
    final VariablesResultado? variable =
        variableResultadoVehiculoSeleccionada.value ?? variableDefaultVehiculo;
    variableResultadoVehiculoSeleccionada.value = variable;
    variableResultadoSeleccionada.value = variable;
  }

  // ============================================================
  // MOSTRAR ERROR AL CAMBIAR TIPO DE CONSULTA
  // ============================================================
  void _mostrarErrorCambioConsulta() {
    if (isClosed) return;
    final String mensaje = mensajeErrorConsulta.trim().isNotEmpty
        ? mensajeErrorConsulta.trim()
        : mensajeErrorActualizaResultado.trim().isNotEmpty
        ? mensajeErrorActualizaResultado.trim()
        : 'No fue posible continuar con la nueva consulta. Verifique la información registrada.';
    DialogosAwesome.getWarning(
      title: "NO ES POSIBLE CONTINUAR",
      descripcion: mensaje,
    );
  }

  Future<bool> nuevaConsultaVehiculo() async {
    if (peticionServerState.value || actualizandoResultado.value || isClosed) {
      return false;
    }
    mensajeErrorConsulta = '';
    mensajeErrorActualizaResultado = '';
    FocusManager.instance.primaryFocus?.unfocus();
    if (dataVehiculo.isEmpty) {
      mensajeErrorConsulta = 'No existe un vehículo consultado.';
      return false;
    }
    final String placa = dataVehiculo.first.datosVehiculo.data.placa
        .trim()
        .toUpperCase();
    debugPrint('==========================================');
    debugPrint('VALIDANDO VEHÍCULO ANTES DE CONTINUAR');
    debugPrint('PLACA: $placa');
    debugPrint('MÓDULO: ${nombreModuloActual.value}');
    debugPrint(
      'CONDUCTOR OBLIGATORIO: ${requiereConductorObligatorio ? 'SI' : 'NO'}',
    );
    debugPrint('==========================================');
    // ==========================================================
    // CONDUCTOR OBLIGATORIO SOLO EN OPERATIVOS PREVENTIVOS
    // ==========================================================
    if (requiereConductorObligatorio) {
      final bool tieneConductor = await consultarExistenciaConductor();
      debugPrint('==========================================');
      debugPrint('RESULTADO VALIDACIÓN CONDUCTOR');
      debugPrint('PLACA: $placa');
      debugPrint('TIENE CONDUCTOR: $tieneConductor');
      debugPrint('==========================================');
      if (!tieneConductor) {
        if (mensajeErrorConsulta.trim().isEmpty) {
          mensajeErrorConsulta = placa.isEmpty
              ? 'Debe registrar un conductor antes de realizar una nueva consulta.'
              : 'El vehículo $placa no tiene un conductor registrado. '
              'Debe registrar un conductor antes de realizar una nueva consulta.';
        }
        debugPrint('CAMBIO BLOQUEADO: OPERATIVO PREVENTIVO SIN CONDUCTOR');
        return false;
      }
    } else {
      // Para Tránsito, Metro, Migración y cualquier otro módulo el conductor
      // puede registrarse, pero NO constituye un requisito para continuar.
      mensajeErrorConsulta = '';
      debugPrint('VALIDACIÓN DE CONDUCTOR OMITIDA: MÓDULO NO PREVENTIVO');
    }
    // ==========================================================
    // GUARDAR RESULTADO PRELIMINAR DEL VEHÍCULO
    // ==========================================================
    if (idHdrEventoResumVehiculo > 0) {
      final bool actualizado = await actualizarResultadoRegistro(
        idHdrEventoResum: idHdrEventoResumVehiculo,
        idVariableOriginal: idVariableInsertadaVehiculo,
        variableSeleccionada: variableResultadoVehiculoSeleccionada.value,
      );
      if (!actualizado) {
        if (mensajeErrorActualizaResultado.trim().isEmpty) {
          mensajeErrorActualizaResultado =
          'No fue posible guardar el resultado del vehículo consultado.';
        }
        return false;
      }
    }
    // ==========================================================
    // LIMPIAR VEHÍCULO ACTUAL
    // ==========================================================
    controllerPlaca.clear();
    dataVehiculo.clear();
    idVariableInsertadaVehiculo = 0;
    vehiculoRobado.value = false;
    ocultarBtnBuscarVehiculo.value = false;
    placaConsultadaAnterior = placaConsultada;
    placaConsultada = '';
    _limpiarPersonasVehiculo();
    conductorRegistradoEnBaseDeDatos.value = false;
    conductorDesdeBase.value = null;
    variableResultadoVehiculoSeleccionada.value = variableDefaultVehiculo;
    variableResultadoPersonaVehiculoSeleccionada.value = variableDefaultPersona;
    limpiarSeleccionConsulta();
    return true;
  }

  Future<void> consultarLicencia(DataConsultaPersona data) async {
    peticionServerState(true);
    try {
      await ExceptionDialogos.manejarErroresShowDialogo(
        showMsjNodata: false,
            () async {
          final GetLicenciaRequest request = GetLicenciaRequest(
            documento: data.dataSiipne.datosSiipne.documento,
          );
          final DatosAnt respuesta = await siipneMovilUseCase.getLicencia(
            request: request,
          );
          data.datosAnt = respuesta;
        },
      );
    } finally {
      peticionServerState(false);
    }
  }

  bool _esTimeoutConsulta(Object error) {
    final String mensaje = error.toString().toLowerCase();
    return mensaje.contains('timeout') ||
        mensaje.contains('timed out') ||
        mensaje.contains('timeoutexception') ||
        mensaje.contains('connection timeout') ||
        mensaje.contains('receive timeout') ||
        mensaje.contains('send timeout') ||
        mensaje.contains('connectiontimeout') ||
        mensaje.contains('receivetimeout') ||
        mensaje.contains('sendtimeout') ||
        mensaje.contains('tiempo de respuesta') ||
        mensaje.contains('tiempo agotado');
  }

  Future<DataConsultaPersona> _consultarPersonaServidor({
    required ConsultarPersonaRequest request,
  }) async {
    _ultimaConsultaPersonaRecuperadaPorTimeout = false;
    try {
      return await siipneMovilUseCase.consultarPersona(request: request);
    } catch (e, stackTrace) {
      if (!_esTimeoutConsulta(e)) {
        debugPrint('==========================================');
        debugPrint('ERROR CONSULTA PERSONA - NO ES TIMEOUT');
        debugPrint('$e');
        debugPrint('$stackTrace');
        debugPrint('==========================================');
        rethrow;
      }
      debugPrint('==========================================');
      debugPrint('TIMEOUT CONSULTA PERSONA');
      debugPrint(
        'La petición pudo haberse procesado correctamente en el servidor.',
      );
      debugPrint('Se realizará UNA recuperación automática.');
      debugPrint('==========================================');
      await Future.delayed(const Duration(milliseconds: 900));
      if (isClosed) {
        throw Exception('El controlador fue cerrado durante la recuperación.');
      }
      _ultimaConsultaPersonaRecuperadaPorTimeout = true;
      final DataConsultaPersona recuperada = await siipneMovilUseCase
          .consultarPersona(request: request);
      debugPrint('==========================================');
      debugPrint('CONSULTA PERSONA RECUPERADA');
      debugPrint('CONSULTA REPETIDA: ${recuperada.consultaRepetida}');
      debugPrint('RECUPERACIÓN TÉCNICA POR TIMEOUT: SI');
      debugPrint('ID HDR EVENTO RESUM: ${recuperada.idHdrEventoResum}');
      debugPrint('==========================================');
      return recuperada;
    }
  }

  Future<DataVehiculo> _consultarVehiculoServidor({
    required ConsultarVehiculoRequest request,
  }) async {
    try {
      return await siipneMovilUseCase.consultarVehiculo(request: request);
    } catch (e, stackTrace) {
      if (!_esTimeoutConsulta(e)) {
        debugPrint('==========================================');
        debugPrint('ERROR CONSULTA VEHÍCULO - NO ES TIMEOUT');
        debugPrint('$e');
        debugPrint('$stackTrace');
        debugPrint('==========================================');
        rethrow;
      }
      debugPrint('==========================================');
      debugPrint('TIMEOUT CONSULTA VEHÍCULO');
      debugPrint(
        'La petición pudo haberse procesado correctamente en el servidor.',
      );
      debugPrint('Se realizará UNA recuperación automática.');
      debugPrint('==========================================');
      await Future.delayed(const Duration(milliseconds: 900));
      if (isClosed) {
        throw Exception('El controlador fue cerrado durante la recuperación.');
      }
      final DataVehiculo recuperado = await siipneMovilUseCase
          .consultarVehiculo(request: request);
      debugPrint('==========================================');
      debugPrint('CONSULTA VEHÍCULO RECUPERADA');
      debugPrint('ID HDR EVENTO RESUM: ${recuperado.idHdrEventoResum}');
      debugPrint('DATOS VEHÍCULO: ${recuperado.datosVehiculo.success}');
      debugPrint('==========================================');
      return recuperado;
    }
  }

  Future<bool> _hayInternetPublico() async {
    if (_verificandoInternetPublico) {
      return internetPublicoDisponible.value;
    }
    _verificandoInternetPublico = true;
    try {
      debugPrint('==========================================');
      debugPrint('[INTERNET] VERIFICANDO INTERNET PÚBLICO');
      debugPrint('==========================================');
      final bool disponible = await InternetConnection().hasInternetAccess
          .timeout(const Duration(seconds: 3), onTimeout: () => false);
      internetPublicoDisponible.value = disponible;
      debugPrint('[INTERNET] INTERNET PÚBLICO: ${disponible ? 'SI' : 'NO'}');
      if (!disponible) {
        debugPrint(
          '[INTERNET] Puede existir acceso únicamente '
              'a los endpoints institucionales autorizados.',
        );
      }
      debugPrint('==========================================');
      return disponible;
    } catch (e, stackTrace) {
      internetPublicoDisponible.value = false;
      debugPrint('==========================================');
      debugPrint('[INTERNET] SIN ACCESO A INTERNET PÚBLICO');
      debugPrint('[INTERNET] $e');
      debugPrint('$stackTrace');
      debugPrint('==========================================');
      return false;
    } finally {
      _verificandoInternetPublico = false;
    }
  }

  void _mostrarAlertaConsultaRepetida({
    required String documento,
    required int idHdrEventoResum,
    String origen = 'PERSONA',
    bool restrictiva = false,
  }) {
    if (isClosed) return;
    final String documentoNormalizado = documento.trim().toUpperCase();
    final String tipo = origen.trim().toUpperCase();
    final String descripcionOrigen = tipo == 'CONDUCTOR'
        ? ' como conductor'
        : tipo == 'OCUPANTE'
        ? ' como ocupante'
        : '';
    debugPrint('==========================================');
    debugPrint(
      restrictiva
          ? 'ALERTA RESTRICTIVA - CONSULTA REPETIDA'
          : 'ALERTA CONSULTA REPETIDA',
    );
    debugPrint('DOCUMENTO: $documentoNormalizado');
    debugPrint('OPERATIVO: ${idHdrEventoActual.value}');
    debugPrint('ID HDR RESUM: $idHdrEventoResum');
    debugPrint('ORIGEN: $tipo');
    debugPrint('==========================================');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed) return;
      final String descripcion = restrictiva
          ? 'La persona con documento $documentoNormalizado$descripcionOrigen ya fue consultada anteriormente dentro de este mismo operativo.\n\nEsta consulta no puede continuar. Realice la consulta con otro documento.'
          : 'La persona con documento $documentoNormalizado$descripcionOrigen ya fue consultada anteriormente dentro de este mismo operativo. La vinculación continuará.';
      if (restrictiva) {
        DialogosAwesome.getError(
          title: 'PERSONA YA CONSULTADA',
          descripcion: descripcion,
        );
      } else {
        DialogosAwesome.getWarning(
          title: 'PERSONA CONSULTADA PREVIAMENTE',
          descripcion: descripcion,
        );
      }
    });
  }

  String _normalizarDocumentoAlerta(String documento) {
    return documento.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  }

  bool _resolverOrdenCapturaPersona({
    required DataConsultaPersona persona,
    required String documento,
  }) {
    final String documentoNormalizado = _normalizarDocumentoAlerta(documento);
    /*
   * ============================================================
   * RESPUESTA ACTUAL DEL SERVIDOR
   * ============================================================
   */
    final bool ordenServidor = persona.ordenCaptura.success;
    if (ordenServidor) {
      if (documentoNormalizado.isNotEmpty) {
        _documentosConOrdenCapturaConfirmada.add(documentoNormalizado);
      }
      debugPrint('==========================================');
      debugPrint('ORDEN DE CAPTURA CONFIRMADA POR SERVIDOR');
      debugPrint('DOCUMENTO: $documentoNormalizado');
      debugPrint('CONSULTA REPETIDA: ${persona.consultaRepetida}');
      debugPrint('ID HDR RESUM: ${persona.idHdrEventoResum}');
      debugPrint('==========================================');
      return true;
    }
    /*
   * ============================================================
   * PROTECCIÓN PARA CONSULTA REPETIDA
   * ============================================================
   *
   * Caso:
   *
   * 1. primera consulta:
   *    ordenCaptura.success = true
   *
   * 2. segunda consulta:
   *    consultaRepetida = true
   *    ordenCaptura.success = false
   *
   * Si durante ESTA sesión ya confirmamos que ese documento
   * tenía boleta, conservamos la alerta.
   */
    final bool alertaConfirmadaAnteriormente =
        documentoNormalizado.isNotEmpty &&
            _documentosConOrdenCapturaConfirmada.contains(documentoNormalizado);
    if (persona.consultaRepetida && alertaConfirmadaAnteriormente) {
      debugPrint('==========================================');
      debugPrint('ORDEN DE CAPTURA RECUPERADA LOCALMENTE');
      debugPrint('DOCUMENTO: $documentoNormalizado');
      debugPrint('CONSULTA REPETIDA: SI');
      debugPrint(
        'El servidor no devolvió ordenCaptura.success=true, '
            'pero este documento ya fue confirmado con boleta '
            'durante esta sesión.',
      );
      debugPrint('==========================================');
      return true;
    }
    debugPrint('==========================================');
    debugPrint('PERSONA SIN ORDEN DE CAPTURA');
    debugPrint('DOCUMENTO: $documentoNormalizado');
    debugPrint('CONSULTA REPETIDA: ${persona.consultaRepetida}');
    debugPrint('==========================================');
    return false;
  }

  Future<bool> _procesarOrdenCapturaPersona({
    required DataConsultaPersona persona,
    required String documento,
    bool actualizarConsultaPrincipal = true,
    String origen = 'PERSONA',
  }) async {
    final bool tieneBoleta = _resolverOrdenCapturaPersona(
      persona: persona,
      documento: documento,
    );
    /*
   * La variable tieneOrdenCaptura pertenece a la consulta
   * principal de persona.
   *
   * Para conductor/ocupante solamente reproducimos
   * la alerta sin alterar la consulta principal.
   */
    if (actualizarConsultaPrincipal) {
      tieneOrdenCaptura.value = tieneBoleta;
    }
    debugPrint('==========================================');
    debugPrint('RESULTADO VALIDACIÓN ALERTA');
    debugPrint('ORIGEN: $origen');
    debugPrint('DOCUMENTO: $documento');
    debugPrint('CONSULTA REPETIDA: ${persona.consultaRepetida}');
    debugPrint('ORDEN SERVIDOR: ${persona.ordenCaptura.success}');
    debugPrint('ORDEN EFECTIVA: $tieneBoleta');
    debugPrint('==========================================');
    if (!tieneBoleta) {
      return false;
    }
    /*
   * Reproducir alerta siempre:
   *
   * - consulta nueva
   * - consulta repetida
   * - recuperación después de timeout
   * - conductor
   * - ocupante
   */
    try {
      await UtilidadesUtil.playAudio(
        nameAudio: AppSiipneMovilImages.audio_Alerta,
      );
    } catch (e, stackTrace) {
      debugPrint('No fue posible reproducir audio de alerta: $e');
      debugPrint('$stackTrace');
    }
    return true;
  }
}
