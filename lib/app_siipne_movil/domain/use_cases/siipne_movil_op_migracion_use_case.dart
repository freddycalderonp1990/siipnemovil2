import '../../data/models/models_siipne_movil.dart';
import '../repository/repository_siipne_movil.dart';
import '../request/request_siipne_movil.dart';

class SiipneMovilOpMigracionUseCase {
  final SiipneMovilOpMigracionRepository repository;

  SiipneMovilOpMigracionUseCase({required this.repository});

  Future<List<DataModulo>> getModulos({
    required GetPermisosModulosRequest request,
  }) {
    return repository.getPermisosModulos(request: request);
  }

  Future<List<DataTipoOperativo>> getTipoOperativos({
    required GetTipoOperativosRequest request,
  }) {
    return repository.getTipoOperativos(request: request);
  }

  Future<DataCreateOp> createOperativo({
    required CreateOperativoRequest request,
  }) {
    return repository.crearOperativo(request: request);
  }

  Future<DataConsultaPersona> consultarPersona({
    required ConsultarPersonaRequest request,
  }) {
    return repository.consultarPersona(request: request);
  }

  Future<Acuerdo> insertaAcuerdo({
    required InsertAcuerdoSiipneRequest request,
  }) {
    return repository.insertaAcuerdo(request: request);
  }

  Future<Pendiente> consultaPendiente({
    required GetOperativosPendientesRequest request,
  }) {
    return repository.consultaPendiente(request: request);
  }

  Future<Anexarse> consultarAnexarse({
    required GetDatosAnexarseOperativoRequest request,
  }) {
    return repository.consultarAnexarse(request: request);
  }

  Future<List<VariablesResultado>> consultarVariblesResultado({
    required GetVariablesResultadosRequest request,
  }) {
    return repository.consultarVariblesResultado(request: request);
  }

  Future<Finalizar> finalizaOperativo({
    required FinalizarOperativoRequest request,
  }) {
    return repository.finalizaOperativo(request: request);
  }

  Future<DataVehiculo> consultarVehiculo({
    required ConsultarVehiculoRequest request,
  }) {
    return repository.consultarVehiculo(request: request);
  }

  Future<List<Integrante>> consultarPersonalOperativo({
    required GetDatosPoliciasOperativoRequest request,
  }) {
    return repository.consultarPersonalOperativo(request: request);
  }

  Future<List<DataOperativosUsuario>> consultarOperativosUsuario({
    required GetDatosOperativoUsuarioRequest request,
  }) {
    return repository.consultarOperativosUsuario(request: request);
  }

  Future<String> downloadPdfOperativo({
    required int idGenUsuario,
    required int idHdrEvento,
  }) {
    return repository.downloadPdfOperativo(
      idGenUsuario: idGenUsuario,
      idHdrEvento: idHdrEvento,
    );
  }

  Future<ActualizaResultado> actualizaResultado({
    required ActualizarResultadoRequest request,
  }) {
    return repository.actualizaResultado(request: request);
  }

  Future<ResultadosOperativo> getDatosResultadosOperativo({
    required ResultadosOperativoRequest request,
  }) {
    return repository.getDatosResultadosOperativo(request: request);
  }

  Future<DataAntecedentes> getDatosAntecedentes({
    required AntecedentesRequest request,
  }) {
    return repository.getDatosAntecedentes(request: request);
  }

  Future<List<DataExtranjeroDocumento>> getDatosExtranjeroDocumento({
    required GetDatosExtranjeroDocumentoRequest request,
  }) {
    return repository.getDatosExtranjeroDocumento(request: request);
  }

  Future<DataMovimientosMigratorios> getMovimientosMigratorios({
    required GetMovimientosMigratoriosRequest request,
  }) {
    return repository.getMovimientosMigratorios(request: request);
  }

  Future<DataRegistroConsultaMigracion> registrarConsultaMigracion({
    required RegistroConsultaMigracionRequest request,
  }) {
    return repository.registrarConsultaMigracion(request: request);
  }

  Future<DataVisaExtranjero> getVisaExtranjero({
    required GetVisaExtranjeroRequest request,
  }) {
    return repository.getVisaExtranjero(request: request);
  }

  Future<DataVisasElectronicas> getVisasElectronicas({
    required GetVisasElectronicasRequest request,
  }) {
    return repository.getVisasElectronicas(request: request);
  }
}
