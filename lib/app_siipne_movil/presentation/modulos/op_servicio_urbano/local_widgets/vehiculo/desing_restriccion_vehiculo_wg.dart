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
    final Color principal = robado ? const Color(0xFFB42318) : const Color(0xFF16834B);
    final Color fondo = robado ? const Color(0xFFFFF6F5) : const Color(0xFFF2FAF5);
    final Color borde = robado ? const Color(0xFFE9B7B2) : const Color(0xFFB9DCC8);
    const Color tituloOscuro = Color(0xFF183B56);
    const Color textoOscuro = Color(0xFF425B70);
    final String fechaIncidente = data.data.fechaIncidente.trim();
    final String direccion = data.data.direccion.trim();
    final String empresa = data.data.empresa.trim();
    final String detalle = data.data.detBusqueda.trim().isNotEmpty
        ? data.data.detBusqueda.trim()
        : robado
        ? 'VEHÍCULO CON RESTRICCIÓN VIGENTE'
        : 'NO EXISTEN RESTRICCIONES REGISTRADAS';
    final List<Widget> campos = <Widget>[];

    void agregarCampo(IconData icono, String titulo, String valor) {
      if (valor.isEmpty) return;
      if (campos.isNotEmpty) campos.add(const SizedBox(height: 8));
      campos.add(
        _DatoRestriccionVehiculoWg(
          icono: icono,
          titulo: titulo,
          valor: valor,
          principal: principal,
        ),
      );
    }

    agregarCampo(Icons.calendar_month_rounded, 'FECHA DEL INCIDENTE', fechaIncidente);
    agregarCampo(Icons.location_on_rounded, 'DIRECCIÓN DEL INCIDENTE', direccion);
    agregarCampo(Icons.account_balance_rounded, 'ENTIDAD REGISTRANTE', empresa);

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
                  robado ? Icons.warning_amber_rounded : Icons.verified_user_rounded,
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
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
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
                    robado ? Icons.report_problem_rounded : Icons.check_circle_rounded,
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
          if (campos.isNotEmpty) ...[
            const SizedBox(height: 9),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: principal.withOpacity(.16)),
              ),
              child: Column(children: campos),
            ),
          ],
        ],
      ),
    );
  }
}

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