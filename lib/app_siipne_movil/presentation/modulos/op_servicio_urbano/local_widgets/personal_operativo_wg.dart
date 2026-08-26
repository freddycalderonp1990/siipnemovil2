part of '../../pages.dart';

mixin PersonalOperativoViewMixin on OpServicioUrbanoPageBase {
  Future<void> mostrarPersonalOperativo() async {
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

    dialogoPersonalOperativo(context);
  }

  void dialogoPersonalOperativo(BuildContext context) {
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
                            (index) => cardIntegranteOperativo(
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

  Widget cardIntegranteOperativo({
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
}
