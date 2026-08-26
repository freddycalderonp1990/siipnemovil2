part of '../../pages.dart';

mixin RegistroMigracionViewMixin on OpMigracionPageBase {
  Widget registroConsultaMigratoria() {
    final DataRegistroConsultaMigracion? registro =
        controller.registroConsulta.value;

    return _MigracionCard(
      borderColor: registro == null
          ? _MigracionColors.borde
          : const Color(0xFF9DD0B4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _MigracionSectionHeader(
            icono: Icons.fact_check_outlined,
            titulo: 'REGISTRO DE LA CONSULTA',
            subtitulo:
                'Trazabilidad de la consulta dentro del operativo actual.',
          ),
          const SizedBox(height: 10),
          if (controller.registrandoConsulta.value)
            const _MigracionCargando('Registrando consulta migratoria...')
          else if (registro == null)
            const _MigracionVacio(
              icono: Icons.pending_actions_outlined,
              texto:
                  'El registro de auditoría aún no está disponible. Revise las advertencias.',
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7F0),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFB8DFC9)),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 39,
                        height: 39,
                        decoration: const BoxDecoration(
                          color: _MigracionColors.verde,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 9),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'CONSULTA REGISTRADA',
                              style: TextStyle(
                                color: Color(0xFF276244),
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'La información quedó asociada al operativo.',
                              style: TextStyle(
                                color: Color(0xFF58806A),
                                fontSize: 7.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _MigracionDato(
                          titulo: 'ID PERSONA',
                          valor: registro.idGenPersona.toString(),
                          icono: Icons.person_pin_outlined,
                          color: _MigracionColors.verde,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: _MigracionDato(
                          titulo: 'ID RESUMEN',
                          valor: registro.idHdrEventoResum.toString(),
                          icono: Icons.receipt_long_outlined,
                          color: _MigracionColors.verde,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  _MigracionDato(
                    titulo: 'PERSONA REGISTRADA',
                    valor: '${registro.documento} · ${registro.nombres}',
                    icono: Icons.badge_outlined,
                    color: _MigracionColors.verde,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget advertenciasMigracion() {
    if (controller.advertenciasComplementos.isEmpty) {
      return const SizedBox.shrink();
    }

    return _MigracionCard(
      color: const Color(0xFFFFF9EC),
      borderColor: const Color(0xFFE7D29A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _MigracionSectionHeader(
            icono: Icons.warning_amber_rounded,
            titulo: 'REGISTRO NO CONFIRMADO',
            subtitulo:
                'La identidad fue recuperada, pero debe revisar la trazabilidad.',
          ),
          const SizedBox(height: 9),
          ...controller.advertenciasComplementos.map(
            (String mensaje) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.circle,
                      color: _MigracionColors.naranja,
                      size: 6,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      mensaje,
                      style: const TextStyle(
                        color: Color(0xFF795E25),
                        fontSize: 8.3,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget botonNuevaConsulta() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 3, 6, 7),
      child: SizedBox(
        width: double.infinity,
        height: 47,
        child: ElevatedButton.icon(
          onPressed: controller.peticionServerState.value
              ? null
              : controller.nuevaConsulta,
          icon: const Icon(Icons.refresh_rounded, size: 19),
          label: const Text(
            'NUEVA CONSULTA MIGRATORIA',
            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _MigracionColors.azul,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
