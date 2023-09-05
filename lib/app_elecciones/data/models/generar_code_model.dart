part of 'models.dart';

class GenerarCodeModel {
  GenerarCodeModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataProcesosAbierto,
  });

  final bool success;
  final int statusCode;
  final String message;
  final DataProcesosAbierto dataProcesosAbierto;

  factory GenerarCodeModel.fromJson(String str) =>
      GenerarCodeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GenerarCodeModel.fromMap(Map<String, dynamic> json) =>
      GenerarCodeModel(
        success: ParseModel.parseToBool(json["success"]),
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        dataProcesosAbierto: json["data"] == null
            ? DataProcesosAbierto.empty()
            : DataProcesosAbierto.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "dataGenerarCode": dataProcesosAbierto.toMap(),
      };
}


