part of '../../data_repositories.dart';

class ProcesosOperativosApiImpl extends ProcesosOperativosRepository {
  final ProcesosOperatviosApiProviderImpl _procesosOperatviosApiProviderImpl =
      Get.find();

  @override
  Future<ProcesosRecAbiertoModel>
      verificarPersonalEncargadoAsignadoRecElectPorIdGenPersona(
          {required int idGenPersona}) async {
    try {
      return _procesosOperatviosApiProviderImpl
          .verificarPersonalEncargadoAsignadoRecElectPorIdGenPersona(
              idGenPersona: idGenPersona);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<ProcesosOperativosDisponiblesModel>
      consultarProcesosOperativosDisponibles(
          {required String latitud, required String longitud}) async {
    try {
      return _procesosOperatviosApiProviderImpl
          .consultarProcesosOperativosDisponibles(
              latitud: latitud, longitud: longitud);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<EjesAsigandosModel> consultarEjesAsigandosAlProceso(
      {required int idDgoProcElec}) async {
    try {
      return _procesosOperatviosApiProviderImpl.consultarEjesAsigandosAlProceso(
          idDgoProcElec: idDgoProcElec);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<InstalacionesRecintosModel> consultarInstalacionesRecintosCercanos(
      {required String latitud,
      required String longitud,
      required int idDgoProcElec,
      required int idDgoTipoEje}) async {
    try {
      return _procesosOperatviosApiProviderImpl
          .consultarInstalacionesRecintosCercanos(
              latitud: latitud,
              longitud: longitud,
              idDgoProcElec: idDgoProcElec,
              idDgoTipoEje: idDgoTipoEje);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<EjesHijosModel> consultarEjesHijos({required int idDgoTipoEje}) async {
    try {
      return _procesosOperatviosApiProviderImpl.consultarEjesHijos(
          idDgoTipoEje: idDgoTipoEje);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<EjesUnidadesPolicialesModel> consultarEjesUnidadesPoliciales() async {
    try {
      return _procesosOperatviosApiProviderImpl
          .consultarEjesUnidadesPoliciales();
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<GenerarCodeModel> crearCodigo(
      {required OperativoCreateRequest operativoCreateRequest}) async {
    try {
      return _procesosOperatviosApiProviderImpl.crearCodigo(
          operativoCreateRequest: operativoCreateRequest);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<bool> finalizarRecintoElectoral(
      {required FinalizarRecintoElectoralRequest
          finalizarRecintoElectoralRequest}) async {
    try {
      return _procesosOperatviosApiProviderImpl.finalizarRecintoElectoral(
          finalizarRecintoElectoralRequest: finalizarRecintoElectoralRequest);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<InstalacionesRecintosModel> consultarAllUnidadesPoliciales() async {
    try {
      return _procesosOperatviosApiProviderImpl
          .consultarAllUnidadesPoliciales();
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<DataPerPolicial> consultarDatosPerPorCedula(
      {required String cedula}) async {
    try {
      return _procesosOperatviosApiProviderImpl.consultarDatosPerPorCedula(
          cedula: cedula);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<bool> addPersonalIntegrante(
      {required AddPersonalRequest addPersonalRequest}) async {
    try {
      return _procesosOperatviosApiProviderImpl.addPersonalIntegrante(
          addPersonalRequest: addPersonalRequest);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<bool> abandonarRecintoInstalacion(
      {required int idDgoPerAsigOpe,
      required int idGenUsuario,
      required String ip}) async {
    try {
      return _procesosOperatviosApiProviderImpl.abandonarRecintoInstalacion(
          idDgoPerAsigOpe: idDgoPerAsigOpe, idGenUsuario: idGenUsuario, ip: ip);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<List<DataPerAsignado>> consultarPersonalAsignado(
      {required int idDgoCreaOpReci}) async {
    try {
      return _procesosOperatviosApiProviderImpl.consultarPersonalAsignado(
          idDgoCreaOpReci: idDgoCreaOpReci);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }
}
