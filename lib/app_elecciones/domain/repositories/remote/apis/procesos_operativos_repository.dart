part of '../../domain_repositories.dart';

abstract class ProcesosOperativosRepository {
  //Se define que cosas quiero hacer
  //se definen los contartos

  Future<ProcesosRecAbiertoModel>
      verificarPersonalEncargadoAsignadoRecElectPorIdGenPersona({
    required int idGenPersona,
  });

  Future<ProcesosOperativosDisponiblesModel>
      consultarProcesosOperativosDisponibles(
          {required String latitud, required String longitud});

  Future<EjesAsigandosModel> consultarEjesAsigandosAlProceso(
      {required int idDgoProcElec});

  Future<InstalacionesRecintosModel> consultarInstalacionesRecintosCercanos(
      {required String latitud,
      required String longitud,
      required int idDgoProcElec,
      required int idDgoTipoEje});

  Future<EjesUnidadesPolicialesModel> consultarEjesUnidadesPoliciales();

  Future<EjesHijosModel> consultarEjesHijos({required int idDgoTipoEje});

  Future<GenerarCodeModel> crearCodigo(
      {required OperativoCreateRequest operativoCreateRequest});

  Future<bool> finalizarRecintoElectoral(
      {required FinalizarRecintoElectoralRequest
          finalizarRecintoElectoralRequest});

  Future<InstalacionesRecintosModel> consultarAllUnidadesPoliciales();

  Future<DataPerPolicial> consultarDatosPerPorCedula({required String cedula});

  Future<bool> addPersonalIntegrante(
      {required AddPersonalRequest addPersonalRequest});

  Future<List<DataPerAsignado>> consultarPersonalAsignado(
      {required int idDgoCreaOpReci});

  Future<bool> abandonarRecintoInstalacion(
      {required int idDgoPerAsigOpe,
      required int idGenUsuario,
      required String ip});
}
