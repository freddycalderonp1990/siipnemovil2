part of '../../pages.dart';

mixin FinalizarOperativoViewMixin on OpServicioUrbanoPageBase {
  Future<void> mostrarFinalizarOperativo() async {
    final context = Get.context;
    if (context == null) return;

    controller.limpiarClaveFinalizar();

    final bool biometriaConfiguradaApp =
    await controller.biometriaConfiguradaEnApp();

    if (!context.mounted) return;

    final validado = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xD90A1422),
      builder: (_) => _DialogoCierreOperativo(
        operativo:
        '${controller.idHdrEventoActual.value}',
        clave:
        controller.controllerClaveFinalizar,
        biometriaConfiguradaApp:
        biometriaConfiguradaApp,
        validarClave: () =>
            controller.validarClaveFinalizar(),
        validarBiometria: () =>
            controller.autenticarBiometriaFinalizar(),
      ),
    );

    controller.limpiarClaveFinalizar();

    if (validado == true &&
        !controller.isClosed) {
      confirmarFinalizacionDefinitiva();
    }
  }
  void confirmarFinalizacionDefinitiva() {
    DialogosAwesome.getWarningSiNo(
      title: "CONFIRMAR FINALIZACIÓN",
      colorAccion: DialogosAwesome.colorError,
      iconoAccion: Icons.gpp_bad_rounded,
      codigoEstado: 'SIIPNE MÓVIL // CIERRE DEFINITIVO',
      etiquetaDetalle: 'CONFIRMACIÓN DE ACCIÓN IRREVERSIBLE',
      descripcion:
      "¿Está seguro de finalizar el operativo N° ${controller.idHdrEventoActual.value}?\n\n"
          "Una vez finalizado no se podrán registrar nuevas consultas.",
      btnOkOnPress: () async {
        final bool resultado = await controller.finalizarOperativo();

        if (!resultado) {
          DialogosAwesome.getError(
            title: "NO SE PUDO FINALIZAR",
            descripcion: controller.mensajeErrorFinalizar.isEmpty
                ? "No fue posible finalizar el operativo."
                : controller.mensajeErrorFinalizar,
          );
          return;
        }

        DialogosAwesome.getSucess(
          title: "OPERATIVO FINALIZADO",
          descripcion:
          "El operativo N° ${controller.idHdrEventoActual.value} fue finalizado correctamente.",
          btnOkOnPress: () {
            controller.volverMenu();
          },
        );
      },
      btnCancelOnPress: () {},
    );
  }
}