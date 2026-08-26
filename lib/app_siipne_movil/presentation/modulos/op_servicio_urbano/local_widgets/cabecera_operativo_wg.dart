part of '../../pages.dart';

mixin CabeceraOperativoViewMixin on OpServicioUrbanoPageBase {
  Widget cabeceraOperativo() {
    return Obx(() {
      final int idOperativo = controller.idHdrEventoActual.value;

      final bool puedeFinalizar = controller.puedeFinalizarOperativo.value;
      final String nombreOperativo = controller.nombreOperativoActual.value
          .trim();
      final bool anexado = controller.esOperativoAnexado.value;

      final bool pendiente = controller.esOperativoPendiente.value;

      final String tipo = pendiente
          ? "OPERATIVO PENDIENTE"
          : anexado
          ? "OPERATIVO ANEXADO"
          : "OPERATIVO EN EJECUCIÓN";

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(6, 4, 6, 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: const Color(0xFFD5E1EC)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D4C9C).withOpacity(.10),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(11, 10, 11, 9),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.14),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: Colors.white.withOpacity(.17),
                          ),
                        ),
                        child: const Icon(
                          Icons.local_police_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 9),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tipo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .35,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF64E39A),
                                    shape: BoxShape.circle,
                                  ),
                                ),

                                const SizedBox(width: 4),

                                const Text(
                                  "ACTIVO",
                                  style: TextStyle(
                                    color: Color(0xFFD8F8E5),
                                    fontSize: 7.2,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                const SizedBox(width: 9),

                                const Icon(
                                  Icons.security_rounded,
                                  color: Color(0xFFDCECFB),
                                  size: 12,
                                ),

                                const SizedBox(width: 3),

                                const Flexible(
                                  child: Text(
                                    "CONSULTAS AUDITADAS",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(0xFFDCECFB),
                                      fontSize: 6.8,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.13),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          anexado
                              ? "ANEXADO"
                              : pendiente
                              ? "RETOMADO"
                              : "APERTURADO",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 6.4,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.13),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: Colors.white.withOpacity(.18)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 33,
                          height: 33,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.numbers_rounded,
                            color: Color(0xFF195BA6),
                            size: 18,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "IDENTIFICADOR DEL OPERATIVO",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.72),
                                  fontSize: 6.4,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .4,
                                ),
                              ),

                              const SizedBox(height: 1),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    idOperativo.toString(),
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                    ),
                                  ),

                                  if (nombreOperativo.isNotEmpty) ...[
                                    const SizedBox(width: 6),

                                    Text(
                                      "·",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.65),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(width: 6),

                                    Expanded(
                                      child: Text(
                                        nombreOperativo.toUpperCase(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(.90),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: .25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF70E7A5),
                          size: 21,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: botonCabeceraOperativo(
                      titulo: "PERSONAL",
                      icono: Icons.groups_2_rounded,
                      color: const Color(0xFF198754),
                      fondo: const Color(0xFFEAF7F0),
                      borde: const Color(0xFFB8DFC9),
                      onTap: controller.peticionServerState.value
                          ? null
                          : mostrarPersonalOperativo,
                    ),
                  ),

                  if (puedeFinalizar) ...[
                    const SizedBox(width: 6),

                    Expanded(
                      child: botonCabeceraOperativo(
                        titulo: "QR",
                        icono: Icons.qr_code_2_rounded,
                        color: const Color(0xFF195BA6),
                        fondo: const Color(0xFFEAF3FC),
                        borde: const Color(0xFFB6CFE5),
                        onTap: controller.peticionServerState.value
                            ? null
                            : mostrarQrOperativo,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: botonCabeceraOperativo(
                        titulo: "FINALIZAR",
                        icono: Icons.edgesensor_low_sharp,
                        color: const Color(0xFFB42318),
                        fondo: const Color(0xFFFFECE9),
                        borde: const Color(0xFFE9BBB7),
                        onTap: controller.peticionServerState.value
                            ? null
                            : mostrarResumenAntesFinalizar,
                      ),
                    ),
                  ],

                  const SizedBox(width: 6),

                  Expanded(
                    child: botonCabeceraOperativo(
                      titulo: "SALIR",
                      icono: Icons.logout_rounded,
                      color: const Color(0xFF586D82),
                      fondo: const Color(0xFFF3F6F9),
                      borde: const Color(0xFFD5DFE8),
                      onTap: controller.peticionServerState.value
                          ? null
                          : confirmarCerrarSesion,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget botonCabeceraOperativo({
    required String titulo,
    required IconData icono,
    required Color color,
    required Color fondo,
    required Color borde,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: fondo,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: borde),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: color, size: 19),

              const SizedBox(height: 2),

              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  titulo,
                  maxLines: 1,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .1,
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
  // CERRAR SESIÓN
  // ============================================================

  void confirmarCerrarSesion() {
    if (controller.peticionServerState.value) {
      return;
    }

    DialogosAwesome.getWarningSiNo(
      title: "CERRAR SESIÓN",
      descripcion:
          "¿Está seguro que desea cerrar la sesión actual?\n\n"
          "El operativo permanecerá activo y podrá retomarlo posteriormente si corresponde.",
      btnOkOnPress: () {
        controller.cerrarSesionOperativo();
      },
      btnCancelOnPress: () {},
    );
  }
}
