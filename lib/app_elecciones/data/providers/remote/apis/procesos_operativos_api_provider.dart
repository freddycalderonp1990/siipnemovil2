part of '../../providers_impl_elecciones.dart';

class ProcesosOperatviosApiProviderImpl extends ProcesosOperativosRepository {
  @override
  Future<ProcesosRecAbiertoModel>
      verificarPersonalEncargadoAsignadoRecElectPorIdGenPersona(
          {required int idGenPersona}) async {
    try {
      String json = await UrlApiProviderElecciones.get(
          segmento: 'verificar-asignacion/${idGenPersona}');
      return ProcesosRecAbiertoModel.fromJson(json);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<ProcesosOperativosDisponiblesModel>
      consultarProcesosOperativosDisponibles(
          {required String latitud, required String longitud}) async {
    try {
      String json = await UrlApiProviderElecciones.get(
          segmento: 'disponibles/${latitud}/${longitud}');
      return ProcesosOperativosDisponiblesModel.fromJson(json);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<EjesAsigandosModel> consultarEjesAsigandosAlProceso(
      {required int idDgoProcElec}) async {
    try {
      String json = await UrlApiProviderElecciones.get(
          segmento: 'ejes-activos/${idDgoProcElec}');
      return EjesAsigandosModel.fromJson(json);
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
      String json = await UrlApiProviderElecciones.get(
          segmento:
              'instalaciones-cercanas/${latitud}/${longitud}/${idDgoProcElec}/${idDgoTipoEje}');
      return InstalacionesRecintosModel.fromJson(json);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<EjesHijosModel> consultarEjesHijos({required int idDgoTipoEje}) async {
    try {
      String json = await UrlApiProviderElecciones.get(
          segmento: 'ejes-hijos/${idDgoTipoEje}');
      return EjesHijosModel.fromJson(json);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<EjesUnidadesPolicialesModel> consultarEjesUnidadesPoliciales() async {
    try {
      String json = await UrlApiProviderElecciones.get(
          segmento: 'ejes-unidades-policiales');
      return EjesUnidadesPolicialesModel.fromJson(json);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<GenerarCodeModel> crearCodigo(
      {required OperativoCreateRequest operativoCreateRequest}) async {
    try {
      Object body = {
        "idGenUsuario": operativoCreateRequest.idGenUsuario,
        "idGenPersona": operativoCreateRequest.idGenPersona,
        "idDgoReciElect": operativoCreateRequest.idDgoReciElect,
        "ip": operativoCreateRequest.ip,
        "latitud": operativoCreateRequest.latitud,
        "longitud": operativoCreateRequest.longitud,
        "idDgoProcElec": operativoCreateRequest.idDgoProcElec,
        "idDgoReciUnidadPolicial":
            operativoCreateRequest.idDgoReciUnidadPolicial,
        "telefono": operativoCreateRequest.telefono
      };

      String json =
          await UrlApiProviderElecciones.post(body: body, segmento: '');
      return GenerarCodeModel.fromJson(json);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<bool> finalizarRecintoElectoral(
      {required FinalizarRecintoElectoralRequest
          finalizarRecintoElectoralRequest}) async {
    try {
      Object body = {
        "idGenUsuario": finalizarRecintoElectoralRequest.idGenUsuario,
        "idDgoCreaOpReci": finalizarRecintoElectoralRequest.idDgoCreaOpReci,
        "ip": finalizarRecintoElectoralRequest.ip,
        "idDgoPerAsigOpe": finalizarRecintoElectoralRequest.idDgoPerAsigOpe,
        "idDgoTipoEje": finalizarRecintoElectoralRequest.idDgoTipoEje
      };

      String json = await UrlApiProviderElecciones.post(
          body: body, segmento: 'finalizar');

      InserUpdateModel data = InserUpdateModel.fromJson(json, "idComentario");

      if (!data.success) {
        DialogosAwesome.getError(
            descripcion: data.message, btnOkOnPress: () {});
        return false;
      }

      return true;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<InstalacionesRecintosModel> consultarAllUnidadesPoliciales() async {
    try {
      String json = await UrlApiProviderElecciones.get(
          segmento: 'ejes-unidades-policiales-all');
      return InstalacionesRecintosModel.fromJson(json);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<DataPerPolicial> consultarDatosPerPorCedula(
      {required String cedula}) async {
    try {
      String json = await UrlApiProviderElecciones.get(
          segmento: 'datos-person/${cedula}');
      return DataPerPolicialModel.fromJson(json).dataPerPolicial;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<bool> addPersonalIntegrante(
      {required AddPersonalRequest addPersonalRequest}) async {
    try {
      Object body = {
        "idGenUsuario": addPersonalRequest.idGenUsuario,
        "idDgoCreaOpReci": addPersonalRequest.idDgoCreaOpReci,
        "ip": addPersonalRequest.ip,
        "idDgoPerAsigOpe": addPersonalRequest.idDgoPerAsigOpe,
        "idDgoReciElect": addPersonalRequest.idDgoReciElect,
        "idGenPersona": addPersonalRequest.idGenPersona,
        "latitud": addPersonalRequest.latitud,
        "longitud": addPersonalRequest.longitud,
        "idRecintoUnidadPolicial": addPersonalRequest.idRecintoUnidadPolicial,
        "idDgoTipoEje": addPersonalRequest.idDgoTipoEje
      };

      String json = await UrlApiProviderElecciones.post(
          body: body, segmento: 'add-personal');

      InserUpdateModel data =
          InserUpdateModel.fromJson(json, "idDgoPerAsigOpe");

      if (!data.success) {
        DialogosAwesome.getError(
            descripcion: data.message, btnOkOnPress: () {});
        return false;
      }

      return true;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<bool> abandonarRecintoInstalacion({required int idDgoPerAsigOpe, required int idGenUsuario, required String ip}) async {
    try {
      Object body = {
        "idGenUsuario": idGenUsuario,
        "ip":ip
      };

      String json = await UrlApiProviderElecciones.patch(
          body: body, segmento: 'abandonar/${idDgoPerAsigOpe}');

      InserUpdateModel data =
      InserUpdateModel.fromJson(json, "idDgoPerAsigOpe");

      if (!data.success) {
        DialogosAwesome.getError(
            descripcion: data.message, btnOkOnPress: () {});
        return false;
      }

      return true;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<List<DataPerAsignado>> consultarPersonalAsignado({required int idDgoCreaOpReci})async {
    try {
      String json = await UrlApiProviderElecciones.get(
          segmento: 'personal-asignado/${idDgoCreaOpReci}');
      return PerAsignadoModel.fromJson(json).dataPerAsignado;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }
}
