part of '../pages.dart';

class OpServicioUrbanoPage extends OpServicioUrbanoPageBase
    with
        VariableResultadoViewMixin,
        CabeceraOperativoViewMixin,
        ResumenOperativoViewMixin,
        EstadisticasOperativoViewMixin,
        FinalizarOperativoViewMixin,
        PersonalOperativoViewMixin,
        QrOperativoViewMixin,
        TipoConsultaViewMixin,
        BusquedaOperativaViewMixin,
        ConfirmacionBusquedaViewMixin,
        PersonaResultadoViewMixin,
        VehiculoResultadoViewMixin,
        EstadosOperativoViewMixin {
  OpServicioUrbanoPage({super.key});
  @override
  final GlobalKey<FormState> keyPlaca = GlobalKey<FormState>();
  @override
  final GlobalKey<FormState> keyCedula = GlobalKey<FormState>();
  @override
  final GlobalKey<FormState> keyCedulaVehiculo = GlobalKey<FormState>();
  @override
  final GlobalKey<FormState> keyFinalizar = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: WorkAreaPageSiipneMovilWidget(
      showGps: true,
      mostrarBtnAtras: false,
      contenidoExpandido: true,
      title: null,
      peticionServer: controller.peticionServerState,
      contenido: Obx(
        () => controller.datosOperativoValidos.value
            ? _contenido(context)
            : operativoInvalido(),
      ),
    ),
  );
  Widget _contenido(BuildContext context) {
    final double teclado = MediaQuery.of(context).viewInsets.bottom;
    return Obx(() {
      final Widget resultado = controller.selectPerson.value
          ? muestraDatosPersona()
          : controller.selectVehiculo.value
          ? muestraDatosVehiculo()
          : estadoInicial();
      return ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(0, 0, 0, teclado + 25),
        children: [
          cabeceraOperativo(),
          const SizedBox(height: 1),
          tipoDeConsulta(),
          const SizedBox(height: 5),
          resultado,
          const SizedBox(height: 15),
        ],
      );
    });
  }
  void mostrarAdvertenciaAlertasFinalizacion(ResultadosOperativo resultado) {
    final int personas = resultado.totalAlertasPersona;
    final int vehiculos = resultado.totalAlertasVehiculo;
    final int total = personas + vehiculos;

    DialogosAwesome.getWarningSiNo(
      title: "ALERTAS PENDIENTES DE JUSTIFICACIÓN",
      colorAccion: DialogosAwesome.colorError,
      iconoAccion: Icons.warning_amber_rounded,
      codigoEstado: 'SIIPNE MÓVIL // ALERTAS DEL OPERATIVO',
      etiquetaDetalle: 'RECORDATORIO DE JUSTIFICACIÓN',
      descripcion:
      "Este operativo registra $total ${total == 1 ? 'alerta' : 'alertas'}.\n\n"
          "Personas: $personas\n"
          "Vehículos: $vehiculos\n\n"
          "Usted tiene alertas de personas o vehículos en este operativo.\n\n"
          "RECUERDE que dispone de 48 horas para realizar la justificación correspondiente.",
      btnOkOnPress: () {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (!controller.isClosed) mostrarFinalizarOperativo();
        });
      },
      btnCancelOnPress: () {},
    );
  }

}
