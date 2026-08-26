part of '../../pages.dart';

mixin MovimientosMigratoriosViewMixin on OpMigracionPageBase {
  Future<void> abrirMovimientosMigratorios() async {
    final bool ok = await controller.consultarMovimientosMigratorios();
    if (!ok) {
      DialogosAwesome.getError(
        title: 'MOVIMIENTOS NO DISPONIBLES',
        descripcion: controller.mensajeErrorMovimientos,
      );
      return;
    }
    dialogoMovimientosMigratorios();
  }

  void dialogoMovimientosMigratorios() {
    final BuildContext? context = Get.context;
    if (context == null) return;

    final List<MovimientoMigratorio> movimientos =
        List<MovimientoMigratorio>.from(controller.listaMovimientos);

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(dialogContext).size.height * .82,
              maxWidth: 560,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _encabezadoMovimientos(dialogContext, movimientos.length),
                const Divider(height: 1),
                Flexible(
                  child: movimientos.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: _MigracionVacio(
                            icono: Icons.flight_takeoff_outlined,
                            texto: 'No se encontraron movimientos migratorios.',
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(12),
                          shrinkWrap: true,
                          itemCount: movimientos.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (BuildContext context, int index) {
                            return _cardMovimiento(movimientos[index], index);
                          },
                        ),
                ),
                _pieMovimientos(dialogContext),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _encabezadoMovimientos(BuildContext context, int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 13, 9, 11),
      child: Row(
        children: <Widget>[
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F2FC),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.swap_vert_circle_outlined,
              color: _MigracionColors.azul,
              size: 22,
            ),
          ),
          const SizedBox(width: 9),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'MOVIMIENTOS MIGRATORIOS',
                  style: TextStyle(
                    color: _MigracionColors.texto,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Historial de arribos y salidas.',
                  style: TextStyle(
                    color: _MigracionColors.textoSuave,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FC),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '$total',
              style: const TextStyle(
                color: _MigracionColors.azul,
                fontSize: 8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
            color: _MigracionColors.textoSuave,
          ),
        ],
      ),
    );
  }

  Widget _pieMovimientos(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: SizedBox(
        width: double.infinity,
        height: 42,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: _MigracionColors.azul,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
          ),
          child: const Text(
            'CERRAR',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }

  Widget _cardMovimiento(MovimientoMigratorio movimiento, int index) {
    final bool arribo =
        movimiento.tipoMovimiento.trim().toUpperCase() == 'ARRIBO';
    final Color color =
        arribo ? _MigracionColors.verde : _MigracionColors.rojo;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: arribo ? const Color(0xFFF0F8F4) : const Color(0xFFFFF4F2),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: arribo ? const Color(0xFFB8DFC9) : const Color(0xFFE9BBB7),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  arribo
                      ? Icons.flight_land_rounded
                      : Icons.flight_takeoff_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movimiento.tipoMovimiento.isEmpty
                          ? 'SIN TIPO'
                          : movimiento.tipoMovimiento,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      movimiento.fechaHoraMovimiento,
                      style: const TextStyle(
                        color: _MigracionColors.textoSuave,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '#${index + 1}',
                style: TextStyle(
                  color: color,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: _MigracionDato(
                  titulo: 'ORIGEN',
                  valor: _ubicacion(
                    movimiento.ciudadOrigen,
                    movimiento.paisOrigen,
                  ),
                  icono: Icons.trip_origin_rounded,
                  color: color,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFF8293A3),
                  size: 17,
                ),
              ),
              Expanded(
                child: _MigracionDato(
                  titulo: 'DESTINO',
                  valor: _ubicacion(
                    movimiento.ciudadDestino,
                    movimiento.paisDestino,
                  ),
                  icono: Icons.location_on_outlined,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          _MigracionDato(
            titulo: 'PUERTO DE REGISTRO',
            valor: movimiento.puertoRegistro,
            icono: Icons.account_balance_outlined,
          ),
          const SizedBox(height: 7),
          Row(
            children: <Widget>[
              Expanded(
                child: _MigracionDato(
                  titulo: 'MOTIVO',
                  valor: movimiento.motivoViaje,
                  icono: Icons.luggage_outlined,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _MigracionDato(
                  titulo: 'DOCUMENTO',
                  valor:
                      '${movimiento.tipoDocumentoMovMigra} ${movimiento.numeroDocumentoMovMigra}',
                  icono: Icons.badge_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _ubicacion(String ciudad, String pais) {
    final List<String> partes = <String>[
      if (ciudad.trim().isNotEmpty) ciudad.trim(),
      if (pais.trim().isNotEmpty) pais.trim(),
    ];
    return partes.join(', ');
  }
}
