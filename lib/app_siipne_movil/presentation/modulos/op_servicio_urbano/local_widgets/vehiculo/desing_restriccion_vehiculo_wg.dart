part of '../operativo_polco_local_widgets.dart';

class DesingRestriccionVehiculoWg extends StatelessWidget {
  final RestriccionPj data;
  final Color colorTexto;
  final Color colorTitulos;

  const DesingRestriccionVehiculoWg({
    Key? key,
    required this.data,
    required this.colorTexto,
    required this.colorTitulos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool robado = data.data.robado;

    final Color principal = robado
        ? const Color(0xFFB42318)
        : const Color(0xFF16834B);

    final Color fondo = robado
        ? const Color(0xFFFFF6F5)
        : const Color(0xFFF2FAF5);

    final Color borde = robado
        ? const Color(0xFFE9B7B2)
        : const Color(0xFFB9DCC8);

    const Color tituloOscuro = Color(0xFF183B56);
    const Color textoOscuro = Color(0xFF425B70);

    final String detalle = data.data.detBusqueda.trim().isNotEmpty
        ? data.data.detBusqueda.trim()
        : robado
        ? 'VEHÍCULO CON RESTRICCIÓN VIGENTE'
        : 'NO EXISTEN RESTRICCIONES REGISTRADAS';

    final int cantidad = data.data.cantidadRestricciones;

    final bool tieneUnaRestriccion =
        cantidad == 1 && data.data.restricciones.isNotEmpty;

    final bool tieneVariasRestricciones =
        cantidad > 1 && data.data.restricciones.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borde, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: principal.withOpacity(.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================================
          // ENCABEZADO
          // ============================================================
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: principal.withOpacity(.11),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  robado
                      ? Icons.warning_amber_rounded
                      : Icons.verified_user_rounded,
                  color: principal,
                  size: 27,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RESTRICCIONES DEL VEHÍCULO',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: tituloOscuro,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .15,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Verificación Policía Judicial',
                      style: TextStyle(
                        color: principal,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: principal,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: principal.withOpacity(.20),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  robado ? 'ALERTA' : 'NORMAL',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .45,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          // ============================================================
          // ESTADO PRINCIPAL
          // ============================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: principal.withOpacity(.18)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: principal.withOpacity(.09),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    robado
                        ? Icons.report_problem_rounded
                        : Icons.check_circle_rounded,
                    color: principal,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        robado ? 'VEHÍCULO ROBADO' : 'VEHÍCULO SIN NOVEDAD',
                        style: TextStyle(
                          color: principal,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        detalle,
                        style: const TextStyle(
                          color: textoOscuro,
                          fontSize: 8.5,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ============================================================
          // UNA SOLA RESTRICCIÓN
          // ============================================================
          if (tieneUnaRestriccion) ...[
            const SizedBox(height: 9),

            _cardRestriccionPrincipal(data.data.restricciones.first),
          ],

          // ============================================================
          // VARIAS RESTRICCIONES - RESUMEN
          // ============================================================
          if (tieneVariasRestricciones) ...[
            const SizedBox(height: 9),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: principal.withOpacity(.16)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: principal.withOpacity(.09),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      Icons.format_list_numbered_rounded,
                      color: principal,
                      size: 18,
                    ),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'RESTRICCIONES REGISTRADAS',
                          style: TextStyle(
                            color: tituloOscuro,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .25,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          '$cantidad registros encontrados',
                          style: const TextStyle(
                            color: textoOscuro,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: principal.withOpacity(.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$cantidad',
                      style: TextStyle(
                        color: principal,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 9),

            // ==========================================================
            // VER TODAS
            // ==========================================================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    _mostrarTodasRestricciones(data.data.restricciones),
                icon: const Icon(Icons.list_alt_rounded, size: 17),
                label: Text('VER TODAS ($cantidad)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB42318),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .3,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================================================================
  // CARD PARA UNA SOLA RESTRICCIÓN
  // ================================================================
  static Widget _cardRestriccionPrincipal(RestriccionPjDetalle restriccion) {
    final String estado = restriccion.estado.trim().toUpperCase();

    final bool esAlerta = estado == 'ROBADO' || estado == 'ALERTA';

    final Color principal = esAlerta
        ? const Color(0xFFB42318)
        : const Color(0xFF16834B);

    final Color fondo = esAlerta
        ? const Color(0xFFFFF6F5)
        : const Color(0xFFF2FAF5);

    final Color borde = esAlerta
        ? const Color(0xFFE9B7B2)
        : const Color(0xFFB9DCC8);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borde, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================================
          // CABECERA
          // ============================================================
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: principal.withOpacity(.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  esAlerta
                      ? Icons.warning_amber_rounded
                      : Icons.verified_user_rounded,
                  color: principal,
                  size: 19,
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DETALLE DE LA RESTRICCIÓN',
                      style: TextStyle(
                        color: Color(0xFF183B56),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .2,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      estado.isNotEmpty ? estado : 'RESTRICCIÓN REGISTRADA',
                      style: TextStyle(
                        color: principal,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: principal,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  esAlerta ? 'ALERTA' : 'NORMAL',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          // ============================================================
          // DATOS
          // ============================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: principal.withOpacity(.13)),
            ),
            child: Column(
              children: [
                if (restriccion.fechaIncidente.trim().isNotEmpty)
                  _DatoRestriccionDialogo(
                    icono: Icons.calendar_month_rounded,
                    titulo: 'FECHA DEL INCIDENTE',
                    valor: restriccion.fechaIncidente.trim(),
                    principal: principal,
                  ),

                if (restriccion.fechaIncidente.trim().isNotEmpty &&
                    restriccion.direccion.trim().isNotEmpty)
                  const SizedBox(height: 8),

                if (restriccion.direccion.trim().isNotEmpty)
                  _DatoRestriccionDialogo(
                    icono: Icons.location_on_rounded,
                    titulo: 'DIRECCIÓN DEL INCIDENTE',
                    valor: restriccion.direccion.trim(),
                    principal: principal,
                  ),

                if (restriccion.empresa.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),

                  _DatoRestriccionDialogo(
                    icono: Icons.account_balance_rounded,
                    titulo: 'ENTIDAD REGISTRANTE',
                    valor: restriccion.empresa.trim(),
                    principal: principal,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // MOSTRAR TODAS LAS RESTRICCIONES
  // ================================================================
  static void _mostrarTodasRestricciones(
    List<RestriccionPjDetalle> restricciones,
  ) {
    Get.dialog<void>(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 620,
            maxHeight: Get.height * .84,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // ======================================================
                // HEADER
                // ======================================================
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF9F2118),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.gavel_rounded,
                        color: Colors.white,
                        size: 23,
                      ),

                      const SizedBox(width: 9),

                      Expanded(
                        child: Text(
                          'RESTRICCIONES (${restricciones.length})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: Get.back,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),

                // ======================================================
                // LISTA
                // ======================================================
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: restricciones.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 9),
                    itemBuilder: (_, index) {
                      return _cardRestriccionDialogo(
                        restricciones[index],
                        index + 1,
                      );
                    },
                  ),
                ),

                // ======================================================
                // BOTÓN ENTENDIDO
                // ======================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: Get.back,
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('ENTENDIDO'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF173F6B),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.72),
    );
  }

  // ================================================================
  // CARD DE CADA RESTRICCIÓN DEL DIÁLOGO
  // ================================================================
  static Widget _cardRestriccionDialogo(
    RestriccionPjDetalle restriccion,
    int numero,
  ) {
    final String estado = restriccion.estado.trim().toUpperCase();

    final bool esAlerta = estado == 'ROBADO' || estado == 'ALERTA';

    final Color principal = esAlerta
        ? const Color(0xFFB42318)
        : const Color(0xFF16834B);

    final Color fondo = esAlerta
        ? const Color(0xFFFFF6F5)
        : const Color(0xFFF2FAF5);

    final Color borde = esAlerta
        ? const Color(0xFFE9B7B2)
        : const Color(0xFFB9DCC8);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borde, width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================================
          // CABECERA
          // ============================================================
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: principal.withOpacity(.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  esAlerta
                      ? Icons.warning_amber_rounded
                      : Icons.verified_user_rounded,
                  color: principal,
                  size: 21,
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RESTRICCIÓN #$numero',
                      style: const TextStyle(
                        color: Color(0xFF183B56),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      estado.isNotEmpty ? estado : 'RESTRICCIÓN REGISTRADA',
                      style: TextStyle(
                        color: principal,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: principal,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  esAlerta ? 'ALERTA' : 'NORMAL',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          // ============================================================
          // INFORMACIÓN
          // ============================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: principal.withOpacity(.13)),
            ),
            child: Column(
              children: [
                if (restriccion.fechaIncidente.trim().isNotEmpty)
                  _DatoRestriccionDialogo(
                    icono: Icons.calendar_month_rounded,
                    titulo: 'FECHA DEL INCIDENTE',
                    valor: restriccion.fechaIncidente.trim(),
                    principal: principal,
                  ),

                if (restriccion.fechaIncidente.trim().isNotEmpty &&
                    restriccion.direccion.trim().isNotEmpty)
                  const SizedBox(height: 8),

                if (restriccion.direccion.trim().isNotEmpty)
                  _DatoRestriccionDialogo(
                    icono: Icons.location_on_rounded,
                    titulo: 'DIRECCIÓN DEL INCIDENTE',
                    valor: restriccion.direccion.trim(),
                    principal: principal,
                  ),

                if (restriccion.empresa.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),

                  _DatoRestriccionDialogo(
                    icono: Icons.account_balance_rounded,
                    titulo: 'ENTIDAD REGISTRANTE',
                    valor: restriccion.empresa.trim(),
                    principal: principal,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// DATO DEL DISEÑO PRINCIPAL
// ====================================================================

class _DatoRestriccionVehiculoWg extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;
  final Color principal;

  const _DatoRestriccionVehiculoWg({
    required this.icono,
    required this.titulo,
    required this.valor,
    required this.principal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: principal.withOpacity(.09),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icono, color: principal, size: 18),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: Color(0xFF183B56),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .25,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                valor,
                style: const TextStyle(
                  color: Color(0xFF425B70),
                  fontSize: 11,
                  height: 1.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ====================================================================
// DATO DEL DIÁLOGO
// ====================================================================

class _DatoRestriccionDialogo extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;
  final Color principal;

  const _DatoRestriccionDialogo({
    required this.icono,
    required this.titulo,
    required this.valor,
    required this.principal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: principal.withOpacity(.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icono, color: principal, size: 16),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: Color(0xFF183B56),
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .2,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                valor,
                style: const TextStyle(
                  color: Color(0xFF425B70),
                  fontSize: 9.5,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
