part of '../../pages.dart';

mixin BusquedaOperativaViewMixin on OpServicioUrbanoPageBase {
  Widget busquedaTipoOperativo() {
    if (controller.selectPerson.value) {
      final Widget wg = BusquedaTipoOperativoWg(
        key: const ValueKey("consulta_persona"),
        anchoPorcentaje: 95,
        myKey: keyCedula,
        controller: controller.controllerCedula,
        maxLength: 20,
        icono: const Icon(Icons.badge_outlined, color: AppColors.colorIcons),
        keyboardType: TextInputType.number,
        title: "Nro. Documento",
        msjError: "Documento vacío",
        focusNode: controller.focusCedula,
        onTap: confirmarBusquedaPersona,
      );

      return Obx(
        () => controller.ocultarBtnBuscarPersona.value
            ? const SizedBox.shrink()
            : cardBusqueda(
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
      myKey: keyPlaca,
      anchoPorcentaje: 95,
      title: "Placa",
      msjError: "Ingrese una placa válida",
      icono: const Icon(
        Icons.directions_car_rounded,
        color: AppColors.colorIcons,
      ),
      maxLength: 7,
      keyboardType: TextInputType.text,
      onTap: confirmarBusquedaVehiculo,
      focusNode: controller.focusPlaca,
    );

    return Obx(
      () => controller.ocultarBtnBuscarVehiculo.value
          ? const SizedBox.shrink()
          : cardBusqueda(
              titulo: "CONSULTA DE VEHÍCULO",
              descripcion: "Ingrese la placa del vehículo a consultar.",
              icono: Icons.directions_car_rounded,
              child: wg,
            ),
    );
  }

  Widget cardBusqueda({
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
           * comboVariableResultado().
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

  Future<void> confirmarBusquedaPersona() async {
    final bool valido = keyCedula.currentState?.validate() ?? false;

    if (!valido) return;

    final String dato = controller.controllerCedula.text.trim();

    if (dato.isEmpty) return;

    await cerrarTeclado();

    await mostrarPreparandoConsulta(tipo: "CONSULTA DE PERSONA");

    dialogoConfirmarBusqueda(
      tipo: "PERSONA",
      etiqueta: "NÚMERO DE DOCUMENTO",
      dato: dato,
      icono: Icons.person_search_rounded,
      onConfirmar: () async {
        final bool resultado = await controller.consultarPersonaPorCedula(
          key: keyCedula,
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

  Future<void> confirmarBusquedaVehiculo() async {
    final bool valido = keyPlaca.currentState?.validate() ?? false;

    if (!valido) return;

    final String dato = controller.controllerPlaca.text.trim().toUpperCase();

    if (dato.isEmpty) return;

    await cerrarTeclado();

    await mostrarPreparandoConsulta(tipo: "CONSULTA DE VEHÍCULO");

    dialogoConfirmarBusqueda(
      tipo: "VEHÍCULO",
      etiqueta: "PLACA",
      dato: dato,
      icono: Icons.directions_car_rounded,
      onConfirmar: () async {
        final bool resultado = await controller.consultarVehiculoPorPlaca(
          key: keyPlaca,
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

  Future<void> cerrarTeclado() async {
    FocusManager.instance.primaryFocus?.unfocus();

    await Future.delayed(const Duration(milliseconds: 180));
  }

  // ============================================================
  // LOADING PREPARACIÓN
  // ============================================================

  Future<void> mostrarPreparandoConsulta({required String tipo}) async {
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
}
