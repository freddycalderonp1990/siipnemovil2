part of '../../pages.dart';

mixin BusquedaOperativaViewMixin on OpServicioUrbanoPageBase {
  Future<void> _abrirConsulta({required bool esPersona}) async {
    final context = Get.context;
    if (controller.isClosed ||
        controller.cargandoVariablesResultado.value ||
        controller.dialogoConsultaAbierto.value ||
        controller.peticionServerState.value ||
        context == null ||
        !context.mounted)
      return;
    controller.dialogoConsultaAbierto.value = true;
    final documentoController = esPersona
        ? controller.controllerCedula
        : controller.controllerPlaca;
    documentoController.clear();
    final formKey = esPersona ? keyCedula : keyPlaca;
    try {
      final resultado = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierColor: DialogoInstitucional.barrera,
        builder: (_) => DialogoConsultaOperativa(
          titulo: esPersona ? 'Consulta de persona' : 'Consulta de vehículo',
          esPersona: esPersona,
          formKey: formKey,
          documentoController: documentoController,
          onConsultar: (nacionalidad) => esPersona
              ? controller.consultarPersonaPorCedula(
                  key: formKey,
                  nacionalidad: nacionalidad,
                )
              : controller.consultarVehiculoPorPlaca(key: formKey),
          obtenerError: () => esPersona && controller.consultaRepetida
              ? 'La persona ya fue consultada durante este operativo.'
              : controller.mensajeErrorConsulta,
          esConsultaRepetida: esPersona ? () => controller.consultaRepetida : null,
        ),
      );
      if (resultado != true && !controller.isClosed) {
        documentoController.clear();
        controller.limpiarSeleccionConsulta();
      }
    } finally {
      controller.dialogoConsultaAbierto.value = false;
    }
  }

  Future<void> confirmarBusquedaPersona() => _abrirConsulta(esPersona: true);

  Future<void> confirmarBusquedaVehiculo() => _abrirConsulta(esPersona: false);

  Future<void> cerrarTeclado() async {
    FocusManager.instance.primaryFocus?.unfocus();

    await Future.delayed(const Duration(milliseconds: 180));
  }
}
