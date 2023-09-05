part of 'models.dart';

OperativoPendienteModel operativoPendienteModelFromJson(String str) =>
    OperativoPendienteModel.fromJson(json.decode(str));

String operativoPendienteModelToJson(OperativoPendienteModel data) =>
    json.encode(data.toJson());

class OperativoPendienteModel {
  OperativoPendienteModel({
    required this.operativoPendiente,
  });

  List<OperativoPendiente> operativoPendiente;

  factory OperativoPendienteModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] != null) {
      return OperativoPendienteModel(
        operativoPendiente: List<OperativoPendiente>.from(
            json["data"].map((x) => OperativoPendiente.fromJson(x))),
      );
    } else {

      return OperativoPendienteModel(
        operativoPendiente: [],
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(operativoPendiente.map((x) => x.toJson())),
      };
}

class OperativoPendiente {
  OperativoPendiente({
    required this.idHdrEvento,
    required this.idGenGeoSenplades,
    required this.idGenPersona,
    required this.usuario,
    required this.fechaEvento,
  });

  int idHdrEvento;
  int idGenGeoSenplades;
  int idGenPersona;
  String usuario;
  String fechaEvento;


  factory OperativoPendiente.fromJson(Map<String, dynamic> json) =>
      OperativoPendiente(
        idHdrEvento: ParseModel.parseToInt( json["idHdrEvento"]),
        idGenGeoSenplades: ParseModel.parseToInt( json["idGenGeoSenplades"]),
        idGenPersona: ParseModel.parseToInt( json["idGenPersona"]),
        usuario:ParseModel.parseToString( json["usuario"]),
        fechaEvento: ParseModel.parseToString(json["fechaEvento"]),
      );

  Map<String, dynamic> toJson() => {
        "idHdrEvento": idHdrEvento,
        "idGenGeoSenplades": idGenGeoSenplades,
        "idGenPersona": idGenPersona,
        "usuario": usuario,
        "fechaEvento": fechaEvento,
      };
}
