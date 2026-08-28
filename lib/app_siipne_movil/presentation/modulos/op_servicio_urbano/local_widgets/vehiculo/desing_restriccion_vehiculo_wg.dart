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
        : const Color(0xFF198754);

    final Color fondo = robado
        ? const Color(0xFFFFF5F4)
        : const Color(0xFFF4FAF6);

    final Color borde = robado
        ? const Color(0xFFE7B4B0)
        : const Color(0xFFBFDCCB);

    final String detalle = data.data.detBusqueda.trim().isEmpty
        ? robado
              ? "VEHÍCULO CON RESTRICCIÓN"
              : "NO EXISTE RESTRICCIÓN"
        : data.data.detBusqueda.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 11),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: borde),
        boxShadow: [
          BoxShadow(
            color: principal.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: principal.withOpacity(.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  robado
                      ? Icons.warning_amber_rounded
                      : Icons.verified_user_outlined,
                  color: principal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "RESTRICCIONES DEL VEHÍCULO",
                      style: TextStyle(
                        color: Color(0xFF203E5B),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "Verificación Policía Judicial",
                      style: TextStyle(
                        color: principal.withOpacity(.75),
                        fontSize: 7.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: principal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  robado ? "ALERTA" : "NORMAL",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 6.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.80),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: principal.withOpacity(.16)),
            ),
            child: Row(
              children: [
                Icon(
                  robado
                      ? Icons.report_problem_outlined
                      : Icons.check_circle_outline_rounded,
                  color: principal,
                  size: 22,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        robado ? "VEHÍCULO ROBADO" : "SIN NOVEDAD",
                        style: TextStyle(
                          color: principal,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        detalle,
                        style: const TextStyle(
                          color: Color(0xFF53697D),
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
