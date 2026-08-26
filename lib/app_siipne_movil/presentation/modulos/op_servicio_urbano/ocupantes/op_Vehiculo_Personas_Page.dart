part of '../../pages.dart';

class OpVehiculoPersonasPage extends StatefulWidget {
  const OpVehiculoPersonasPage({super.key});

  @override
  State<OpVehiculoPersonasPage> createState() => _OpVehiculoPersonasPageState();
}

class _OpVehiculoPersonasPageState extends State<OpVehiculoPersonasPage> {
  late final OpServicioUrbanoController controller;

  final GlobalKey<FormState> _keyPersonaVehiculo = GlobalKey<FormState>();
  final GlobalKey _keyCampoDocumento = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusDocumento = FocusNode();

  int? _detalleVisibleId;

  @override
  void initState() {
    super.initState();
    controller = Get.find<OpServicioUrbanoController>();
    _focusDocumento.addListener(_onFocusDocumento);
  }

  @override
  void dispose() {
    _focusDocumento.removeListener(_onFocusDocumento);
    _focusDocumento.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocusDocumento() {
    if (!_focusDocumento.hasFocus) return;

    Future.delayed(
      const Duration(milliseconds: 280),
      _mostrarCampoSobreTeclado,
    );
  }

  Future<void> _mostrarCampoSobreTeclado() async {
    if (!mounted) return;

    final BuildContext? context = _keyCampoDocumento.currentContext;

    if (context == null) return;

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      alignment: .28,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final double teclado = MediaQuery.of(context).viewInsets.bottom;

    return WorkAreaPageSiipneMovilWidget(
      showGps: true,
      mostrarBtnAtras: true,
      contenidoExpandido: true,
      title: "PERSONAS DEL VEHÍCULO",
      peticionServer: controller.paginaPersonasVehiculoLoading,
      contenido: Obx(() {
        if (controller.dataVehiculo.isEmpty) {
          return _sinVehiculo();
        }

        final bool conductorRegistrado =
            controller.dataPersona_conductor.isNotEmpty;

        final int cantidadOcupantes = controller.dataPersona_ocupantes.length;

        final String tipoSeleccionado = controller.tipoPersonaVehiculo.value;

        final bool cargando = controller.consultandoPersonaVehiculo.value;

        final DatosVehiculoSiipneData vehiculo =
            controller.dataVehiculo.first.datosVehiculo.data;

        return ListView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(7, 7, 7, teclado + 28),
          children: [
            _cabeceraVehiculo(vehiculo),

            const SizedBox(height: 7),

            _resumenPersonas(
              conductorRegistrado: conductorRegistrado,
              cantidadOcupantes: cantidadOcupantes,
            ),

            const SizedBox(height: 7),

            _accionesRegistro(
              conductorRegistrado: conductorRegistrado,
              tipoSeleccionado: tipoSeleccionado,
              cargando: cargando,
            ),

            const SizedBox(height: 8),

            _personasRegistradas(
              conductorRegistrado: conductorRegistrado,
              cantidadOcupantes: cantidadOcupantes,
            ),

            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }

  // ============================================================
  // CABECERA VEHÍCULO
  // ============================================================

  Widget _cabeceraVehiculo(DatosVehiculoSiipneData vehiculo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF195BA6).withOpacity(.16),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.14),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.directions_car_filled_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "VEHÍCULO CONSULTADO",
                  style: TextStyle(
                    color: Color(0xCCFFFFFF),
                    fontSize: 6.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .25,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  vehiculo.placa.trim().isEmpty ? "SIN PLACA" : vehiculo.placa,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .7,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  "${vehiculo.marca} · ${vehiculo.modelo}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xE6FFFFFF),
                    fontSize: 7.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  "HDR",
                  style: TextStyle(
                    color: Color(0xBFFFFFFF),
                    fontSize: 5.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Text(
                  "#${controller.idHdrEventoResumVehiculo}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 6.3,
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

  // ============================================================
  // RESUMEN PERSONAS
  // ============================================================

  Widget _resumenPersonas({
    required bool conductorRegistrado,
    required int cantidadOcupantes,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFD8E3ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.account_tree_outlined,
                color: Color(0xFF195BA6),
                size: 16,
              ),
              SizedBox(width: 5),
              Text(
                "PERSONAS RELACIONADAS",
                style: TextStyle(
                  color: Color(0xFF29445D),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _estadoPersona(
                  icon: Icons.person_pin_rounded,
                  titulo: "CONDUCTOR",
                  detalle: conductorRegistrado ? "REGISTRADO" : "PENDIENTE",
                  activo: conductorRegistrado,
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: _estadoPersona(
                  icon: Icons.groups_2_rounded,
                  titulo: "OCUPANTES",
                  detalle:
                      "$cantidadOcupantes REGISTRADO${cantidadOcupantes == 1 ? '' : 'S'}",
                  activo: cantidadOcupantes > 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _estadoPersona({
    required IconData icon,
    required String titulo,
    required String detalle,
    required bool activo,
  }) {
    return Container(
      height: 55,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: activo ? const Color(0xFFEAF7F0) : const Color(0xFFF5F7F9),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: activo ? const Color(0xFFAFD9C0) : const Color(0xFFDCE4EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: activo ? const Color(0xFFDDF2E6) : const Color(0xFFE8EDF2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: activo ? const Color(0xFF198754) : const Color(0xFF82909D),
              size: 16,
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: activo
                        ? const Color(0xFF267149)
                        : const Color(0xFF53697D),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                Text(
                  detalle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF8996A3),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
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
  // FORMULARIO AGREGAR PERSONA
  // ============================================================

  Widget _accionesRegistro({
    required bool conductorRegistrado,
    required String tipoSeleccionado,
    required bool cargando,
  }) {
    final bool esConductor = tipoSeleccionado == "CONDUCTOR";

    return Container(
      key: _keyCampoDocumento,
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFD8E3ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.person_add_alt_1_rounded,
                color: Color(0xFF195BA6),
                size: 15,
              ),
              SizedBox(width: 5),
              Text(
                "AGREGAR PERSONA AL VEHÍCULO",
                style: TextStyle(
                  color: Color(0xFF52687C),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          Row(
            children: [
              Expanded(
                child: _botonTipo(
                  titulo: conductorRegistrado ? "CONDUCTOR ✓" : "CONDUCTOR",
                  icon: Icons.person_pin_rounded,
                  seleccionado: esConductor,
                  habilitado: !conductorRegistrado,
                  onTap: () {
                    controller.seleccionarTipoPersonaVehiculo("CONDUCTOR");
                  },
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: _botonTipo(
                  titulo: "OCUPANTE",
                  icon: Icons.airline_seat_recline_normal_rounded,
                  seleccionado: !esConductor,
                  habilitado: true,
                  onTap: () {
                    controller.seleccionarTipoPersonaVehiculo("OCUPANTE");
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          _variableResultadoPersona(),

          const SizedBox(height: 8),

          Form(
            key: _keyPersonaVehiculo,
            child: TextFormField(
              focusNode: _focusDocumento,
              controller: controller.controllerCedulaVehiculo,
              enabled: !cargando,
              keyboardType: TextInputType.number,
              maxLength: 20,
              textInputAction: TextInputAction.search,
              scrollPadding: const EdgeInsets.only(bottom: 140),
              onTap: () {
                Future.delayed(
                  const Duration(milliseconds: 280),
                  _mostrarCampoSobreTeclado,
                );
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Ingrese un documento";
                }

                return null;
              },
              onFieldSubmitted: (_) {
                if (!cargando) {
                  _consultarPersona();
                }
              },
              decoration: InputDecoration(
                counterText: "",
                hintText: esConductor
                    ? "Documento del conductor"
                    : "Documento del ocupante",
                hintStyle: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8996A3),
                ),
                prefixIcon: Icon(
                  esConductor
                      ? Icons.person_pin_rounded
                      : Icons.airline_seat_recline_normal_rounded,
                  color: const Color(0xFF195BA6),
                  size: 18,
                ),
                suffixIcon: cargando
                    ? const Padding(
                        padding: EdgeInsets.all(13),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF195BA6),
                        ),
                      )
                    : IconButton(
                        onPressed: _consultarPersona,
                        icon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF195BA6),
                        ),
                      ),
                filled: true,
                fillColor: const Color(0xFFF7F9FC),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: Color(0xFFD5E0E9)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    color: Color(0xFF195BA6),
                    width: 1.4,
                  ),
                ),
              ),
            ),
          ),

          if (cargando) ...[
            const SizedBox(height: 6),

            const Row(
              children: [
                SizedBox(
                  width: 13,
                  height: 13,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.7,
                    color: Color(0xFF195BA6),
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "CONSULTANDO INFORMACIÓN...",
                    style: TextStyle(
                      color: Color(0xFF718496),
                      fontSize: 6.3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _botonTipo({
    required String titulo,
    required IconData icon,
    required bool seleccionado,
    required bool habilitado,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: habilitado ? onTap : null,
        borderRadius: BorderRadius.circular(11),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 42,
          decoration: BoxDecoration(
            gradient: seleccionado
                ? const LinearGradient(
                    colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
                  )
                : null,
            color: seleccionado ? null : const Color(0xFFF5F8FB),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: seleccionado
                  ? const Color(0xFF195BA6)
                  : const Color(0xFFD7E2EB),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: seleccionado
                    ? Colors.white
                    : habilitado
                    ? const Color(0xFF195BA6)
                    : const Color(0xFFAAB4BE),
              ),

              const SizedBox(width: 5),

              Flexible(
                child: Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: seleccionado
                        ? Colors.white
                        : habilitado
                        ? const Color(0xFF52687C)
                        : const Color(0xFFAAB4BE),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
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
  // VARIABLE RESULTADO PERSONA
  // ============================================================

  Widget _variableResultadoPersona() {
    return Obx(() {
      final bool cargando = controller.cargandoVariablesResultado.value;
      final List<VariablesResultado> variables =
          controller.variablesResultadoPersona;
      final VariablesResultado? seleccionada =
          controller.variableResultadoSeleccionada.value;

      if (cargando) {
        return Container(
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FC),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: const Color(0xFFD8E3ED)),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF195BA6),
                ),
              ),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  "CARGANDO VARIABLES DE RESULTADO...",
                  style: TextStyle(
                    color: Color(0xFF718496),
                    fontSize: 7.5,
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
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E8),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: const Color(0xFFE7D29A)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Color(0xFFA97814),
                size: 16,
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  "NO EXISTEN VARIABLES CONFIGURADAS PARA PERSONA.",
                  style: TextStyle(
                    color: Color(0xFF795E25),
                    fontSize: 7.3,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                padding: EdgeInsets.zero,
                onPressed: controller.recargarVariablesResultado,
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Color(0xFFA97814),
                  size: 18,
                ),
              ),
            ],
          ),
        );
      }

      VariablesResultado valorActual = variables.first;

      if (seleccionada != null &&
          variables.any(
            (VariablesResultado item) =>
                item.idVariable == seleccionada.idVariable,
          )) {
        valorActual = seleccionada;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 2, bottom: 4),
            child: Row(
              children: [
                Icon(
                  Icons.fact_check_outlined,
                  color: Color(0xFF195BA6),
                  size: 13,
                ),
                SizedBox(width: 4),
                Text(
                  "VARIABLE DE RESULTADO",
                  style: TextStyle(
                    color: Color(0xFF607589),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9FD),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: const Color(0xFF9FC2E2)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<VariablesResultado>(
                value: valorActual,
                isExpanded: true,
                borderRadius: BorderRadius.circular(12),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF195BA6),
                ),
                items: variables.map((VariablesResultado variable) {
                  return DropdownMenuItem<VariablesResultado>(
                    value: variable,
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5F0FA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.assignment_turned_in_outlined,
                            color: Color(0xFF195BA6),
                            size: 15,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
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
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: controller.consultandoPersonaVehiculo.value
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
  // ANTECEDENTES PERSONA DEL VEHÍCULO
  // ============================================================

  Future<void> _mostrarAntecedentesPersonaVehiculo(
    DataConsultaPersona persona,
    String rol,
  ) async {
    if (controller.consultandoAntecedentesPersona.value) return;

    FocusManager.instance.primaryFocus?.unfocus();

    final bool resultado = await controller.consultarAntecedentesPersona(
      personaConsulta: persona,
    );

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

    if (antecedentes == null || !mounted) {
      DialogosAwesome.getError(
        title: "INFORMACIÓN NO DISPONIBLE",
        descripcion: "El servidor no devolvió información válida.",
      );
      return;
    }

    _dialogoAntecedentesPersonaVehiculo(
      persona: persona,
      rol: rol,
      antecedentes: antecedentes,
    );
  }

  void _dialogoAntecedentesPersonaVehiculo({
    required DataConsultaPersona persona,
    required String rol,
    required DataAntecedentes antecedentes,
  }) {
    if (!mounted) return;

    String documento = "";
    String nombres = "PERSONA CONSULTADA";

    if (persona.dataSiipne.success) {
      documento = persona.dataSiipne.datosSiipne.documento.trim();

      final String nombreSiipne = persona.dataSiipne.datosSiipne.apenom.trim();

      if (nombreSiipne.isNotEmpty) nombres = nombreSiipne;
    }

    final dynamic dinardap = persona.dataDinardap.datosDinardap;

    if (dinardap != null) {
      if (documento.isEmpty) {
        try {
          documento = (dinardap.cedula ?? "").toString().trim();
        } catch (_) {}
      }

      if (nombres == "PERSONA CONSULTADA") {
        try {
          final String nombreDinardap = (dinardap.nombre ?? "")
              .toString()
              .trim();

          if (nombreDinardap.isNotEmpty) nombres = nombreDinardap;
        } catch (_) {}
      }
    }

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
            constraints: BoxConstraints(maxHeight: alto * .86),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(21),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.23),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(13, 11, 6, 11),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF334E68), Color(0xFF243B53)],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.14),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(
                            Icons.fact_check_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "ANTECEDENTES",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                rol.trim().isEmpty
                                    ? "PERSONA DEL VEHÍCULO"
                                    : rol.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFFD9E4EC),
                                  fontSize: 7.2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
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
                      padding: const EdgeInsets.all(11),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: const Color(0xFFD7E2EC),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F2FC),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.person_search_rounded,
                                    color: Color(0xFF195BA6),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nombres,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFF29445D),
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        documento.isEmpty
                                            ? "DOCUMENTO NO REGISTRADO"
                                            : documento,
                                        style: const TextStyle(
                                          color: Color(0xFF758799),
                                          fontSize: 7.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: tieneAntecedentes
                                  ? const Color(0xFFFFF7ED)
                                  : const Color(0xFFF0F8F4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: tieneAntecedentes
                                    ? const Color(0xFFEBCFAF)
                                    : const Color(0xFFB8DCC8),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  tieneAntecedentes
                                      ? Icons.manage_search_rounded
                                      : Icons.verified_rounded,
                                  color: tieneAntecedentes
                                      ? const Color(0xFFA95D16)
                                      : const Color(0xFF198754),
                                  size: 21,
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Text(
                                    tieneAntecedentes
                                        ? "${antecedentes.antecedentes.length} REGISTRO${antecedentes.antecedentes.length == 1 ? '' : 'S'} ENCONTRADO${antecedentes.antecedentes.length == 1 ? '' : 'S'}"
                                        : "SIN ANTECEDENTES",
                                    style: TextStyle(
                                      color: tieneAntecedentes
                                          ? const Color(0xFF8A541C)
                                          : const Color(0xFF267149),
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w900,
                                    ),
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
                              final String dato =
                                  antecedentes.antecedentes[index];

                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                    color: const Color(0xFFD8E2EB),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 26,
                                      height: 26,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAF2F8),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Text(
                                        "${index + 1}",
                                        style: const TextStyle(
                                          color: Color(0xFF334E68),
                                          fontSize: 8,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    Expanded(
                                      child: Text(
                                        dato,
                                        style: const TextStyle(
                                          color: Color(0xFF405A72),
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w600,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                          const SizedBox(height: 9),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              icon: const Icon(Icons.check_rounded, size: 17),
                              label: const Text(
                                "CERRAR",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(43),
                                backgroundColor: const Color(0xFF334E68),
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
  // CONSULTAR PERSONA
  // ============================================================

  Future<void> _consultarPersona() async {
    if (controller.consultandoPersonaVehiculo.value) {
      return;
    }
    final String documento = controller.controllerCedulaVehiculo.text.trim();

    if (controller.documentoPersonaVehiculoRegistrado(documento)) {
      FocusManager.instance.primaryFocus?.unfocus();

      DialogosAwesome.getWarning(
        title: "PERSONA YA REGISTRADA",
        descripcion:
            "La persona con documento $documento ya se encuentra relacionada con este vehículo.",
      );

      return;
    }
    final bool valido = _keyPersonaVehiculo.currentState?.validate() ?? false;

    if (!valido) {
      _focusDocumento.requestFocus();

      await _mostrarCampoSobreTeclado();

      return;
    }

    final bool eraConductor =
        controller.tipoPersonaVehiculo.value == "CONDUCTOR";

    FocusManager.instance.primaryFocus?.unfocus();

    final bool resultado = await controller.consultarPersonaRelacionadaVehiculo(
      key: _keyPersonaVehiculo,
    );

    if (!resultado) {
      DialogosAwesome.getError(
        title: "CONSULTA NO REALIZADA",
        descripcion: controller.mensajeErrorConsulta.isEmpty
            ? "No fue posible consultar la persona."
            : controller.mensajeErrorConsulta,
      );

      return;
    }

    DataConsultaPersona? persona;

    if (eraConductor && controller.dataPersona_conductor.isNotEmpty) {
      persona = controller.dataPersona_conductor.first;
    } else if (!eraConductor && controller.dataPersona_ocupantes.isNotEmpty) {
      persona = controller.dataPersona_ocupantes.last;
    }

    if (persona != null && mounted) {
      setState(() {
        _detalleVisibleId = persona!.idHdrEventoResum;
      });

      await Future.delayed(const Duration(milliseconds: 150));

      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    }
  }

  // ============================================================
  // PERSONAS REGISTRADAS
  // CUADRÍCULA TIPO VEHÍCULO
  // ============================================================

  Widget _personasRegistradas({
    required bool conductorRegistrado,
    required int cantidadOcupantes,
  }) {
    if (!conductorRegistrado && cantidadOcupantes == 0) {
      return _sinPersonas();
    }

    final List<DataConsultaPersona> personas = <DataConsultaPersona>[];

    final List<String> titulos = <String>[];

    final List<bool> esConductor = <bool>[];

    if (conductorRegistrado) {
      personas.add(controller.dataPersona_conductor.first);

      titulos.add("CONDUCTOR");

      esConductor.add(true);
    }

    for (int i = 0; i < cantidadOcupantes; i++) {
      personas.add(controller.dataPersona_ocupantes[i]);

      titulos.add("OCUPANTE ${i + 1}");

      esConductor.add(false);
    }

    DataConsultaPersona? personaDetalle;
    String tituloDetalle = '';

    for (int i = 0; i < personas.length; i++) {
      if (personas[i].idHdrEventoResum == _detalleVisibleId) {
        personaDetalle = personas[i];

        tituloDetalle = titulos[i];

        break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ======================================================
        // TÍTULO
        // ======================================================

        Row(
          children: [
            const Icon(
              Icons.airline_seat_recline_normal_rounded,
              color: Color(0xFF195BA6),
              size: 16,
            ),

            const SizedBox(width: 5),

            const Expanded(
              child: Text(
                "DISTRIBUCIÓN DE PERSONAS",
                style: TextStyle(
                  color: Color(0xFF52687C),
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.people_alt_rounded,
                    color: Color(0xFF195BA6),
                    size: 11,
                  ),

                  const SizedBox(width: 3),

                  Text(
                    "${personas.length}",
                    style: const TextStyle(
                      color: Color(0xFF195BA6),
                      fontSize: 7,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 7),

        // ======================================================
        // ESTRUCTURA DEL VEHÍCULO
        // ======================================================
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFC7D8E7)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF195BA6).withOpacity(.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Stack(
              children: [
                // ======================================================
                // FONDO VEHÍCULO
                // ======================================================
                Positioned.fill(
                  child: Container(
                    color: const Color(0xFFF2F7FB),
                    child: Opacity(
                      opacity: 1,
                      child: Image.asset(
                        AppSiipneMovilImages.img_auto_fondo,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (_, __, ___) {
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ),

                // ======================================================
                // DEGRADADO PARA MANTENER LEGIBILIDAD
                // ======================================================
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(.74),
                          const Color(0xFFF2F7FB).withOpacity(.82),
                        ],
                      ),
                    ),
                  ),
                ),

                // ======================================================
                // CONTENIDO
                // ======================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(9, 9, 9, 11),
                  child: Column(
                    children: [
                      // =================================================
                      // PARTE FRONTAL
                      // =================================================

                      Container(
                        width: 112,
                        height: 23,
                        decoration: const BoxDecoration(
                          color: Color(0xFF195BA6),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_car_filled_rounded,
                              color: Colors.white,
                              size: 13,
                            ),

                            SizedBox(width: 4),

                            Text(
                              "FRENTE DEL VEHÍCULO",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 5.6,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .25,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // =================================================
                      // CUADRÍCULA
                      // =================================================
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: personas.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 7,
                              mainAxisSpacing: 7,
                              childAspectRatio: .90,
                            ),
                        itemBuilder: (BuildContext context, int index) {
                          final DataConsultaPersona data = personas[index];

                          return _asientoPersonaVehiculo(
                            titulo: titulos[index],
                            data: data,
                            conductor: esConductor[index],
                            seleccionado:
                                _detalleVisibleId == data.idHdrEventoResum,
                            onTap: () {
                              setState(() {
                                if (_detalleVisibleId ==
                                    data.idHdrEventoResum) {
                                  _detalleVisibleId = null;
                                } else {
                                  _detalleVisibleId = data.idHdrEventoResum;
                                }
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ======================================================
        // DETALLE PERSONA
        // ======================================================
        if (personaDetalle != null) ...[
          const SizedBox(height: 9),

          Row(
            children: [
              const Icon(
                Icons.badge_outlined,
                color: Color(0xFF195BA6),
                size: 14,
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Text(
                  "DETALLE · $tituloDetalle",
                  style: const TextStyle(
                    color: Color(0xFF52687C),
                    fontSize: 7.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              IconButton(
                constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    _detalleVisibleId = null;
                  });
                },
                icon: const Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: Color(0xFF718496),
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          DesingBusquedaPorCedulaWidget(
            key: ValueKey("detalle_${personaDetalle.idHdrEventoResum}"),
            dataPersona: <DataConsultaPersona>[personaDetalle],
            onPressedAceptar: () {
              _nuevaConsultaPersonaVehiculo();
            },
            onPressedAntecedentes: () {
              _mostrarAntecedentesPersonaVehiculo(
                personaDetalle!,
                tituloDetalle,
              );
            },
          ),
        ],
      ],
    );
  }

  // ============================================================
  // ASIENTO / TARJETA PERSONA
  // ============================================================

  Widget _asientoPersonaVehiculo({
    required String titulo,
    required DataConsultaPersona data,
    required bool conductor,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    final Map<String, String> persona = _extraerPersona(data);

    final bool alerta = data.ordenCaptura.success;

    final Color colorRol = conductor
        ? const Color(0xFF195BA6)
        : const Color(0xFF198754);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: alerta
                ? const Color(0xFFFFF2F1)
                : seleccionado
                ? const Color(0xFFEAF3FC)
                : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: alerta
                  ? const Color(0xFFE2A19D)
                  : seleccionado
                  ? const Color(0xFF79A9D3)
                  : const Color(0xFFD5E1EB),
              width: seleccionado ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.035),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // =================================================
              // ROL
              // =================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: colorRol.withOpacity(.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      conductor
                          ? Icons.airline_seat_recline_extra_rounded
                          : Icons.airline_seat_recline_normal_rounded,
                      color: colorRol,
                      size: 11,
                    ),

                    const SizedBox(width: 3),

                    Flexible(
                      child: Text(
                        titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorRol,
                          fontSize: 6.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 7),

              // =================================================
              // FOTO
              // =================================================
              Expanded(
                child: Center(
                  child: _fotoPersonaCuadricula(
                    persona["foto"] ?? "",
                    alerta: alerta,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // =================================================
              // NOMBRE
              // =================================================
              Text(
                persona["nombre"] ?? "SIN DATOS",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: alerta
                      ? const Color(0xFF9C241B)
                      : const Color(0xFF29445D),
                  fontSize: 7.4,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
              ),

              const SizedBox(height: 5),

              // =================================================
              // ESTADO
              // =================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: alerta
                      ? const Color(0xFFFFE3E1)
                      : const Color(0xFFEAF7F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      alerta
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_rounded,
                      color: alerta
                          ? const Color(0xFFB42318)
                          : const Color(0xFF198754),
                      size: 11,
                    ),

                    const SizedBox(width: 3),

                    Text(
                      alerta ? "ALERTA" : "REGISTRADO",
                      style: TextStyle(
                        color: alerta
                            ? const Color(0xFFB42318)
                            : const Color(0xFF198754),
                        fontSize: 5.8,
                        fontWeight: FontWeight.w900,
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
  }

  // ============================================================
  // EXTRAER DATOS PERSONA
  // ============================================================

  Map<String, String> _extraerPersona(DataConsultaPersona data) {
    String nombre = "SIN DATOS";

    String fotoSiipne = "";
    dynamic fotoDinardap;

    if (data.dataSiipne.success) {
      final String nombreSiipne = data.dataSiipne.datosSiipne.apenom.trim();

      if (nombreSiipne.isNotEmpty) {
        nombre = nombreSiipne;
      }

      fotoSiipne = data.dataSiipne.datosSiipne.foto64.trim();
    }

    final dynamic dinardap = data.dataDinardap.datosDinardap;

    if (dinardap != null) {
      try {
        final String nombreDinardap = (dinardap.nombre ?? '').toString().trim();

        if ((nombre.trim().isEmpty || nombre == "SIN DATOS") &&
            nombreDinardap.isNotEmpty) {
          nombre = nombreDinardap;
        }
      } catch (_) {}

      try {
        fotoDinardap = dinardap.fotografia;
      } catch (_) {
        fotoDinardap = null;
      }
    }

    final String foto = obtenerFotoPersona(
      fotoSiipne: fotoSiipne,
      fotoDinardap: fotoDinardap,
    );

    return <String, String>{
      "nombre": nombre.trim().isEmpty ? "SIN DATOS" : nombre,
      "foto": foto,
    };
  }

  String obtenerFotoPersona({
    required String? fotoSiipne,
    required dynamic fotoDinardap,
  }) {
    final String dinardap = fotoDinardap?.toString().trim() ?? '';
    final String siipne = fotoSiipne?.trim() ?? '';

    if (_base64ImagenValido(dinardap)) {
      return dinardap;
    }

    if (_base64ImagenValido(siipne)) {
      return siipne;
    }

    return '';
  }

  bool _base64ImagenValido(String valor) {
    if (valor.trim().isEmpty) {
      return false;
    }

    try {
      String limpio = valor.trim();

      if (limpio.contains(',')) {
        limpio = limpio.split(',').last;
      }

      limpio = limpio.replaceAll(RegExp(r'\s+'), '');

      final int resto = limpio.length % 4;

      if (resto != 0) {
        limpio = limpio.padRight(limpio.length + (4 - resto), '=');
      }

      final Uint8List bytes = base64Decode(limpio);

      if (bytes.length < 4) {
        return false;
      }

      final bool jpg = bytes[0] == 0xFF && bytes[1] == 0xD8;

      final bool png =
          bytes.length >= 8 &&
          bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47;

      return jpg || png;
    } catch (_) {
      return false;
    }
  }
  // ============================================================
  // FOTO PERSONA CUADRÍCULA
  // ============================================================

  Widget _fotoPersonaCuadricula(String fotoBase64, {required bool alerta}) {
    Widget placeholder() {
      return const Center(
        child: Icon(Icons.person_rounded, color: Color(0xFF7796B3), size: 31),
      );
    }

    Widget contenedor(Widget child) {
      return Container(
        width: 68,
        height: 75,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2FA),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: alerta ? const Color(0xFFE2A19D) : const Color(0xFFB8CDE0),
            width: 1.3,
          ),
        ),
        child: child,
      );
    }

    if (fotoBase64.trim().isEmpty) {
      return contenedor(placeholder());
    }

    try {
      String limpio = fotoBase64.trim();

      if (limpio.contains(',')) {
        limpio = limpio.split(',').last;
      }

      limpio = limpio
          .replaceAll('\n', '')
          .replaceAll('\r', '')
          .replaceAll(' ', '');

      final int resto = limpio.length % 4;

      if (resto != 0) {
        limpio = limpio.padRight(limpio.length + (4 - resto), '=');
      }

      final bytes = base64Decode(limpio);

      return contenedor(
        Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => placeholder(),
        ),
      );
    } catch (_) {
      return contenedor(placeholder());
    }
  }

  // ============================================================
  // NUEVA CONSULTA
  // ============================================================

  Future<void> _nuevaConsultaPersonaVehiculo() async {
    if (!mounted) return;

    setState(() {
      _detalleVisibleId = null;
    });

    controller.controllerCedulaVehiculo.clear();

    /*
     * Si ya existe conductor,
     * automáticamente continuamos con ocupantes.
     */
    if (controller.dataPersona_conductor.isNotEmpty) {
      controller.tipoPersonaVehiculo.value = "OCUPANTE";
    }

    await Future.delayed(const Duration(milliseconds: 120));

    if (!mounted) return;

    _focusDocumento.requestFocus();

    await _mostrarCampoSobreTeclado();
  }

  // ============================================================
  // SIN PERSONAS
  // ============================================================

  Widget _sinPersonas() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFDDE5ED)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.people_outline_rounded,
            color: Color(0xFF9AA8B5),
            size: 28,
          ),

          SizedBox(height: 5),

          Text(
            "SIN PERSONAS REGISTRADAS",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF718294),
              fontSize: 7.5,
              fontWeight: FontWeight.w900,
            ),
          ),

          SizedBox(height: 2),

          Text(
            "Registre primero el conductor y luego los ocupantes del vehículo.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF99A5B1),
              fontSize: 6.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIN VEHÍCULO
  // ============================================================

  Widget _sinVehiculo() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FC),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Icon(
                Icons.directions_car_outlined,
                color: Color(0xFF195BA6),
                size: 29,
              ),
            ),

            const SizedBox(height: 9),

            const Text(
              "VEHÍCULO NO DISPONIBLE",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF29445D),
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              "No existe información de un vehículo consultado para relacionar personas.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8493A1),
                fontSize: 8,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: Get.back,
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text(
                "REGRESAR",
                style: TextStyle(fontSize: 7.5, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
