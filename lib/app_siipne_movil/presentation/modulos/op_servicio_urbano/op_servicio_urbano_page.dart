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
          busquedaTipoOperativo(),
          const SizedBox(height: 6),
          resultado,
          const SizedBox(height: 15),
        ],
      );
    });
  }
}
