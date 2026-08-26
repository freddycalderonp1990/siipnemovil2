part of '../../pages.dart';

mixin VehiculoResultadoViewMixin on OpServicioUrbanoPageBase {
  Widget muestraDatosVehiculo() {
    return Obx(() {
      if (controller.dataVehiculo.isEmpty) {
        return estadoConsulta(
          icono: Icons.directions_car_outlined,
          titulo: "CONSULTA DE VEHÍCULOS",
          descripcion:
              "Ingrese una placa para visualizar la información del vehículo.",
        );
      }

      return Column(
        children: [
          resultadoConsultaVariable(),

          Padding(
            padding: const EdgeInsets.fromLTRB(6, 3, 6, 15),
            child: DesingDatosVehiculoWg(
              data: controller.dataVehiculo.first,
              onPressedNewConsulta: () {
                nuevaConsultaVehiculo();
              },
              onPressedOcupantes: abrirPersonasVehiculo,
            ),
          ),
        ],
      );
    });
  }

  // ============================================================
  // NUEVA CONSULTA PERSONA
  // ============================================================

  Future<void> nuevaConsultaPersona() async {
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

  Future<void> nuevaConsultaVehiculo() async {
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

  Widget panelPersonasVehiculo() {
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

            diagramaVehiculoPersonas(),

            const SizedBox(height: 9),

            selectorRolPersonaVehiculo(),

            const SizedBox(height: 7),

            busquedaPersonaVehiculo(),

            if (tieneConductor || ocupantes > 0) ...[
              const SizedBox(height: 9),

              personasRegistradasVehiculo(),
            ],
          ],
        ),
      );
    });
  }

  Widget diagramaVehiculoPersonas() {
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

  Widget selectorRolPersonaVehiculo() {
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

  Widget busquedaPersonaVehiculo() {
    return BusquedaTipoOperativoWg(
      key: const ValueKey("persona_relacionada_vehiculo"),
      anchoPorcentaje: 100,
      myKey: keyCedulaVehiculo,
      controller: controller.controllerCedulaVehiculo,
      maxLength: 20,
      icono: const Icon(Icons.badge_outlined, color: AppColors.colorIcons),
      keyboardType: TextInputType.number,
      title: controller.tipoPersonaVehiculo.value == 'CONDUCTOR'
          ? "Documento del conductor"
          : "Documento del ocupante",
      msjError: "Documento vacío",
      onTap: confirmarPersonaVehiculo,
    );
  }

  Future<void> confirmarPersonaVehiculo() async {
    final bool valido = keyCedulaVehiculo.currentState?.validate() ?? false;

    if (!valido) return;

    final String documento = controller.controllerCedulaVehiculo.text.trim();

    if (documento.isEmpty) return;

    await cerrarTeclado();

    final String rol = controller.tipoPersonaVehiculo.value;

    dialogoConfirmarBusqueda(
      tipo: rol,
      etiqueta: "NÚMERO DE DOCUMENTO",
      dato: documento,
      icono: rol == 'CONDUCTOR'
          ? Icons.person_pin_rounded
          : Icons.person_add_alt_1_rounded,
      onConfirmar: () async {
        final bool resultado = await controller
            .consultarPersonaRelacionadaVehiculo(key: keyCedulaVehiculo);

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

  Widget personasRegistradasVehiculo() {
    return Obx(
      () => Column(
        children: [
          if (controller.dataPersona_conductor.isNotEmpty)
            cardPersonaRelacionada(
              titulo: "CONDUCTOR",
              icono: Icons.person_pin_circle_rounded,
              data: controller.dataPersona_conductor.first,
              onEliminar: controller.eliminarConductorVehiculoLocal,
            ),

          ...List<Widget>.generate(
            controller.dataPersona_ocupantes.length,
            (int index) => cardPersonaRelacionada(
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

  Widget cardPersonaRelacionada({
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

  void abrirPersonasVehiculo() {
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
