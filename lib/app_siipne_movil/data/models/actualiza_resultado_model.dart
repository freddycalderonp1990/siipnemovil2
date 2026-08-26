part of 'models_siipne_movil.dart';

ActualizaResultadoModel actualizaResultadoModelFromJson(String str) =>
    ActualizaResultadoModel.fromJson(json.decode(str));

String actualizaResultadoModelToJson(ActualizaResultadoModel data) =>
    json.encode(data.toJson());

class ActualizaResultadoModel {
  int statusCode;
  String message;
  ActualizaResultado actualizaResultado;

  ActualizaResultadoModel({
    required this.statusCode,
    required this.message,
    required this.actualizaResultado,
  });

  factory ActualizaResultadoModel.fromJson(Map<String, dynamic> json) =>
      ActualizaResultadoModel(
        statusCode: json["status_code"],
        message: json["message"],
        actualizaResultado: ActualizaResultado.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": actualizaResultado.toJson(),
  };
}

class ActualizaResultado {
  int idHdrEventoResum;

  ActualizaResultado({required this.idHdrEventoResum});

  factory ActualizaResultado.fromJson(Map<String, dynamic> json) =>
      ActualizaResultado(
        idHdrEventoResum: ParseModel.parseToInt(json["idHdrEventoResum"]),
      );

  Map<String, dynamic> toJson() => {"idHdrEventoResum": idHdrEventoResum};
}
