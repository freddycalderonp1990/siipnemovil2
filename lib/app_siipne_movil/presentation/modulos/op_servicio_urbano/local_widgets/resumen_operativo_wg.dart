part of '../../pages.dart';

mixin ResumenOperativoViewMixin on OpServicioUrbanoPageBase {
  Future<void> mostrarResumenAntesFinalizar() async {
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
    dialogoResumenOperativo(resultado);
  }

  void dialogoResumenOperativo(ResultadosOperativo resultado) {
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
                  headerResumenOperativo(
                    dialogContext: dialogContext,
                    resultado: resultado,
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(9, 9, 9, 10),
                      child: Column(
                        children: [
                          resumenPrincipalCompacto(resultado),

                          const SizedBox(height: 7),
                          ubicacionCompacta(resultado),

                          const SizedBox(height: 7),
                          estadisticasCompactas(resultado),

                          if (resultado.variablesResultado.isNotEmpty) ...[
                            const SizedBox(height: 7),

                            variablesResultadoCompactas(resultado),
                          ],

                          const SizedBox(height: 7),

                          avisoFinalizacionResumen(),

                          const SizedBox(height: 9),

                          botonesResumenFinalizacion(dialogContext),
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

  Widget headerResumenOperativo({
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

  Widget avisoFinalizacionResumen() {
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

  Widget botonesResumenFinalizacion(BuildContext dialogContext) {
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
                mostrarFinalizarOperativo();
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
}
