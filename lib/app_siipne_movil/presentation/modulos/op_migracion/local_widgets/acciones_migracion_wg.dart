part of '../../pages.dart';

mixin AccionesMigracionViewMixin on OpMigracionPageBase {
  Widget accionesConsultaMigratoria() {
    final bool habilitado = controller.consultaRegistrada &&
        !controller.registrandoConsulta.value &&
        !controller.peticionServerState.value;

    return _MigracionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _MigracionSectionHeader(
            icono: Icons.manage_search_rounded,
            titulo: 'CONSULTAS COMPLEMENTARIAS',
            subtitulo: 'Seleccione únicamente la información que desea ver.',
          ),
          const SizedBox(height: 11),
          Row(
            children: <Widget>[
              Expanded(
                child: _botonAccion(
                  icono: Icons.swap_vert_circle_outlined,
                  texto: 'MOVIMIENTOS',
                  cargando: controller.cargandoMovimientos.value,
                  consultado: controller.movimientosConsultados.value,
                  habilitado: habilitado,
                  onTap: abrirMovimientosMigratorios,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _botonAccion(
                  icono: Icons.approval_outlined,
                  texto: 'VISAS',
                  cargando: controller.cargandoVisa.value,
                  consultado: controller.visasSimiecConsultadas.value,
                  habilitado: habilitado,
                  onTap: abrirVisasSimiec,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _botonAccion(
                  icono: Icons.contactless_outlined,
                  texto: 'VISAS\nELECTRÓNICAS',
                  cargando: controller.cargandoVisaElectronica.value,
                  consultado: controller.visasElectronicasConsultadas.value,
                  habilitado: habilitado,
                  onTap: abrirVisasElectronicas,
                ),
              ),
            ],
          ),
          if (!controller.consultaRegistrada) ...<Widget>[
            const SizedBox(height: 8),
            const Text(
              'Las opciones se habilitan cuando el servidor confirma el registro inicial.',
              style: TextStyle(
                color: _MigracionColors.textoSuave,
                fontSize: 7.7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _botonAccion({
    required IconData icono,
    required String texto,
    required bool cargando,
    required bool consultado,
    required bool habilitado,
    required Future<void> Function() onTap,
  }) {
    final Color color = habilitado
        ? _MigracionColors.azul
        : const Color(0xFF9AA9B7);

    return Material(
      color: habilitado
          ? const Color(0xFFEAF3FC)
          : const Color(0xFFF1F4F6),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: habilitado && !cargando
            ? () {
                onTap();
              }
            : null,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 74,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: habilitado
                  ? const Color(0xFFBFD5E7)
                  : const Color(0xFFD9E0E6),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (cargando)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: _MigracionColors.azul,
                  ),
                )
              else
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Icon(icono, color: color, size: 24),
                    if (consultado)
                      const Positioned(
                        right: -5,
                        top: -4,
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: _MigracionColors.verde,
                          size: 13,
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 5),
              Text(
                texto,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: color,
                  fontSize: 7.4,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
