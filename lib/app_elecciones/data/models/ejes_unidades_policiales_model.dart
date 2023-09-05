part of 'models.dart';

class EjesUnidadesPolicialesModel {
  EjesUnidadesPolicialesModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataEjesUnidadesPoliciales,
  });

  final bool success;
  final int statusCode;
  final String message;
  final List<DataEjes> dataEjesUnidadesPoliciales;

  factory EjesUnidadesPolicialesModel.fromJson(String str) =>
      EjesUnidadesPolicialesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EjesUnidadesPolicialesModel.fromMap(Map<String, dynamic> json) =>
      EjesUnidadesPolicialesModel(
        success: ParseModel.parseToBool(json["success"]),
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        dataEjesUnidadesPoliciales: json["data"] == null
            ? []
            : List<DataEjes>.from(
                json["data"].map((x) => DataEjes.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "data": List<dynamic>.from(
            dataEjesUnidadesPoliciales.map((x) => x.toMap())),
      };
}

class DataEjes {
  DataEjes({
    required this.idDgoTipoEje,
    required this.dgoIdDgoTipoEje,
    required this.descripcion,
  });

  final int idDgoTipoEje;
  final int dgoIdDgoTipoEje;
  final String descripcion;


  factory DataEjes.empty()=>DataEjes(idDgoTipoEje: 0, dgoIdDgoTipoEje: 0, descripcion: "");


  factory DataEjes.fromJson(String str) =>
      DataEjes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataEjes.fromMap(Map<String, dynamic> json) =>
      DataEjes(
        idDgoTipoEje: ParseModel.parseToInt(json["idDgoTipoEje"]),
        dgoIdDgoTipoEje: ParseModel.parseToInt(json["dgo_idDgoTipoEje"]),
        descripcion: ParseModel.parseToString(json["descripcion"]),
      );

  Map<String, dynamic> toMap() => {
        "idDgoTipoEje": idDgoTipoEje,
        "dgo_idDgoTipoEje": dgoIdDgoTipoEje,
        "descripcion": descripcion,
      };
}
