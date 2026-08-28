part of '../../pages.dart';

mixin PersonalOperativoMigracionViewMixin on OpMigracionPageBase {
  Future<void> mostrarPersonalOperativo() async {
    final bool ok = await controller.consultarPersonalOperativo();
    if (!ok) {
      DialogosAwesome.getError(
        title: 'PERSONAL NO DISPONIBLE',
        descripcion: controller.mensajeErrorPersonalOperativo,
      );
      return;
    }

    final BuildContext? context = Get.context;
    if (context == null) return;
    final List<Integrante> personal = controller.personalOperativo.toList();
    final String jefe = personal.first.jefe.trim().isEmpty
        ? 'NO REGISTRADO'
        : personal.first.jefe.trim();
    final String fecha = personal.first.fechaEvento.trim();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.68),
      builder: (BuildContext dialogContext) => _MigracionDialog(
        icono: Icons.groups_2_rounded,
        titulo: 'PERSONAL DEL OPERATIVO',
        subtitulo:
            'OPERATIVO N.° ${controller.idHdrEventoActual.value} · ${personal.length} SERVIDORES',
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(13),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F7FC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFC8DAEB)),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _MigracionColors.azul,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.supervisor_account_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'RESPONSABLE DEL OPERATIVO',
                            style: TextStyle(
                              color: _MigracionColors.textoSuave,
                              fontSize: 7,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            jefe,
                            style: const TextStyle(
                              color: _MigracionColors.texto,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          if (fecha.isNotEmpty)
                            Text(
                              'APERTURA: $fecha',
                              style: const TextStyle(
                                color: _MigracionColors.textoSuave,
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
              const SizedBox(height: 10),
              ...personal.asMap().entries.map(
                (MapEntry<int, Integrante> entry) =>
                    _cardIntegranteMigracion(entry.value, entry.key),
              ),
              const SizedBox(height: 5),
              const _MigracionDialogCloseButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardIntegranteMigracion(Integrante integrante, int index) {
    final String nombre = integrante.integrante.trim().isEmpty
        ? 'SERVIDOR NO REGISTRADO'
        : integrante.integrante.trim();
    final String jefe = integrante.jefe.trim();
    final bool esJefe = jefe.isNotEmpty &&
        jefe.toUpperCase() == integrante.integrante.trim().toUpperCase();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: esJefe ? const Color(0xFFF1F6FC) : Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: esJefe ? const Color(0xFFAFC9E2) : const Color(0xFFDDE5ED),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: esJefe ? _MigracionColors.azul : const Color(0xFFEAF3FC),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              esJefe ? Icons.star_rounded : Icons.local_police_outlined,
              color: esJefe ? Colors.white : _MigracionColors.azul,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        nombre,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _MigracionColors.texto,
                          fontSize: 9,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    if (esJefe)
                      const Text(
                        'JEFE',
                        style: TextStyle(
                          color: _MigracionColors.azul,
                          fontSize: 6,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'DOCUMENTO: ${integrante.documento.trim().isEmpty ? 'NO REGISTRADO' : integrante.documento.trim()}',
                  style: const TextStyle(
                    color: _MigracionColors.textoSuave,
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'ANEXADO: ${integrante.fecha.trim().isEmpty ? 'NO REGISTRADA' : integrante.fecha.trim()}',
                  style: const TextStyle(
                    color: _MigracionColors.textoSuave,
                    fontSize: 7,
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
}
