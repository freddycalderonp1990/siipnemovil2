part of '../pages.dart';

class OpServicioUrbanoPage extends GetView<OpServicioUrbanoController> {
  OpServicioUrbanoPage({super.key});

  final GlobalKey<FormState> _keyPlaca = GlobalKey<FormState>();
  final GlobalKey<FormState> _keyCedula = GlobalKey<FormState>();
  final GlobalKey<FormState> _keyCedulaVehiculo = GlobalKey<FormState>();
  final GlobalKey<FormState> _keyFinalizar = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: WorkAreaPageSiipneMovilWidget(
        showGps: true,
        mostrarBtnAtras: false,
        contenidoExpandido: true,
        title: null,
        peticionServer: controller.peticionServerState,
        contenido: Obx(
          () => controller.datosOperativoValidos.value
              ? getContenido(context)
              : _operativoInvalido(),
        ),
      ),
    );
  }

  Widget getContenido(BuildContext context) {
    final double teclado = MediaQuery.of(context).viewInsets.bottom;

    return Obx(() {
      Widget resultado = _estadoInicial();

      if (controller.selectPerson.value) {
        resultado = getMuestraDatosPersona();
      } else if (controller.selectVehiculo.value) {
        resultado = getMuestraDatosVehiculo();
      }

      return ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(0, 0, 0, teclado + 25),
        children: [
          _cabeceraOperativo(),

          const SizedBox(height: 1),

          getTipoDeConsulta(),

          const SizedBox(height: 5),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: getBusquedaTipoOperativo(),
          ),

          const SizedBox(height: 6),

          resultado,

          const SizedBox(height: 15),
        ],
      );
    });
  }

  // ============================================================
  // VARIABLE RESULTADO
  // ============================================================

  Widget _comboVariableResultado() {
    return Obx(() {
      final bool cargando = controller.cargandoVariablesResultado.value;

      final List<VariablesResultado> variables =
          controller.variablesResultadoConsultaActual;

      final VariablesResultado? seleccionada =
          controller.variableResultadoSeleccionada.value;

      if (cargando) {
        return Container(
          width: double.infinity,
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FC),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFD8E3ED)),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.3,
                  color: Color(0xFF195BA6),
                ),
              ),

              SizedBox(width: 9),

              Expanded(
                child: Text(
                  "CARGANDO VARIABLES DEL OPERATIVO...",
                  style: TextStyle(
                    color: Color(0xFF687B8E),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      if (variables.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE7D29A)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Color(0xFFA97814),
                size: 18,
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Text(
                  controller.mensajeErrorVariables.isEmpty
                      ? "No existen variables configuradas para este operativo."
                      : controller.mensajeErrorVariables,
                  style: const TextStyle(
                    color: Color(0xFF795E25),
                    fontSize: 8.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              IconButton(
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
                onPressed: () {
                  controller.recargarVariablesResultado();
                },
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Color(0xFFA97814),
                  size: 19,
                ),
              ),
            ],
          ),
        );
      }

      VariablesResultado? valorActual;

      if (seleccionada != null &&
          variables.any(
            (VariablesResultado item) =>
                item.idVariable == seleccionada.idVariable,
          )) {
        valorActual = seleccionada;
      } else if (variables.isNotEmpty) {
        valorActual = variables.first;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 2, bottom: 5),
            child: Row(
              children: [
                Icon(
                  Icons.fact_check_outlined,
                  color: Color(0xFF195BA6),
                  size: 14,
                ),

                SizedBox(width: 5),

                Expanded(
                  child: Text(
                    "VARIABLE DE RESULTADO",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .35,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9FD),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: valorActual != null
                    ? const Color(0xFF8CB6DC)
                    : const Color(0xFFC8D8E7),
                width: valorActual != null ? 1.3 : 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<VariablesResultado>(
                value: valorActual,
                isExpanded: true,
                borderRadius: BorderRadius.circular(14),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF195BA6),
                ),
                hint: const Text(
                  "Seleccione una variable",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF7B8B99),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                items: variables.map((VariablesResultado variable) {
                  return DropdownMenuItem<VariablesResultado>(
                    value: variable,
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5F0FA),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(
                            Icons.assignment_turned_in_outlined,
                            color: Color(0xFF195BA6),
                            size: 17,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                variable.desHdrTipoResum.trim().isEmpty
                                    ? "SIN DESCRIPCIÓN"
                                    : variable.desHdrTipoResum,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF29445D),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged:
                    controller.peticionServerState.value ||
                        controller.actualizandoResultado.value
                    ? null
                    : (VariablesResultado? value) {
                        controller.seleccionarVariableResultado(value);
                      },
              ),
            ),
          ),
        ],
      );
    });
  }

  // ============================================================
  // RESULTADO DE LA CONSULTA
  // ============================================================

  Widget _resultadoConsultaVariable() {
    return Obx(() {
      final VariablesResultado? variable =
          controller.variableResultadoSeleccionada.value;

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(5, 4, 5, 7),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFF9FC2E2), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF195BA6).withOpacity(.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F2FC),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.assignment_turned_in_outlined,
                    color: Color(0xFF195BA6),
                    size: 22,
                  ),
                ),

                const SizedBox(width: 9),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "RESULTADO DE LA CONSULTA",
                        style: TextStyle(
                          color: Color(0xFF29445D),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      SizedBox(height: 2),

                      Text(
                        "Seleccione la novedad o resultado correspondiente al registro consultado.",
                        style: TextStyle(
                          color: Color(0xFF758799),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 9),
            _comboVariableResultado(),
          ],
        ),
      );
    });
  }

  // ============================================================
  // CABECERA OPERATIVO
  // ============================================================

  Widget _cabeceraOperativo() {
    return Obx(() {
      final int idOperativo = controller.idHdrEventoActual.value;

      final bool puedeFinalizar = controller.puedeFinalizarOperativo.value;
      final String nombreOperativo = controller.nombreOperativoActual.value
          .trim();
      final bool anexado = controller.esOperativoAnexado.value;

      final bool pendiente = controller.esOperativoPendiente.value;

      final String tipo = pendiente
          ? "OPERATIVO PENDIENTE"
          : anexado
          ? "OPERATIVO ANEXADO"
          : "OPERATIVO EN EJECUCIÓN";

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(6, 4, 6, 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: const Color(0xFFD5E1EC)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D4C9C).withOpacity(.10),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(11, 10, 11, 9),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.14),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: Colors.white.withOpacity(.17),
                          ),
                        ),
                        child: const Icon(
                          Icons.local_police_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 9),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tipo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .35,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF64E39A),
                                    shape: BoxShape.circle,
                                  ),
                                ),

                                const SizedBox(width: 4),

                                const Text(
                                  "ACTIVO",
                                  style: TextStyle(
                                    color: Color(0xFFD8F8E5),
                                    fontSize: 7.2,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                const SizedBox(width: 9),

                                const Icon(
                                  Icons.security_rounded,
                                  color: Color(0xFFDCECFB),
                                  size: 12,
                                ),

                                const SizedBox(width: 3),

                                const Flexible(
                                  child: Text(
                                    "CONSULTAS AUDITADAS",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(0xFFDCECFB),
                                      fontSize: 6.8,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.13),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          anexado
                              ? "ANEXADO"
                              : pendiente
                              ? "RETOMADO"
                              : "APERTURADO",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 6.4,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.13),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: Colors.white.withOpacity(.18)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 33,
                          height: 33,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.numbers_rounded,
                            color: Color(0xFF195BA6),
                            size: 18,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "IDENTIFICADOR DEL OPERATIVO",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.72),
                                  fontSize: 6.4,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .4,
                                ),
                              ),

                              const SizedBox(height: 1),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    idOperativo.toString(),
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                    ),
                                  ),

                                  if (nombreOperativo.isNotEmpty) ...[
                                    const SizedBox(width: 6),

                                    Text(
                                      "·",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.65),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(width: 6),

                                    Expanded(
                                      child: Text(
                                        nombreOperativo.toUpperCase(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(.90),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: .25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF70E7A5),
                          size: 21,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: _botonCabeceraOperativo(
                      titulo: "PERSONAL",
                      icono: Icons.groups_2_rounded,
                      color: const Color(0xFF198754),
                      fondo: const Color(0xFFEAF7F0),
                      borde: const Color(0xFFB8DFC9),
                      onTap: controller.peticionServerState.value
                          ? null
                          : _mostrarPersonalOperativo,
                    ),
                  ),

                  if (puedeFinalizar) ...[
                    const SizedBox(width: 6),

                    Expanded(
                      child: _botonCabeceraOperativo(
                        titulo: "QR",
                        icono: Icons.qr_code_2_rounded,
                        color: const Color(0xFF195BA6),
                        fondo: const Color(0xFFEAF3FC),
                        borde: const Color(0xFFB6CFE5),
                        onTap: controller.peticionServerState.value
                            ? null
                            : _mostrarQrOperativo,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: _botonCabeceraOperativo(
                        titulo: "FINALIZAR",
                        icono: Icons.edgesensor_low_sharp,
                        color: const Color(0xFFB42318),
                        fondo: const Color(0xFFFFECE9),
                        borde: const Color(0xFFE9BBB7),
                        onTap: controller.peticionServerState.value
                            ? null
                            : _mostrarResumenAntesFinalizar,
                      ),
                    ),
                  ],

                  const SizedBox(width: 6),

                  Expanded(
                    child: _botonCabeceraOperativo(
                      titulo: "SALIR",
                      icono: Icons.logout_rounded,
                      color: const Color(0xFF586D82),
                      fondo: const Color(0xFFF3F6F9),
                      borde: const Color(0xFFD5DFE8),
                      onTap: controller.peticionServerState.value
                          ? null
                          : _confirmarCerrarSesion,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ============================================================
  // RESUMEN ANTES DE FINALIZAR
  // ============================================================
  Future<void> _mostrarResumenAntesFinalizar() async {
    if (controller.peticionServerState.value ||
        controller.actualizandoResultado.value ||
        controller.cargandoResultadosOperativo.value) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    final bool resultadoGuardado = await controller
        .guardarResultadoPendienteAntesFinalizar();

    if (!resultadoGuardado) {
      DialogosAwesome.getError(
        title: "RESULTADO NO ACTUALIZADO",
        descripcion: controller.mensajeErrorActualizaResultado.trim().isEmpty
            ? "No fue posible guardar el resultado de la consulta actual."
            : controller.mensajeErrorActualizaResultado,
      );
      return;
    }

    /*
   * ==========================================================
   * 2. CONSULTAR RESUMEN DESDE BASE
   * ==========================================================
   */
    final bool resumenConsultado = await controller
        .consultarResultadosOperativo();

    if (!resumenConsultado) {
      DialogosAwesome.getError(
        title: "RESUMEN NO DISPONIBLE",
        descripcion: controller.mensajeErrorResultadosOperativo.trim().isEmpty
            ? "No fue posible obtener el resumen del operativo."
            : controller.mensajeErrorResultadosOperativo,
      );
      return;
    }

    final ResultadosOperativo? resultado = controller.resultadosOperativo.value;

    if (resultado == null || !resultado.tieneDatos) {
      DialogosAwesome.getError(
        title: "RESUMEN NO DISPONIBLE",
        descripcion:
            "El servidor no devolvió información válida del operativo.",
      );
      return;
    }

    /*
   * ==========================================================
   * 3. MOSTRAR DIÁLOGO
   * ==========================================================
   */
    _dialogoResumenOperativo(resultado);
  }

  void _dialogoResumenOperativo(ResultadosOperativo resultado) {
    final BuildContext? context = Get.context;
    if (context == null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      barrierColor: Colors.black.withOpacity(.70),
      builder: (dialogContext) {
        final double alto = MediaQuery.sizeOf(dialogContext).height;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: alto * .92),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.22),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  _headerResumenOperativo(
                    dialogContext: dialogContext,
                    resultado: resultado,
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(9, 9, 9, 10),
                      child: Column(
                        children: [
                          _resumenPrincipalCompacto(resultado),

                          const SizedBox(height: 7),
                          _ubicacionCompacta(resultado),

                          const SizedBox(height: 7),
                          _estadisticasCompactas(resultado),

                          if (resultado.variablesResultado.isNotEmpty) ...[
                            const SizedBox(height: 7),

                            _variablesResultadoCompactas(resultado),
                          ],

                          const SizedBox(height: 7),

                          _avisoFinalizacionResumen(),

                          const SizedBox(height: 9),

                          _botonesResumenFinalizacion(dialogContext),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  // ============================================================
  // VARIABLES / RESULTADOS DEL OPERATIVO
  // ============================================================

  Widget _variablesResultadoCompactas(ResultadosOperativo resultado) {
    final List<VariableResultadoOperativo> variables = resultado
        .variablesResultado
        .where((VariableResultadoOperativo item) => item.cantidad > 0)
        .toList();

    if (variables.isEmpty) {
      return const SizedBox.shrink();
    }

    final int total = variables.fold<int>(
      0,
      (int suma, VariableResultadoOperativo item) => suma + item.cantidad,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFD7E2EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // CABECERA
          // ======================================================

          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2FC),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.assignment_turned_in_outlined,
                  color: Color(0xFF195BA6),
                  size: 17,
                ),
              ),

              const SizedBox(width: 7),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "VARIABLES DE RESULTADO",
                      style: TextStyle(
                        color: Color(0xFF29445D),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: 1),

                    Text(
                      "Resultados registrados durante el operativo",
                      style: TextStyle(
                        color: Color(0xFF8493A1),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Divider(height: 1),

          const SizedBox(height: 7),

          // ======================================================
          // LISTADO
          // ======================================================
          ...List.generate(variables.length, (int index) {
            final VariableResultadoOperativo variable = variables[index];

            return _filaVariableResultado(
              variable: variable,
              index: index,
              ultima: index == variables.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Widget _filaVariableResultado({
    required VariableResultadoOperativo variable,
    required int index,
    required bool ultima,
  }) {
    final String descripcion = variable.desHdrTipoResum.trim().toUpperCase();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F9FC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE1E8EF)),
          ),
          child: Row(
            children: [
              // ==================================================
              // ICONO / ORDEN
              // ==================================================

              Container(
                width: 31,
                height: 31,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F0FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Color(0xFF195BA6),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(width: 7),

              // ==================================================
              // DESCRIPCIÓN
              // ==================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      descripcion.isEmpty ? "SIN DESCRIPCIÓN" : descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF405A72),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 7),

              // ==================================================
              // CANTIDAD
              // ==================================================
              Container(
                constraints: const BoxConstraints(minWidth: 42),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      variable.cantidad.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (!ultima) const SizedBox(height: 5),
      ],
    );
  }

  Widget _resumenPrincipalCompacto(ResultadosOperativo resultado) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFD7E2EC)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2FC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_police_rounded,
                  color: Color(0xFF195BA6),
                  size: 22,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resultado.codigoEvento.isEmpty
                          ? "OPERATIVO ${resultado.idHdrEvento}"
                          : resultado.codigoEvento,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF29445D),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 1),

                    Text(
                      resultado.descripcionOperativo.isEmpty
                          ? "SIN DESCRIPCIÓN"
                          : resultado.descripcionOperativo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF718496),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F0),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  resultado.tipoOperativo.isEmpty
                      ? "OPERATIVO"
                      : resultado.tipoOperativo,
                  style: const TextStyle(
                    color: Color(0xFF198754),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          const Divider(height: 1),

          const SizedBox(height: 6),

          Row(
            children: [
              Expanded(
                child: _datoTextoCompacto(
                  icono: Icons.play_circle_outline_rounded,
                  titulo: "APERTURA",
                  valor: resultado.fechaEvento,
                ),
              ),
            ],
          ),

          if ((resultado.fechaFinalizacion ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 6),

            _datoTextoCompacto(
              icono: Icons.stop_circle_outlined,
              titulo: "FINALIZACIÓN",
              valor: resultado.fechaFinalizacion ?? '',
            ),
          ],
        ],
      ),
    );
  }

  Widget _datoTextoCompacto({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    final String dato = valor.trim().isEmpty ? "NO REGISTRADO" : valor.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FB),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Icon(icono, color: const Color(0xFF607A91), size: 14),

          const SizedBox(width: 5),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF5E5F65),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                Text(
                  dato,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF405A72),
                    fontSize: 12,
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

  Widget _estadisticasCompactas(ResultadosOperativo resultado) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFD7E2EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // CABECERA
          // ======================================================

          const Row(
            children: [
              Icon(
                Icons.query_stats_rounded,
                color: Color(0xFF195BA6),
                size: 16,
              ),

              SizedBox(width: 5),

              Expanded(
                child: Text(
                  "RESULTADOS DEL OPERATIVO",
                  style: TextStyle(
                    color: Color(0xFF52687C),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ======================================================
          // TOTAL CONSULTAS
          // ======================================================
          _cardTotalConsultas(resultado.totalConsultas),

          const SizedBox(height: 7),

          // ======================================================
          // PERSONAS / VEHÍCULOS
          // ======================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _cardConsultaResultado(
                  titulo: "PERSONAS",
                  subtitulo: "CONSULTADAS",
                  cantidad: resultado.totalPersonas,
                  alertas: resultado.totalAlertasPersona,
                  icono: Icons.person_search_rounded,
                  iconoAlerta: Icons.person_off_outlined,
                ),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: _cardConsultaResultado(
                  titulo: "VEHÍCULOS",
                  subtitulo: "CONSULTADOS",
                  cantidad: resultado.totalVehiculos,
                  alertas: resultado.totalAlertasVehiculo,
                  icono: Icons.directions_car_rounded,
                  iconoAlerta: Icons.car_crash_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardConsultaResultado({
    required String titulo,
    required String subtitulo,
    required int cantidad,
    required int alertas,
    required IconData icono,
    required IconData iconoAlerta,
  }) {
    final bool tieneAlertas = alertas > 0;

    final Color colorAlerta = tieneAlertas
        ? const Color(0xFFB42318)
        : const Color(0xFF198754);

    final Color fondoAlerta = tieneAlertas
        ? const Color(0xFFFFF0EF)
        : const Color(0xFFEAF7F0);

    final Color bordeAlerta = tieneAlertas
        ? const Color(0xFFE7B8B4)
        : const Color(0xFFB8DCC8);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCDCDCD)),
      ),
      child: Column(
        children: [
          // ======================================================
          // CONSULTADOS
          // ======================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
            child: Row(
              children: [
                Container(
                  width: 37,
                  height: 37,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F0FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icono, color: const Color(0xFF195BA6), size: 20),
                ),

                const SizedBox(width: 7),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cantidad.toString(),
                        style: const TextStyle(
                          color: Color(0xFF195BA6),
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF405A72),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      Text(
                        subtitulo,
                        style: const TextStyle(
                          color: Color(0xFF8493A1),
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // ALERTAS
          // ======================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
            decoration: BoxDecoration(
              color: fondoAlerta,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(11),
                bottomRight: Radius.circular(11),
              ),
              border: Border(top: BorderSide(color: bordeAlerta)),
            ),
            child: Row(
              children: [
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    color: colorAlerta.withOpacity(.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    tieneAlertas ? iconoAlerta : Icons.verified_rounded,
                    color: colorAlerta,
                    size: 15,
                  ),
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ALERTAS",
                        style: TextStyle(
                          color: colorAlerta,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      Text(
                        tieneAlertas ? "CON NOVEDAD" : "SIN NOVEDAD",
                        style: TextStyle(
                          color: colorAlerta.withOpacity(.75),
                          fontSize: 6.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  alertas.toString(),
                  style: TextStyle(
                    color: colorAlerta,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardTotalConsultas(int valor) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD8E4EE)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE5F0FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: Color(0xFF195BA6),
              size: 17,
            ),
          ),

          const SizedBox(width: 7),

          const Expanded(
            child: Text(
              "CONSULTAS REALIZADAS",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF405A72),
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          Text(
            valor.toString(),
            style: const TextStyle(
              color: Color(0xFF195BA6),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ubicacionCompacta(ResultadosOperativo resultado) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD7E2EC)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Color(0xFF195BA6),
                size: 15,
              ),

              SizedBox(width: 5),

              Text(
                "UBICACIÓN DEL OPERATIVO",
                style: TextStyle(
                  color: Color(0xFF52687C),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          _ubicacionFila(
            titulo: "ZONA / SUBZONA",
            valor: "${resultado.zona} · ${resultado.subzona}",
          ),

          _ubicacionFila(titulo: "DISTRITO", valor: resultado.distrito),

          _ubicacionFila(titulo: "CIRCUITO", valor: resultado.circuito),

          _ubicacionFila(
            titulo: "SUBCIRCUITO",
            valor: resultado.subcircuito,
            linea: false,
          ),
        ],
      ),
    );
  }

  Widget _ubicacionFila({
    required String titulo,
    required String valor,
    bool linea = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 74,
                child: Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF464749),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Text(
                  valor.trim().isEmpty ? "NO REGISTRADO" : valor.trim(),
                  style: const TextStyle(
                    color: Color(0xFF405A72),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (linea) const Divider(height: 1),
      ],
    );
  }

  Widget _headerResumenOperativo({
    required BuildContext dialogContext,
    required ResultadosOperativo resultado,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 9, 5, 9),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 37,
            height: 37,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "RESUMEN DEL OPERATIVO",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  "${resultado.tipoOperativo.isEmpty ? 'OPERATIVO' : resultado.tipoOperativo} · ${resultado.codigoEvento.isEmpty ? resultado.idHdrEvento : resultado.codigoEvento}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFDCEBFA),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.of(dialogContext).pop(),
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avisoFinalizacionResumen() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFEBCFAF)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFFB76832), size: 18),

          SizedBox(width: 7),

          Expanded(
            child: Text(
              "Revise la información antes de continuar. Si selecciona FINALIZAR deberá validar su identidad mediante clave institucional o biometría. Si selecciona VOLVER, el operativo permanecerá activo.",
              style: TextStyle(
                color: Color(0xFF795235),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonesResumenFinalizacion(BuildContext dialogContext) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            icon: const Icon(Icons.arrow_back_rounded, size: 17),
            label: const Text(
              "VOLVER",
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 47),
              foregroundColor: const Color(0xFF607589),
              side: const BorderSide(color: Color(0xFFC8D5E0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();

              Future.delayed(const Duration(milliseconds: 150), () {
                _mostrarFinalizarOperativo();
              });
            },
            icon: const Icon(Icons.power_settings_new_rounded, size: 18),
            label: const Text(
              "FINALIZAR",
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 47),
              backgroundColor: const Color(0xFFB42318),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _botonCabeceraOperativo({
    required String titulo,
    required IconData icono,
    required Color color,
    required Color fondo,
    required Color borde,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: fondo,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: borde),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: color, size: 19),

              const SizedBox(height: 2),

              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  titulo,
                  maxLines: 1,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CERRAR SESIÓN
  // ============================================================

  void _confirmarCerrarSesion() {
    if (controller.peticionServerState.value) {
      return;
    }

    DialogosAwesome.getWarningSiNo(
      title: "CERRAR SESIÓN",
      descripcion:
          "¿Está seguro que desea cerrar la sesión actual?\n\n"
          "El operativo permanecerá activo y podrá retomarlo posteriormente si corresponde.",
      btnOkOnPress: () {
        controller.cerrarSesionOperativo();
      },
      btnCancelOnPress: () {},
    );
  }

  // ============================================================
  // FINALIZAR
  // ============================================================

  void _mostrarFinalizarOperativo() {
    controller.limpiarClaveFinalizar();

    final BuildContext? context = Get.context;

    if (context == null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      barrierColor: Colors.black.withOpacity(.68),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 20,
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(23),
            clipBehavior: Clip.antiAlias,
            elevation: 20,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _headerFinalizar(dialogContext),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 14, 15, 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7F1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF0D3BF)),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFFB76832),
                                size: 19,
                              ),

                              SizedBox(width: 7),

                              Expanded(
                                child: Text(
                                  "Al finalizar el operativo se cerrará el registro de nuevas consultas. Esta acción requiere validar su identidad.",
                                  style: TextStyle(
                                    color: Color(0xFF7A4A2A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 13),

                        _opcionFinalizarClave(dialogContext),

                        const SizedBox(height: 10),

                        const Row(
                          children: [
                            Expanded(child: Divider()),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "O",
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),

                            Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 10),

                        _opcionFinalizarBiometria(dialogContext),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed: () {
                              controller.limpiarClaveFinalizar();

                              Navigator.of(dialogContext).pop();
                            },
                            icon: const Icon(Icons.close_rounded, size: 17),
                            label: const Text(
                              "CANCELAR",
                              style: TextStyle(
                                fontSize: 9,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _headerFinalizar(BuildContext dialogContext) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 7, 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFB42318), Color(0xFF78170F)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.power_settings_new_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FINALIZAR OPERATIVO",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  "OPERATIVO N° ${controller.idHdrEventoActual.value}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.80),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              controller.limpiarClaveFinalizar();

              Navigator.of(dialogContext).pop();
            },
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _opcionFinalizarClave(BuildContext dialogContext) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD9E3ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFE6EFF8),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFF195BA6),
                  size: 17,
                ),
              ),

              SizedBox(width: 7),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "VALIDAR CON CLAVE",
                      style: TextStyle(
                        color: Color(0xFF314A61),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    Text(
                      "Ingrese su clave institucional",
                      style: TextStyle(color: Color(0xFF82909D), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          TextFormField(
            controller: controller.controllerClaveFinalizar,
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Clave institucional",
              prefixIcon: const Icon(
                Icons.password_rounded,
                color: Color(0xFF195BA6),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: Color(0xFFD5DFE8)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: Color(0xFFD5DFE8)),
              ),
            ),
          ),

          const SizedBox(height: 9),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();

                if (controller.controllerClaveFinalizar.text.trim().isEmpty) {
                  DialogosAwesome.getWarning(
                    title: "CLAVE REQUERIDA",
                    descripcion:
                        "Ingrese su clave institucional para continuar.",
                  );

                  return;
                }

                final bool valida = await controller.validarClaveFinalizar();

                if (!valida) {
                  DialogosAwesome.getError(
                    title: "CLAVE INCORRECTA",
                    descripcion: "La clave ingresada no pudo ser validada.",
                  );

                  return;
                }

                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }

                await Future.delayed(const Duration(milliseconds: 120));

                _confirmarFinalizacionDefinitiva();
              },
              icon: const Icon(Icons.verified_user_rounded, size: 18),
              label: const Text(
                "VALIDAR CLAVE",
                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(43),
                backgroundColor: const Color(0xFF195BA6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcionFinalizarBiometria(BuildContext dialogContext) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          FocusManager.instance.primaryFocus?.unfocus();

          final bool autenticado = await controller
              .autenticarBiometriaFinalizar();

          if (!autenticado) {
            DialogosAwesome.getError(
              title: "AUTENTICACIÓN NO VALIDADA",
              descripcion:
                  "No fue posible validar su identidad mediante huella o biometría.",
            );

            return;
          }

          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }

          await Future.delayed(const Duration(milliseconds: 120));

          _confirmarFinalizacionDefinitiva();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFEAF3FC), Color(0xFFF4F8FC)],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFACC9E3)),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: Color(0xFFDCEBFA),
                child: Icon(
                  Icons.fingerprint_rounded,
                  color: Color(0xFF195BA6),
                  size: 31,
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HUELLA / BIOMETRÍA",
                      style: TextStyle(
                        color: Color(0xFF195BA6),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      "Toque aquí para validar su identidad rápidamente.",
                      style: TextStyle(
                        color: Color(0xFF6F8294),
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF195BA6),
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmarFinalizacionDefinitiva() {
    DialogosAwesome.getWarningSiNo(
      title: "CONFIRMAR FINALIZACIÓN",
      descripcion:
          "¿Está seguro de finalizar el operativo N° ${controller.idHdrEventoActual.value}?\n\n"
          "Una vez finalizado no se podrán registrar nuevas consultas.",
      btnOkOnPress: () async {
        final bool resultado = await controller.finalizarOperativo();

        if (!resultado) {
          DialogosAwesome.getError(
            title: "NO SE PUDO FINALIZAR",
            descripcion: controller.mensajeErrorFinalizar.isEmpty
                ? "No fue posible finalizar el operativo."
                : controller.mensajeErrorFinalizar,
          );

          return;
        }

        DialogosAwesome.getSucess(
          title: "OPERATIVO FINALIZADO",
          descripcion:
              "El operativo N° ${controller.idHdrEventoActual.value} fue finalizado correctamente.",
          btnOkOnPress: () {
            controller.volverMenu();
          },
        );
      },
      btnCancelOnPress: () {},
    );
  }

  // ============================================================
  // PERSONAL OPERATIVO
  // ============================================================

  Future<void> _mostrarPersonalOperativo() async {
    if (controller.peticionServerState.value) {
      return;
    }

    if (controller.idHdrEventoActual.value <= 0) {
      DialogosAwesome.getWarning(
        title: "OPERATIVO NO DISPONIBLE",
        descripcion: "No existe un identificador válido del operativo.",
      );

      return;
    }

    final bool resultado = await controller.consultarPersonalOperativo();

    if (!resultado) {
      DialogosAwesome.getError(
        title: "PERSONAL NO DISPONIBLE",
        descripcion: controller.mensajeErrorPersonalOperativo.trim().isEmpty
            ? "No fue posible consultar el personal del operativo."
            : controller.mensajeErrorPersonalOperativo,
      );

      return;
    }

    final BuildContext? context = Get.context;

    if (context == null) return;

    _dialogoPersonalOperativo(context);
  }

  void _dialogoPersonalOperativo(BuildContext context) {
    final List<Integrante> personal = controller.personalOperativo.toList();

    if (personal.isEmpty) {
      return;
    }

    final int idEvento = controller.idHdrEventoActual.value;

    final String jefe = personal.first.jefe.trim().isEmpty
        ? "NO REGISTRADO"
        : personal.first.jefe.trim();

    final String fechaApertura = personal.first.fechaEvento.trim();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.65),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * .82,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(23),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.22),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(14, 12, 7, 12),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.groups_2_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),

                        const SizedBox(width: 9),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "PERSONAL DEL OPERATIVO",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                "OPERATIVO N° $idEvento",
                                style: const TextStyle(
                                  color: Color(0xDFFFFFFF),
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(13),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(11),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F7FC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFC8DAEB),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF195BA6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.supervisor_account_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),

                                const SizedBox(width: 9),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "RESPONSABLE DEL OPERATIVO",
                                        style: TextStyle(
                                          color: Color(0xFF8292A2),
                                          fontSize: 7,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),

                                      const SizedBox(height: 2),

                                      Text(
                                        jefe,
                                        style: const TextStyle(
                                          color: Color(0xFF29445D),
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),

                                      if (fechaApertura.isNotEmpty)
                                        Text(
                                          "APERTURA: $fechaApertura",
                                          style: const TextStyle(
                                            color: Color(0xFF758799),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              const Icon(
                                Icons.badge_outlined,
                                color: Color(0xFF195BA6),
                                size: 15,
                              ),

                              const SizedBox(width: 5),

                              const Expanded(
                                child: Text(
                                  "SERVIDORES REGISTRADOS",
                                  style: TextStyle(
                                    color: Color(0xFF52687C),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAF3FC),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${personal.length}",
                                  style: const TextStyle(
                                    color: Color(0xFF195BA6),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 7),

                          ...List.generate(
                            personal.length,
                            (index) => _cardIntegranteOperativo(
                              integrante: personal[index],
                              index: index,
                            ),
                          ),

                          const SizedBox(height: 8),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              icon: const Icon(Icons.check_rounded, size: 17),
                              label: const Text(
                                "CERRAR",
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(45),
                                backgroundColor: const Color(0xFF195BA6),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
        );
      },
    );
  }

  Widget _cardIntegranteOperativo({
    required Integrante integrante,
    required int index,
  }) {
    final String nombre = integrante.integrante.trim().isEmpty
        ? "SERVIDOR NO REGISTRADO"
        : integrante.integrante.trim();

    final String documento = integrante.documento.trim().isEmpty
        ? "NO REGISTRADO"
        : integrante.documento.trim();

    final String fecha = integrante.fecha.trim().isEmpty
        ? "NO REGISTRADA"
        : integrante.fecha.trim();

    final bool esJefe =
        integrante.jefe.trim().isNotEmpty &&
        integrante.integrante.trim().isNotEmpty &&
        integrante.jefe.trim().toUpperCase() ==
            integrante.integrante.trim().toUpperCase();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: esJefe ? const Color(0xFFF1F6FC) : Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: esJefe ? const Color(0xFFAFC9E2) : const Color(0xFFDDE5ED),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: esJefe ? const Color(0xFF195BA6) : const Color(0xFFEAF3FC),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              esJefe ? Icons.star_rounded : Icons.local_police_outlined,
              color: esJefe ? Colors.white : const Color(0xFF195BA6),
              size: 20,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        nombre,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF29445D),
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                    ),

                    if (esJefe)
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2EFFB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "JEFE",
                          style: TextStyle(
                            color: Color(0xFF195BA6),
                            fontSize: 6,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  "DOCUMENTO: $documento",
                  style: const TextStyle(
                    color: Color(0xFF748698),
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  "ANEXADO: $fecha",
                  style: const TextStyle(
                    color: Color(0xFF748698),
                    fontSize: 7,
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

  // ============================================================
  // QR
  // ============================================================

  Future<void> _mostrarQrOperativo() async {
    if (controller.peticionServerState.value) {
      return;
    }

    if (!controller.puedeFinalizarOperativo.value) {
      return;
    }

    final int idHdrEvento = controller.idHdrEventoActual.value;

    if (idHdrEvento <= 0) {
      DialogosAwesome.getWarning(
        title: "OPERATIVO NO DISPONIBLE",
        descripcion:
            "No existe un identificador válido para generar el código QR.",
      );

      return;
    }

    try {
      final String codigoQr = await OperativoQrUtil.encriptarIdOperativo(
        idHdrEvento,
      );

      final BuildContext? context = Get.context;

      if (context == null) {
        return;
      }

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(.65),
        builder: (dialogContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 24,
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 12, 7, 12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.qr_code_2_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),

                          const SizedBox(width: 9),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "QR DEL OPERATIVO",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                const SizedBox(height: 2),

                                Text(
                                  "OPERATIVO N° $idHdrEvento",
                                  style: const TextStyle(
                                    color: Color(0xDFFFFFFF),
                                    fontSize: 8.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(17),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFD6E2ED),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.07),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: QrImageView(
                              data: codigoQr,
                              version: QrVersions.auto,
                              size: 230,
                              backgroundColor: Colors.white,
                              errorCorrectionLevel: QrErrorCorrectLevel.M,
                            ),
                          ),

                          const SizedBox(height: 13),

                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_rounded,
                                color: Color(0xFF198754),
                                size: 15,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "IDENTIFICADOR CIFRADO",
                                style: TextStyle(
                                  color: Color(0xFF198754),
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 7),

                          const Text(
                            "Otro servidor policial puede escanear este código desde la opción ANEXARSE para vincularse al operativo.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF718294),
                              fontSize: 8.5,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 14),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              icon: const Icon(Icons.check_rounded, size: 17),
                              label: const Text(
                                "ENTENDIDO",
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(45),
                                backgroundColor: const Color(0xFF195BA6),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
          );
        },
      );
    } catch (e) {
      DialogosAwesome.getError(
        title: "QR NO DISPONIBLE",
        descripcion: "No fue posible generar el código QR del operativo.",
      );
    }
  }

  // ============================================================
  // TIPO CONSULTA
  // ============================================================

  Widget getTipoDeConsulta() {
    return Obx(
      () => Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.fromLTRB(7, 7, 7, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD7E2ED)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D4C9C).withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 1, 4, 7),
              child: Row(
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    color: Color(0xFF60758A),
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "SELECCIONE QUÉ DESEA CONSULTAR",
                      style: TextStyle(
                        color: Color(0xFF52687C),
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: _botonConsulta(
                    seleccionado: controller.selectPerson.value,
                    titulo: "PERSONA",
                    subtitulo: "Documento de identidad",
                    detalle: "CONSULTA CIUDADANO",
                    icono: Icons.person_search_rounded,
                    onTap: controller.seleccionarPersona,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _botonConsulta(
                    seleccionado: controller.selectVehiculo.value,
                    titulo: "VEHÍCULO",
                    subtitulo: "Número de placa",
                    detalle: "CONSULTA AUTOMOTOR",
                    icono: Icons.directions_car_filled_rounded,
                    onTap: controller.seleccionarVehiculo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonConsulta({
    required bool seleccionado,
    required String titulo,
    required String subtitulo,
    required String detalle,
    required IconData icono,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          height: 108,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            gradient: seleccionado
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1764B2), Color(0xFF073B78)],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFAFCFE), Color(0xFFF1F5F9)],
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: seleccionado
                  ? const Color(0xFF1764B2)
                  : const Color(0xFFD8E3ED),
              width: seleccionado ? 2 : 1,
            ),
            boxShadow: seleccionado
                ? [
                    BoxShadow(
                      color: const Color(0xFF195BA6).withOpacity(.20),
                      blurRadius: 11,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: seleccionado
                          ? Colors.white.withOpacity(.16)
                          : const Color(0xFFE4EEF8),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      icono,
                      size: 25,
                      color: seleccionado
                          ? Colors.white
                          : const Color(0xFF1764B2),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: seleccionado
                                ? Colors.white
                                : const Color(0xFF253E55),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          subtitulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: seleccionado
                                ? Colors.white.withOpacity(.78)
                                : const Color(0xFF7C8998),
                            fontSize: 7.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: seleccionado
                          ? Colors.white
                          : const Color(0xFFE7EDF3),
                    ),
                    child: Icon(
                      seleccionado
                          ? Icons.check_rounded
                          : Icons.circle_outlined,
                      size: 15,
                      color: seleccionado
                          ? const Color(0xFF1764B2)
                          : const Color(0xFFA1ACB7),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: seleccionado
                      ? Colors.white.withOpacity(.12)
                      : const Color(0xFFEAF0F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  seleccionado ? "$detalle · SELECCIONADO" : detalle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: seleccionado
                        ? Colors.white
                        : const Color(0xFF607589),
                    fontSize: 6.8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BÚSQUEDA
  // ============================================================

  Widget getBusquedaTipoOperativo() {
    if (controller.selectPerson.value) {
      final Widget wg = BusquedaTipoOperativoWg(
        key: const ValueKey("consulta_persona"),
        anchoPorcentaje: 95,
        myKey: _keyCedula,
        controller: controller.controllerCedula,
        maxLength: 20,
        icono: const Icon(Icons.badge_outlined, color: AppColors.colorIcons),
        keyboardType: TextInputType.number,
        title: "Nro. Documento",
        msjError: "Documento vacío",
        focusNode: controller.focusCedula,
        onTap: _confirmarBusquedaPersona,
      );

      return Obx(
        () => controller.ocultarBtnBuscarPersona.value
            ? const SizedBox.shrink()
            : _cardBusqueda(
                titulo: "CONSULTA DE PERSONA",
                descripcion: "Ingrese el número de documento de identidad.",
                icono: Icons.person_search_rounded,
                child: wg,
              ),
      );
    }

    final Widget wg = BusquedaTipoOperativoWg(
      key: const ValueKey("consulta_vehiculo"),
      controller: controller.controllerPlaca,
      myKey: _keyPlaca,
      anchoPorcentaje: 95,
      title: "Placa",
      msjError: "Ingrese una placa válida",
      icono: const Icon(
        Icons.directions_car_rounded,
        color: AppColors.colorIcons,
      ),
      maxLength: 7,
      keyboardType: TextInputType.text,
      onTap: _confirmarBusquedaVehiculo,
      focusNode: controller.focusPlaca,
    );

    return Obx(
      () => controller.ocultarBtnBuscarVehiculo.value
          ? const SizedBox.shrink()
          : _cardBusqueda(
              titulo: "CONSULTA DE VEHÍCULO",
              descripcion: "Ingrese la placa del vehículo a consultar.",
              icono: Icons.directions_car_rounded,
              child: wg,
            ),
    );
  }

  Widget _cardBusqueda({
    required String titulo,
    required String descripcion,
    required IconData icono,
    required Widget child,
  }) {
    return Container(
      key: ValueKey(titulo),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 11),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.98),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFA8C5E1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FC),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icono, color: const Color(0xFF195BA6), size: 21),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        color: Color(0xFF203E5B),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    Text(
                      descripcion,
                      style: const TextStyle(
                        color: Color(0xFF788899),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          /*
           * IMPORTANTE:
           *
           * AQUÍ YA NO MOSTRAMOS
           * _comboVariableResultado().
           *
           * Antes de consultar solamente
           * mostramos documento / placa.
           */
          child,
        ],
      ),
    );
  }

  // ============================================================
  // CONFIRMAR PERSONA
  // ============================================================

  Future<void> _confirmarBusquedaPersona() async {
    final bool valido = _keyCedula.currentState?.validate() ?? false;

    if (!valido) return;

    final String dato = controller.controllerCedula.text.trim();

    if (dato.isEmpty) return;

    await _cerrarTeclado();

    await _mostrarPreparandoConsulta(tipo: "CONSULTA DE PERSONA");

    _dialogoConfirmarBusqueda(
      tipo: "PERSONA",
      etiqueta: "NÚMERO DE DOCUMENTO",
      dato: dato,
      icono: Icons.person_search_rounded,
      onConfirmar: () async {
        final bool resultado = await controller.consultarPersonaPorCedula(
          key: _keyCedula,
        );

        if (!resultado) {
          DialogosAwesome.getError(
            title: "CONSULTA NO REALIZADA",
            descripcion: controller.mensajeErrorConsulta.isEmpty
                ? "No fue posible realizar la consulta."
                : controller.mensajeErrorConsulta,
          );
        }
      },
    );
  }

  // ============================================================
  // CONFIRMAR VEHÍCULO
  // ============================================================

  Future<void> _confirmarBusquedaVehiculo() async {
    final bool valido = _keyPlaca.currentState?.validate() ?? false;

    if (!valido) return;

    final String dato = controller.controllerPlaca.text.trim().toUpperCase();

    if (dato.isEmpty) return;

    await _cerrarTeclado();

    await _mostrarPreparandoConsulta(tipo: "CONSULTA DE VEHÍCULO");

    _dialogoConfirmarBusqueda(
      tipo: "VEHÍCULO",
      etiqueta: "PLACA",
      dato: dato,
      icono: Icons.directions_car_rounded,
      onConfirmar: () async {
        final bool resultado = await controller.consultarVehiculoPorPlaca(
          key: _keyPlaca,
        );

        if (!resultado) {
          DialogosAwesome.getError(
            title: "CONSULTA NO REALIZADA",
            descripcion: controller.mensajeErrorConsulta.isEmpty
                ? "No fue posible realizar la consulta del vehículo."
                : controller.mensajeErrorConsulta,
          );
        }
      },
    );
  }

  Future<void> _cerrarTeclado() async {
    FocusManager.instance.primaryFocus?.unfocus();

    await Future.delayed(const Duration(milliseconds: 180));
  }

  // ============================================================
  // LOADING PREPARACIÓN
  // ============================================================

  Future<void> _mostrarPreparandoConsulta({required String tipo}) async {
    final BuildContext? context = Get.context;

    if (context == null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.48),
      builder: (dialogContext) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 190,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.18),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 34,
                      height: 34,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(0xFF195BA6),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "PREPARANDO CONSULTA",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF203E5B),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      tipo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF718496),
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
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

    await Future.delayed(const Duration(milliseconds: 450));

    if (Get.context != null && Navigator.of(Get.context!).canPop()) {
      Navigator.of(Get.context!).pop();
    }

    await Future.delayed(const Duration(milliseconds: 80));
  }

  // ============================================================
  // DATOS PERSONA
  // ============================================================

  Widget getMuestraDatosPersona() {
    return Obx(() {
      if (controller.dataPersona.isEmpty) {
        return _estadoConsulta(
          icono: Icons.person_search_outlined,
          titulo: "CONSULTA DE PERSONAS",
          descripcion:
              "Ingrese un documento para visualizar la información del ciudadano.",
        );
      }

      return Column(
        children: [
          _resultadoConsultaVariable(),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 8),
            child: DesingBusquedaPorCedulaWidget(
              onPressedAceptar: () {
                _nuevaConsultaPersona();
              },
              onPressedAntecedentes: () {
                _mostrarAntecedentesPersona();
              },
              dataPersona: controller.dataPersona,
            ),
          ),
        ],
      );
    });
  }
  // ============================================================
  // ANTECEDENTES PERSONA
  // ============================================================

  Future<void> _mostrarAntecedentesPersona() async {
    if (controller.consultandoAntecedentesPersona.value) {
      return;
    }

    if (controller.dataPersona.isEmpty) {
      DialogosAwesome.getWarning(
        title: "PERSONA NO DISPONIBLE",
        descripcion: "Primero debe realizar la consulta de una persona.",
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final bool resultado = await controller.consultarAntecedentesPersona();

    if (!resultado) {
      DialogosAwesome.getError(
        title: "ANTECEDENTES NO DISPONIBLES",
        descripcion: controller.mensajeErrorAntecedentesPersona.trim().isEmpty
            ? "No fue posible consultar los antecedentes de la persona."
            : controller.mensajeErrorAntecedentesPersona,
      );

      return;
    }

    final DataAntecedentes? antecedentes =
        controller.datosAntecedentesPersona.value;

    if (antecedentes == null) {
      DialogosAwesome.getError(
        title: "INFORMACIÓN NO DISPONIBLE",
        descripcion: "El servidor no devolvió información válida.",
      );
      return;
    }

    final BuildContext? context = Get.context;

    if (context == null) return;

    _dialogoAntecedentesPersona(context, antecedentes);
  }

  void _dialogoAntecedentesPersona(
    BuildContext context,
    DataAntecedentes antecedentes,
  ) {
    if (controller.dataPersona.isEmpty) {
      return;
    }

    final DataConsultaPersona data = controller.dataPersona.first;

    String documento = '';
    String nombres = '';
    String fechaDefuncion = '';

    if (data.dataSiipne.success) {
      documento = data.dataSiipne.datosSiipne.documento.trim();

      nombres = data.dataSiipne.datosSiipne.apenom.trim();
    }

    final String fechaNormalizada = fechaDefuncion.toUpperCase();

    final bool personaFallecida =
        fechaDefuncion.isNotEmpty &&
        fechaNormalizada != 'N/D' &&
        fechaNormalizada != 'NULL' &&
        fechaDefuncion != '0000-00-00';

    final bool tieneAntecedentes = antecedentes.antecedentes.isNotEmpty;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      barrierColor: Colors.black.withOpacity(.68),
      builder: (dialogContext) {
        final double alto = MediaQuery.sizeOf(dialogContext).height;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 18,
          ),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: alto * .88),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.24),
                  blurRadius: 25,
                  offset: const Offset(0, 9),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // =============================================
                  // HEADER
                  // =============================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(13, 11, 6, 11),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF334E68), Color(0xFF243B53)],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.14),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(.16),
                            ),
                          ),
                          child: const Icon(
                            Icons.fact_check_outlined,
                            color: Colors.white,
                            size: 23,
                          ),
                        ),

                        const SizedBox(width: 9),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ANTECEDENTES",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: .35,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                "INFORMACIÓN DE LA PERSONA CONSULTADA",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFFD9E4EC),
                                  fontSize: 7.3,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          constraints: const BoxConstraints(
                            minWidth: 34,
                            minHeight: 34,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 21,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(11),
                      child: Column(
                        children: [
                          // =====================================
                          // PERSONA
                          // =====================================
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFD7E2EC),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F2FC),
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: const Icon(
                                    Icons.person_search_rounded,
                                    color: Color(0xFF195BA6),
                                    size: 22,
                                  ),
                                ),

                                const SizedBox(width: 9),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nombres.isEmpty
                                            ? "PERSONA CONSULTADA"
                                            : nombres,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFF29445D),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2,
                                        ),
                                      ),

                                      const SizedBox(height: 3),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.badge_outlined,
                                            color: Color(0xFF758799),
                                            size: 13,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              documento.isEmpty
                                                  ? "DOCUMENTO NO REGISTRADO"
                                                  : documento,
                                              style: const TextStyle(
                                                color: Color(0xFF758799),
                                                fontSize: 8,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),
                          // =====================================
                          // RESUMEN
                          // =====================================
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: tieneAntecedentes
                                  ? const Color(0xFFFFF7ED)
                                  : const Color(0xFFF0F8F4),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: tieneAntecedentes
                                    ? const Color(0xFFEBCFAF)
                                    : const Color(0xFFB8DCC8),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: tieneAntecedentes
                                        ? const Color(0xFFFFE7CC)
                                        : const Color(0xFFDDF1E5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    tieneAntecedentes
                                        ? Icons.manage_search_rounded
                                        : Icons.verified_rounded,
                                    color: tieneAntecedentes
                                        ? const Color(0xFFA95D16)
                                        : const Color(0xFF198754),
                                    size: 21,
                                  ),
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tieneAntecedentes
                                            ? "INFORMACIÓN REGISTRADA"
                                            : "SIN ANTECEDENTES",
                                        style: TextStyle(
                                          color: tieneAntecedentes
                                              ? const Color(0xFF8A541C)
                                              : const Color(0xFF267149),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),

                                      const SizedBox(height: 2),

                                      Text(
                                        tieneAntecedentes
                                            ? "${antecedentes.antecedentes.length} registro${antecedentes.antecedentes.length == 1 ? '' : 's'} encontrado${antecedentes.antecedentes.length == 1 ? '' : 's'}"
                                            : "No se encontraron registros para la persona consultada.",
                                        style: const TextStyle(
                                          color: Color(0xFF718496),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  "${antecedentes.antecedentes.length}",
                                  style: TextStyle(
                                    color: tieneAntecedentes
                                        ? const Color(0xFFA95D16)
                                        : const Color(0xFF198754),
                                    fontSize: 21,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (tieneAntecedentes) ...[
                            const SizedBox(height: 8),

                            ...List.generate(antecedentes.antecedentes.length, (
                              int index,
                            ) {
                              final String antecedente =
                                  antecedentes.antecedentes[index];

                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFD8E2EB),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAF2F8),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "${index + 1}",
                                        style: const TextStyle(
                                          color: Color(0xFF334E68),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    Expanded(
                                      child: Text(
                                        antecedente,
                                        style: const TextStyle(
                                          color: Color(0xFF405A72),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          height: 1.35,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],

                          const SizedBox(height: 9),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F6FA),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.security_rounded,
                                  color: Color(0xFF607589),
                                  size: 18,
                                ),

                                SizedBox(width: 7),

                                Expanded(
                                  child: Text(
                                    "Información obtenida mediante los servicios institucionales habilitados para la consulta operativa.",
                                    style: TextStyle(
                                      color: Color(0xFF6E8091),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              icon: const Icon(Icons.check_rounded, size: 18),
                              label: const Text(
                                "CERRAR",
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(45),
                                backgroundColor: const Color(0xFF334E68),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
        );
      },
    );
  }
  // ============================================================
  // DATOS VEHÍCULO
  // ============================================================

  Widget getMuestraDatosVehiculo() {
    return Obx(() {
      if (controller.dataVehiculo.isEmpty) {
        return _estadoConsulta(
          icono: Icons.directions_car_outlined,
          titulo: "CONSULTA DE VEHÍCULOS",
          descripcion:
              "Ingrese una placa para visualizar la información del vehículo.",
        );
      }

      return Column(
        children: [
          _resultadoConsultaVariable(),

          Padding(
            padding: const EdgeInsets.fromLTRB(6, 3, 6, 15),
            child: DesingDatosVehiculoWg(
              data: controller.dataVehiculo.first,
              onPressedNewConsulta: () {
                _nuevaConsultaVehiculo();
              },
              onPressedOcupantes: _abrirPersonasVehiculo,
            ),
          ),
        ],
      );
    });
  }

  // ============================================================
  // NUEVA CONSULTA PERSONA
  // ============================================================

  Future<void> _nuevaConsultaPersona() async {
    final bool resultado = await controller.nuevaConsultaPersona();

    if (resultado) {
      return;
    }

    if (controller.mensajeErrorActualizaResultado.trim().isNotEmpty) {
      DialogosAwesome.getError(
        title: "RESULTADO NO ACTUALIZADO",
        descripcion: controller.mensajeErrorActualizaResultado,
      );
    }
  }

  // ============================================================
  // NUEVA CONSULTA VEHÍCULO
  // ============================================================

  Future<void> _nuevaConsultaVehiculo() async {
    final bool resultado = await controller.nuevaConsultaVehiculo();

    if (resultado) {
      return;
    }

    if (controller.mensajeErrorActualizaResultado.trim().isNotEmpty) {
      DialogosAwesome.getError(
        title: "RESULTADO NO ACTUALIZADO",
        descripcion: controller.mensajeErrorActualizaResultado,
      );
    }
  }

  // ============================================================
  // PERSONAS EN VEHÍCULO
  // ============================================================

  Widget _panelPersonasVehiculo() {
    return Obx(() {
      final bool tieneConductor = controller.dataPersona_conductor.isNotEmpty;

      final int ocupantes = controller.dataPersona_ocupantes.length;

      final int idPadre = controller.idHdrEventoResumVehiculo;

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.fromLTRB(9, 9, 9, 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.98),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFB7CEE3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D4C9C).withOpacity(.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F1FB),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.airline_seat_recline_normal_rounded,
                    color: Color(0xFF195BA6),
                    size: 22,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PERSONAS EN EL VEHÍCULO",
                        style: TextStyle(
                          color: Color(0xFF203E5B),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      Text(
                        "RELACIÓN HDR #$idPadre · "
                        "${tieneConductor ? 'CONDUCTOR REGISTRADO' : 'SIN CONDUCTOR'} · "
                        "$ocupantes OCUPANTE${ocupantes == 1 ? '' : 'S'}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF74879A),
                          fontSize: 7.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  constraints: const BoxConstraints(
                    minWidth: 34,
                    minHeight: 34,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: controller.cerrarRegistroOcupantes,
                  icon: const Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: Color(0xFF6D8194),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            _diagramaVehiculoPersonas(),

            const SizedBox(height: 9),

            _selectorRolPersonaVehiculo(),

            const SizedBox(height: 7),

            _busquedaPersonaVehiculo(),

            if (tieneConductor || ocupantes > 0) ...[
              const SizedBox(height: 9),

              _personasRegistradasVehiculo(),
            ],
          ],
        ),
      );
    });
  }

  Widget _diagramaVehiculoPersonas() {
    return Obx(() {
      final bool conductor = controller.dataPersona_conductor.isNotEmpty;

      final int ocupantes = controller.dataPersona_ocupantes.length;

      Widget asiento({
        required IconData icon,
        required String titulo,
        required bool ocupado,
        String? detalle,
      }) {
        return Expanded(
          child: Container(
            height: 61,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            decoration: BoxDecoration(
              color: ocupado
                  ? const Color(0xFFE8F5EE)
                  : const Color(0xFFF3F6F9),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: ocupado
                    ? const Color(0xFF9DD0B4)
                    : const Color(0xFFD8E1E9),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: ocupado
                      ? const Color(0xFF198754)
                      : const Color(0xFF91A0AE),
                ),

                const SizedBox(height: 3),

                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ocupado
                        ? const Color(0xFF276244)
                        : const Color(0xFF6E7F8F),
                    fontSize: 7,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                if (detalle != null)
                  Text(
                    detalle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF7C8C9A),
                      fontSize: 6.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        );
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF5F9FD), Color(0xFFEDF4FA)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD2E0EC)),
        ),
        child: Row(
          children: [
            asiento(
              icon: Icons.person_rounded,
              titulo: "CONDUCTOR",
              ocupado: conductor,
              detalle: conductor ? "REGISTRADO" : "PENDIENTE",
            ),

            const SizedBox(width: 7),

            Expanded(
              child: Container(
                height: 61,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
                  ),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.directions_car_filled_rounded,
                      color: Colors.white,
                      size: 24,
                    ),

                    const SizedBox(height: 2),

                    Text(
                      controller.dataVehiculo.isNotEmpty
                          ? controller
                                .dataVehiculo
                                .first
                                .datosVehiculoSiipne
                                .data
                                .placa
                          : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 7),

            asiento(
              icon: Icons.groups_2_rounded,
              titulo: "OCUPANTES",
              ocupado: ocupantes > 0,
              detalle: "$ocupantes REGISTRADO${ocupantes == 1 ? '' : 'S'}",
            ),
          ],
        ),
      );
    });
  }

  Widget _selectorRolPersonaVehiculo() {
    return Obx(() {
      final bool conductorSeleccionado =
          controller.tipoPersonaVehiculo.value == 'CONDUCTOR';

      final bool conductorYaRegistrado =
          controller.dataPersona_conductor.isNotEmpty;

      Widget boton({
        required String titulo,
        required IconData icon,
        required bool seleccionado,
        required VoidCallback? onTap,
      }) {
        return Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(11),
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: seleccionado
                      ? const Color(0xFF195BA6)
                      : const Color(0xFFF2F6FA),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: seleccionado
                        ? const Color(0xFF195BA6)
                        : const Color(0xFFD4E0EA),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 17,
                      color: seleccionado
                          ? Colors.white
                          : const Color(0xFF61788D),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      titulo,
                      style: TextStyle(
                        color: seleccionado
                            ? Colors.white
                            : const Color(0xFF53697D),
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return Row(
        children: [
          boton(
            titulo: conductorYaRegistrado ? "CONDUCTOR ✓" : "CONDUCTOR",
            icon: Icons.person_pin_rounded,
            seleccionado: conductorSeleccionado,
            onTap: conductorYaRegistrado
                ? null
                : () => controller.seleccionarTipoPersonaVehiculo('CONDUCTOR'),
          ),

          const SizedBox(width: 7),

          boton(
            titulo: "AGREGAR OCUPANTE",
            icon: Icons.person_add_alt_1_rounded,
            seleccionado: !conductorSeleccionado,
            onTap: () => controller.seleccionarTipoPersonaVehiculo('OCUPANTE'),
          ),
        ],
      );
    });
  }

  Widget _busquedaPersonaVehiculo() {
    return BusquedaTipoOperativoWg(
      key: const ValueKey("persona_relacionada_vehiculo"),
      anchoPorcentaje: 100,
      myKey: _keyCedulaVehiculo,
      controller: controller.controllerCedulaVehiculo,
      maxLength: 20,
      icono: const Icon(Icons.badge_outlined, color: AppColors.colorIcons),
      keyboardType: TextInputType.number,
      title: controller.tipoPersonaVehiculo.value == 'CONDUCTOR'
          ? "Documento del conductor"
          : "Documento del ocupante",
      msjError: "Documento vacío",
      onTap: _confirmarPersonaVehiculo,
    );
  }

  Future<void> _confirmarPersonaVehiculo() async {
    final bool valido = _keyCedulaVehiculo.currentState?.validate() ?? false;

    if (!valido) return;

    final String documento = controller.controllerCedulaVehiculo.text.trim();

    if (documento.isEmpty) return;

    await _cerrarTeclado();

    final String rol = controller.tipoPersonaVehiculo.value;

    _dialogoConfirmarBusqueda(
      tipo: rol,
      etiqueta: "NÚMERO DE DOCUMENTO",
      dato: documento,
      icono: rol == 'CONDUCTOR'
          ? Icons.person_pin_rounded
          : Icons.person_add_alt_1_rounded,
      onConfirmar: () async {
        final bool resultado = await controller
            .consultarPersonaRelacionadaVehiculo(key: _keyCedulaVehiculo);

        if (!resultado) {
          DialogosAwesome.getError(
            title: "CONSULTA NO REALIZADA",
            descripcion: controller.mensajeErrorConsulta.isEmpty
                ? "No fue posible registrar la persona en el vehículo."
                : controller.mensajeErrorConsulta,
          );
        }
      },
    );
  }

  Widget _personasRegistradasVehiculo() {
    return Obx(
      () => Column(
        children: [
          if (controller.dataPersona_conductor.isNotEmpty)
            _cardPersonaRelacionada(
              titulo: "CONDUCTOR",
              icono: Icons.person_pin_circle_rounded,
              data: controller.dataPersona_conductor.first,
              onEliminar: controller.eliminarConductorVehiculoLocal,
            ),

          ...List<Widget>.generate(
            controller.dataPersona_ocupantes.length,
            (int index) => _cardPersonaRelacionada(
              titulo: "OCUPANTE ${index + 1}",
              icono: Icons.airline_seat_recline_normal_rounded,
              data: controller.dataPersona_ocupantes[index],
              onEliminar: () => controller.eliminarOcupanteVehiculoLocal(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardPersonaRelacionada({
    required String titulo,
    required IconData icono,
    required DataConsultaPersona data,
    required VoidCallback onEliminar,
  }) {
    final bool alerta = data.ordenCaptura.success;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: alerta ? const Color(0xFFFFF1F0) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: alerta ? const Color(0xFFE6A4A0) : const Color(0xFFDCE5ED),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(9, 7, 5, 4),
            child: Row(
              children: [
                Icon(
                  icono,
                  size: 17,
                  color: alerta
                      ? const Color(0xFFB42318)
                      : const Color(0xFF195BA6),
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    titulo,
                    style: TextStyle(
                      color: alerta
                          ? const Color(0xFF9C241B)
                          : const Color(0xFF34536F),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                if (alerta)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Text(
                      "ALERTA",
                      style: TextStyle(
                        color: Color(0xFFB42318),
                        fontSize: 6.8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          DesingBusquedaPorCedulaWidget(
            onPressedAceptar: onEliminar,
            dataPersona: <DataConsultaPersona>[data],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ESTADO INICIAL
  // ============================================================

  Widget _estadoInicial() {
    return _estadoConsulta(
      icono: Icons.manage_search_rounded,
      titulo: "CONSULTA OPERATIVA",
      descripcion: "Seleccione Personas o Vehículos para iniciar una consulta.",
    );
  }

  Widget _estadoConsulta({
    required IconData icono,
    required String titulo,
    required String descripcion,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FB),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icono, color: const Color(0xFF195BA6), size: 28),
          ),

          const SizedBox(height: 9),

          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF3B536A),
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            descripcion,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF8491A0),
              fontSize: 9,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OPERATIVO INVÁLIDO
  // ============================================================

  Widget _operativoInvalido() {
    return SizedBox.expand(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE1E7EE)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0ED),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFB3261E),
                    size: 34,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  "OPERATIVO NO DISPONIBLE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF293A4F),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  controller.mensajeDatosOperativo.isEmpty
                      ? "No fue posible obtener los datos del operativo."
                      : controller.mensajeDatosOperativo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.volverMenu,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text("VOLVER AL MENÚ"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorAzul,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DIALOGO CONFIRMAR CONSULTA
  // ============================================================

  void _dialogoConfirmarBusqueda({
    required String tipo,
    required String etiqueta,
    required String dato,
    required IconData icono,
    required VoidCallback onConfirmar,
  }) {
    final BuildContext? context = Get.context;

    if (context == null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      barrierColor: Colors.black.withOpacity(.62),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 20,
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            clipBehavior: Clip.antiAlias,
            elevation: 18,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _headerDialogoConfirmacion(
                    dialogContext: dialogContext,
                    icono: icono,
                    tipo: tipo,
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Verifique cuidadosamente la información antes de realizar la consulta.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 10,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 12),

                        _datoConfirmacion(
                          icono: icono,
                          titulo: etiqueta,
                          valor: dato,
                        ),

                        const SizedBox(height: 9),

                        _detalleTipoConsulta(tipo: tipo),

                        const SizedBox(height: 9),

                        _avisoAuditoria(),

                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                icon: const Icon(Icons.close_rounded, size: 17),
                                label: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "CANCELAR",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(0, 45),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  foregroundColor: const Color(0xFF64748B),
                                  side: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 9),

                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();

                                  Future.delayed(
                                    const Duration(milliseconds: 120),
                                    onConfirmar,
                                  );
                                },
                                icon: const Icon(
                                  Icons.search_rounded,
                                  size: 17,
                                ),
                                label: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "SÍ, CONSULTAR",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 45),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  backgroundColor: const Color(0xFF195BA6),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _headerDialogoConfirmacion({
    required BuildContext dialogContext,
    required IconData icono,
    required String tipo,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 11, 7, 11),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(.18)),
            ),
            child: Icon(icono, color: Colors.white, size: 22),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "CONFIRMAR CONSULTA",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .2,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  "CONSULTA DE $tipo",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xDFFFFFFF),
                    fontSize: 8.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.of(dialogContext).pop(),
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _datoConfirmacion({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF5F9FD), Color(0xFFEDF4FB)],
        ),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFBCD3E7)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFDDECF8),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icono, color: const Color(0xFF195BA6), size: 22),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF718496),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .3,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  valor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF203E5B),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .4,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5EE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF198754),
              size: 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detalleTipoConsulta({required String tipo}) {
    final bool esPersona = tipo == "PERSONA";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(
            esPersona ? Icons.badge_outlined : Icons.directions_car_outlined,
            color: const Color(0xFF195BA6),
            size: 17,
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TIPO DE CONSULTA",
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 7,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                Text(
                  esPersona
                      ? "INFORMACIÓN DE PERSONA"
                      : "INFORMACIÓN VEHICULAR",
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F2FB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "OPERATIVO",
              style: TextStyle(
                color: Color(0xFF195BA6),
                fontSize: 6.8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avisoAuditoria() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFEBD8A8)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.security_rounded, color: Color(0xFFA97814), size: 17),

          SizedBox(width: 7),

          Expanded(
            child: Text(
              "Esta consulta será registrada y auditada con su usuario, ubicación, fecha y hora.",
              style: TextStyle(
                color: Color(0xFF795E25),
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ABRIR PERSONAS VEHÍCULO
  // ============================================================

  void _abrirPersonasVehiculo() {
    if (controller.dataVehiculo.isEmpty) {
      DialogosAwesome.getWarning(
        title: "VEHÍCULO REQUERIDO",
        descripcion: "Primero debe realizar la consulta de un vehículo.",
      );

      return;
    }

    if (controller.idHdrEventoResumVehiculo <= 0) {
      DialogosAwesome.getWarning(
        title: "REGISTRO NO DISPONIBLE",
        descripcion: "El vehículo consultado no posee un identificador válido.",
      );

      return;
    }

    controller.prepararPantallaPersonasVehiculo();

    Get.to(
      () => OpVehiculoPersonasPage(),
      duration: const Duration(milliseconds: 280),
    );
  }
}
