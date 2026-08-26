part of '../../pages.dart';

mixin PersonaResultadoViewMixin on OpServicioUrbanoPageBase {
  Widget muestraDatosPersona() {
    return Obx(() {
      if (controller.dataPersona.isEmpty) {
        return estadoConsulta(
          icono: Icons.person_search_outlined,
          titulo: "CONSULTA DE PERSONAS",
          descripcion:
              "Ingrese un documento para visualizar la información del ciudadano.",
        );
      }

      return Column(
        children: [
          resultadoConsultaVariable(),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 8),
            child: DesingBusquedaPorCedulaWidget(
              onPressedAceptar: () {
                nuevaConsultaPersona();
              },
              onPressedAntecedentes: () {
                mostrarAntecedentesPersona();
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

  Future<void> mostrarAntecedentesPersona() async {
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

    dialogoAntecedentesPersona(context, antecedentes);
  }

  void dialogoAntecedentesPersona(
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
}
