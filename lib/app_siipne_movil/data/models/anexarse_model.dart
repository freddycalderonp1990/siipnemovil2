part of 'models_siipne_movil.dart';

AnexarseModel anexarseModelFromJson(String str) =>
    AnexarseModel.fromJson(json.decode(str));

String anexarseModelToJson(AnexarseModel data) => json.encode(data.toJson());

class AnexarseModel {
  final int statusCode;
  final String message;
  final Anexarse anexarse;

  AnexarseModel({
    required this.statusCode,
    required this.message,
    required this.anexarse,
  });

  factory AnexarseModel.fromJson(Map<String, dynamic> json) => AnexarseModel(
    statusCode: ParseModel.parseToInt(json["status_code"]),
    message: ParseModel.parseToString(json["message"]),
    anexarse: Anexarse.fromJson(json["data"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": anexarse.toJson(),
  };
}

class Anexarse {
  final int idHdrEvento;
  final String fechaEvento;
  final String policia;
  final String estadoOperativo;
  final String fecha;
  final String zona;
  final String subzona;
  final String distrito;
  final String circuito;
  final String subcircuito;
  final String descripcion;
  final String estadoPolicia;
  final String latitud;
  final String longitud;
  final int idTipoOperativo;

  Anexarse({
    required this.idHdrEvento,
    required this.fechaEvento,
    required this.policia,
    required this.estadoOperativo,
    required this.fecha,
    required this.zona,
    required this.subzona,
    required this.distrito,
    required this.circuito,
    required this.subcircuito,
    required this.descripcion,
    required this.estadoPolicia,
    required this.latitud,
    required this.longitud,
    required this.idTipoOperativo,
  });

  factory Anexarse.fromJson(Map<String, dynamic> json) => Anexarse(
    idHdrEvento: ParseModel.parseToInt(json["idHdrEvento"]),
    fechaEvento: ParseModel.parseToString(json["fechaEvento"]),
    policia: ParseModel.parseToString(json["policia"]),
    estadoOperativo: ParseModel.parseToString(json["estadoOperativo"]),
    fecha: ParseModel.parseToString(json["fecha"]),
    zona: ParseModel.parseToString(json["zona"]),
    subzona: ParseModel.parseToString(json["subzona"]),
    distrito: ParseModel.parseToString(json["distrito"]),
    circuito: ParseModel.parseToString(json["circuito"]),
    subcircuito: ParseModel.parseToString(json["subcircuito"]),
    descripcion: ParseModel.parseToString(json["descripcion"]),
    estadoPolicia: ParseModel.parseToString(json["estadoPolicia"]),
    latitud: ParseModel.parseToString(json["latitud"]),
    longitud: ParseModel.parseToString(json["longitud"]),
    idTipoOperativo: ParseModel.parseToInt(json["idTipoOperativo"]),
  );

  factory Anexarse.empty() => Anexarse(
    idHdrEvento: 0,
    fechaEvento: '',
    policia: '',
    estadoOperativo: '',
    fecha: '',
    zona: '',
    subzona: '',
    distrito: '',
    circuito: '',
    subcircuito: '',
    descripcion: '',
    estadoPolicia: '',
    latitud: '',
    longitud: '',
    idTipoOperativo: 0,
  );

  Map<String, dynamic> toJson() => {
    "idHdrEvento": idHdrEvento,
    "fechaEvento": fechaEvento,
    "policia": policia,
    "estadoOperativo": estadoOperativo,
    "fecha": fecha,
    "zona": zona,
    "subzona": subzona,
    "distrito": distrito,
    "circuito": circuito,
    "subcircuito": subcircuito,
    "descripcion": descripcion,
    "estadoPolicia": estadoPolicia,
    "latitud": latitud,
    "longitud": longitud,
    "idTipoOperativo": idTipoOperativo,
  };
}
