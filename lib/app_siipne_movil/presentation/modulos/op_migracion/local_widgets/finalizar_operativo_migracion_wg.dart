part of '../../pages.dart';

mixin FinalizarOperativoMigracionViewMixin on OpMigracionPageBase {
  Future<void> mostrarFinalizarOperativo() async {
    if (!controller.puedeFinalizarOperativo.value ||
        controller.peticionServerState.value) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final bool resumenCargado =
    await controller.consultarResultadosOperativo();
    final ResultadosOperativo? resultado =
        controller.resultadosOperativo.value;

    if (!resumenCargado || resultado == null) {
      DialogosAwesome.getWarning(
        title: 'RESUMEN NO DISPONIBLE',
        descripcion: controller.mensajeErrorResultadosOperativo.isEmpty
            ? 'No fue posible cargar el resumen estadístico del operativo.'
            : controller.mensajeErrorResultadosOperativo,
      );
      return;
    }

    _mostrarResumenFinalMigracion(resultado);
  }

  void _mostrarValidacionFinalizacion() {
    if (!controller.puedeFinalizarOperativo.value ||
        controller.peticionServerState.value) {
      return;
    }

    controller.limpiarClaveFinalizar();
    final BuildContext? context = Get.context;
    if (context == null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xFF210408).withOpacity(.88),
      builder: (BuildContext dialogContext) => _MigracionDialog(
        icono: Icons.edgesensor_low_sharp,
        titulo: 'FINALIZAR OPERATIVO',
        subtitulo:
        'OPERATIVO N.° ${controller.idHdrEventoActual.value} · VALIDACIÓN DE IDENTIDAD',
        colorInicio: const Color(0xFFB42318),
        colorFin: const Color(0xFF78170F),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2F3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF0B8BE)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.gpp_bad_rounded, color: Color(0xFFB42318)),
                    SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Al finalizar se bloqueará el registro de nuevas consultas. Valide su identidad con la clave institucional o biometría.',
                        style: TextStyle(
                          color: Color(0xFF7A1821),
                          fontSize: 9.5,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD9E3ED)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFFFFE1E4),
                          child: Icon(
                            Icons.lock_outline_rounded,
                            color: _MigracionColors.rojo,
                            size: 17,
                          ),
                        ),
                        SizedBox(width: 7),
                        Text(
                          'CLAVE INSTITUCIONAL',
                          style: TextStyle(
                            color: _MigracionColors.texto,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Obx(
                          () => TextFormField(
                        controller: controller.controllerClaveFinalizar,
                        obscureText: controller.ocultarClaveFinalizar.value,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Ingrese su clave',
                          prefixIcon: const Icon(Icons.password_rounded),
                          suffixIcon: IconButton(
                            onPressed:
                            controller.cambiarVisibilidadClaveFinalizar,
                            icon: Icon(
                              controller.ocultarClaveFinalizar.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _validarClaveYConfirmar(dialogContext),
                        icon: const Icon(Icons.verified_user_rounded, size: 18),
                        label: const Text('VALIDAR CLAVE'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _MigracionColors.rojo,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _validarBiometriaYConfirmar(dialogContext),
                  child: Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFFFFE8EA), Color(0xFFFFF5F6)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE7A6AD)),
                    ),
                    child: const Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFFFFD7DB),
                          child: Icon(
                            Icons.fingerprint_rounded,
                            color: _MigracionColors.rojo,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'HUELLA / BIOMETRÍA',
                                style: TextStyle(
                                  color: _MigracionColors.rojo,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'Toque para validar rápidamente.',
                                style: TextStyle(
                                  color: _MigracionColors.textoSuave,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: _MigracionColors.rojo,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  controller.limpiarClaveFinalizar();
                  Navigator.of(dialogContext).pop();
                },
                icon: const Icon(Icons.close_rounded, size: 17),
                label: const Text('CANCELAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _validarClaveYConfirmar(BuildContext dialogContext) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (controller.controllerClaveFinalizar.text.trim().isEmpty) {
      DialogosAwesome.getWarning(
        title: 'CLAVE REQUERIDA',
        descripcion: 'Ingrese su clave institucional para continuar.',
      );
      return;
    }
    final bool valida = await controller.validarClaveFinalizar();
    if (!valida) {
      DialogosAwesome.getError(
        title: 'CLAVE INCORRECTA',
        descripcion: 'La clave ingresada no pudo ser validada.',
      );
      return;
    }
    if (Navigator.of(dialogContext).canPop()) {
      Navigator.of(dialogContext).pop();
    }
    confirmarFinalizacionDefinitiva();
  }

  Future<void> _validarBiometriaYConfirmar(
      BuildContext dialogContext,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final bool ok = await controller.autenticarBiometriaFinalizar();
    if (!ok) {
      DialogosAwesome.getError(
        title: 'AUTENTICACIÓN NO VALIDADA',
        descripcion:
        'No fue posible validar su identidad mediante biometría.',
      );
      return;
    }
    if (Navigator.of(dialogContext).canPop()) {
      Navigator.of(dialogContext).pop();
    }
    confirmarFinalizacionDefinitiva();
  }

  void confirmarFinalizacionDefinitiva() {
    DialogosAwesome.getWarningSiNo(
      title: 'CONFIRMAR FINALIZACIÓN',
      colorAccion: DialogosAwesome.colorError,
      iconoAccion: Icons.gpp_bad_rounded,
      codigoEstado: 'SIIPNE MIGRACIÓN // CIERRE DEFINITIVO',
      etiquetaDetalle: 'CONFIRMACIÓN DE ACCIÓN IRREVERSIBLE',
      descripcion:
      '¿Está seguro de finalizar el operativo migratorio N.° ${controller.idHdrEventoActual.value}?\n\n'
          'Una vez finalizado no podrá registrar nuevas consultas migratorias.',
      btnOkOnPress: () async {
        final bool ok = await controller.finalizarOperativo();
        if (!ok) {
          DialogosAwesome.getError(
            title: 'NO SE PUDO FINALIZAR',
            descripcion: controller.mensajeErrorFinalizar.isEmpty
                ? 'No fue posible finalizar el operativo migratorio.'
                : controller.mensajeErrorFinalizar,
          );
          return;
        }

        DialogosAwesome.getSucess(
          title: 'OPERATIVO FINALIZADO',
          descripcion:
          'El operativo migratorio N.° ${controller.idHdrEventoActual.value} '
              'fue finalizado correctamente.',
          btnOkOnPress: controller.volverMenu,
        );
      },
      btnCancelOnPress: () {},
    );
  }

  // ============================================================
  // RESUMEN PREVIO A LA FINALIZACIÓN DEL OPERATIVO DE MIGRACIÓN
  // ============================================================

  void _mostrarResumenFinalMigracion(ResultadosOperativo resultado) {
    final BuildContext? context = Get.context;
    if (context == null) return;

    final List<VariableResultadoOperativo> variables = resultado
        .variablesResultado
        .where((VariableResultadoOperativo item) => item.cantidad > 0)
        .toList(growable: false);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      barrierColor: const Color(0xFF041C33).withOpacity(.88),
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 12,
            ),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: 720,
                maxHeight: MediaQuery.sizeOf(dialogContext).height * .92,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FA),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color(0xFF39C985).withOpacity(.75),
                  width: 1.3,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(.30),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _cabeceraResumenMigracion(resultado),
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                        child: Column(
                          children: <Widget>[
                            _estadoRevisionMigracion(),
                            const SizedBox(height: 9),
                            _datosGeneralesResumenMigracion(resultado),
                            const SizedBox(height: 9),
                            _estadisticasResumenMigracion(resultado),
                            const SizedBox(height: 9),
                            _variablesResumenMigracion(variables),
                            const SizedBox(height: 9),
                            _ubicacionResumenMigracion(resultado),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  Navigator.of(dialogContext).pop();
                                  await Future<void>.delayed(
                                    const Duration(milliseconds: 120),
                                  );
                                  _mostrarValidacionFinalizacion();
                                },
                                icon: const Icon(
                                  Icons.lock_outline_rounded,
                                  size: 19,
                                ),
                                label: const Text(
                                  'CONTINUAR PARA FINALIZAR',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: .25,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB42318),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(50),
                                  elevation: 4,
                                  shadowColor: const Color(0xFFB42318),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton.icon(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  size: 18,
                                ),
                                label: const Text(
                                  'REGRESAR AL OPERATIVO',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _cabeceraResumenMigracion(ResultadosOperativo resultado) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 13),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF062B4D),
            Color(0xFF0A4776),
            Color(0xFF17633E),
          ],
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.13),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(.22)),
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              color: Color(0xFF7EF0B2),
              size: 30,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'SIIPNE MIGRACIÓN  //  REVISIÓN FINAL',
                  style: TextStyle(
                    color: Color(0xFFB9D7EA),
                    fontSize: 7.8,
                    letterSpacing: .65,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'RESUMEN DEL OPERATIVO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'N.° ${resultado.idHdrEvento}  ·  PREVIO A LA FINALIZACIÓN',
                  style: const TextStyle(
                    color: Color(0xFFD7E8F3),
                    fontSize: 8.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _estadoRevisionMigracion() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7EF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB5DEC7)),
      ),
      child: const Row(
        children: <Widget>[
          Icon(Icons.verified_rounded, color: Color(0xFF198754), size: 18),
          SizedBox(width: 7),
          Expanded(
            child: Text(
              'Revise los resultados registrados. Para cerrar el operativo deberá continuar y validar su identidad.',
              style: TextStyle(
                color: Color(0xFF286346),
                fontSize: 9.2,
                height: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _datosGeneralesResumenMigracion(ResultadosOperativo resultado) {
    final String nombre = resultado.descripcionOperativo.trim().isEmpty
        ? 'OPERATIVO MIGRATORIO'
        : resultado.descripcionOperativo.trim();

    return _seccionResumenMigracion(
      titulo: 'INFORMACIÓN DEL OPERATIVO',
      icono: Icons.badge_outlined,
      child: Column(
        children: <Widget>[
          _datoResumenMigracion('OPERATIVO', nombre),
          _datoResumenMigracion('APERTURA', resultado.fechaEvento),
          _datoResumenMigracion(
            'ESTADO',
            resultado.fechaFinalizacion.trim().isEmpty
                ? 'PENDIENTE DE FINALIZACIÓN'
                : 'FINALIZADO · ${resultado.fechaFinalizacion}',
            mostrarLinea: false,
          ),
        ],
      ),
    );
  }

  Widget _estadisticasResumenMigracion(ResultadosOperativo resultado) {
    return _seccionResumenMigracion(
      titulo: 'ESTADÍSTICAS MIGRATORIAS',
      icono: Icons.query_stats_rounded,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFF0B4E82), Color(0xFF1976B9)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: <Widget>[
                const Icon(Icons.search_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'TOTAL DE CONSULTAS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  resultado.totalConsultas.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: <Widget>[
              Expanded(
                child: _tarjetaEstadisticaMigracion(
                  titulo: 'EXTRANJEROS',
                  subtitulo: 'CONSULTADOS',
                  cantidad: resultado.totalPersonas,
                  icono: Icons.person_search_rounded,
                  color: const Color(0xFF195BA6),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _tarjetaEstadisticaMigracion(
                  titulo: 'ALERTAS',
                  subtitulo: resultado.totalAlertas > 0
                      ? 'CON NOVEDAD'
                      : 'SIN NOVEDAD',
                  cantidad: resultado.totalAlertas,
                  icono: resultado.totalAlertas > 0
                      ? Icons.report_problem_rounded
                      : Icons.verified_user_rounded,
                  color: resultado.totalAlertas > 0
                      ? const Color(0xFFB42318)
                      : const Color(0xFF198754),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tarjetaEstadisticaMigracion({
    required String titulo,
    required String subtitulo,
    required int cantidad,
    required IconData icono,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: color.withOpacity(.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(.25)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: color, size: 19),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  cantidad.toString(),
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF344C61),
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  subtitulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF7C8D9C),
                    fontSize: 6.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _variablesResumenMigracion(
      List<VariableResultadoOperativo> variables,
      ) {
    return _seccionResumenMigracion(
      titulo: 'RESULTADOS MIGRATORIOS CONSOLIDADOS',
      icono: Icons.assignment_turned_in_outlined,
      child: variables.isEmpty
          ? const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No se registraron variables de resultado durante el operativo.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF718292),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
          : Column(
        children: List<Widget>.generate(variables.length, (int index) {
          final VariableResultadoOperativo variable = variables[index];
          final String descripcion =
          variable.desHdrTipoResum.trim().isEmpty
              ? 'SIN DESCRIPCIÓN'
              : variable.desHdrTipoResum.trim().toUpperCase();

          return Container(
            margin: EdgeInsets.only(
              bottom: index == variables.length - 1 ? 0 : 6,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE0E8EF)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3EFF9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Color(0xFF195BA6),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF3E566B),
                      fontSize: 9,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Container(
                  constraints: const BoxConstraints(minWidth: 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F7EF),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    variable.cantidad.toString(),
                    style: const TextStyle(
                      color: Color(0xFF198754),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _ubicacionResumenMigracion(ResultadosOperativo resultado) {
    return _seccionResumenMigracion(
      titulo: 'UBICACIÓN OPERATIVA',
      icono: Icons.location_on_outlined,
      child: Column(
        children: <Widget>[
          _datoResumenMigracion(
            'ZONA / SUBZONA',
            '${resultado.zona} · ${resultado.subzona}',
          ),
          _datoResumenMigracion('DISTRITO', resultado.distrito),
          _datoResumenMigracion('CIRCUITO', resultado.circuito),
          _datoResumenMigracion(
            'SUBCIRCUITO',
            resultado.subcircuito,
            mostrarLinea: false,
          ),
        ],
      ),
    );
  }

  Widget _seccionResumenMigracion({
    required String titulo,
    required IconData icono,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD7E2EC)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0F0B3558),
            blurRadius: 9,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F0F8),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icono, color: const Color(0xFF195BA6), size: 17),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF344E64),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _datoResumenMigracion(
      String titulo,
      String valor, {
        bool mostrarLinea = true,
      }) {
    final String dato = valor.trim().isEmpty ? 'NO REGISTRADO' : valor.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: mostrarLinea
            ? const Border(bottom: BorderSide(color: Color(0xFFE8EDF2)))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 88,
            child: Text(
              titulo,
              style: const TextStyle(
                color: Color(0xFF718292),
                fontSize: 7.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              dato,
              style: const TextStyle(
                color: Color(0xFF3D5569),
                fontSize: 8.8,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}