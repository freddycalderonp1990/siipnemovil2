part of 'models.dart';

class EjesAsigandosModel {
  EjesAsigandosModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataEjesAsignados,
  });

  final bool success;
  final int statusCode;
  final String message;
  final DataEjesAsignados dataEjesAsignados;

  factory EjesAsigandosModel.fromJson(String str) =>
      EjesAsigandosModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EjesAsigandosModel.fromMap(Map<String, dynamic> json) =>
      EjesAsigandosModel(
        success: ParseModel.parseToBool(json["success"]),
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        dataEjesAsignados: json["data"] == null
            ? DataEjesAsignados(
                tipoEjeRecintos: false,
                tipoEjeUnidadesPoliciales: false,
                tipoEjeOtros: false)
            : DataEjesAsignados.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "data": dataEjesAsignados.toMap(),
      };
}

class DataEjesAsignados {
  DataEjesAsignados({
    required this.tipoEjeRecintos,
    required this.tipoEjeUnidadesPoliciales,
    required this.tipoEjeOtros,
  });

  final bool tipoEjeRecintos;
  final bool tipoEjeUnidadesPoliciales;
  final bool tipoEjeOtros;

  factory DataEjesAsignados.fromJson(String str) =>
      DataEjesAsignados.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataEjesAsignados.fromMap(Map<String, dynamic> json) =>
      DataEjesAsignados(
        tipoEjeRecintos: ParseModel.parseToBool(json["tipoEjeRecintos"]),
        tipoEjeUnidadesPoliciales:
            ParseModel.parseToBool(json["tipoEjeUnidadesPoliciales"]),
        tipoEjeOtros: ParseModel.parseToBool(json["tipoEjeOtros"]),
      );

  Map<String, dynamic> toMap() => {
        "tipoEjeRecintos": tipoEjeRecintos,
        "tipoEjeUnidadesPoliciales": tipoEjeUnidadesPoliciales,
        "tipoEjeOtros": tipoEjeOtros,
      };
}
