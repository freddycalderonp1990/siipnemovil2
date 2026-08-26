part of 'repository_siipne_movil.dart';

abstract class SiipneMovilOpMigracionRepository {
  Future<List<DataModulo>> getPermisosModulos({
    required GetPermisosModulosRequest request,
  });

  Future<List<DataTipoOperativo>> getTipoOperativos({
    required GetTipoOperativosRequest request,
  });

  Future<DataCreateOp> crearOperativo({
    required CreateOperativoRequest request,
  });

  Future<DataConsultaPersona> consultarPersona({
    required ConsultarPersonaRequest request,
  });

  Future<Acuerdo> insertaAcuerdo({
    required InsertAcuerdoSiipneRequest request,
  });

  Future<Pendiente> consultaPendiente({
    required GetOperativosPendientesRequest request,
  });

  Future<Anexarse> consultarAnexarse({
    required GetDatosAnexarseOperativoRequest request,
  });

  Future<List<VariablesResultado>> consultarVariblesResultado({
    required GetVariablesResultadosRequest request,
  });

  Future<Finalizar> finalizaOperativo({
    required FinalizarOperativoRequest request,
  });

  Future<DataVehiculo> consultarVehiculo({
    required ConsultarVehiculoRequest request,
  });

  Future<List<Integrante>> consultarPersonalOperativo({
    required GetDatosPoliciasOperativoRequest request,
  });

  Future<List<DataOperativosUsuario>> consultarOperativosUsuario({
    required GetDatosOperativoUsuarioRequest request,
  });

  Future<String> downloadPdfOperativo({
    required int idGenUsuario,
    required int idHdrEvento,
  });

  Future<ActualizaResultado> actualizaResultado({
    required ActualizarResultadoRequest request,
  });

  Future<ResultadosOperativo> getDatosResultadosOperativo({
    required ResultadosOperativoRequest request,
  });

  Future<DataAntecedentes> getDatosAntecedentes({
    required AntecedentesRequest request,
  });

  Future<List<DataExtranjeroDocumento>> getDatosExtranjeroDocumento({
    required GetDatosExtranjeroDocumentoRequest request,
  });

  Future<DataMovimientosMigratorios> getMovimientosMigratorios({
    required GetMovimientosMigratoriosRequest request,
  });

  Future<DataRegistroConsultaMigracion> registrarConsultaMigracion({
    required RegistroConsultaMigracionRequest request,
  });

  Future<DataVisaExtranjero> getVisaExtranjero({
    required GetVisaExtranjeroRequest request,
  });

  Future<DataVisasElectronicas> getVisasElectronicas({
    required GetVisasElectronicasRequest request,
  });
}
