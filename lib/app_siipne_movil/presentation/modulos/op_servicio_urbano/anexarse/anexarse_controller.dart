part of '../../controllers.dart';

class AnexarseController extends GetxController {
  final LoginController loginController = Get.find<LoginController>();
  final SiipneMovilUseCase siipneMovilUseCase = Get.find<SiipneMovilUseCase>();

  late UserEntities user;

  final TextEditingController controllerOperativo = TextEditingController();

  final RxBool peticionServerState = false.obs;
  final RxBool operativoConsultado = false.obs;
  final RxBool operativoValido = false.obs;

  final Rxn<Anexarse> datosAnexarse = Rxn<Anexarse>();

  final RxString mensajeValidacion = ''.obs;

  @override
  void onInit() {
    super.onInit();

    user = loginController.user.value;

    /*
     * Permitimos opcionalmente recibir el número
     * de operativo desde otra pantalla.
     */
    final dynamic arguments = Get.arguments;

    if (arguments is Map) {
      final dynamic numero = arguments['numeroOperativo'];

      if (numero != null) {
        final String valor = numero.toString().trim();

        if (valor.isNotEmpty && valor != '0') {
          controllerOperativo.text = valor;
        }
      }
    }
  }

  // ============================================================
  // CONSULTAR OPERATIVO
  // ============================================================
  Future<bool> consultarOperativo({
    required GlobalKey<FormState> key,
  }) async {
    debugPrint('==========================================');
    debugPrint('ENTRÓ A consultarOperativo()');
    debugPrint(
      'CAMPO: "${controllerOperativo.text}"',
    );
    debugPrint('==========================================');

    if (peticionServerState.value) {
      debugPrint(
        'ANEXARSE -> CONSULTA BLOQUEADA: YA EXISTE PETICIÓN',
      );
      return false;
    }

    mensajeValidacion.value = '';

    final bool formularioValido =
        key.currentState?.validate() ?? false;

    debugPrint(
      'ANEXARSE -> FORMULARIO VÁLIDO: $formularioValido',
    );

    if (!formularioValido) {
      return false;
    }

    final String numeroTexto =
    controllerOperativo.text.trim();

    debugPrint(
      'ANEXARSE -> TEXTO OPERATIVO: $numeroTexto',
    );

    final int idHdrEvento =
        int.tryParse(numeroTexto) ?? 0;

    debugPrint(
      'ANEXARSE -> ID CONVERTIDO: $idHdrEvento',
    );

    if (idHdrEvento <= 0) {
      _limpiarResultado(
        limpiarCampo: false,
      );

      mensajeValidacion.value =
      'Ingrese un número de operativo válido.';

      return false;
    }

    _limpiarResultado(
      limpiarCampo: false,
    );

    peticionServerState.value = true;

    bool resultado = false;

    try {
      await ExceptionDialogos.manejarErroresShowDialogo(
        showMsjNodata: false,
            () async {
          final GetDatosAnexarseOperativoRequest request =
          GetDatosAnexarseOperativoRequest(
            idHdrEvento: idHdrEvento,
          );

          debugPrint('==========================================');
          debugPrint('ANEXARSE -> ENVIANDO REQUEST');
          debugPrint('ID HDR EVENTO: $idHdrEvento');

          /*
         * Si tu request tiene toJson(),
         * esto nos permitirá comprobar exactamente
         * qué se está enviando.
         */
          try {
            debugPrint(
              'REQUEST: ${request.toJson()}',
            );
          } catch (_) {}

          debugPrint('==========================================');

          final Anexarse respuesta =
          await siipneMovilUseCase.consultarAnexarse(
            request: request,
          );

          debugPrint('==========================================');
          debugPrint('ANEXARSE -> RESPUESTA RECIBIDA');
          debugPrint(
            'ID HDR EVENTO: ${respuesta.idHdrEvento}',
          );
          debugPrint(
            'ID TIPO OPERATIVO: ${respuesta.idTipoOperativo}',
          );
          debugPrint(
            'DESCRIPCIÓN: ${respuesta.descripcion}',
          );
          debugPrint(
            'ESTADO OPERATIVO: ${respuesta.estadoOperativo}',
          );
          debugPrint(
            'ESTADO POLICÍA: ${respuesta.estadoPolicia}',
          );
          debugPrint(
            'POLICÍA: ${respuesta.policia}',
          );
          debugPrint('==========================================');

          datosAnexarse.value = respuesta;
          operativoConsultado.value = true;

          resultado = _validarOperativo(
            respuesta,
          );

          operativoValido.value = resultado;

          debugPrint(
            'ANEXARSE -> OPERATIVO VÁLIDO: $resultado',
          );
        },
      );

      if (!operativoConsultado.value) {
        datosAnexarse.value = null;
        operativoValido.value = false;

        if (mensajeValidacion.value.isEmpty) {
          mensajeValidacion.value =
          'No fue posible verificar el operativo.';
        }

        debugPrint(
          'ANEXARSE -> NO SE OBTUVO RESPUESTA DE OPERATIVO',
        );

        return false;
      }

      return resultado;
    } catch (e, stackTrace) {
      debugPrint('==========================================');
      debugPrint('ERROR CONSULTANDO OPERATIVO PARA ANEXARSE');
      debugPrint('$e');
      debugPrint('$stackTrace');
      debugPrint('==========================================');

      _limpiarResultado(
        limpiarCampo: false,
      );

      mensajeValidacion.value =
      'No fue posible verificar el operativo.';

      return false;
    } finally {
      peticionServerState.value = false;

      debugPrint(
        'ANEXARSE -> FIN consultarOperativo()',
      );
    }
  }
  // ============================================================
  // VALIDAR OPERATIVO
  // ============================================================

