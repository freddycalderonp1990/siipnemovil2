part of 'models_siipne_movil.dart';

DatosOperativoUsuarioModel datosOperativoUsuarioModelFromJson(String str) =>
    DatosOperativoUsuarioModel.fromJson(json.decode(str));

String datosOperativoUsuarioModelToJson(DatosOperativoUsuarioModel data) =>
    json.encode(data.toJson());

class DatosOperativoUsuarioModel {
  int statusCode;
  String message;
  List<DataOperativosUsuario> dataOperativosUsuario;

  DatosOperativoUsuarioModel({
    required this.statusCode,
    required this.message,
    required this.dataOperativosUsuario,
  });

  factory DatosOperativoUsuarioModel.fromJson(Map<String, dynamic> json) {
    final dynamic data = json["data"];

    return DatosOperativoUsuarioModel(
      statusCode: ParseModel.parseToInt(json["status_code"]),
      message: ParseModel.parseToString(json["message"]),
      dataOperativosUsuario: data is List
          ? data
                .map(
                  (dynamic x) => DataOperativosUsuario.fromJson(
                    Map<String, dynamic>.from(x as Map),
                  ),
                )
                .toList()
          : <DataOperativosUsuario>[],
    );
  }

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": dataOperativosUsuario.map((x) => x.toJson()).toList(),
  };
}

class DataOperativosUsuario {
  int idHdrEvento;
  String fechaEvento;
  String policia;
  String fecha;
  String zona;
  String subzona;
  String distrito;
  String circuito;
  String subcircuito;
  String tipoOperativo;

  DataOperativosUsuario({
    required this.idHdrEvento,
    required this.fechaEvento,
    required this.policia,
    required this.fecha,
    required this.zona,
    required this.subzona,
    required this.distrito,
    required this.circuito,
    required this.subcircuito,
    required this.tipoOperativo,
  });

  factory DataOperativosUsuario.fromJson(Map<String, dynamic> json) =>
      DataOperativosUsuario(
        idHdrEvento: ParseModel.parseToInt(json["idHdrEvento"]),
        fechaEvento: ParseModel.parseToString(json["fechaEvento"]),
        policia: ParseModel.parseToString(json["policia"]),
        fecha: ParseModel.parseToString(json["fecha"]),
        zona: ParseModel.parseToString(json["zona"]),
        subzona: ParseModel.parseToString(json["subzona"]),
        distrito: ParseModel.parseToString(json["distrito"]),
        circuito: ParseModel.parseToString(json["circuito"]),
        subcircuito: ParseModel.parseToString(json["subcircuito"]),
        tipoOperativo: ParseModel.parseToString(json["tipoOperativo"]),
      );

  Map<String, dynamic> toJson() => {
    "idHdrEvento": idHdrEvento,
    "fechaEvento": fechaEvento,
    "policia": policia,
    "fecha": fecha,
    "zona": zona,
    "subzona": subzona,
    "distrito": distrito,
    "circuito": circuito,
    "subcircuito": subcircuito,
    "tipoOperativo": tipoOperativo,
  };
}
