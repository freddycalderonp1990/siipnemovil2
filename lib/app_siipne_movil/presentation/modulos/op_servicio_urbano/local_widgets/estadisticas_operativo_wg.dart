part of '../../pages.dart';

mixin EstadisticasOperativoViewMixin on OpServicioUrbanoPageBase {
  Widget variablesResultadoCompactas(ResultadosOperativo resultado) {
    final List<VariableResultadoOperativo> variables = resultado
        .variablesResultado
        .where((VariableResultadoOperativo item) => item.cantidad > 0)
        .toList();

    if (variables.isEmpty) {
      return const SizedBox.shrink();
    }

    final int total = variables.fold<int>(
      0,
      (int suma, VariableResultadoOperativo item) => suma + item.cantidad,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFD7E2EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // CABECERA
          // ======================================================

          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2FC),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.assignment_turned_in_outlined,
                  color: Color(0xFF195BA6),
                  size: 17,
                ),
              ),

              const SizedBox(width: 7),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "VARIABLES DE RESULTADO",
                      style: TextStyle(
                        color: Color(0xFF29445D),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: 1),

                    Text(
                      "Resultados registrados durante el operativo",
                      style: TextStyle(
                        color: Color(0xFF8493A1),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Divider(height: 1),

          const SizedBox(height: 7),

          // ======================================================
          // LISTADO
          // ======================================================
          ...List.generate(variables.length, (int index) {
            final VariableResultadoOperativo variable = variables[index];

            return filaVariableResultado(
              variable: variable,
              index: index,
              ultima: index == variables.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Widget filaVariableResultado({
    required VariableResultadoOperativo variable,
    required int index,
    required bool ultima,
  }) {
    final String descripcion = variable.desHdrTipoResum.trim().toUpperCase();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F9FC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE1E8EF)),
          ),
          child: Row(
            children: [
              // ==================================================
              // ICONO / ORDEN
              // ==================================================

              Container(
                width: 31,
                height: 31,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F0FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Color(0xFF195BA6),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(width: 7),

              // ==================================================
              // DESCRIPCIÓN
              // ==================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      descripcion.isEmpty ? "SIN DESCRIPCIÓN" : descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF405A72),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 7),

              // ==================================================
              // CANTIDAD
              // ==================================================
              Container(
                constraints: const BoxConstraints(minWidth: 42),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      variable.cantidad.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (!ultima) const SizedBox(height: 5),
      ],
    );
  }

  Widget resumenPrincipalCompacto(ResultadosOperativo resultado) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFD7E2EC)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2FC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_police_rounded,
                  color: Color(0xFF195BA6),
                  size: 22,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resultado.codigoEvento.isEmpty
                          ? "OPERATIVO ${resultado.idHdrEvento}"
                          : resultado.codigoEvento,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF29445D),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 1),

                    Text(
                      resultado.descripcionOperativo.isEmpty
                          ? "SIN DESCRIPCIÓN"
                          : resultado.descripcionOperativo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF718496),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F0),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  resultado.tipoOperativo.isEmpty
                      ? "OPERATIVO"
                      : resultado.tipoOperativo,
                  style: const TextStyle(
                    color: Color(0xFF198754),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          const Divider(height: 1),

          const SizedBox(height: 6),

          Row(
            children: [
              Expanded(
                child: datoTextoCompacto(
                  icono: Icons.play_circle_outline_rounded,
                  titulo: "APERTURA",
                  valor: resultado.fechaEvento,
                ),
              ),
            ],
          ),

          if ((resultado.fechaFinalizacion ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 6),

            datoTextoCompacto(
              icono: Icons.stop_circle_outlined,
              titulo: "FINALIZACIÓN",
              valor: resultado.fechaFinalizacion ?? '',
            ),
          ],
        ],
      ),
    );
  }

  Widget datoTextoCompacto({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    final String dato = valor.trim().isEmpty ? "NO REGISTRADO" : valor.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FB),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Icon(icono, color: const Color(0xFF607A91), size: 14),

          const SizedBox(width: 5),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF5E5F65),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                Text(
                  dato,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF405A72),
                    fontSize: 12,
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

  Widget estadisticasCompactas(ResultadosOperativo resultado) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFD7E2EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // CABECERA
          // ======================================================

          const Row(
            children: [
              Icon(
                Icons.query_stats_rounded,
                color: Color(0xFF195BA6),
                size: 16,
              ),

              SizedBox(width: 5),

              Expanded(
                child: Text(
                  "RESULTADOS DEL OPERATIVO",
                  style: TextStyle(
                    color: Color(0xFF52687C),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ======================================================
          // TOTAL CONSULTAS
          // ======================================================
          cardTotalConsultas(resultado.totalConsultas),

          const SizedBox(height: 7),

          // ======================================================
          // PERSONAS / VEHÍCULOS
          // ======================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: cardConsultaResultado(
                  titulo: "PERSONAS",
                  subtitulo: "CONSULTADAS",
                  cantidad: resultado.totalPersonas,
                  alertas: resultado.totalAlertasPersona,
                  icono: Icons.person_search_rounded,
                  iconoAlerta: Icons.person_off_outlined,
                ),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: cardConsultaResultado(
                  titulo: "VEHÍCULOS",
                  subtitulo: "CONSULTADOS",
                  cantidad: resultado.totalVehiculos,
                  alertas: resultado.totalAlertasVehiculo,
                  icono: Icons.directions_car_rounded,
                  iconoAlerta: Icons.car_crash_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cardConsultaResultado({
    required String titulo,
    required String subtitulo,
    required int cantidad,
    required int alertas,
    required IconData icono,
    required IconData iconoAlerta,
  }) {
    final bool tieneAlertas = alertas > 0;

    final Color colorAlerta = tieneAlertas
        ? const Color(0xFFB42318)
        : const Color(0xFF198754);

    final Color fondoAlerta = tieneAlertas
        ? const Color(0xFFFFF0EF)
        : const Color(0xFFEAF7F0);

    final Color bordeAlerta = tieneAlertas
        ? const Color(0xFFE7B8B4)
        : const Color(0xFFB8DCC8);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCDCDCD)),
      ),
      child: Column(
        children: [
          // ======================================================
          // CONSULTADOS
          // ======================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
            child: Row(
              children: [
                Container(
                  width: 37,
                  height: 37,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F0FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icono, color: const Color(0xFF195BA6), size: 20),
                ),

                const SizedBox(width: 7),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cantidad.toString(),
                        style: const TextStyle(
                          color: Color(0xFF195BA6),
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF405A72),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      Text(
                        subtitulo,
                        style: const TextStyle(
                          color: Color(0xFF8493A1),
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // ALERTAS
          // ======================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
            decoration: BoxDecoration(
              color: fondoAlerta,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(11),
                bottomRight: Radius.circular(11),
              ),
              border: Border(top: BorderSide(color: bordeAlerta)),
            ),
            child: Row(
              children: [
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    color: colorAlerta.withOpacity(.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    tieneAlertas ? iconoAlerta : Icons.verified_rounded,
                    color: colorAlerta,
                    size: 15,
                  ),
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ALERTAS",
                        style: TextStyle(
                          color: colorAlerta,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      Text(
                        tieneAlertas ? "CON NOVEDAD" : "SIN NOVEDAD",
                        style: TextStyle(
                          color: colorAlerta.withOpacity(.75),
                          fontSize: 6.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  alertas.toString(),
                  style: TextStyle(
                    color: colorAlerta,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cardTotalConsultas(int valor) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD8E4EE)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE5F0FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: Color(0xFF195BA6),
              size: 17,
            ),
          ),

          const SizedBox(width: 7),

          const Expanded(
            child: Text(
              "CONSULTAS REALIZADAS",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF405A72),
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          Text(
            valor.toString(),
            style: const TextStyle(
              color: Color(0xFF195BA6),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget ubicacionCompacta(ResultadosOperativo resultado) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD7E2EC)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Color(0xFF195BA6),
                size: 15,
              ),

              SizedBox(width: 5),

              Text(
                "UBICACIÓN DEL OPERATIVO",
                style: TextStyle(
                  color: Color(0xFF52687C),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          ubicacionFila(
            titulo: "ZONA / SUBZONA",
            valor: "${resultado.zona} · ${resultado.subzona}",
          ),

          ubicacionFila(titulo: "DISTRITO", valor: resultado.distrito),

          ubicacionFila(titulo: "CIRCUITO", valor: resultado.circuito),

          ubicacionFila(
            titulo: "SUBCIRCUITO",
            valor: resultado.subcircuito,
            linea: false,
          ),
        ],
      ),
    );
  }

  Widget ubicacionFila({
    required String titulo,
    required String valor,
    bool linea = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 74,
                child: Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF464749),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Text(
                  valor.trim().isEmpty ? "NO REGISTRADO" : valor.trim(),
                  style: const TextStyle(
                    color: Color(0xFF405A72),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (linea) const Divider(height: 1),
      ],
    );
  }
}
