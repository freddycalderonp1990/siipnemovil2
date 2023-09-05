part of 'models.dart';

class DataPerPolicialModel {
  DataPerPolicialModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataPerPolicial,
  });

  final bool success;
  final int statusCode;
  final String message;
  final DataPerPolicial dataPerPolicial;

  factory DataPerPolicialModel.fromJson(String str) =>
      DataPerPolicialModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataPerPolicialModel.fromMap(Map<String, dynamic> json) =>
      DataPerPolicialModel(
        success: ParseModel.parseToBool(json["success"]),
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        dataPerPolicial: DataPerPolicial.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "data": dataPerPolicial.toMap(),
      };
}

class DataPerPolicial {
  DataPerPolicial({
    required this.idGenPersona,
    required this.documento,
    required this.apenom,
    required this.codigoDactilar,
    required this.sexo,
    required this.fechaNacimiento,
    required this.grado,
    required this.siglas,
    required this.edad,
  });

  final int idGenPersona;
  final String documento;
  final String apenom;
  final String codigoDactilar;
  final String sexo;
  final String fechaNacimiento;
  final String grado;
  final String siglas;
  final Edad edad;

  factory DataPerPolicial.fromJson(String str) =>
      DataPerPolicial.fromMap(json.decode(str));

  factory DataPerPolicial.empty() => DataPerPolicial(
      idGenPersona: 0,
      documento: "",
      apenom: "",
      codigoDactilar: "",
      sexo: "",
      fechaNacimiento: "",
      grado: "",
      siglas: "",
      edad: Edad.empty());

  String toJson() => json.encode(toMap());

  factory DataPerPolicial.fromMap(Map<String, dynamic> json) => DataPerPolicial(
        idGenPersona: ParseModel.parseToInt(json["idGenPersona"]),
        documento: ParseModel.parseToString(json["documento"]),
        apenom: ParseModel.parseToString(json["apenom"]),
        codigoDactilar: ParseModel.parseToString(json["codigoDactilar"]),
        sexo: ParseModel.parseToString(json["sexo"]),
        fechaNacimiento: ParseModel.parseToString(json["fechaNacimiento"]),
        grado: ParseModel.parseToString(json["grado"]),
        siglas: ParseModel.parseToString(json["siglas"]),
        edad: json["edad"] != null ? Edad.fromMap(json["edad"]) : Edad.empty(),
      );

  Map<String, dynamic> toMap() => {
        "idGenPersona": idGenPersona,
        "documento": documento,
        "apenom": apenom,
        "codigoDactilar": codigoDactilar,
        "sexo": sexo,
        "fechaNacimiento": fechaNacimiento,
        "grado": grado,
        "siglas": siglas,
        "edad": edad.toMap(),
      };
}

class Edad {
  Edad({
    required this.anos,
    required this.meses,
    required this.dias,
  });

  final int anos;
  final int meses;
  final int dias;

  factory Edad.fromJson(String str) => Edad.fromMap(json.decode(str));

  factory Edad.empty() => Edad(anos: 0, meses: 0, dias: 0);

  String toJson() => json.encode(toMap());

  factory Edad.fromMap(Map<String, dynamic> json) => Edad(
        anos: ParseModel.parseToInt(json["anos"]),
        meses: ParseModel.parseToInt(json["meses"]),
        dias: ParseModel.parseToInt(json["dias"]),
      );

  Map<String, dynamic> toMap() => {
        "anos": anos,
        "meses": meses,
        "dias": dias,
      };
}
