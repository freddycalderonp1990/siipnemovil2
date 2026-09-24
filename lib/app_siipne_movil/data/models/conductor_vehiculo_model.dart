part of 'models_siipne_movil.dart';

ConductorVehiculoModel conductorVehiculoModelFromJson(String str) => ConductorVehiculoModel.fromJson(json.decode(str));

String conductorVehiculoModelToJson(ConductorVehiculoModel data) => json.encode(data.toJson());

class ConductorVehiculoModel {
  int statusCode;
  String message;
  ConductorVehiculo conductorVehiculo;

  ConductorVehiculoModel({
    required this.statusCode,
    required this.message,
    required this.conductorVehiculo,
  });

  factory ConductorVehiculoModel.fromJson(Map<String, dynamic> json) => ConductorVehiculoModel(
    statusCode: json["status_code"],
    message: json["message"],
    conductorVehiculo: ConductorVehiculo.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": conductorVehiculo.toJson(),
  };
}

class ConductorVehiculo {
  String placa;
  String cedula;
  String conductor;
  String edad;
  String sexo;
  String tipoLicencia;
  String puntosLicencia;
  String caducaLicencia;
  String tipoOcupante;

  ConductorVehiculo({
    required this.placa,
    required this.cedula,
    required this.conductor,
    required this.edad,
    required this.sexo,
    required this.tipoLicencia,
    required this.puntosLicencia,
    required this.caducaLicencia,
    required this.tipoOcupante,
  });

  factory ConductorVehiculo.fromJson(Map<String, dynamic> json) => ConductorVehiculo(
    placa: ParseModel.parseToString(json["placa"]),
    cedula: ParseModel.parseToString(json["cedula"]),
    conductor: ParseModel.parseToString(json["conductor"]),
    edad: ParseModel.parseToString(json["edad"]),
    sexo: ParseModel.parseToString(json["sexo"]),
    tipoLicencia: ParseModel.parseToString(json["tipoLicencia"]),
    puntosLicencia: ParseModel.parseToString(json["puntosLicencia"]),
    caducaLicencia: ParseModel.parseToString(json["caducaLicencia"]),
    tipoOcupante: ParseModel.parseToString(json["tipoOcupante"]),
  );

  Map<String, dynamic> toJson() => {
    "placa": placa,
    "cedula": cedula,
    "conductor": conductor,
    "edad": edad,
    "sexo": sexo,
    "tipoLicencia": tipoLicencia,
    "puntosLicencia": puntosLicencia,
    "caducaLicencia": caducaLicencia,
    "tipoOcupante": tipoOcupante,
  };
}
