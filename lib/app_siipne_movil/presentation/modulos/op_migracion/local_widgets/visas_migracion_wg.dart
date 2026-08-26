part of '../../pages.dart';

mixin VisasMigracionViewMixin on OpMigracionPageBase {
  Future<void> abrirVisasSimiec() async {
    final bool ok = await controller.consultarVisasSimiec();
    if (!ok) {
      DialogosAwesome.getError(
        title: 'VISAS NO DISPONIBLES',
        descripcion: controller.mensajeErrorVisas,
      );
      return;
    }
    dialogoVisasSimiec();
  }

  Future<void> abrirVisasElectronicas() async {
    final bool ok = await controller.consultarVisasElectronicas();
    if (!ok) {
      DialogosAwesome.getError(
        title: 'VISAS ELECTRÓNICAS NO DISPONIBLES',
        descripcion: controller.mensajeErrorVisasElectronicas,
      );
      return;
    }
    dialogoVisasElectronicas();
  }

  void dialogoVisasSimiec() {
    final List<VisaSimiecMigracion> visas =
        List<VisaSimiecMigracion>.from(controller.listaVisasSimiec);
    _mostrarDialogoVisas(
      icono: Icons.approval_outlined,
      titulo: 'VISAS SIMIEC',
      subtitulo: 'Visas registradas para el ciudadano.',
      total: visas.length,
      vacio: 'No se encontraron visas en SIMIEC.',
      iconoVacio: Icons.gpp_maybe_outlined,
      contenido: (int index) => _cardVisaSimiec(visas[index]),
    );
  }

  void dialogoVisasElectronicas() {
    final List<VisaElectronicaMigracion> visas =
        List<VisaElectronicaMigracion>.from(
      controller.listaVisasElectronicas,
    );
    _mostrarDialogoVisas(
      icono: Icons.contactless_outlined,
      titulo: 'VISAS ELECTRÓNICAS',
      subtitulo: 'Información electrónica disponible.',
      total: visas.length,
      vacio: 'No se encontraron visas electrónicas.',
      iconoVacio: Icons.credit_card_off_outlined,
      contenido: (int index) => _cardVisaElectronica(visas[index]),
    );
  }

  void _mostrarDialogoVisas({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required int total,
    required String vacio,
    required IconData iconoVacio,
    required Widget Function(int index) contenido,
  }) {
    final BuildContext? context = Get.context;
    if (context == null) return;

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
                _encabezadoVisas(
                  dialogContext,
                  icono: icono,
                  titulo: titulo,
                  subtitulo: subtitulo,
                  total: total,
                ),
                const Divider(height: 1),
                Flexible(
                  child: total == 0
                      ? Padding(
                          padding: const EdgeInsets.all(14),
                          child: _MigracionVacio(
                            icono: iconoVacio,
                            texto: vacio,
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(12),
                          shrinkWrap: true,
                          itemCount: total,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, int index) => contenido(index),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
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
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _encabezadoVisas(
    BuildContext context, {
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required int total,
  }) {
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
            child: Icon(icono, color: _MigracionColors.azul, size: 22),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  titulo,
                  style: const TextStyle(
                    color: _MigracionColors.texto,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  subtitulo,
                  style: const TextStyle(
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

  Widget _cardVisaSimiec(VisaSimiecMigracion visa) {
    final bool activa = visa.estado.trim().toUpperCase() == 'ACTIVA';
    final Color color =
        activa ? _MigracionColors.verde : _MigracionColors.rojo;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: activa ? const Color(0xFFF0F8F4) : const Color(0xFFFFF4F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: activa ? const Color(0xFFB8DFC9) : const Color(0xFFE9BBB7),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.workspace_premium_outlined, color: color, size: 22),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      visa.numeroVisa.isEmpty ? 'SIN NÚMERO' : visa.numeroVisa,
                      style: const TextStyle(
                        color: _MigracionColors.texto,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${visa.tipo} · ${visa.motivo}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _MigracionColors.textoSuave,
                        fontSize: 7.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  visa.estado.isEmpty ? 'SIN ESTADO' : visa.estado,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 6.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: _MigracionDato(
                  titulo: 'VÁLIDA DESDE',
                  valor: visa.validaDesde,
                  icono: Icons.event_available_outlined,
                  color: color,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _MigracionDato(
                  titulo: 'VÁLIDA HASTA',
                  valor: visa.validaHasta,
                  icono: Icons.event_busy_outlined,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          _MigracionDato(
            titulo: 'ACTIVIDAD / LUGAR DE EXPEDICIÓN',
            valor: '${visa.actividad} · ${visa.lugarExpedicion}',
            icono: Icons.location_city_outlined,
          ),
          const SizedBox(height: 7),
          _MigracionDato(
            titulo: 'DOCUMENTO',
            valor: '${visa.tipoDocumento} ${visa.numeroDocumento}',
            icono: Icons.badge_outlined,
          ),
        ],
      ),
    );
  }

  Widget _cardVisaElectronica(VisaElectronicaMigracion visa) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFF4F9FD), Color(0xFFEBF3FA)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFD5E7)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.contactless_rounded,
                color: _MigracionColors.azul,
                size: 23,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      visa.numeroVisa.isEmpty ? 'SIN NÚMERO' : visa.numeroVisa,
                      style: const TextStyle(
                        color: _MigracionColors.texto,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      visa.actividad,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _MigracionColors.textoSuave,
                        fontSize: 7.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (visa.tieneFoto)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF7F0),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Row(
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera_outlined,
                        color: _MigracionColors.verde,
                        size: 14,
                      ),
                      SizedBox(width: 3),
                      Text(
                        'FOTO',
                        style: TextStyle(
                          color: _MigracionColors.verde,
                          fontSize: 6.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _MigracionDato(
            titulo: 'PASAPORTE',
            valor: visa.numeroPasaporte,
            icono: Icons.menu_book_outlined,
          ),
          const SizedBox(height: 7),
          Row(
            children: <Widget>[
              Expanded(
                child: _MigracionDato(
                  titulo: 'FECHA DE EMISIÓN',
                  valor: visa.fechaEmision,
                  icono: Icons.event_available_outlined,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _MigracionDato(
                  titulo: 'FECHA DE CADUCIDAD',
                  valor: visa.fechaCaducidad,
                  icono: Icons.event_busy_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
