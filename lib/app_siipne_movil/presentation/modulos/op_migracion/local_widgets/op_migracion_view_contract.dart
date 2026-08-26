part of '../../pages.dart';

/// Contrato de presentación del módulo.
///
/// La lógica y las peticiones permanecen en [OpMigracionController]. Los
/// mixins de esta carpeta contienen únicamente composición visual.
abstract class OpMigracionPageBase extends GetView<OpMigracionController> {
  OpMigracionPageBase({super.key});

  GlobalKey<FormState> get keyBusqueda;

  Widget cabeceraMigracion();
  Widget busquedaMigracion();
  Future<void> confirmarConsultaMigratoria();
  void dialogoConfirmarConsulta();
  Widget selectorVariableMigracion();
  Widget selectorExtranjeros();
  Widget identidadMigratoria();
  Widget documentosMigratorios();
  Widget registroConsultaMigratoria();
  Widget accionesConsultaMigratoria();
  Future<void> abrirMovimientosMigratorios();
  Future<void> abrirVisasSimiec();
  Future<void> abrirVisasElectronicas();
  void dialogoMovimientosMigratorios();
  void dialogoVisasSimiec();
  void dialogoVisasElectronicas();
  Widget advertenciasMigracion();
  Widget botonNuevaConsulta();
  Widget estadoInicialMigracion();
  Widget operativoMigracionInvalido();
}
