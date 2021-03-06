// To parse this JSON data, do
//
//     final datosRecintoElectoral = datosRecintoElectoralFromJson(jsonString);

part of '../models.dart';

DatosRecintoElectoral datosRecintoElectoralFromJson(String str) => DatosRecintoElectoral.fromJson(json.decode(str));

String datosRecintoElectoralToJson(DatosRecintoElectoral data) => json.encode(data.toJson());

class DatosRecintoElectoral {
  DatosRecintoElectoral({
    this.datosRecintoElectoral,
  });

  DatosRecintoElectoralClass datosRecintoElectoral;

  factory DatosRecintoElectoral.fromJson(Map<String, dynamic> json) => DatosRecintoElectoral(
    datosRecintoElectoral: json["datos"] == null ? null : DatosRecintoElectoralClass.fromJson(json["datos"]),
  );

  Map<String, dynamic> toJson() => {
    "datosRecintoElectoral": datosRecintoElectoral == null ? null : datosRecintoElectoral.toJson(),
  };
}

class DatosRecintoElectoralClass {
  DatosRecintoElectoralClass({
    this.nomRecintoElec,
    this.encargado,
    this.documento,
    this.sexoPerson,
    this.idDgoReciElect
  });

  String nomRecintoElec;
  String encargado;
  String documento;
  String sexoPerson;
  String idDgoReciElect;

  factory DatosRecintoElectoralClass.fromJson(Map<String, dynamic> json) => DatosRecintoElectoralClass(
    nomRecintoElec: json["nomRecintoElec"] == null ? null : json["nomRecintoElec"],
    encargado: json["encargado"] == null ? null : json["encargado"],
    documento: json["documento"] == null ? null : json["documento"],
    sexoPerson: json["sexoPerson"] == null ? null : json["sexoPerson"],
    idDgoReciElect: json["idDgoReciElect"] == null ? null : json["idDgoReciElect"],
  );

  Map<String, dynamic> toJson() => {
    "nomRecintoElec": nomRecintoElec == null ? null : nomRecintoElec,
    "encargado": encargado == null ? null : encargado,
    "documento": documento == null ? null : documento,
    "sexoPerson": sexoPerson == null ? null : sexoPerson,
  };
}
