part of '../../pages.dart';

mixin EstadosOperativoViewMixin on OpServicioUrbanoPageBase {
  Widget estadoInicial() {
    return estadoConsulta(
      icono: Icons.manage_search_rounded,
      titulo: "CONSULTA OPERATIVA",
      descripcion: "Seleccione Personas o Vehículos para iniciar una consulta.",
    );
  }

  Widget estadoConsulta({
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

  Widget operativoInvalido() {
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
}
