part of 'models_siipne_movil.dart';

PendienteModel pendienteModelFromJson(String str) =>
    PendienteModel.fromJson(json.decode(str));

String pendienteModelToJson(PendienteModel data) => json.encode(data.toJson());

class PendienteModel {
  int statusCode;
  String message;
  Pendiente pendiente;

  PendienteModel({
    required this.statusCode,
    required this.message,
    required this.pendiente,
  });

  factory PendienteModel.fromJson(Map<String, dynamic> json) => PendienteModel(
    statusCode: json["status_code"],
    message: json["message"],
    pendiente: Pendiente.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": pendiente.toJson(),
  };
}

class Pendiente {
  int idHdrEvento;
  int idGenGeoSenplades;
  String fechaEvento;
  String descripcion;
  int idTipoOperativo;

  Pendiente({
    required this.idHdrEvento,
    required this.idGenGeoSenplades,
    required this.fechaEvento,
    required this.descripcion,
    required this.idTipoOperativo,
  });

  factory Pendiente.fromJson(Map<String, dynamic> json) => Pendiente(
    idHdrEvento: ParseModel.parseToInt(json["idHdrEvento"]),
    idGenGeoSenplades: ParseModel.parseToInt(json["idGenGeoSenplades"]),
    fechaEvento: ParseModel.parseToString(json["fechaEvento"]),
    descripcion: ParseModel.parseToString(json["descripcion"]),
    idTipoOperativo: ParseModel.parseToInt(json["idTipoOperativo"]),
  );

  Map<String, dynamic> toJson() => {
    "idHdrEvento": idHdrEvento,
    "idGenGeoSenplades": idGenGeoSenplades,
    "fechaEvento": fechaEvento,
    "descripcion": descripcion,
    "idTipoOperativo": idTipoOperativo,
  };
}
