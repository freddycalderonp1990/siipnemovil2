part of '../../pages.dart';

mixin BusquedaMigracionViewMixin on OpMigracionPageBase {
  Widget busquedaMigracion() {
    return Obx(() {
      final bool bloqueado =
          controller.peticionServerState.value || controller.hayResultado;

      return _MigracionCard(
        child: Form(
          key: keyBusqueda,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _MigracionSectionHeader(
                icono: Icons.person_search_rounded,
                titulo: 'CONSULTAR PERSONA EXTRANJERA',
                subtitulo:
                    'Ingrese el documento y el código de nacionalidad de tres letras.',
                badge: 'MIGRACIÓN',
              ),
              const SizedBox(height: 12),
              selectorVariableMigracion(),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.controllerDocumento,
                focusNode: controller.focusDocumento,
                enabled: !bloqueado,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    controller.focusNacionalidad.requestFocus(),
                decoration: _decoracionCampo(
                  label: 'DOCUMENTO',
                  hint: 'Ej.: 108080986 o FB440010',
                  icono: Icons.badge_outlined,
                ),
                validator: (String? value) {
                  final String documento = value?.trim() ?? '';
                  if (documento.isEmpty) return 'Ingrese el documento.';
                  if (documento.length < 4) return 'Documento no válido.';
                  return null;
                },
              ),
              const SizedBox(height: 9),
              TextFormField(
                controller: controller.controllerNacionalidad,
                focusNode: controller.focusNacionalidad,
                enabled: !bloqueado,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.search,
                maxLength: 3,
                onFieldSubmitted: (_) => confirmarConsultaMigratoria(),
                decoration: _decoracionCampo(
                  label: 'NACIONALIDAD',
                  hint: 'Ej.: VEN, COL, PER',
                  icono: Icons.flag_outlined,
                ).copyWith(counterText: ''),
                validator: (String? value) {
                  final String nacionalidad = value?.trim() ?? '';
                  if (nacionalidad.length != 3) {
                    return 'Ingrese el código de tres letras.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 11),
              SizedBox(
                width: double.infinity,
                height: 47,
                child: ElevatedButton.icon(
                  onPressed: bloqueado ? null : confirmarConsultaMigratoria,
                  icon: const Icon(Icons.travel_explore_rounded, size: 19),
                  label: const Text(
                    'CONSULTAR INFORMACIÓN MIGRATORIA',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _MigracionColors.azul,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFB9C7D4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (controller.mensajeErrorConsulta.trim().isNotEmpty) ...<Widget>[
                const SizedBox(height: 9),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECE9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE9BBB7)),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.error_outline_rounded,
                        color: _MigracionColors.rojo,
                        size: 18,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          controller.mensajeErrorConsulta,
                          style: const TextStyle(
                            color: Color(0xFF81352F),
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  InputDecoration _decoracionCampo({
    required String label,
    required String hint,
    required IconData icono,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icono, color: _MigracionColors.azul, size: 20),
      filled: true,
      fillColor: _MigracionColors.fondo,
      labelStyle: const TextStyle(
        color: _MigracionColors.azul,
        fontSize: 9,
        fontWeight: FontWeight.w800,
      ),
      hintStyle: const TextStyle(color: Color(0xFF9AA8B5), fontSize: 9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFC9D9E7)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: _MigracionColors.azul,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _MigracionColors.rojo),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _MigracionColors.rojo, width: 1.4),
      ),
    );
  }

  Widget selectorVariableMigracion() {
    if (controller.cargandoVariablesResultado.value) {
      return const _MigracionCargando('Cargando variables del operativo...');
    }

    if (controller.variablesResultado.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E8),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0xFFE7D29A)),
        ),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.info_outline_rounded,
              color: _MigracionColors.naranja,
              size: 18,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                controller.mensajeErrorVariables.isEmpty
                    ? 'No existen variables configuradas.'
                    : controller.mensajeErrorVariables,
                style: const TextStyle(
                  color: Color(0xFF795E25),
                  fontSize: 8.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              onPressed: () =>
                  controller.cargarVariablesResultado(forzar: true),
              icon: const Icon(
                Icons.refresh_rounded,
                color: _MigracionColors.naranja,
                size: 19,
              ),
            ),
          ],
        ),
      );
    }

    return DropdownButtonFormField<VariablesResultado>(
      value: controller.variableResultadoSeleccionada.value,
      isExpanded: true,
      decoration: _decoracionCampo(
        label: 'VARIABLE DE RESULTADO',
        hint: 'Seleccione la clasificación',
        icono: Icons.fact_check_outlined,
      ),
      items: controller.variablesResultado.map((VariablesResultado item) {
        final String descripcion = item.desHdrTipoResum.trim().isEmpty
            ? 'SIN DESCRIPCIÓN'
            : item.desHdrTipoResum.trim();
        return DropdownMenuItem<VariablesResultado>(
          value: item,
          child: Text(
            descripcion,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _MigracionColors.texto,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      }).toList(),
      onChanged: controller.peticionServerState.value || controller.hayResultado
          ? null
          : controller.seleccionarVariableResultado,
      validator: (VariablesResultado? value) =>
          value == null ? 'Seleccione una variable.' : null,
    );
  }

  Future<void> confirmarConsultaMigratoria() async {
    if (!(keyBusqueda.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    dialogoConfirmarConsulta();
  }

  void dialogoConfirmarConsulta() {
    final BuildContext? context = Get.context;
    if (context == null) return;

    final String documento = controller.controllerDocumento.text
        .trim()
        .toUpperCase();
    final String nacionalidad = controller.controllerNacionalidad.text
        .trim()
        .toUpperCase();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19),
          ),
          title: const Row(
            children: <Widget>[
              Icon(Icons.security_rounded, color: _MigracionColors.azul),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'CONFIRMAR CONSULTA',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _MigracionDato(
                titulo: 'DOCUMENTO',
                valor: documento,
                icono: Icons.badge_outlined,
              ),
              const SizedBox(height: 7),
              _MigracionDato(
                titulo: 'NACIONALIDAD',
                valor: nacionalidad,
                icono: Icons.flag_outlined,
              ),
              const SizedBox(height: 9),
              const Text(
                'La consulta será auditada con el usuario, ubicación, fecha y hora.',
                style: TextStyle(
                  color: _MigracionColors.textoSuave,
                  fontSize: 9,
                  height: 1.3,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('CANCELAR'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final bool ok = await controller.consultarExtranjero(
                  formKey: keyBusqueda,
                );
                if (!ok && controller.mensajeErrorConsulta.isNotEmpty) {
                  DialogosAwesome.getError(
                    title: 'CONSULTA NO REALIZADA',
                    descripcion: controller.mensajeErrorConsulta,
                  );
                }
              },
              icon: const Icon(Icons.search_rounded, size: 17),
              label: const Text('CONSULTAR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _MigracionColors.azul,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
