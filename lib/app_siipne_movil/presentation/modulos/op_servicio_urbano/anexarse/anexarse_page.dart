part of '../../pages.dart';

class AnexarsePage extends GetView<AnexarseController> {
  AnexarsePage({super.key});

  final GlobalKey<FormState> _keyOperativo =
  GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double teclado =
        MediaQuery.of(context).viewInsets.bottom;

    return WorkAreaPageSiipneMovilWidget(
      showGps: true,
      mostrarBtnAtras: true,
      title: "ANEXARSE A OPERATIVO",
      contenidoExpandido: true,
      peticionServer:
      controller.peticionServerState,
      contenido: Obx(
            () => ListView(
          physics:
          const BouncingScrollPhysics(
            parent:
            AlwaysScrollableScrollPhysics(),
          ),
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior
              .onDrag,
          padding: EdgeInsets.fromLTRB(
            10,
            8,
            10,
            teclado + 22,
          ),
          children: [
            _cabecera(),

            const SizedBox(height: 10),

            if (!controller
                .operativoConsultado.value)
              _formularioConsulta(),

            if (controller
                .operativoConsultado.value) ...[
              _resultadoOperativo(),

              const SizedBox(height: 10),

              if (controller
                  .operativoValido.value)
                _botonAnexarse()
              else
                _mensajeNoValido(),

              const SizedBox(height: 8),

              _botonNuevaConsulta(),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CABECERA
  // ============================================================

  Widget _cabecera() {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF195BA6),
            Color(0xFF0A3D7E),
          ],
        ),
        borderRadius:
        BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color:
            const Color(0xFF0D4C9C)
                .withOpacity(.15),
            blurRadius: 13,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(
            Icons.group_add_rounded,
            color: Colors.white,
            size: 30,
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  "ANEXARSE A UN OPERATIVO",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  "Ingrese el número del operativo para verificar su información y disponibilidad.",
                  style: TextStyle(
                    color:
                    Color(0xDFFFFFFF),
                    fontSize: 9.5,
                    height: 1.3,
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
  // FORMULARIO
  // ============================================================

  Widget _formularioConsulta() {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(17),
        border: Border.all(
          color:
          const Color(0xFFD8E3EE),
        ),
        boxShadow: [
          BoxShadow(
            color:
            const Color(0xFF0D4C9C)
                .withOpacity(.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _keyOperativo,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              "NÚMERO DE OPERATIVO",
              style: TextStyle(
                color:
                Color(0xFF40566B),
                fontSize: 10,
                fontWeight:
                FontWeight.w900,
              ),
            ),

            const SizedBox(height: 7),

            TextFormField(
              controller:
              controller
                  .controllerOperativo,

              keyboardType:
              TextInputType.number,

              textInputAction:
              TextInputAction.search,

              maxLength: 15,

              autofocus: controller
                  .controllerOperativo
                  .text
                  .isNotEmpty,

              scrollPadding:
              const EdgeInsets.only(
                bottom: 130,
              ),

              decoration: InputDecoration(
                counterText: "",

                hintText: "Ej. 7237253",

                prefixIcon: const Icon(
                  Icons.numbers_rounded,
                  color:
                  Color(0xFF195BA6),
                ),

                suffixIcon: IconButton(
                  onPressed:
                  controller
                      .peticionServerState
                      .value
                      ? null
                      : _verificarOperativo,
                  icon: const Icon(
                    Icons.search_rounded,
                    color:
                    Color(0xFF195BA6),
                  ),
                ),

                filled: true,

                fillColor:
                const Color(0xFFF7FAFD),

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                  borderSide:
                  const BorderSide(
                    color:
                    Color(0xFFD8E3EE),
                  ),
                ),

                enabledBorder:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                  borderSide:
                  const BorderSide(
                    color:
                    Color(0xFFD8E3EE),
                  ),
                ),

                focusedBorder:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                  borderSide:
                  const BorderSide(
                    color:
                    Color(0xFF195BA6),
                    width: 1.5,
                  ),
                ),
              ),

              validator: (value) {
                final String dato =
                (value ?? '')
                    .trim();

                if (dato.isEmpty) {
                  return 'Ingrese el número del operativo';
                }

                final int id =
                    int.tryParse(dato) ??
                        0;

                if (id <= 0) {
                  return 'Número de operativo no válido';
                }

                return null;
              },

              onFieldSubmitted: (_) {
                _verificarOperativo();
              },
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: Obx(
                    () => ElevatedButton.icon(
                  onPressed: controller
                      .peticionServerState
                      .value
                      ? null
                      : _verificarOperativo,

                  icon: controller
                      .peticionServerState
                      .value
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color:
                      Colors.white,
                    ),
                  )
                      : const Icon(
                    Icons
                        .search_rounded,
                  ),

                  label: Text(
                    controller
                        .peticionServerState
                        .value
                        ? "VERIFICANDO..."
                        : "VERIFICAR OPERATIVO",
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),

                  style:
                  ElevatedButton
                      .styleFrom(
                    backgroundColor:
                    const Color(
                      0xFF195BA6,
                    ),
                    foregroundColor:
                    Colors.white,
                    minimumSize:
                    const Size
                        .fromHeight(
                      48,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verificarOperativo() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final String numero =
    controller.controllerOperativo.text.trim();

    debugPrint('==========================================');
    debugPrint('PAGE ANEXARSE -> BOTÓN VERIFICAR');
    debugPrint('OPERATIVO DIGITADO: $numero');
    debugPrint('==========================================');

    if (numero.isEmpty) {
      _keyOperativo.currentState?.validate();
      return;
    }

    final bool resultado =
    await controller.consultarOperativo(
      key: _keyOperativo,
    );

    debugPrint(
      'PAGE ANEXARSE -> RESULTADO CONSULTA: $resultado',
    );
  }

  // ============================================================
  // RESULTADO
  // ============================================================

  Widget _resultadoOperativo() {
    final Anexarse? data =
        controller.datosAnexarse.value;

    if (data == null) {
      return const SizedBox.shrink();
    }

    final bool valido =
        controller
            .operativoValido.value;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: valido
              ? const Color(
            0xFFB8DAC7,
          )
              : const Color(
            0xFFE6B3AF,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black
                .withOpacity(.035),
            blurRadius: 9,
            offset:
            const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.all(
              11,
            ),
            decoration: BoxDecoration(
              color: valido
                  ? const Color(
                0xFFEAF7F0,
              )
                  : const Color(
                0xFFFFEFED,
              ),
              borderRadius:
              const BorderRadius
                  .only(
                topLeft:
                Radius.circular(17),
                topRight:
                Radius.circular(17),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  valido
                      ? Icons
                      .verified_rounded
                      : Icons
                      .warning_amber_rounded,
                  color: valido
                      ? const Color(
                    0xFF198754,
                  )
                      : const Color(
                    0xFFB42318,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        valido
                            ? 'OPERATIVO VERIFICADO'
                            : 'OPERATIVO NO DISPONIBLE',
                        style: TextStyle(
                          color: valido
                              ? const Color(
                            0xFF176F47,
                          )
                              : const Color(
                            0xFF9D2821,
                          ),
                          fontSize: 11,
                          fontWeight:
                          FontWeight
                              .w900,
                        ),
                      ),

                      if (controller
                          .mensajeValidacion
                          .value
                          .isNotEmpty)
                        Text(
                          controller
                              .mensajeValidacion
                              .value,
                          style: TextStyle(
                            color: valido
                                ? const Color(
                              0xFF559073,
                            )
                                : const Color(
                              0xFFAD615B,
                            ),
                            fontSize: 7.5,
                            fontWeight:
                            FontWeight
                                .w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.all(12),
            child: Column(
              children: [
                _dato(
                  'OPERATIVO',
                  '${data.idHdrEvento}',
                  Icons.numbers_rounded,
                ),

                _dato(
                  'TIPO DE OPERATIVO',
                  data.descripcion,
                  Icons
                      .assignment_outlined,
                ),

                _dato(
                  'FECHA',
                  data.fechaEvento,
                  Icons
                      .calendar_month_outlined,
                ),

                _dato(
                  'ESTADO OPERATIVO',
                  data.estadoOperativo,
                  Icons
                      .info_outline_rounded,
                ),

                if (data.estadoPolicia
                    .trim()
                    .isNotEmpty)
                  _dato(
                    'ESTADO POLICÍA',
                    data.estadoPolicia,
                    Icons
                        .local_police_outlined,
                  ),

                _dato(
                  'ZONA',
                  data.zona,
                  Icons
                      .location_on_outlined,
                ),

                _dato(
                  'SUBZONA',
                  data.subzona,
                  Icons
                      .location_city_outlined,
                ),

                _dato(
                  'DISTRITO',
                  data.distrito,
                  Icons.map_outlined,
                ),

                _dato(
                  'CIRCUITO',
                  data.circuito,
                  Icons.route_outlined,
                ),

                _dato(
                  'SUBCIRCUITO',
                  data.subcircuito,
                  Icons
                      .alt_route_rounded,
                ),

                if (data.policia
                    .trim()
                    .isNotEmpty)
                  _dato(
                    'SERVIDOR POLICIAL',
                    data.policia,
                    Icons
                        .local_police_outlined,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dato(
      String titulo,
      String valor,
      IconData icono,
      ) {
    final String dato =
    valor.trim().isEmpty
        ? 'NO REGISTRADO'
        : valor.trim();

    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 7,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(
                0xFFEAF2FB,
              ),
              borderRadius:
              BorderRadius.circular(
                8,
              ),
            ),
            child: Icon(
              icono,
              size: 16,
              color:
              const Color(
                0xFF195BA6,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  titulo,
                  style:
                  const TextStyle(
                    color: Color(
                      0xFF8593A0,
                    ),
                    fontSize: 7.5,
                    fontWeight:
                    FontWeight
                        .w900,
                  ),
                ),

                Text(
                  dato,
                  style:
                  const TextStyle(
                    color: Color(
                      0xFF32495E,
                    ),
                    fontSize: 10,
                    fontWeight:
                    FontWeight
                        .w700,
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
  // ANEXARSE
  // ============================================================

  Widget _botonAnexarse() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed:
        controller.puedeAnexarse()
            ? _confirmarAnexarse
            : null,

        icon: const Icon(
          Icons.group_add_rounded,
        ),

        label: const Text(
          'ANEXARSE Y CONTINUAR',
          style: TextStyle(
            fontWeight:
            FontWeight.w900,
          ),
        ),

        style:
        ElevatedButton.styleFrom(
          backgroundColor:
          const Color(0xFF198754),
          foregroundColor:
          Colors.white,
          minimumSize:
          const Size.fromHeight(
            50,
          ),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              13,
            ),
          ),
        ),
      ),
    );
  }

  void _confirmarAnexarse() {
    final Anexarse? data =
        controller.datosAnexarse.value;

    if (data == null) return;

    DialogosAwesome.getWarningSiNo(
      title: 'ANEXARSE AL OPERATIVO',
      descripcion:
      '¿Está seguro de anexarse al operativo N° ${data.idHdrEvento}?\n\n${data.descripcion}',
      btnOkOnPress: () {
        controller
            .continuarOperativo();
      },
      btnCancelOnPress: () {},
    );
  }

  // ============================================================
  // NUEVA CONSULTA
  // ============================================================

  Widget _botonNuevaConsulta() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed:
        controller.nuevaConsulta,

        icon: const Icon(
          Icons.refresh_rounded,
        ),

        label: const Text(
          'CONSULTAR OTRO OPERATIVO',
          style: TextStyle(
            fontWeight:
            FontWeight.w800,
          ),
        ),

        style:
        OutlinedButton.styleFrom(
          foregroundColor:
          const Color(0xFF195BA6),
          minimumSize:
          const Size.fromHeight(
            46,
          ),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _mensajeNoValido() {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color:
        const Color(0xFFFFF1EF),
        borderRadius:
        BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons
                .error_outline_rounded,
            color:
            Color(0xFFB42318),
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Text(
              controller
                  .mensajeValidacion
                  .value
                  .isEmpty
                  ? 'El operativo no está disponible para anexarse.'
                  : controller
                  .mensajeValidacion
                  .value,
              style: const TextStyle(
                color:
                Color(0xFF8D312A),
                fontSize: 10,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}