part of '../../pages.dart';

mixin TipoConsultaViewMixin on OpServicioUrbanoPageBase {
  Widget tipoDeConsulta() {
    return Obx(
      () => Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.fromLTRB(7, 7, 7, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD7E2ED)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D4C9C).withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 1, 4, 7),
              child: Row(
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    color: Color(0xFF60758A),
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "SELECCIONE UN TIPO DE CONSULTA",
                      style: TextStyle(
                        color: Color(0xFF52687C),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: botonConsulta(
                    seleccionado: controller.selectPerson.value,
                    titulo: "PERSONA",
                    subtitulo: "Documento de identidad",
                    detalle: "CONSULTA CIUDADANO",
                    icono: Icons.person_search_rounded,
                    onTap: controller.seleccionarPersona,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: botonConsulta(
                    seleccionado: controller.selectVehiculo.value,
                    titulo: "VEHÍCULO",
                    subtitulo: "Número de placa",
                    detalle: "CONSULTA AUTOMOTOR",
                    icono: Icons.directions_car_filled_rounded,
                    onTap: controller.seleccionarVehiculo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget botonConsulta({
    required bool seleccionado,
    required String titulo,
    required String subtitulo,
    required String detalle,
    required IconData icono,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          height: 108,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            gradient: seleccionado
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1764B2), Color(0xFF073B78)],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFAFCFE), Color(0xFFF1F5F9)],
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: seleccionado
                  ? const Color(0xFF1764B2)
                  : const Color(0xFFD8E3ED),
              width: seleccionado ? 2 : 1,
            ),
            boxShadow: seleccionado
                ? [
                    BoxShadow(
                      color: const Color(0xFF195BA6).withOpacity(.20),
                      blurRadius: 11,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: seleccionado
                          ? Colors.white.withOpacity(.16)
                          : const Color(0xFFE4EEF8),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      icono,
                      size: 25,
                      color: seleccionado
                          ? Colors.white
                          : const Color(0xFF1764B2),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: seleccionado
                                ? Colors.white
                                : const Color(0xFF253E55),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          subtitulo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: seleccionado
                                ? Colors.white.withOpacity(.78)
                                : const Color(0xFF7C8998),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: seleccionado
                          ? Colors.white
                          : const Color(0xFFE7EDF3),
                    ),
                    child: Icon(
                      seleccionado
                          ? Icons.check_rounded
                          : Icons.circle_outlined,
                      size: 22,
                      color: seleccionado
                          ? const Color(0xFF1764B2)
                          : const Color(0xFFA1ACB7),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: seleccionado
                      ? Colors.white.withOpacity(.12)
                      : const Color(0xFFEAF0F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  seleccionado ? "$detalle · SELECCIONADO" : detalle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: seleccionado
                        ? Colors.white
                        : const Color(0xFF607589),
                    fontSize: 6.8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
