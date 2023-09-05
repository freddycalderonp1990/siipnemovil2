part of 'models.dart';

class CatalogoTipoConsultaModel {
  CatalogoTipoConsultaModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataCatalogoTipoConsulta,
  });

  final bool success;
  final int statusCode;
  final String message;
  final List<DataCatalogoTipoConsulta> dataCatalogoTipoConsulta;

  factory CatalogoTipoConsultaModel.fromJson(String str) =>
      CatalogoTipoConsultaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CatalogoTipoConsultaModel.fromMap(Map<String, dynamic> json) =>
      CatalogoTipoConsultaModel(
        success: ParseModel.parseToBool(json["success"]),
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        dataCatalogoTipoConsulta: json["data"] == null
            ? []
            : List<DataCatalogoTipoConsulta>.from(
                json["data"].map((x) => DataCatalogoTipoConsulta.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "data":
            List<dynamic>.from(dataCatalogoTipoConsulta.map((x) => x.toMap())),
      };
}

class DataCatalogoTipoConsulta {
  DataCatalogoTipoConsulta({
    required this.idHdrTipoResum,
    required this.desHdrTipoResum,
  });

  final int idHdrTipoResum;
  final String desHdrTipoResum;

  factory DataCatalogoTipoConsulta.fromJson(String str) =>
      DataCatalogoTipoConsulta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataCatalogoTipoConsulta.fromMap(Map<String, dynamic> json) =>
      DataCatalogoTipoConsulta(
        idHdrTipoResum:ParseModel.parseToInt( json["idHdrTipoResum"]),
        desHdrTipoResum:ParseModel.parseToString( json["desHdrTipoResum"]),
      );

  Map<String, dynamic> toMap() => {
        "idHdrTipoResum": idHdrTipoResum,
        "desHdrTipoResum": desHdrTipoResum,
      };
}
