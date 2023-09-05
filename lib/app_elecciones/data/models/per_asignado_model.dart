part of 'models.dart';

class PerAsignadoModel {
  PerAsignadoModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataPerAsignado,
  });

  final bool success;
  final int statusCode;
  final String message;
  final List<DataPerAsignado> dataPerAsignado;

  factory PerAsignadoModel.fromJson(String str) =>
      PerAsignadoModel.fromMap(json.decode(str));

  factory PerAsignadoModel.fromMap(Map<String, dynamic> json) =>
      PerAsignadoModel(
        success: ParseModel.parseToBool(json["success"]),
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        dataPerAsignado: json["data"] == null
            ? []
            : List<DataPerAsignado>.from(
                json["data"].map((x) => DataPerAsignado.fromMap(x))),
      );
}

class DataPerAsignado {
  DataPerAsignado({
    required this.idDgoPerAsigOpe,
    required this.cargo,
    required this.idDgoCreaOpReci,
    required this.nomRecintoElec,
    required this.fechaIni,
    required this.fechaFin,
    required this.estadoPersonal,
    required this.isJefe,
    required this.recintoActivo,
    required this.personalName,
    required this.personalActivo,
  });

  final int idDgoPerAsigOpe;
  final String cargo;
  final bool isJefe;
  final int idDgoCreaOpReci;
  final String nomRecintoElec;
  final bool recintoActivo;
  final String fechaIni;
  final String fechaFin;
  final String personalName;
  final String estadoPersonal;
  final bool personalActivo;

  factory DataPerAsignado.fromJson(String str) =>
      DataPerAsignado.fromMap(json.decode(str));

  factory DataPerAsignado.empty() => DataPerAsignado(
      idDgoPerAsigOpe: 0,
      cargo: "",
      idDgoCreaOpReci: 0,
      nomRecintoElec: "",
      fechaIni: "",
      fechaFin: "",
      estadoPersonal: "",
      isJefe: false,
      recintoActivo: false,
      personalName: "",
      personalActivo: false);

  factory DataPerAsignado.fromMap(Map<String, dynamic> json) => DataPerAsignado(
      idDgoPerAsigOpe: ParseModel.parseToInt(json["idDgoPerAsigOpe"]),
      cargo: ParseModel.parseToString(json["cargo"]),
      isJefe: ParseModel.parseToBool(json["cargo"], valueCompareTrue: 'J'),
      idDgoCreaOpReci: ParseModel.parseToInt(json["idDgoCreaOpReci"]),
      nomRecintoElec: ParseModel.parseToString(json["nomRecintoElec"]),
      recintoActivo:
          ParseModel.parseToBool(json["recintoEstado"], valueCompareTrue: 'A'),
      fechaIni: ParseModel.parseToString(json["fechaIni"]),
      fechaFin: ParseModel.parseToString(json["FechaFin"]),
      personalName: ParseModel.parseToString(json["personal"]),
      estadoPersonal: ParseModel.parseToString(json["estado_personal"]),
      personalActivo: ParseModel.parseToBool(json["estado_personal"],
          valueCompareTrue: 'ACTIVO'));
}
