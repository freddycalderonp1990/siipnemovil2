import '../../data/models/models_siipne_movil.dart';
import '../repository/repository_siipne_movil.dart';
import '../request/request_siipne_movil.dart';

class SiipneMovilUseCase {
  final SiipneMovilRepository repository;

  SiipneMovilUseCase({required this.repository});

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
  }) async {
    return await repository.consultarPersona(request: request);
  }

  Future<Acuerdo> insertaAcuerdo({
    required InsertAcuerdoSiipneRequest request,
  }) async {
    return await repository.insertaAcuerdo(request: request);
  }

  Future<Pendiente> consultaPendiente({
    required GetOperativosPendientesRequest request,
  }) async {
    return await repository.consultaPendiente(request: request);
  }

  Future<Anexarse> consultarAnexarse({
    required GetDatosAnexarseOperativoRequest request,
  }) async {
    return await repository.consultarAnexarse(request: request);
  }

  Future<List<VariablesResultado>> consultarVariblesResultado({
    required GetVariablesResultadosRequest request,
  }) async {
    return await repository.consultarVariblesResultado(request: request);
  }

  Future<Finalizar> finalizaOperativo({
    required FinalizarOperativoRequest request,
  }) async {
    return await repository.finalizaOperativo(request: request);
  }

  Future<DataVehiculo> consultarVehiculo({
    required ConsultarVehiculoRequest request,
  }) async {
    return await repository.consultarVehiculo(request: request);
  }

  Future<List<Integrante>> consultarPersonalOperativo({
    required GetDatosPoliciasOperativoRequest request,
  }) async {
    return await repository.consultarPersonalOperativo(request: request);
  }

  Future<List<DataOperativosUsuario>> consultarOperativosUsuario({
    required GetDatosOperativoUsuarioRequest request,
  }) async {
    return await repository.consultarOperativosUsuario(request: request);
  }

  Future<String> downloadPdfOperativo({
    required int idGenUsuario,
    required int idHdrEvento,
  }) async {
    return await repository.downloadPdfOperativo(
      idGenUsuario: idGenUsuario,
      idHdrEvento: idHdrEvento,
    );
  }

  Future<ActualizaResultado> actualizaResultado({
    required ActualizarResultadoRequest request,
  }) async {
    return await repository.actualizaResultado(request: request);
  }

  Future<ResultadosOperativo> getDatosResultadosOperativo({
    required ResultadosOperativoRequest request,
  }) async {
    return await repository.getDatosResultadosOperativo(request: request);
  }
  Future<DataAntecedentes> getDatosAntecedentes({
    required AntecedentesRequest request,
  }) async {
    return await repository.getDatosAntecedentes(request: request);
  }
}
