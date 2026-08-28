part of '../controllers.dart';

class AcuerdoAppController extends GetxController {
  final LoginController loginController = Get.find<LoginController>();
  final SiipneMovilUseCase siipneMovilUseCase = Get.find<SiipneMovilUseCase>();

  late UserEntities user;

  final RxBool peticionServerState = false.obs;
  final RxBool acepta = false.obs;
  final RxBool puedeAceptar = false.obs;
  final RxBool procesandoAceptacion = false.obs;

  /// Mientras sea true AcuerdoAppPage NO debe mostrar el acuerdo.
  final RxBool verificandoAcuerdoInicial = true.obs;

  /// Evita que el finally habilite visualmente el acuerdo mientras
  /// estamos abandonando esta ruta.
  final RxBool redireccionando = false.obs;

  final ScrollController scrollController = ScrollController();

  String mensajeError = '';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _prefAcuerdo = 'siipne_movil_acuerdo_aceptado';
  static const String _prefIdAcuerdo = 'siipne_movil_id_acuerdo';

  final RxString textoAcuerdo =
      '''
Antes de ingresar al aplicativo SIIPNE Móvil, el usuario declara conocer y aceptar que el acceso, uso, consulta, registro, almacenamiento y tratamiento de la información contenida en este sistema se encuentra sujeto a la Constitución de la República del Ecuador, la Ley Orgánica de Protección de Datos Personales, su Reglamento General, la Ley de Comercio Electrónico, Firmas Electrónicas y Mensajes de Datos, el Código Orgánico Integral Penal, el Código Orgánico de las Entidades de Seguridad Ciudadana y Orden Público, y demás normativa legal e institucional vigente.

El aplicativo SIIPNE Móvil es de uso exclusivo para usuarios autorizados. La información consultada o registrada deberá utilizarse únicamente para fines institucionales, operativos, administrativos y legales relacionados con las competencias de la Policía Nacional del Ecuador.

El usuario declara conocer que toda información personal, institucional, operativa o reservada a la que acceda mediante este aplicativo debe ser tratada con estricta confidencialidad, responsabilidad, seguridad y reserva, quedando prohibida su divulgación, reproducción, alteración, captura, difusión, cesión o uso para fines particulares o no autorizados.

Asimismo, el usuario acepta que el sistema podrá registrar datos de acceso, fecha, hora, usuario, dispositivo, ubicación cuando corresponda, consultas realizadas y demás trazabilidad necesaria para fines de seguridad, control, auditoría, soporte técnico y cumplimiento normativo.

El uso indebido del aplicativo, la entrega de credenciales a terceros, el acceso no autorizado, la manipulación de información o la revelación ilegal de datos podrá generar responsabilidades administrativas, disciplinarias, civiles y penales, conforme a la normativa vigente.

Al seleccionar la opción "ACEPTO", declaro que he leído, comprendido y acepto las condiciones de uso del aplicativo SIIPNE Móvil, comprometiéndome a utilizarlo de manera legal, responsable, confidencial y exclusivamente para fines institucionales.
'''
          .obs;

  String get _keyAcuerdo => '${_prefAcuerdo}_${user.idGenPersona}';
  String get _keyIdAcuerdo => '${_prefIdAcuerdo}_${user.idGenPersona}';

  bool get puedeContinuar =>
      puedeAceptar.value && acepta.value && !procesandoAceptacion.value;

  @override
  void onInit() {
    super.onInit();

    user = loginController.user.value;

    debugPrint('==========================================');
    debugPrint('ACUERDO APP - ON INIT');
    debugPrint('ID PERSONA ACTUAL: ${user.idGenPersona}');
    debugPrint('ID USUARIO ACTUAL: ${user.idGenUsuario}');
    debugPrint('KEY ACUERDO: $_keyAcuerdo');
    debugPrint('KEY ID ACUERDO: $_keyIdAcuerdo');
    debugPrint('==========================================');

    _listenerScroll();

    verificarAcuerdoAceptado();
  }

