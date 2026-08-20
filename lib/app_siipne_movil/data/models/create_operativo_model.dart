part of 'models_siipne_movil.dart';

CreateOperativoModel createOperativoModelFromJson(String str) => CreateOperativoModel.fromJson(json.decode(str));

String createOperativoModelToJson(CreateOperativoModel data) => json.encode(data.toJson());

class CreateOperativoModel {
  final int statusCode;
  final String message;
  final DataCreateOp dataCreateOp;

  CreateOperativoModel({
    required this.statusCode,
    required this.message,
    required this.dataCreateOp,
  });

  factory CreateOperativoModel.fromJson(Map<String, dynamic> json) => CreateOperativoModel(
    statusCode: json["status_code"],
    message: json["message"],
    dataCreateOp: DataCreateOp.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": dataCreateOp.toJson(),
  };
}

class DataCreateOp {
  final int idHdrEvento;
  final int idGenGeoSenplades;
  final String fechaEvento;
  final int idTipoOperativo;

  DataCreateOp({
    required this.idHdrEvento,
    required this.idGenGeoSenplades,
    required this.fechaEvento,
    required this.idTipoOperativo
  });

  factory DataCreateOp.empty()=>DataCreateOp(idHdrEvento: 0, idGenGeoSenplades: 0, fechaEvento: "",idTipoOperativo:0);
  factory DataCreateOp.fromJson(Map<String, dynamic> json) => DataCreateOp(
    idHdrEvento:ParseModel.parseToInt( json["idHdrEvento"]),
    idGenGeoSenplades: ParseModel.parseToInt( json["idGenGeoSenplades"]),
    fechaEvento:ParseModel.parseToString( json["fechaEvento"]),
    idTipoOperativo:ParseModel.parseToInt( json["idTipoOperativo"]),
  );

  Map<String, dynamic> toJson() => {
    "idHdrEvento": idHdrEvento,
    "idGenGeoSenplades": idGenGeoSenplades,
    "fechaEvento": fechaEvento,
    "idTipoOperativo":idTipoOperativo,
  };
}
