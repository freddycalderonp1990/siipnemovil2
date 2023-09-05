part of 'models.dart';

class EjesHijosModel {
  EjesHijosModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataEjesHijos,
  });

  final bool success;
  final int statusCode;
  final String message;
  final List<DataEjes> dataEjesHijos;

  factory EjesHijosModel.fromJson(String str) =>
      EjesHijosModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EjesHijosModel.fromMap(Map<String, dynamic> json) => EjesHijosModel(
        success: ParseModel.parseToBool(json["success"]),
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        dataEjesHijos: json["data"] == null
            ? []
            : List<DataEjes>.from(json["data"].map((x) => DataEjes.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "dataEjesHijos":
            List<dynamic>.from(dataEjesHijos.map((x) => x.toMap())),
      };
}
