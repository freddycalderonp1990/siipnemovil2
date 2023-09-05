part of 'models.dart';
class NovedadesModel {
  NovedadesModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataNovedades,
  });

  final bool success;
  final int statusCode;
  final String message;
  final List<DataNovedade> dataNovedades;

  factory NovedadesModel.fromJson(String str) => NovedadesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NovedadesModel.fromMap(Map<String, dynamic> json) => NovedadesModel(
    success: ParseModel.parseToBool(json["success"]),
    statusCode: ParseModel.parseToInt(json["status_code"]),
    message: ParseModel.parseToString(json["message"]),
    dataNovedades:json["data"]==null?[]: List<DataNovedade>.from(json["data"].map((x) => DataNovedade.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "data": List<dynamic>.from(dataNovedades.map((x) => x.toMap())),
  };
}

class DataNovedade {
  DataNovedade({
    required this.idDgoNovedadesElect,
    required this.dgoIdDgoNovedadesElect,
    required this.descripcion,
    required this.nomCorto,
    required this.idDgoTipoEje,
    required this.eje,
    required this.idDgoNovedadesElectPadre,
    required this.novedadPadre,
    required this.idDgoNovedadesElectHija,
    required this.novedadHija,
  });

  final int idDgoNovedadesElect;
  final int dgoIdDgoNovedadesElect;
  final String descripcion;
  final String nomCorto;
  final int idDgoTipoEje;
  final String eje;
  final int idDgoNovedadesElectPadre;
  final String novedadPadre;
  final int idDgoNovedadesElectHija;
  final String novedadHija;

  factory DataNovedade.fromJson(String str) => DataNovedade.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataNovedade.fromMap(Map<String, dynamic> json) => DataNovedade(
    idDgoNovedadesElect: ParseModel.parseToInt( json["idDgoNovedadesElect"]),
    dgoIdDgoNovedadesElect:  ParseModel.parseToInt( json["dgo_idDgoNovedadesElect"]),
    descripcion:ParseModel.parseToString( json["descripcion"]),
    nomCorto: ParseModel.parseToString( json["nomCorto"]),
    idDgoTipoEje:  ParseModel.parseToInt( json["idDgoTipoEje"]),
    eje: ParseModel.parseToString( json["eje"]),
    idDgoNovedadesElectPadre:  ParseModel.parseToInt( json["idDgoNovedadesElectPadre"]),
    novedadPadre: ParseModel.parseToString( json["novedadPadre"]),
    idDgoNovedadesElectHija:  ParseModel.parseToInt( json["idDgoNovedadesElectHija"]),
    novedadHija: ParseModel.parseToString( json["novedadHija"]),
  );

  Map<String, dynamic> toMap() => {
    "idDgoNovedadesElect": idDgoNovedadesElect,
    "dgo_idDgoNovedadesElect": dgoIdDgoNovedadesElect,
    "descripcion": descripcion,
    "nomCorto": nomCorto,
    "idDgoTipoEje": idDgoTipoEje,
    "eje": eje,
    "idDgoNovedadesElectPadre": idDgoNovedadesElectPadre,
    "novedadPadre": novedadPadre,
    "idDgoNovedadesElectHija": idDgoNovedadesElectHija,
    "novedadHija": novedadHija,
  };
}
