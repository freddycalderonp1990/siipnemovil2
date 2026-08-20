part of '../data_repositories_siipne_movil.dart';

class SiipneMovilRepositoryImpl extends SiipneMovilRepository{
  final SiipneMovilRemoteDataSource siipneMovilRemoteDataSource;

  SiipneMovilRepositoryImpl({
    required this.siipneMovilRemoteDataSource,
  });

  @override
  Future<List<DataModulo>> getPermisosModulos({
    required GetPermisosModulosRequest request,
  })async{
    return await siipneMovilRemoteDataSource.getPermisosModulos(
      request:request,
    );
  }

  @override
  Future<List<DataTipoOperativo>> getTipoOperativos({
    required GetTipoOperativosRequest request,
  })async{
    return await siipneMovilRemoteDataSource.getTipoOperativos(
      request:request,
    );
  }

  @override
  Future<DataCreateOp> crearOperativo({
    required CreateOperativoRequest request,
  })async{
    return await siipneMovilRemoteDataSource.crearOperativo(
      request:request,
    );
  }

  @override
  Future<DataConsultaPersona> consultarPersona({
    required ConsultarPersonaRequest request,
  })async{
    return await siipneMovilRemoteDataSource.consultarPersona(
      request:request,
    );
  }

  @override
  Future<Pendiente> consultaPendiente({
    required GetOperativosPendientesRequest request,
  })async{
    return await siipneMovilRemoteDataSource.consultaPendiente(
      request:request,
    );
  }

  @override
  Future<Anexarse> consultarAnexarse({
    required GetDatosAnexarseOperativoRequest request,
  })async{
    return await siipneMovilRemoteDataSource.consultarAnexarse(
      request:request,
    );
  }

  @override
  Future<List<VariablesResultado>> consultarVariblesResultado({
    required GetVariablesResultadosRequest request,
  })async{
    return await siipneMovilRemoteDataSource.consultarVariblesResultado(
      request:request,
    );
  }

  @override
  Future<Finalizar> finalizaOperativo({
    required FinalizarOperativoRequest request,
  })async{
    return await siipneMovilRemoteDataSource.finalizaOperativo(
      request:request,
    );
  }

  @override
  Future<Acuerdo> insertaAcuerdo({
    required InsertAcuerdoSiipneRequest request,
  })async{
    return await siipneMovilRemoteDataSource.insertaAcuerdo(
      request:request,
    );
  }

  @override
  Future<DataVehiculo> consultarVehiculo({
    required ConsultarVehiculoRequest request,
  })async{
    return await siipneMovilRemoteDataSource.consultarVehiculo(
      request:request,
    );
  }

  @override
  Future<List<Integrante>> consultarPersonalOperativo({
    required GetDatosPoliciasOperativoRequest request,
  })async{
    return await siipneMovilRemoteDataSource.consultarPersonalOperativo(
      request:request,
    );
  }

  @override
  Future<List<DataOperativosUsuario>> consultarOperativosUsuario({
    required GetDatosOperativoUsuarioRequest request,
  })async{
    return await siipneMovilRemoteDataSource.consultarOperativosUsuario(
      request:request,
    );
  }

  @override
  Future<String> downloadPdfOperativo({
    required int idGenUsuario,
    required int idHdrEvento
  })async{
    return await siipneMovilRemoteDataSource.downloadPdfOperativo(
      idHdrEvento:idHdrEvento, idGenUsuario: idGenUsuario,
    );
  }

  @override
  Future<ActualizaResultado> actualizaResultado({required ActualizarResultadoRequest request}) async{
    return await siipneMovilRemoteDataSource.actualizaResultado(request: request
    );
  }

  @override
  Future<ResultadosOperativo> getDatosResultadosOperativo({required ResultadosOperativoRequest request}) async{
    return await siipneMovilRemoteDataSource.getDatosResultadosOperativo(request: request
    );
  }

  @override
  Future<DataAntecedentes> getDatosAntecedentes({required AntecedentesRequest request}) async {
    return await siipneMovilRemoteDataSource.getDatosAntecedentes(request: request
    );
  }

}