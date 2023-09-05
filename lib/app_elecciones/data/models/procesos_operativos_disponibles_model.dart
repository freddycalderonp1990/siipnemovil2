part of 'models.dart';

class ProcesosOperativosDisponiblesModel {
  ProcesosOperativosDisponiblesModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataProcesosDisponibles,
  });

  final bool success;
  final int statusCode;
  final String message;
  final List<DataProcesosDisponible> dataProcesosDisponibles;

  factory ProcesosOperativosDisponiblesModel.fromJson(String str) =>
      ProcesosOperativosDisponiblesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProcesosOperativosDisponiblesModel.fromMap(
          Map<String, dynamic> json) =>
      ProcesosOperativosDisponiblesModel(
        success: ParseModel.parseToBool(json["success"]),
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        dataProcesosDisponibles: json["data"] == null
            ? []
            : List<DataProcesosDisponible>.from(
                json["data"].map((x) => DataProcesosDisponible.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "data":
            List<dynamic>.from(dataProcesosDisponibles.map((x) => x.toMap())),
      };
}

class DataProcesosDisponible {
  DataProcesosDisponible({
    required this.idDgoProcElec,
    required this.idGenGeoSenplades,
    required this.descProcElecc,
    required this.fechaInici,
    required this.fechaFin,
    required this.tipo,
  });

  final int idDgoProcElec;
  final int idGenGeoSenplades;
  final String descProcElecc;
  final String fechaInici;
  final String fechaFin;
  final String tipo;

  factory DataProcesosDisponible.empty() => DataProcesosDisponible(
      idDgoProcElec: 0,
      idGenGeoSenplades: 0,
      descProcElecc: "",
      fechaInici: "",
      fechaFin: "",
      tipo: "");

  factory DataProcesosDisponible.fromJson(String str) =>
      DataProcesosDisponible.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataProcesosDisponible.fromMap(Map<String, dynamic> json) =>
      DataProcesosDisponible(
        idDgoProcElec: ParseModel.parseToInt(json["idDgoProcElec"]),
        idGenGeoSenplades: ParseModel.parseToInt(json["idGenGeoSenplades"]),
        descProcElecc: ParseModel.parseToString(json["descProcElecc"]),
        fechaInici: ParseModel.parseToStringFecha(json["fechaInici"]),
        fechaFin: ParseModel.parseToStringFecha((json["fechaFin"])),
        tipo: ParseModel.parseToString(json["tipo"]),
      );

  Map<String, dynamic> toMap() => {
        "idDgoProcElec": idDgoProcElec,
        "idGenGeoSenplades": idGenGeoSenplades,
        "descProcElecc": descProcElecc,
      };
}
