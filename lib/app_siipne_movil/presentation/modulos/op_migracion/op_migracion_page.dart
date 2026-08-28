part of '../pages.dart';

class OpMigracionPage extends OpMigracionPageBase
    with
        CabeceraMigracionViewMixin,
        AccionesOperativoMigracionViewMixin,
        PersonalOperativoMigracionViewMixin,
        QrOperativoMigracionViewMixin,
        FinalizarOperativoMigracionViewMixin,
        BusquedaMigracionViewMixin,
        SelectorNacionalidadMigracionViewMixin,
        IdentidadMigratoriaViewMixin,
        DocumentosMigracionViewMixin,
        FuentesPersonaMigracionViewMixin,
        AccionesMigracionViewMixin,
        MovimientosMigratoriosViewMixin,
        VisasMigracionViewMixin,
        RegistroMigracionViewMixin,
        EstadosMigracionViewMixin {
  OpMigracionPage({super.key});

  @override
  final GlobalKey<FormState> keyBusqueda = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: WorkAreaPageSiipneMovilWidget(
        showGps: true,
        mostrarBtnAtras: false,
        contenidoExpandido: true,
        title: null,
        peticionServer: controller.peticionServerState,
        contenido: Obx(
              () => controller.datosOperativoValidos.value
              ? contenidoMigracion(context)
              : operativoMigracionInvalido(),
        ),
      ),
    );
  }

  Widget contenidoMigracion(BuildContext context) {
    final double teclado = MediaQuery.of(context).viewInsets.bottom;

    return Obx(() {
      return ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(0, 0, 0, teclado + 24),
        children: <Widget>[
          cabeceraMigracion(),
          accionesOperativoMigracion(),
          const SizedBox(height: 4),
          busquedaMigracion(),
          if (controller.extranjerosEncontrados.isEmpty &&
              !controller.peticionServerState.value)
            estadoInicialMigracion(),
          if (controller.extranjerosEncontrados.length > 1 &&
              controller.extranjeroSeleccionado.value == null)
            selectorExtranjeros(),
          if (controller.extranjeroSeleccionado.value != null) ...<Widget>[
            identidadMigratoria(),
            documentosMigratorios(),
            fuentesPersonaMigracion(),
            accionesConsultaMigratoria(),
            advertenciasMigracion(),
            const SizedBox(height: 10),
            selectorVariableMigracion(),
            const SizedBox(height: 10),
            botonNuevaConsulta(),
          ],
          const SizedBox(height: 18),
        ],
      );
    });
  }
}