part of '../../data_repositories.dart';

class OperativosApiImpl extends OperativosRepository {
  final OperativosApiProviderImpl _OperativosApiProviderImpl = Get.find();

  @override
  Future<List<TipoOperativo>> getTipoOperativos(int idTipoOperativo) async {
    try {
      List<TipoOperativo> tipoOperativos =
          await _OperativosApiProviderImpl.getTipoOperativos(idTipoOperativo);

      return tipoOperativos;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<List<OperativoPendiente>> getOperativosPendientes(
      {required int idGenUsuario, required int idGenPersona}) async {
    try {
      List<OperativoPendiente> operativoPendiente =
          await _OperativosApiProviderImpl.getOperativosPendientes(
        idGenUsuario: idGenUsuario,
        idGenPersona: idGenPersona,
      );

      return operativoPendiente;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<String> crearOperativo(
      OperativoCreateRequest operativoCreateRequest) async {
    try {
      String id = await _OperativosApiProviderImpl.crearOperativo(
          operativoCreateRequest);
      return id;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<PersonaModel> consultarPersona(
      {required int idOperativo,
      required String cedula,
      required String ip,
      required String latitud,
      required String longitud,
      String descOcupante = '',
      String? detalle,
      required int idGenUsuario,
      int idHdrEventoResum = 0}) async {
    try {
      return await _OperativosApiProviderImpl.consultarPersona(
          ip: ip,
          longitud: longitud,
          latitud: latitud,
          descOcupante: descOcupante,
          detalle: detalle,
          idOperativo: idOperativo,
          cedula: cedula,
          idGenUsuario: idGenUsuario,
          idHdrEventoResum: idHdrEventoResum);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<DataVehiculo> consultarVehiculo(
      {required int idOperativo,
      required String placa,
      required String ip,
      required String latitud,
      required String longitud,
      required int idGenUsuario}) async {
    return await _OperativosApiProviderImpl.consultarVehiculo(
        longitud: longitud,
        latitud: latitud,
        ip: ip,
        idOperativo: idOperativo,
        placa: placa,
        idGenUsuario: idGenUsuario);
    try {} catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<bool> finalizarOperativo(
      {required String user,
      required String pass,
      required int idGenPersona,
      required int idHdrEvento}) async {
    try {
      return _OperativosApiProviderImpl.finalizarOperativo(
          user: user,
          pass: pass,
          idGenPersona: idGenPersona,
          idHdrEvento: idHdrEvento);
      ;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<List<DataCatalogoTipoConsulta>> consultarCatalogoTipoConsulta(
      {required String filtro}) async {
    try {
      return await _OperativosApiProviderImpl.consultarCatalogoTipoConsulta(
          filtro: filtro);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<bool> updateResumenConsultas(
      {required int idHdrEventoResum, required int idHdrTipoResum}) async {
    try {
      return await _OperativosApiProviderImpl.updateResumenConsultas(
          idHdrEventoResum: idHdrEventoResum, idHdrTipoResum: idHdrTipoResum);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<ResumenConsultaModel> getResumenConsulta(
      {required int idHdrEvento_idOperativo}) async {
    try {
      return await _OperativosApiProviderImpl.getResumenConsulta(
          idHdrEvento_idOperativo: idHdrEvento_idOperativo);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }
}
