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

              TextFormField(
                controller: controller.controllerDocumento,
                focusNode: controller.focusDocumento,
                enabled: !bloqueado,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: _decoracionCampo(
                  label: 'DOCUMENTO',
                  hint: 'Ej.: 108080986 o FB440010',
                  icono: Icons.badge_outlined,
                ),
                validator: (String? value) {
                  final String documento = value?.trim() ?? '';

                  if (documento.isEmpty) {
                    return 'Ingrese el documento.';
                  }

                  if (documento.length < 4) {
                    return 'Documento no válido.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 9),

              selectorNacionalidadMigracion(
                bloqueado: bloqueado,
              ),

              const SizedBox(height: 11),

              SizedBox(
                width: double.infinity,
                height: 47,
                child: ElevatedButton.icon(
                  onPressed: bloqueado ? null : confirmarConsultaMigratoria,
                  icon: const Icon(
                    Icons.travel_explore_rounded,
                    size: 19,
                  ),
                  label: const Text(
                    'CONSULTAR INFORMACIÓN',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
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
              const SizedBox(height: 11),
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
        fontSize: 14,
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
                  fontSize: 9,
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
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      }).toList(),
      onChanged: controller.peticionServerState.value
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

    FocusManager.instance.primaryFocus?.unfocus();

    final String documento = controller.controllerDocumento.text
        .trim()
        .toUpperCase();
    final String nacionalidad = controller.controllerNacionalidad.text
        .trim()
        .toUpperCase();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xD9061C35),
      useSafeArea: true,
      builder: (BuildContext dialogContext) {
        final MediaQueryData mediaQuery = MediaQuery.of(dialogContext);
        final double altoDisponible =
            mediaQuery.size.height -
                mediaQuery.viewInsets.bottom -
                mediaQuery.padding.vertical -
                32;
        final double altoMaximo = altoDisponible
            .clamp(260.0, mediaQuery.size.height)
            .toDouble();

        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: altoMaximo),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(1.2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFF38BDF8),
                    _MigracionColors.azul,
                    Color(0xFF0A3D7E),
                  ],
                ),
                borderRadius: BorderRadius.circular(23),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x59061C35),
                    blurRadius: 28,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Material(
                  color: const Color(0xFFF2F7FB),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Color(0xFF061C35),
                                Color(0xFF0A3158),
                                _MigracionColors.azul,
                              ],
                            ),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                right: 36,
                                top: -17,
                                child: Icon(
                                  Icons.language_rounded,
                                  color: Colors.white.withOpacity(.05),
                                  size: 94,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.12),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(.20),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.travel_explore_rounded,
                                      color: Colors.white,
                                      size: 27,
                                    ),
                                  ),
                                  const SizedBox(width: 11),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'SIIPNE MÓVIL // MIGRACIÓN',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Color(0xFFA9E4FF),
                                            fontSize: 7.5,
                                            letterSpacing: .65,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'CONFIRMAR CONSULTA',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            height: 1.1,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Validación previa de identidad extranjera',
                                          style: TextStyle(
                                            color: Color(0xFFD4E8F7),
                                            fontSize: 8,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Cancelar',
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 13),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFC7D8E7),
                                  ),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                      color: Color(0x12061C35),
                                      blurRadius: 13,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.fact_check_outlined,
                                          color: _MigracionColors.azul,
                                          size: 17,
                                        ),
                                        SizedBox(width: 7),
                                        Text(
                                          'DATOS QUE SERÁN CONSULTADOS',
                                          style: TextStyle(
                                            color: _MigracionColors.azul,
                                            fontSize: 8,
                                            letterSpacing: .40,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 11),
                                    _MigracionDato(
                                      titulo: 'DOCUMENTO',
                                      valor: documento,
                                      icono: Icons.badge_outlined,
                                    ),
                                    const SizedBox(height: 8),
                                    _MigracionDato(
                                      titulo: 'NACIONALIDAD',
                                      valor: nacionalidad,
                                      icono: Icons.flag_outlined,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 11),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                      Color(0xFFE8F2FA),
                                      Color(0xFFF5F9FC),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFB8D2E6),
                                  ),
                                ),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Color(0x19195BA6),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.shield_outlined,
                                          color: _MigracionColors.azul,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 9),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'TRAZABILIDAD INSTITUCIONAL',
                                            style: TextStyle(
                                              color: _MigracionColors.azul,
                                              fontSize: 7.8,
                                              letterSpacing: .35,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            'La consulta será auditada con el usuario, ubicación, fecha y hora.',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              color:
                                              _MigracionColors.textoSuave,
                                              fontSize: 9.5,
                                              height: 1.38,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                      },
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        size: 17,
                                      ),
                                      label: const Text(
                                        'CANCELAR',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(50),
                                        foregroundColor: const Color(0xFF617487),
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                          color: Color(0xFFB8C8D6),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(13),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        Navigator.of(dialogContext).pop();

                                        final bool ok =
                                        await controller.consultarExtranjero(
                                          formKey: keyBusqueda,
                                        );

                                        if (!ok &&
                                            controller.mensajeErrorConsulta
                                                .isNotEmpty) {
                                          DialogosAwesome.getError(
                                            title: 'CONSULTA NO REALIZADA',
                                            descripcion: controller
                                                .mensajeErrorConsulta,
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.search_rounded,
                                        size: 17,
                                      ),
                                      label: const Text(
                                        'CONSULTAR',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 9,
                                          letterSpacing: .20,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(50),
                                        backgroundColor: _MigracionColors.azul,
                                        foregroundColor: Colors.white,
                                        elevation: 4,
                                        shadowColor: const Color(0x66195BA6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(13),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.lock_outline_rounded,
                                    color: Color(0xFF718294),
                                    size: 11,
                                  ),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      'CANAL SEGURO  ·  CONSULTA AUDITABLE',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFF718294),
                                        fontSize: 7,
                                        letterSpacing: .32,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
