part of '../data_repositories_siipne_movil.dart';

class SiipneMovilOpMigracionRepositoryImpl
    extends SiipneMovilOpMigracionRepository {
  final SiipneMovilOpMigracionRemoteDataSource
      siipneMovilOpMigracionRemoteDataSource;

  SiipneMovilOpMigracionRepositoryImpl({
    required this.siipneMovilOpMigracionRemoteDataSource,
  });

  @override
  Future<List<DataModulo>> getPermisosModulos({
    required GetPermisosModulosRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.getPermisosModulos(
      request: request,
    );
  }

  @override
  Future<List<DataTipoOperativo>> getTipoOperativos({
    required GetTipoOperativosRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.getTipoOperativos(
      request: request,
    );
  }

  @override
  Future<DataCreateOp> crearOperativo({
    required CreateOperativoRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.crearOperativo(
      request: request,
    );
  }

  @override
  Future<DataConsultaPersona> consultarPersona({
    required ConsultarPersonaRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.consultarPersona(
      request: request,
    );
  }

  @override
  Future<Acuerdo> insertaAcuerdo({
    required InsertAcuerdoSiipneRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.insertaAcuerdo(
      request: request,
    );
  }

  @override
  Future<Pendiente> consultaPendiente({
    required GetOperativosPendientesRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.consultaPendiente(
      request: request,
    );
  }

  @override
  Future<Anexarse> consultarAnexarse({
    required GetDatosAnexarseOperativoRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.consultarAnexarse(
      request: request,
    );
  }

  @override
  Future<List<VariablesResultado>> consultarVariblesResultado({
    required GetVariablesResultadosRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.consultarVariblesResultado(
      request: request,
    );
  }

  @override
  Future<Finalizar> finalizaOperativo({
    required FinalizarOperativoRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.finalizaOperativo(
      request: request,
    );
  }

  @override
  Future<DataVehiculo> consultarVehiculo({
    required ConsultarVehiculoRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.consultarVehiculo(
      request: request,
    );
  }

  @override
  Future<List<Integrante>> consultarPersonalOperativo({
    required GetDatosPoliciasOperativoRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.consultarPersonalOperativo(
      request: request,
    );
  }

  @override
  Future<List<DataOperativosUsuario>> consultarOperativosUsuario({
    required GetDatosOperativoUsuarioRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.consultarOperativosUsuario(
      request: request,
    );
  }

  @override
  Future<String> downloadPdfOperativo({
    required int idGenUsuario,
    required int idHdrEvento,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.downloadPdfOperativo(
      idGenUsuario: idGenUsuario,
      idHdrEvento: idHdrEvento,
    );
  }

  @override
  Future<ActualizaResultado> actualizaResultado({
    required ActualizarResultadoRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.actualizaResultado(
      request: request,
    );
  }

  @override
  Future<ResultadosOperativo> getDatosResultadosOperativo({
    required ResultadosOperativoRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource
        .getDatosResultadosOperativo(request: request);
  }

  @override
  Future<DataAntecedentes> getDatosAntecedentes({
    required AntecedentesRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.getDatosAntecedentes(
      request: request,
    );
  }

  @override
  Future<List<DataExtranjeroDocumento>> getDatosExtranjeroDocumento({
    required GetDatosExtranjeroDocumentoRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource
        .getDatosExtranjeroDocumento(request: request);
  }

  @override
  Future<DataMovimientosMigratorios> getMovimientosMigratorios({
    required GetMovimientosMigratoriosRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.getMovimientosMigratorios(
      request: request,
    );
  }

  @override
  Future<DataRegistroConsultaMigracion> registrarConsultaMigracion({
    required RegistroConsultaMigracionRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.registrarConsultaMigracion(
      request: request,
    );
  }

  @override
  Future<DataVisaExtranjero> getVisaExtranjero({
    required GetVisaExtranjeroRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.getVisaExtranjero(
      request: request,
    );
  }

  @override
  Future<DataVisasElectronicas> getVisasElectronicas({
    required GetVisasElectronicasRequest request,
  }) {
    return siipneMovilOpMigracionRemoteDataSource.getVisasElectronicas(
      request: request,
    );
  }
}
