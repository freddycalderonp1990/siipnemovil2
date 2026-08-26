part of '../../pages.dart';

mixin ConfirmacionBusquedaViewMixin on OpServicioUrbanoPageBase {
  void dialogoConfirmarBusqueda({
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
                  headerDialogoConfirmacion(
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

                        datoConfirmacion(
                          icono: icono,
                          titulo: etiqueta,
                          valor: dato,
                        ),

                        const SizedBox(height: 9),

                        detalleTipoConsulta(tipo: tipo),

                        const SizedBox(height: 9),

                        avisoAuditoria(),

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

  Widget headerDialogoConfirmacion({
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

  Widget datoConfirmacion({
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

  Widget detalleTipoConsulta({required String tipo}) {
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

  Widget avisoAuditoria() {
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
}
