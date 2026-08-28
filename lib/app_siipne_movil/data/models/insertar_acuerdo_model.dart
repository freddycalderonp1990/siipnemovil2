part of 'models_siipne_movil.dart';

InsertarAcuerdoModel insertarAcuerdoModelFromJson(String str) =>
    InsertarAcuerdoModel.fromJson(json.decode(str));
String insertarAcuerdoModelToJson(InsertarAcuerdoModel data) =>
    json.encode(data.toJson());

class InsertarAcuerdoModel {
  int statusCode;
  String message;
  Acuerdo acuerdo;

  InsertarAcuerdoModel({
    required this.statusCode,
    required this.message,
    required this.acuerdo,
  });

  factory InsertarAcuerdoModel.fromJson(Map<String, dynamic> json) =>
      InsertarAcuerdoModel(
        statusCode: json["status_code"],
        message: json["message"],
        acuerdo: Acuerdo.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": acuerdo.toJson(),
  };
}

class Acuerdo {
  String idDgoAcuerdoSiipneMovil;

  Acuerdo({required this.idDgoAcuerdoSiipneMovil});

  factory Acuerdo.fromJson(Map<String, dynamic> json) => Acuerdo(
    idDgoAcuerdoSiipneMovil: ParseModel.parseToString(
      json["idDgoAcuerdoSiipneMovil"],
    ),
  );

  Map<String, dynamic> toJson() => {
    "idDgoAcuerdoSiipneMovil": idDgoAcuerdoSiipneMovil,
  };
}
