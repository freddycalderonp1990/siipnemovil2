part of 'models_siipne_movil.dart';

IntegrantesPoliciaModel integrantesPoliciaModelFromJson(String str) =>
    IntegrantesPoliciaModel.fromJson(json.decode(str));

String integrantesPoliciaModelToJson(IntegrantesPoliciaModel data) =>
    json.encode(data.toJson());

class IntegrantesPoliciaModel {
  int statusCode;
  String message;
  List<Integrante> integrantes;

  IntegrantesPoliciaModel({
    required this.statusCode,
    required this.message,
    required this.integrantes,
  });

  factory IntegrantesPoliciaModel.fromJson(Map<String, dynamic> json) =>
      IntegrantesPoliciaModel(
        statusCode: json["status_code"],
        message: json["message"],
        integrantes: List<Integrante>.from(
          json["data"].map((x) => Integrante.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": List<dynamic>.from(integrantes.map((x) => x.toJson())),
  };
}

class Integrante {
  int idHdrEvento;
  String fechaEvento;
  int idUsuario;
  String jefe;
  String integrante;
  String documento;
  String fecha;
  int idTipoOperativo;

  Integrante({
    required this.idHdrEvento,
    required this.fechaEvento,
    required this.idUsuario,
    required this.jefe,
    required this.integrante,
    required this.documento,
    required this.fecha,
    required this.idTipoOperativo,
  });

  factory Integrante.fromJson(Map<String, dynamic> json) => Integrante(
    idHdrEvento: ParseModel.parseToInt(json["idHdrEvento"]),
    fechaEvento: ParseModel.parseToString(json["fechaEvento"]),
    idUsuario: ParseModel.parseToInt(json["idUsuario"]),
    jefe: ParseModel.parseToString(json["jefe"]),
    integrante: ParseModel.parseToString(json["integrante"]),
    documento: ParseModel.parseToString(json["documento"]),
    fecha: ParseModel.parseToString(json["fecha"]),
    idTipoOperativo: ParseModel.parseToInt(json["idTipoOperativo"]),
  );

  Map<String, dynamic> toJson() => {
    "idHdrEvento": idHdrEvento,
    "fechaEvento": fechaEvento,
    "idUsuario": idUsuario,
    "jefe": jefe,
    "integrante": integrante,
    "documento": documento,
    "fecha": fecha,
    "idTipoOperativo": idTipoOperativo,
  };
}
