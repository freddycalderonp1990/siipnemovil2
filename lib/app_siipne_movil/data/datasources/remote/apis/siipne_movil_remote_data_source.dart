part of '../../datasource_impl_siipne_movil.dart';

abstract class SiipneMovilRemoteDataSource {
  //Se define que cosas quiero hacer
  //se definen los contartos

  Future<List<DataModulo>> getPermisosModulos({
    required GetPermisosModulosRequest request,
  });

  Future<List<DataTipoOperativo>> getTipoOperativos({
    required GetTipoOperativosRequest request,
  });

  Future<DataCreateOp> crearOperativo({
    required CreateOperativoRequest request,
  });
}

class SiipneMovilRemoteDataSourceImpl implements SiipneMovilRemoteDataSource {
  @override
  Future<List<DataModulo>> getPermisosModulos({
    required GetPermisosModulosRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_MODULOS,
      bodyRequest: request.toJson(),
    ).toJson();
    String json = await UrlApiProviderAppCenso.post(body: body);

    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      // Parsear y retornar el modelo correspondiente
      return permisosModulosModelFromJson(json).dataModulos;
    });
  }

  @override
  Future<List<DataTipoOperativo>> getTipoOperativos({
    required GetTipoOperativosRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_TIPOS_OPERATIVOS,
      bodyRequest: request.toJson(),
    ).toJson();
    String json = await UrlApiProviderAppCenso.post(body: body);

    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      // Parsear y retornar el modelo correspondiente
      return tipoOperativoModelFromJson(json).dataTipoOperativos;
    });
  }

  @override
  Future<DataCreateOp> crearOperativo({
    required CreateOperativoRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_CREATE_OPERATIVO,
      bodyRequest: request.toJson(),
    ).toJson();
    String json = await UrlApiProviderAppCenso.post(body: body);

    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      // Parsear y retornar el modelo correspondiente
      return createOperativoModelFromJson(json).dataCreateOp;
    });
  }
}
