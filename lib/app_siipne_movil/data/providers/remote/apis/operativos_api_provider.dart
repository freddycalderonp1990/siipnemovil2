part of '../../providers_impl.dart';

class OperativosApiProviderImpl extends OperativosRepository {
  @override
  Future<List<TipoOperativo>> getTipoOperativos(int idTipoOperativo) async {
    try {
      String json = await UrlApiProviderSiipneMovil.get(
          segmento: 'operativos/tipos/' + idTipoOperativo.toString());

      tipoOperativoModelFromJson(json).tipoOperativo.length;

      return tipoOperativoModelFromJson(json).tipoOperativo;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<List<OperativoPendiente>> getOperativosPendientes(
      {required int idGenUsuario, required int idGenPersona}) async {
    try {
      Object? body = {
        "idGenUsuario": idGenUsuario,
        "idGenPersona": idGenPersona,
        "idGenTipoTipificacionEcu": 0,
      };

      String json = await UrlApiProviderSiipneMovil.post(
          body: body, segmento: 'operativos/pendientes');

      return operativoPendienteModelFromJson(json).operativoPendiente;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<String> crearOperativo(
      OperativoCreateRequest operativoCreateRequest) async {
    try {
      Object? body = {
        "latitude": operativoCreateRequest.latitude,
        "longitude": operativoCreateRequest.longitude,
        "idGenPersona": operativoCreateRequest.idGenPersona,
        "idGenTipoTipificacionEcu":
            operativoCreateRequest.idGenTipoTipificacion,
        "idSubTipoOperativo": operativoCreateRequest.idSubTipoOperativo,
        "idGenUsuario": operativoCreateRequest.idGenUsuario
      };
      String jsonString = await UrlApiProviderSiipneMovil.post(
          body: body, segmento: 'operativos');

      Map<String, dynamic> jsonMap = json.decode(jsonString);

      String id = jsonMap['data']['idHdrEvento'].toString();

      if (id == null) {
        id = "0";
      }
      return id;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<PersonaModel> consultarPersona({
    required int idOperativo,
    required String cedula,
    required int idGenUsuario,
    required String ip,
    required String latitud,
    required String longitud,
    String descOcupante='',
    String? detalle,
    int idHdrEventoResum = 0,
  }) async {
    try {
      print(idOperativo);
      if (idOperativo == 0) {
        throw ServerException(cause: "Código del operativo incorrecto");
      } else if (idGenUsuario == 0) {
        throw ServerException(cause: "Código del usuario incorrecto");
      }

      if (cedula.length < 10) {
        throw ServerException(cause: "La cédula debe tener 10 Digitos");
      }

      Object? body = {
        "idOperativo": idOperativo,
        "documento": cedula,
        "idGenUsuario": idGenUsuario,
        "latitud": latitud,
        "longitud": longitud,
        "ip": ip,
        "detalle": detalle == null ? "" : detalle
      };

      if (idHdrEventoResum != "") {
        body = {
          "idOperativo": idOperativo,
          "documento": cedula,
          "idGenUsuario": idGenUsuario,
          "idHdrEventoResum": idHdrEventoResum,
          "detalle": detalle == null ? "" : detalle,
          "latitud": latitud,
          "longitud": longitud,
          "ip": ip,
          "descOcupante": descOcupante,

        };
      }

      String jsonString = await UrlApiProviderSiipneMovil.post(
          body: body, segmento: 'operativos/personas');

      PersonaModel data = PersonaModel.fromJson(jsonString);

      if (!data.success) {
        throw ServerException(cause: "No exiten datos");
      }

      if(data.data.dataDinardap.success){
        return data;
      }

      if(data.data.dataSiipne.success){
        return data;
      }


      throw ServerException(cause: "Cédula incorrecta");


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
    Object? body = {
      "idOperativo": idOperativo,
      "placa": placa,
      "idGenUsuario": idGenUsuario,
      "latitud": latitud,
      "longitud": longitud,
      "ip": ip
    };
    String jsonString = await UrlApiProviderSiipneMovil.post(
        body: body, segmento: 'operativos/vehiculo-placa');

    DataVehiculo? data = VehiculoModel.fromJson(jsonString).dataVehiculo;

    if (data.datosVehiculoAnt == null) {
      throw ServerException(cause: "Web services de la ant no disponible");
    }

    return data;
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
      Object? body = {
        "user": user,
        "pass": EncriptarUtil.generateSha512(pass),
        "idGenPersona": idGenPersona,
        "idHdrEvento": idHdrEvento,
      };
      String jsonString = await UrlApiProviderSiipneMovil.post(
          body: body, segmento: 'operativos/finalizar');

      Map<String, dynamic> jsonMap = json.decode(jsonString);

      String resultString = jsonMap['data']['finalizado'].toString();

      bool result = resultString == 'true' ? true : false;

      return result;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<List<DataCatalogoTipoConsulta>> consultarCatalogoTipoConsulta(
      {required String filtro}) async {
    try {
      String json = await UrlApiProviderSiipneMovil.get(
          segmento: 'operativos/catalogo/${filtro}');

      return CatalogoTipoConsultaModel.fromJson(json).dataCatalogoTipoConsulta;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<bool> updateResumenConsultas({required int idHdrEventoResum, required int idHdrTipoResum}) async {
    try {
      Object body = {
        "idHdrTipoResum": idHdrTipoResum,
      };

      String json = await UrlApiProviderSiipneMovil.patch(
          body: body, segmento: 'operativos/resumen-consultas/${idHdrEventoResum}');

      InserUpdateModel data =
      InserUpdateModel.fromJson(json, "idHdrEventoResum");

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
  Future<ResumenConsultaModel> getResumenConsulta({required int idHdrEvento_idOperativo}) async {
    try {


      String json = await UrlApiProviderSiipneMovil.get(
          segmento: 'operativos/resumen-consultas/${idHdrEvento_idOperativo}');



      return ResumenConsultaModel.fromJson(json);


    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }
}