  // ============================================================
  // VERIFICAR ACUERDO
  // ============================================================

  Future<void> verificarAcuerdoAceptado() async {

    if (redireccionando.value) return;

    verificandoAcuerdoInicial.value = true;
    mensajeError = '';

    bool debeMostrarAcuerdo = false;

    try {
      user = loginController.user.value;

      if (user.idGenPersona <= 0) {
        debugPrint('ACUERDO -> idGenPersona inválido: ${user.idGenPersona}');

        debeMostrarAcuerdo = true;
        return;
      }


      final String? valorAceptado = await _storage.read(key: _keyAcuerdo);
      final bool aceptado = valorAceptado == 'true';

      final String idAcuerdo =
          await _storage.read(key: _keyIdAcuerdo) ?? '';



      debugPrint('------------------------------------------');
      debugPrint('VERIFICACIÓN ACUERDO LOCAL');
      debugPrint('PERSONA: ${user.idGenPersona}');
      debugPrint('KEY: $_keyAcuerdo');
      debugPrint('ACEPTADO: $aceptado');
      debugPrint('ID ACUERDO: $idAcuerdo');
      debugPrint('------------------------------------------');

      if (aceptado && idAcuerdo.trim().isNotEmpty) {
        debugPrint('ACUERDO -> YA ACEPTADO PARA PERSONA ${user.idGenPersona}');

        /*
         * IMPORTANTE:
         * Desde este momento NO permitimos que AcuerdoAppPage
         * construya _pantallaAcuerdo().
         */
        redireccionando.value = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isClosed) return;

          debugPrint('ACUERDO -> REDIRECCIONANDO A MENU_APP');

          Get.offNamed(SiipneMovilRoutes.MENU_APP);
        });

