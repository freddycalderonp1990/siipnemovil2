part of '../../pages.dart';

mixin FuentesPersonaMigracionViewMixin on OpMigracionPageBase {
  Widget fuentesPersonaMigracion() {
    final bool habilitado = controller.consultaRegistrada &&
        !controller.peticionServerState.value;

    return _MigracionCard(
      borderColor: const Color(0xFFC4D7E8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _MigracionSectionHeader(
            icono: Icons.account_balance_outlined,
            titulo: 'FUENTES INSTITUCIONALES',
            subtitulo:
                'Registro Civil, ANT, boletas y antecedentes de la persona.',
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: _botonFuente(
                  icono: Icons.fact_check_outlined,
                  titulo: 'RC · ANT · BOLETAS',
                  subtitulo: controller.fuentesPersonaConsultadas.value
                      ? 'CONSULTADO'
                      : 'CONSULTAR',
                  habilitado: habilitado,
                  consultado: controller.fuentesPersonaConsultadas.value,
                  onTap: abrirFuentesPersona,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _botonFuente(
                  icono: Icons.manage_search_rounded,
                  titulo: 'ANTECEDENTES',
                  subtitulo: controller.antecedentesPersonaConsultados.value
                      ? 'CONSULTADO'
                      : 'CONSULTAR',
                  habilitado: habilitado,
                  consultado:
                      controller.antecedentesPersonaConsultados.value,
                  onTap: abrirAntecedentesPersona,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Estas consultas son independientes de movimientos y visas, y se ejecutan solo al seleccionar cada opción.',
            style: TextStyle(
              color: _MigracionColors.textoSuave,
              fontSize: 7.4,
              height: 1.3,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonFuente({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required bool habilitado,
    required bool consultado,
    required Future<void> Function() onTap,
  }) {
    final Color color = habilitado
        ? _MigracionColors.azul
        : const Color(0xFF98A6B3);
    return Material(
      color: habilitado
          ? const Color(0xFFF1F7FC)
          : const Color(0xFFF2F4F6),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: habilitado ? onTap : null,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 70,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: habilitado
                  ? const Color(0xFFBFD5E7)
                  : const Color(0xFFD9E0E6),
            ),
          ),
          child: Row(
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Icon(icono, color: color, size: 25),
                  if (consultado)
                    const Positioned(
                      right: -5,
                      top: -5,
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: _MigracionColors.verde,
                        size: 14,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      titulo,
                      maxLines: 2,
                      style: TextStyle(
                        color: color,
                        fontSize: 8,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitulo,
                      style: TextStyle(
                        color: consultado
                            ? _MigracionColors.verde
                            : _MigracionColors.textoSuave,
                        fontSize: 6.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> abrirFuentesPersona() async {
    final bool ok = await controller.consultarFuentesPersona();
    if (!ok) {
      DialogosAwesome.getError(
        title: 'FUENTES NO DISPONIBLES',
        descripcion: controller.mensajeErrorFuentesPersona,
      );
      return;
    }
    final BuildContext? context = Get.context;
    if (context == null || controller.dataPersonaComplementaria.isEmpty) {
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.68),
      builder: (BuildContext dialogContext) => _MigracionDialog(
        icono: Icons.account_balance_outlined,
        titulo: 'FUENTES INSTITUCIONALES',
        subtitulo: 'REGISTRO CIVIL · ANT · BOLETAS / ALERTAS',
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10),
          child: DesingBusquedaPorCedulaWidget(
            dataPersona: controller.dataPersonaComplementaria,
            onPressedAceptar: () => Navigator.of(dialogContext).pop(),
            onPressedAntecedentes: abrirAntecedentesPersona,
          ),
        ),
      ),
    );
  }

  Future<void> abrirAntecedentesPersona() async {
    final bool ok = await controller.consultarAntecedentesPersona();
    if (!ok) {
      DialogosAwesome.getError(
        title: 'ANTECEDENTES NO DISPONIBLES',
        descripcion: controller.mensajeErrorAntecedentesPersona,
      );
      return;
    }

    final DataAntecedentes? datos = controller.datosAntecedentesPersona.value;
    final BuildContext? context = Get.context;
    if (datos == null || context == null) return;

    final List<String> antecedentes = datos.antecedentes;
    final DatosBiograficosMigracion? bio = controller.datosBiograficos;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.68),
      builder: (BuildContext dialogContext) => _MigracionDialog(
        icono: antecedentes.isEmpty
            ? Icons.verified_user_outlined
            : Icons.fact_check_outlined,
        titulo: 'ANTECEDENTES',
        subtitulo: bio?.nombresCompletos ?? 'PERSONA CONSULTADA',
        colorInicio: antecedentes.isEmpty
            ? _MigracionColors.verde
            : const Color(0xFF8A541C),
        colorFin: antecedentes.isEmpty
            ? const Color(0xFF0E5E3A)
            : const Color(0xFF56310D),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(13),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: antecedentes.isEmpty
                      ? const Color(0xFFF0F8F4)
                      : const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: antecedentes.isEmpty
                        ? const Color(0xFFB8DCC8)
                        : const Color(0xFFEBCFAF),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      antecedentes.isEmpty
                          ? Icons.verified_rounded
                          : Icons.manage_search_rounded,
                      color: antecedentes.isEmpty
                          ? _MigracionColors.verde
                          : const Color(0xFFA95D16),
                      size: 28,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        antecedentes.isEmpty
                            ? 'SIN ANTECEDENTES REGISTRADOS'
                            : '${antecedentes.length} REGISTRO(S) ENCONTRADO(S)',
                        style: TextStyle(
                          color: antecedentes.isEmpty
                              ? const Color(0xFF267149)
                              : const Color(0xFF8A541C),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (antecedentes.isNotEmpty) ...<Widget>[
                const SizedBox(height: 9),
                ...antecedentes.asMap().entries.map(
                  (MapEntry<int, String> entry) => Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 7),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD8E2EB)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFFEAF2F8),
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: _MigracionColors.texto,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              color: _MigracionColors.texto,
                              fontSize: 9,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 5),
              const _MigracionDialogCloseButton(),
            ],
          ),
        ),
      ),
    );
  }
}
