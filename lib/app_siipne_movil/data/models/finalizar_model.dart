part of 'models_siipne_movil.dart';

FinalizarModel finalizarModelFromJson(String str) =>
    FinalizarModel.fromJson(json.decode(str));

String finalizarModelToJson(FinalizarModel data) => json.encode(data.toJson());

class FinalizarModel {
  int statusCode;
  String message;
  Finalizar finalizar;

  FinalizarModel({
    required this.statusCode,
    required this.message,
    required this.finalizar,
  });

  factory FinalizarModel.fromJson(Map<String, dynamic> json) => FinalizarModel(
    statusCode: json["status_code"],
    message: json["message"],
    finalizar: Finalizar.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": finalizar.toJson(),
  };
}

class Finalizar {
  int idHdrEvento;

  Finalizar({required this.idHdrEvento});

  factory Finalizar.fromJson(Map<String, dynamic> json) =>
      Finalizar(idHdrEvento: json["idHdrEvento"]);

  Map<String, dynamic> toJson() => {"idHdrEvento": idHdrEvento};
}
