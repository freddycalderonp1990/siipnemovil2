part of 'models.dart';

class ResumenConsultaModel {
  ResumenConsultaModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataResumenConsulta,
  });

  final bool success;
  final int statusCode;
  final String message;
  final List<DataResumenConsulta> dataResumenConsulta;

  factory ResumenConsultaModel.fromJson(String str) =>
      ResumenConsultaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResumenConsultaModel.fromMap(Map<String, dynamic> json) =>
      ResumenConsultaModel(
        success: ParseModel.parseToBool(json["success"]),
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        dataResumenConsulta:json["data"]==null?[]:  List<DataResumenConsulta>.from(
            json["data"].map((x) => DataResumenConsulta.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "data": List<dynamic>.from(dataResumenConsulta.map((x) => x.toMap())),
      };
}

class DataResumenConsulta {
  DataResumenConsulta({
    required this.idHdrEventoResum,
    required this.hdrEventoResumIdHdrEventoResum,
    required this.descOcupante,
    required this.tipo,
    required this.descEventoResum,
    required this.detBusqueda,
  });

  final int idHdrEventoResum;
  final int hdrEventoResumIdHdrEventoResum;
  final String descOcupante;
  final String tipo;
  final String descEventoResum;
  final String detBusqueda;

  factory DataResumenConsulta.fromJson(String str) =>
      DataResumenConsulta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataResumenConsulta.fromMap(Map<String, dynamic> json) =>
      DataResumenConsulta(
        idHdrEventoResum: ParseModel.parseToInt(json["idHdrEventoResum"]),
        hdrEventoResumIdHdrEventoResum:
            ParseModel.parseToInt(json["hdrEventoResum_idHdrEventoResum"]),
        descOcupante: ParseModel.parseToString(json["descOcupante"]),
        tipo: ParseModel.parseToString(json["tipo"]),
        descEventoResum: ParseModel.parseToString(json["descEventoResum"]),
        detBusqueda: ParseModel.parseToString(json["detBusqueda"]),
      );

  Map<String, dynamic> toMap() => {
        "idHdrEventoResum": idHdrEventoResum,
        "hdrEventoResum_idHdrEventoResum": hdrEventoResumIdHdrEventoResum,
        "descOcupante": descOcupante,
        "tipo": tipo,
        "descEventoResum": descEventoResum,
        "detBusqueda": detBusqueda,
      };
}
