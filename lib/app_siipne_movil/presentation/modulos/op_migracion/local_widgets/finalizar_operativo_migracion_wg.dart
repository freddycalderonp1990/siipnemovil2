part of '../../pages.dart';

mixin FinalizarOperativoMigracionViewMixin on OpMigracionPageBase {
  void mostrarFinalizarOperativo() {
    if (!controller.puedeFinalizarOperativo.value ||
        controller.peticionServerState.value) {
      return;
    }

    controller.limpiarClaveFinalizar();
    final BuildContext? context = Get.context;
    if (context == null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xFF210408).withOpacity(.88),
      builder: (BuildContext dialogContext) => _MigracionDialog(
        icono: Icons.edgesensor_low_sharp,
        titulo: 'FINALIZAR OPERATIVO',
        subtitulo:
        'OPERATIVO N.° ${controller.idHdrEventoActual.value} · VALIDACIÓN DE IDENTIDAD',
        colorInicio: const Color(0xFFB42318),
        colorFin: const Color(0xFF78170F),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2F3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF0B8BE)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.gpp_bad_rounded, color: Color(0xFFB42318)),
                    SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Al finalizar se bloqueará el registro de nuevas consultas. Valide su identidad con la clave institucional o biometría.',
                        style: TextStyle(
                          color: Color(0xFF7A1821),
                          fontSize: 9.5,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD9E3ED)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFFFFE1E4),
                          child: Icon(
                            Icons.lock_outline_rounded,
                            color: _MigracionColors.rojo,
                            size: 17,
                          ),
                        ),
                        SizedBox(width: 7),
                        Text(
                          'CLAVE INSTITUCIONAL',
                          style: TextStyle(
                            color: _MigracionColors.texto,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Obx(
                          () => TextFormField(
                        controller: controller.controllerClaveFinalizar,
                        obscureText: controller.ocultarClaveFinalizar.value,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Ingrese su clave',
                          prefixIcon: const Icon(Icons.password_rounded),
                          suffixIcon: IconButton(
                            onPressed:
                            controller.cambiarVisibilidadClaveFinalizar,
                            icon: Icon(
                              controller.ocultarClaveFinalizar.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _validarClaveYConfirmar(dialogContext),
                        icon: const Icon(Icons.verified_user_rounded, size: 18),
                        label: const Text('VALIDAR CLAVE'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _MigracionColors.rojo,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _validarBiometriaYConfirmar(dialogContext),
                  child: Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFFFFE8EA), Color(0xFFFFF5F6)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE7A6AD)),
                    ),
                    child: const Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFFFFD7DB),
                          child: Icon(
                            Icons.fingerprint_rounded,
                            color: _MigracionColors.rojo,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'HUELLA / BIOMETRÍA',
                                style: TextStyle(
                                  color: _MigracionColors.rojo,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'Toque para validar rápidamente.',
                                style: TextStyle(
                                  color: _MigracionColors.textoSuave,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: _MigracionColors.rojo,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  controller.limpiarClaveFinalizar();
                  Navigator.of(dialogContext).pop();
                },
                icon: const Icon(Icons.close_rounded, size: 17),
                label: const Text('CANCELAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _validarClaveYConfirmar(BuildContext dialogContext) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (controller.controllerClaveFinalizar.text.trim().isEmpty) {
      DialogosAwesome.getWarning(
        title: 'CLAVE REQUERIDA',
        descripcion: 'Ingrese su clave institucional para continuar.',
      );
      return;
    }
    final bool valida = await controller.validarClaveFinalizar();
    if (!valida) {
      DialogosAwesome.getError(
        title: 'CLAVE INCORRECTA',
        descripcion: 'La clave ingresada no pudo ser validada.',
      );
      return;
    }
    if (Navigator.of(dialogContext).canPop()) {
      Navigator.of(dialogContext).pop();
    }
    confirmarFinalizacionDefinitiva();
  }

  Future<void> _validarBiometriaYConfirmar(
      BuildContext dialogContext,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final bool ok = await controller.autenticarBiometriaFinalizar();
    if (!ok) {
      DialogosAwesome.getError(
        title: 'AUTENTICACIÓN NO VALIDADA',
        descripcion:
        'No fue posible validar su identidad mediante biometría.',
      );
      return;
    }
    if (Navigator.of(dialogContext).canPop()) {
      Navigator.of(dialogContext).pop();
    }
    confirmarFinalizacionDefinitiva();
  }

  void confirmarFinalizacionDefinitiva() {
    DialogosAwesome.getWarningSiNo(
      title: 'CONFIRMAR FINALIZACIÓN',
      colorAccion: DialogosAwesome.colorError,
      iconoAccion: Icons.gpp_bad_rounded,
      codigoEstado: 'SIIPNE MIGRACIÓN // CIERRE DEFINITIVO',
      etiquetaDetalle: 'CONFIRMACIÓN DE ACCIÓN IRREVERSIBLE',
      descripcion:
      '¿Está seguro de finalizar el operativo migratorio N.° ${controller.idHdrEventoActual.value}?\n\n'
          'Una vez finalizado no podrá registrar nuevas consultas migratorias.',
      btnOkOnPress: () async {
        final bool ok = await controller.finalizarOperativo();
        if (!ok) {
          DialogosAwesome.getError(
            title: 'NO SE PUDO FINALIZAR',
            descripcion: controller.mensajeErrorFinalizar.isEmpty
                ? 'No fue posible finalizar el operativo migratorio.'
                : controller.mensajeErrorFinalizar,
          );
          return;
        }
        DialogosAwesome.getSucess(
          title: 'OPERATIVO FINALIZADO',
          descripcion:
          'El operativo migratorio fue finalizado correctamente.',
          btnOkOnPress: controller.volverMenu,
        );
      },
      btnCancelOnPress: () {},
    );
  }
}