  bool _validarOperativo(
      Anexarse data,
      ) {
    if (data.idHdrEvento <= 0) {
      mensajeValidacion.value =
      'El operativo consultado no es válido.';

      return false;
    }

    /*
     * Para entrar posteriormente a las variables
     * del operativo necesitamos conocer también
     * su idTipoOperativo.
     */
    if (data.idTipoOperativo <= 0) {
      mensajeValidacion.value =
      'El operativo no posee una configuración válida.';

      return false;
    }

    final String estadoOperativo =
    data.estadoOperativo
        .trim()
        .toUpperCase();

    /*
     * Bloqueamos únicamente estados claramente
     * cerrados/finalizados.
     */
    if (
    estadoOperativo.contains('FINALIZ') ||
        estadoOperativo.contains('CERRAD') ||
        estadoOperativo.contains('INACTIV') ||
        estadoOperativo.contains('CANCELAD')) {
      mensajeValidacion.value =
      data.estadoOperativo.trim().isEmpty
          ? 'El operativo no se encuentra disponible.'
          : 'El operativo se encuentra ${data.estadoOperativo}.';

      return false;
    }

    mensajeValidacion.value =
    'Operativo verificado correctamente.';

    return true;
  }

  // ============================================================
  // PUEDE ANEXARSE
  // ============================================================

  bool puedeAnexarse() {
    final Anexarse? data =
        datosAnexarse.value;

    if (!operativoConsultado.value) {
      return false;
    }

    if (!operativoValido.value) {
      return false;
    }

    if (data == null) {
      return false;
    }

    if (data.idHdrEvento <= 0) {
      return false;
    }

    if (data.idTipoOperativo <= 0) {
      return false;
    }

    return true;
  }

  // ============================================================
  // ANEXARSE Y CONTINUAR
  // ============================================================

  void continuarOperativo() {
    if (peticionServerState.value) {
      return;
    }

    final Anexarse? data =
        datosAnexarse.value;

    if (!puedeAnexarse() ||
        data == null) {
      DialogosAwesome.getWarning(
        title: 'OPERATIVO NO DISPONIBLE',
        descripcion:
        mensajeValidacion.value.isEmpty
            ? 'Primero verifique un operativo válido.'
            : mensajeValidacion.value,
      );

      return;
    }

    FocusManager.instance.primaryFocus
        ?.unfocus();

    debugPrint(
      '==========================================',
    );
    debugPrint(
      'ANEXARSE - CONTINUAR',
    );
    debugPrint(
      'ID HDR EVENTO: ${data.idHdrEvento}',
    );
    debugPrint(
      'ID TIPO OPERATIVO: ${data.idTipoOperativo}',
    );
    debugPrint(
      'DESCRIPCIÓN: ${data.descripcion}',
    );
    debugPrint(
      '==========================================',
    );

    /*
     * AQUÍ ESTÁ LA PARTE FUNDAMENTAL.
     *
     * Enviamos TODO el objeto Anexarse.
     *
     * OpServicioUrbanoController ya sabe interpretar:
     *
     * arguments['anexarse']
     */
    Get.offNamed(
      SiipneMovilRoutes.OPERATIVOS_SERVICIO_URBANO,
      arguments: {
        'tipoAcceso': 'ANEXARSE',

        'anexarse': data,

        'idHdrEvento':
        data.idHdrEvento,

        'idOperativo':
        data.idTipoOperativo,
      },
    );
  }

  // ============================================================
  // NUEVA CONSULTA
  // ============================================================

  void nuevaConsulta() {
    if (peticionServerState.value) {
      return;
    }

    FocusManager.instance.primaryFocus
        ?.unfocus();

    _limpiarResultado(
      limpiarCampo: true,
    );
  }

  // ============================================================
  // LIMPIAR RESULTADO
  // ============================================================

  void _limpiarResultado({
    bool limpiarCampo = false,
  }) {
    if (limpiarCampo) {
      controllerOperativo.clear();
    }

    datosAnexarse.value = null;
    operativoConsultado.value = false;
    operativoValido.value = false;
    mensajeValidacion.value = '';
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  void onClose() {
    controllerOperativo.dispose();
    super.onClose();
  }
}