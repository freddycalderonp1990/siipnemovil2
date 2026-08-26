part of '../../pages.dart';

abstract class OpServicioUrbanoPageBase
    extends GetView<OpServicioUrbanoController> {
  OpServicioUrbanoPageBase({super.key});

  GlobalKey<FormState> get keyPlaca;
  GlobalKey<FormState> get keyCedula;
  GlobalKey<FormState> get keyCedulaVehiculo;
  GlobalKey<FormState> get keyFinalizar;

  Widget comboVariableResultado();
  Widget resultadoConsultaVariable();
  Widget cabeceraOperativo();
  Future<void> mostrarResumenAntesFinalizar();
  void dialogoResumenOperativo(ResultadosOperativo resultado);
  Widget variablesResultadoCompactas(ResultadosOperativo resultado);
  Widget filaVariableResultado({
    required VariableResultadoOperativo variable,
    required int index,
    required bool ultima,
  });
  Widget resumenPrincipalCompacto(ResultadosOperativo resultado);
  Widget datoTextoCompacto({
    required IconData icono,
    required String titulo,
    required String valor,
  });
  Widget estadisticasCompactas(ResultadosOperativo resultado);
  Widget cardConsultaResultado({
    required String titulo,
    required String subtitulo,
    required int cantidad,
    required int alertas,
    required IconData icono,
    required IconData iconoAlerta,
  });
  Widget cardTotalConsultas(int valor);
  Widget ubicacionCompacta(ResultadosOperativo resultado);
  Widget ubicacionFila({
    required String titulo,
    required String valor,
    bool linea = true,
  });
  Widget headerResumenOperativo({
    required BuildContext dialogContext,
    required ResultadosOperativo resultado,
  });
  Widget avisoFinalizacionResumen();
  Widget botonesResumenFinalizacion(BuildContext dialogContext);
  Widget botonCabeceraOperativo({
    required String titulo,
    required IconData icono,
    required Color color,
    required Color fondo,
    required Color borde,
    required VoidCallback? onTap,
  });
  void confirmarCerrarSesion();
  void mostrarFinalizarOperativo();
  Widget headerFinalizar(BuildContext dialogContext);
  Widget opcionFinalizarClave(BuildContext dialogContext);
  Widget opcionFinalizarBiometria(BuildContext dialogContext);
  void confirmarFinalizacionDefinitiva();
  Future<void> mostrarPersonalOperativo();
  void dialogoPersonalOperativo(BuildContext context);
  Widget cardIntegranteOperativo({
    required Integrante integrante,
    required int index,
  });
  Future<void> mostrarQrOperativo();

  Widget tipoDeConsulta();
  Widget botonConsulta({
    required bool seleccionado,
    required String titulo,
    required String subtitulo,
    required String detalle,
    required IconData icono,
    required VoidCallback onTap,
  });
  Widget busquedaTipoOperativo();
  Widget cardBusqueda({
    required String titulo,
    required String descripcion,
    required IconData icono,
    required Widget child,
  });
  Future<void> confirmarBusquedaPersona();
  Future<void> confirmarBusquedaVehiculo();
  Future<void> cerrarTeclado();
  Future<void> mostrarPreparandoConsulta({required String tipo});
  void dialogoConfirmarBusqueda({
    required String tipo,
    required String etiqueta,
    required String dato,
    required IconData icono,
    required VoidCallback onConfirmar,
  });
  Widget headerDialogoConfirmacion({
    required BuildContext dialogContext,
    required IconData icono,
    required String tipo,
  });
  Widget datoConfirmacion({
    required IconData icono,
    required String titulo,
    required String valor,
  });
  Widget detalleTipoConsulta({required String tipo});
  Widget avisoAuditoria();

  Widget muestraDatosPersona();
  Future<void> mostrarAntecedentesPersona();
  void dialogoAntecedentesPersona(
    BuildContext context,
    DataAntecedentes antecedentes,
  );

  Widget muestraDatosVehiculo();
  Future<void> nuevaConsultaPersona();
  Future<void> nuevaConsultaVehiculo();
  Widget panelPersonasVehiculo();
  Widget diagramaVehiculoPersonas();
  Widget selectorRolPersonaVehiculo();
  Widget busquedaPersonaVehiculo();
  Future<void> confirmarPersonaVehiculo();
  Widget personasRegistradasVehiculo();
  Widget cardPersonaRelacionada({
    required String titulo,
    required IconData icono,
    required DataConsultaPersona data,
    required VoidCallback onEliminar,
  });
  void abrirPersonasVehiculo();

  Widget estadoInicial();
  Widget estadoConsulta({
    required IconData icono,
    required String titulo,
    required String descripcion,
  });
  Widget operativoInvalido();
}