        return;
      }

      debugPrint(
        'ACUERDO -> DEBE MOSTRAR ACUERDO PARA PERSONA ${user.idGenPersona}',
      );

      debeMostrarAcuerdo = true;
    } catch (e, stackTrace) {
      debugPrint('Error verificando acuerdo SIIPNE: $e');

      debugPrint('$stackTrace');

      /*
       * Ante un error real sí mostramos el acuerdo.
       */
      debeMostrarAcuerdo = true;
    } finally {
      /*
       * ESTE ERA EL PROBLEMA.
       *
       * Antes siempre se hacía:
       *
       * verificandoAcuerdoInicial.value=false;
       *
       * incluso cuando ya habíamos programado una navegación.
       *
       * Ahora solo habilitamos el acuerdo si realmente debe
       * permanecer en esta pantalla.
       */
      if (!isClosed && !redireccionando.value && debeMostrarAcuerdo) {
        verificandoAcuerdoInicial.value = false;
      }

      debugPrint(
        'ACUERDO -> VERIFICACIÓN FINALIZADA | '
        'redireccionando=${redireccionando.value} | '
        'mostrarAcuerdo=$debeMostrarAcuerdo',
      );
    }
  }

  // ============================================================
  // LISTENER SCROLL
  // ============================================================

  void _listenerScroll() {
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;
      if (puedeAceptar.value) return;

      final double max = scrollController.position.maxScrollExtent;

      final double actual = scrollController.position.pixels;

      if (max <= 0 || actual >= max - 20) {
        puedeAceptar.value = true;
      }
    });
  }

  // ============================================================
  // ACEPTACIÓN
  // ============================================================

  void cambiarAceptacion(bool? valor) {
    if (!puedeAceptar.value) return;
    if (procesandoAceptacion.value) return;

    acepta.value = valor ?? false;
  }

  // ============================================================
  // REGISTRAR ACUERDO
  // ============================================================

  Future<bool> registrarAcuerdo() async {
    if (procesandoAceptacion.value) return false;
    if (redireccionando.value) return false;

    mensajeError = '';

    if (!puedeAceptar.value) {
      mensajeError = 'Debe leer completamente las condiciones de uso.';
      return false;
    }

    if (!acepta.value) {
      mensajeError = 'Debe aceptar las condiciones para continuar.';
      return false;
    }

    user = loginController.user.value;

    if (user.idGenPersona <= 0) {
      mensajeError = 'No fue posible identificar al usuario actual.';
      return false;
    }

    try {
      procesandoAceptacion.value = true;
      peticionServerState.value = true;

      debugPrint('==========================================');
      debugPrint('REGISTRANDO ACUERDO SIIPNE');
      debugPrint('ID PERSONA: ${user.idGenPersona}');
      debugPrint('ID USUARIO: ${user.idGenUsuario}');
      debugPrint('KEY: $_keyAcuerdo');
      debugPrint('==========================================');

      final Acuerdo acuerdo = await siipneMovilUseCase.insertaAcuerdo(
        request: InsertAcuerdoSiipneRequest(
          idGenPersona: user.idGenPersona,
          pathDocumento: 'acuerdo_siipne_movil.pdf',
          ip: 'movil',
        ),
      );

      final String idAcuerdo = acuerdo.idDgoAcuerdoSiipneMovil.trim();

      debugPrint('ACUERDO -> ID RECIBIDO: $idAcuerdo');

      if (idAcuerdo.isEmpty) {
        mensajeError = 'El servidor no confirmó el registro del acuerdo.';
        return false;
      }

      final bool guardado = await _guardarAceptacionLocal(idAcuerdo: idAcuerdo);

      if (!guardado) {
        mensajeError =
            'El acuerdo fue registrado, pero no fue posible guardar la configuración local.';
        return false;
      }

      debugPrint(
        'ACUERDO -> REGISTRO COMPLETADO PARA PERSONA ${user.idGenPersona}',
      );

      /*
       * Igual que en la verificación:
       * bloqueamos la vista del acuerdo antes de navegar.
       */
      redireccionando.value = true;
      verificandoAcuerdoInicial.value = true;

      Get.offNamed(SiipneMovilRoutes.MENU_APP);

      return true;
    } catch (e, stackTrace) {
      debugPrint('Error registrando acuerdo SIIPNE: $e');

      debugPrint('$stackTrace');

      mensajeError =
          'No fue posible registrar la aceptación del acuerdo. Intente nuevamente.';

      return false;
    } finally {
      peticionServerState.value = false;
      procesandoAceptacion.value = false;
    }
  }

  // ============================================================
  // GUARDAR LOCAL
  // ============================================================

  Future<bool> _guardarAceptacionLocal({required String idAcuerdo}) async {
    try {
      if (user.idGenPersona <= 0) {
        debugPrint('No se puede guardar acuerdo: idGenPersona inválido.');
        return false;
      }

      if (idAcuerdo.trim().isEmpty) {
        debugPrint('No se puede guardar acuerdo: idAcuerdo vacío.');
        return false;
      }

      await _storage.write(
        key: _keyAcuerdo,
        value: 'true',
      );

      await _storage.write(
        key: _keyIdAcuerdo,
        value: idAcuerdo.trim(),
      );

      final bool guardadoAcuerdo =
          await _storage.read(key: _keyAcuerdo) == 'true';

      final bool guardadoId =
          (await _storage.read(key: _keyIdAcuerdo) ?? '').isNotEmpty;

      debugPrint('ACUERDO GUARDADO LOCALMENTE');
      debugPrint('PERSONA: ${user.idGenPersona}');
      debugPrint('KEY ACUERDO: $_keyAcuerdo');
      debugPrint('KEY ID: $_keyIdAcuerdo');
      debugPrint('ID ACUERDO: $idAcuerdo');
      debugPrint('BOOL GUARDADO: $guardadoAcuerdo');
      debugPrint('ID GUARDADO: $guardadoId');

      return guardadoAcuerdo && guardadoId;
    } catch (e, stackTrace) {
      debugPrint('Error guardando acuerdo en almacenamiento seguro: $e');
      debugPrint('$stackTrace');
      return false;
    }
  }

  // ============================================================
  // CONSULTAR ACUERDO LOCAL
  // ============================================================

  Future<bool> acuerdoAceptadoLocalmente() async {
    try {
      user = loginController.user.value;

      if (user.idGenPersona <= 0) return false;

      final String? valorAceptado = await _storage.read(key: _keyAcuerdo);
      final bool aceptado = valorAceptado == 'true';

      final String idAcuerdo =
          await _storage.read(key: _keyIdAcuerdo) ?? '';


      return aceptado && idAcuerdo.trim().isNotEmpty;
    } catch (e) {
      debugPrint('Error consultando acuerdo local: $e');

      return false;
    }
  }

  // ============================================================
  // OBTENER ID
  // ============================================================

  Future<String?> obtenerIdAcuerdoLocal() async {
    try {
      user = loginController.user.value;

      if (user.idGenPersona <= 0) return null;



      return await _storage.read(key: _keyIdAcuerdo);
    } catch (e) {
      debugPrint('Error obteniendo ID del acuerdo local: $e');

      return null;
    }
  }

  // ============================================================
  // ELIMINAR ACUERDO
  // ============================================================

  Future<void> eliminarAcuerdoLocal() async {
    try {
      user = loginController.user.value;

      if (user.idGenPersona <= 0) return;



      await _storage.delete(key: _keyAcuerdo);
      await _storage.delete(key: _keyIdAcuerdo);

      acepta.value = false;
      puedeAceptar.value = false;
      redireccionando.value = false;

      debugPrint('ACUERDO LOCAL ELIMINADO PARA PERSONA ${user.idGenPersona}');
    } catch (e) {
      debugPrint('Error eliminando acuerdo local: $e');
    }
  }

  // ============================================================
  // REVERIFICAR
  // ============================================================

  Future<void> verificarAcuerdoUsuarioActual() async {
    if (procesandoAceptacion.value) return;
    if (redireccionando.value) return;

    user = loginController.user.value;

    debugPrint('==========================================');
    debugPrint('REVERIFICANDO ACUERDO');
    debugPrint('PERSONA: ${user.idGenPersona}');
    debugPrint('USUARIO: ${user.idGenUsuario}');
    debugPrint('==========================================');

    acepta.value = false;
    puedeAceptar.value = false;
    verificandoAcuerdoInicial.value = true;

    await verificarAcuerdoAceptado();
  }

  // ============================================================
  // DEBUG
  // ============================================================

  Future<void> debugAcuerdoLocal() async {
    try {
      user = loginController.user.value;

      final bool aceptado =
          await _storage.read(key: _keyAcuerdo) == 'true';

      final String idAcuerdo =
          await _storage.read(key: _keyIdAcuerdo) ?? '';

      debugPrint('==========================================');
      debugPrint('DEBUG ACUERDO SIIPNE MÓVIL');
      debugPrint('PERSONA: ${user.idGenPersona}');
      debugPrint('USUARIO: ${user.idGenUsuario}');
      debugPrint('KEY ACUERDO: $_keyAcuerdo');
      debugPrint('KEY ID ACUERDO: $_keyIdAcuerdo');
      debugPrint('ACEPTADO: $aceptado');
      debugPrint('ID ACUERDO: $idAcuerdo');
      debugPrint('==========================================');
    } catch (e) {
      debugPrint('Error debug acuerdo local: $e');
    }
  }

  // ============================================================
  // CERRAR SESIÓN
  // ============================================================

  void cerrarSession() {
    if (procesandoAceptacion.value) return;
    if (redireccionando.value) return;

    Get.offAllNamed(AppRoutes.SPLASH_APP);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
