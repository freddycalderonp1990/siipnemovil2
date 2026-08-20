part of 'models_siipne_movil.dart';
VariablesResultadoModel variablesResultadoModelFromJson(String str) => VariablesResultadoModel.fromJson(json.decode(str));
String variablesResultadoModelToJson(VariablesResultadoModel data) => json.encode(data.toJson());
class VariablesResultadoModel {
  int statusCode;
  String message;
  List<VariablesResultado> variablesResultado;

  VariablesResultadoModel({
    required this.statusCode,
    required this.message,
    required this.variablesResultado,
  });

  factory VariablesResultadoModel.fromJson(Map<String, dynamic> json) => VariablesResultadoModel(
    statusCode: json["status_code"],
    message: json["message"],
    variablesResultado: List<VariablesResultado>.from(json["data"].map((x) => VariablesResultado.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": List<dynamic>.from(variablesResultado.map((x) => x.toJson())),
  };
}

class VariablesResultado {
  int idOperativo;
  String nombreOperativo;
  String horaInicio;
  String horaFin;
  String subzonas;
  int idVariable;
  String desHdrTipoResum;
  String tipoConsulta;

  VariablesResultado({
    required this.idOperativo,
    required this.nombreOperativo,
    required this.horaInicio,
    required this.horaFin,
    required this.subzonas,
    required this.idVariable,
    required this.desHdrTipoResum,
    required this.tipoConsulta,
  });

  factory VariablesResultado.fromJson(Map<String, dynamic> json) => VariablesResultado(
    idOperativo: ParseModel.parseToInt(json["idOperativo"]),
    nombreOperativo: ParseModel.parseToString(json["nombreOperativo"]),
    horaInicio: ParseModel.parseToString(json["horaInicio"]),
    horaFin: ParseModel.parseToString(json["horaFin"]),
    subzonas: ParseModel.parseToString(json["subzonas"]),
    idVariable: ParseModel.parseToInt(json["idVariable"]),
    desHdrTipoResum:ParseModel.parseToString( json["desHdrTipoResum"]),
    tipoConsulta: ParseModel.parseToString(json["tipoConsulta"]),
  );

  Map<String, dynamic> toJson() => {
    "idOperativo": idOperativo,
    "nombreOperativo": nombreOperativo,
    "horaInicio": horaInicio,
    "horaFin": horaFin,
    "subzonas": subzonas,
    "idVariable": idVariable,
    "desHdrTipoResum": desHdrTipoResum,
    "tipoConsulta": tipoConsulta,
  };
}
