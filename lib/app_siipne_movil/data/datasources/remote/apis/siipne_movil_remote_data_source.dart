part of '../../datasource_impl_siipne_movil.dart';

abstract class SiipneMovilRemoteDataSource {
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

  Future<Acuerdo> insertaAcuerdo({required InsertAcuerdoSiipneRequest request});

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
      return createOperativoModelFromJson(json).dataCreateOp;
    });
  }

  @override
  Future<DataConsultaPersona> consultarPersona({
    required ConsultarPersonaRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_CONSULTAR_PERSONA,
      bodyRequest: request.toJson(),
    ).toJson();

    String json = await UrlApiProviderAppCenso.post(body: body);

    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      return operativoPersonaModelFromJson(json).dataConsultaPersona;
    });
  }

  @override
  Future<Pendiente> consultaPendiente({
    required GetOperativosPendientesRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_OPERATIVOS_PENDIENTES,
      bodyRequest: request.toJson(),
    ).toJson();

    String json = await UrlApiProviderAppCenso.post(body: body);

    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      return pendienteModelFromJson(json).pendiente;
    });
  }

  @override
  Future<Anexarse> consultarAnexarse({
    required GetDatosAnexarseOperativoRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_DATOS_ANEXARSE_OPERATIVO,
      bodyRequest: request.toJson(),
    ).toJson();

    String json = await UrlApiProviderAppCenso.post(body: body);

    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      return anexarseModelFromJson(json).anexarse;
    });
  }

  @override
  Future<List<VariablesResultado>> consultarVariblesResultado({
    required GetVariablesResultadosRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_VARIABLES_RESULTADOS,
      bodyRequest: request.toJson(),
    ).toJson();

    String json = await UrlApiProviderAppCenso.post(body: body);

    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      return variablesResultadoModelFromJson(json).variablesResultado;
    });
  }

  @override
  Future<Finalizar> finalizaOperativo({
    required FinalizarOperativoRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_PUT_FINALIZAR_OPERATIVO,
      bodyRequest: request.toJson(),
    ).toJson();

    String json = await UrlApiProviderAppCenso.put(body: body);

    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      return finalizarModelFromJson(json).finalizar;
    });
  }

  @override
  Future<Acuerdo> insertaAcuerdo({
    required InsertAcuerdoSiipneRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_INSERT_ACUERDO_SIIPNE,
      bodyRequest: request.toJson(),
    ).toJson();

    String json = await UrlApiProviderAppCenso.post(body: body);

    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      return insertarAcuerdoModelFromJson(json).acuerdo;
    });
  }

  @override
  Future<DataVehiculo> consultarVehiculo({
    required ConsultarVehiculoRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_CONSULTAR_VEHICULO,
      bodyRequest: request.toJson(),
    ).toJson();

    String json = await UrlApiProviderAppCenso.post(body: body);

    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      return opeVehiculoModelFromJson(json).dataVehiculo;
    });
  }

  @override
  Future<List<Integrante>> consultarPersonalOperativo({
    required GetDatosPoliciasOperativoRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes
          .SIIPNE_MOVIL_GET_SERVIDORES_POLICIALES_OPERATIVO,
      bodyRequest: request.toJson(),
    ).toJson();

    String json = await UrlApiProviderAppCenso.post(body: body);

    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      return integrantesPoliciaModelFromJson(json).integrantes;
    });
  }

  @override
  Future<List<DataOperativosUsuario>> consultarOperativosUsuario({
    required GetDatosOperativoUsuarioRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_DATOS_OPERATIVO_USUARIO,
      bodyRequest: request.toJson(),
    ).toJson();

    String json = await UrlApiProviderAppCenso.post(body: body);

    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      return datosOperativoUsuarioModelFromJson(json).dataOperativosUsuario;
    });
  }

  @override
  Future<String> downloadPdfOperativo({
    required int idGenUsuario,
    required int idHdrEvento,
  }) async {
    return await UrlApiProviderAppCenso.downloadPdfOperativo(
      idGenUsuario: idGenUsuario,
      idHdrEvento: idHdrEvento,
    );
  }

  @override
  Future<ActualizaResultado> actualizaResultado({
    required ActualizarResultadoRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_PUT_RESULTADO,
      bodyRequest: request.toJson(),
    ).toJson();
    String json = await UrlApiProviderAppCenso.put(body: body);
    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      return actualizaResultadoModelFromJson(json).actualizaResultado;
    });
  }

  @override
  Future<ResultadosOperativo> getDatosResultadosOperativo({
    required ResultadosOperativoRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_RESULTADO_OPERATIVO,
      bodyRequest: request.toJson(),
    ).toJson();
    String json = await UrlApiProviderAppCenso.post(body: body);
    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      return resultadoOperativoModelFromJson(json).resultadosOperativo;
    });
  }

  @override
  Future<DataAntecedentes> getDatosAntecedentes({
    required AntecedentesRequest request,
  }) async {
    Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_ANTECEDENTES_PERSONA,
      bodyRequest: request.toJson(),
    ).toJson();

    String json = await UrlApiProviderAppCenso.post(body: body);

    return await ExceptionHelper.manejarErroresParseJsonException(() async {
      return antecedentesModelFromJson(json).dataAntecedentes;
    });
  }
}
