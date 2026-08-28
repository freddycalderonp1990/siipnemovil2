part of '../../pages.dart';

mixin VariableResultadoViewMixin on OpServicioUrbanoPageBase {
  Widget comboVariableResultado() {
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

  Widget resultadoConsultaVariable() {
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
            comboVariableResultado(),
          ],
        ),
      );
    });
  }
}
