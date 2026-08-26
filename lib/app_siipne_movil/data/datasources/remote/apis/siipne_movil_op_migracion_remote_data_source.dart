part of '../../datasource_impl_siipne_movil.dart';

abstract class SiipneMovilOpMigracionRemoteDataSource {
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

class SiipneMovilOpMigracionRemoteDataSourceImpl
    implements SiipneMovilOpMigracionRemoteDataSource {
  const SiipneMovilOpMigracionRemoteDataSourceImpl();

  Future<String> _post({
    required String uri,
    required Map<String, dynamic> bodyRequest,
  }) {
    final Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: uri,
      bodyRequest: bodyRequest,
    ).toJson();

    return UrlApiProviderAppCenso.post(body: body);
  }

  Future<String> _put({
    required String uri,
    required Map<String, dynamic> bodyRequest,
  }) {
    final Map<String, dynamic> body = HeadAppSiipneMovilRequest(
      uri: uri,
      bodyRequest: bodyRequest,
    ).toJson();

    return UrlApiProviderAppCenso.put(body: body);
  }

  @override
  Future<List<DataModulo>> getPermisosModulos({
    required GetPermisosModulosRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_MODULOS,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return permisosModulosModelFromJson(response).dataModulos;
    });
  }

  @override
  Future<List<DataTipoOperativo>> getTipoOperativos({
    required GetTipoOperativosRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_TIPOS_OPERATIVOS,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return tipoOperativoModelFromJson(response).dataTipoOperativos;
    });
  }

  @override
  Future<DataCreateOp> crearOperativo({
    required CreateOperativoRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_CREATE_OPERATIVO,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return createOperativoModelFromJson(response).dataCreateOp;
    });
  }

  @override
  Future<DataConsultaPersona> consultarPersona({
    required ConsultarPersonaRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_CONSULTAR_PERSONA,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return operativoPersonaModelFromJson(response).dataConsultaPersona;
    });
  }

  @override
  Future<Acuerdo> insertaAcuerdo({
    required InsertAcuerdoSiipneRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_INSERT_ACUERDO_SIIPNE,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return insertarAcuerdoModelFromJson(response).acuerdo;
    });
  }

  @override
  Future<Pendiente> consultaPendiente({
    required GetOperativosPendientesRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_OPERATIVOS_PENDIENTES,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return pendienteModelFromJson(response).pendiente;
    });
  }

  @override
  Future<Anexarse> consultarAnexarse({
    required GetDatosAnexarseOperativoRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes
          .SIIPNE_MOVIL_GET_DATOS_ANEXARSE_OPERATIVO,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return anexarseModelFromJson(response).anexarse;
    });
  }

  @override
  Future<List<VariablesResultado>> consultarVariblesResultado({
    required GetVariablesResultadosRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_VARIABLES_RESULTADOS,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return variablesResultadoModelFromJson(response).variablesResultado;
    });
  }

  @override
  Future<Finalizar> finalizaOperativo({
    required FinalizarOperativoRequest request,
  }) async {
    final String response = await _put(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_PUT_FINALIZAR_OPERATIVO,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return finalizarModelFromJson(response).finalizar;
    });
  }

  @override
  Future<DataVehiculo> consultarVehiculo({
    required ConsultarVehiculoRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_CONSULTAR_VEHICULO,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return opeVehiculoModelFromJson(response).dataVehiculo;
    });
  }

  @override
  Future<List<Integrante>> consultarPersonalOperativo({
    required GetDatosPoliciasOperativoRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes
          .SIIPNE_MOVIL_GET_SERVIDORES_POLICIALES_OPERATIVO,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return integrantesPoliciaModelFromJson(response).integrantes;
    });
  }

  @override
  Future<List<DataOperativosUsuario>> consultarOperativosUsuario({
    required GetDatosOperativoUsuarioRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_DATOS_OPERATIVO_USUARIO,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return datosOperativoUsuarioModelFromJson(response)
          .dataOperativosUsuario;
    });
  }

  @override
  Future<String> downloadPdfOperativo({
    required int idGenUsuario,
    required int idHdrEvento,
  }) {
    return UrlApiProviderAppCenso.downloadPdfOperativo(
      idGenUsuario: idGenUsuario,
      idHdrEvento: idHdrEvento,
    );
  }

  @override
  Future<ActualizaResultado> actualizaResultado({
    required ActualizarResultadoRequest request,
  }) async {
    final String response = await _put(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_PUT_RESULTADO,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return actualizaResultadoModelFromJson(response).actualizaResultado;
    });
  }

  @override
  Future<ResultadosOperativo> getDatosResultadosOperativo({
    required ResultadosOperativoRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_RESULTADO_OPERATIVO,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return resultadoOperativoModelFromJson(response).resultadosOperativo;
    });
  }

  @override
  Future<DataAntecedentes> getDatosAntecedentes({
    required AntecedentesRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_ANTECEDENTES_PERSONA,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return antecedentesModelFromJson(response).dataAntecedentes;
    });
  }

  @override
  Future<List<DataExtranjeroDocumento>> getDatosExtranjeroDocumento({
    required GetDatosExtranjeroDocumentoRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes
          .SIIPNE_MOVIL_GET_DATOS_EXTRANJERO_DOCUMENTO,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return datosExtranjeroDocumentoModelFromJson(response).data;
    });
  }

  @override
  Future<DataMovimientosMigratorios> getMovimientosMigratorios({
    required GetMovimientosMigratoriosRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_MOVIMIENTOS_MIGRATORIOS,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return movimientosMigratoriosModelFromJson(response).data;
    });
  }

  @override
  Future<DataRegistroConsultaMigracion> registrarConsultaMigracion({
    required RegistroConsultaMigracionRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes
          .SIIPNE_MOVIL_GET_DATOS_REGISTRO_CONSULTA_MIGRACION,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return registroConsultaMigracionModelFromJson(response).data;
    });
  }

  @override
  Future<DataVisaExtranjero> getVisaExtranjero({
    required GetVisaExtranjeroRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes.SIIPNE_MOVIL_GET_VISA_EXTRANJERO,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return visaExtranjeroModelFromJson(response).data;
    });
  }

  @override
  Future<DataVisasElectronicas> getVisasElectronicas({
    required GetVisasElectronicasRequest request,
  }) async {
    final String response = await _post(
      uri: SiipneMovilApiConstantes
          .SIIPNE_MOVIL_GET_DATOS_VISAS_ELECTRONICAS,
      bodyRequest: request.toJson(),
    );

    return ExceptionHelper.manejarErroresParseJsonException(() async {
      return visasElectronicasModelFromJson(response).data;
    });
  }
}
