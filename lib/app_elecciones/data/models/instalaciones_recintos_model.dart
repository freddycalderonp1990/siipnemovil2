part of 'models.dart';

class InstalacionesRecintosModel {
  InstalacionesRecintosModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataInstalacionesRecintos,
  });

  final bool success;
  final int statusCode;
  final String message;
  final List<DataInstalacionesRecinto> dataInstalacionesRecintos;

  factory InstalacionesRecintosModel.fromJson(String str) =>
      InstalacionesRecintosModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InstalacionesRecintosModel.fromMap(Map<String, dynamic> json) =>
      InstalacionesRecintosModel(
        success: ParseModel.parseToBool(json["success"]),
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        dataInstalacionesRecintos: json["data"] == null
            ? []
            : List<DataInstalacionesRecinto>.from(
                json["data"].map((x) => DataInstalacionesRecinto.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "status_code": statusCode,
        "message": message,
        "data":
            List<dynamic>.from(dataInstalacionesRecintos.map((x) => x.toMap())),
      };
}

class DataInstalacionesRecinto {
  DataInstalacionesRecinto({
    required this.numElectores,
    required this.numJuntMascu,
    required this.numJuntFeme,
    required this.idDgoReciElect,
    required this.idGenGeoSenplades,
    required this.idGenDivPolitica,
    required this.idGenEstado,
    required this.idDgoTipoEje,
    required this.siglaPro,
    required this.codRecintoElec,
    required this.nomRecintoElec,
    required this.direcRecintoElec,
    required this.latitud,
    required this.longitud,
    required this.tipoRecinto,
    required this.distance,
  });

  final int numElectores;
  final int numJuntMascu;
  final int numJuntFeme;
  final int idDgoReciElect;
  final int idGenGeoSenplades;
  final int idGenDivPolitica;
  final int idGenEstado;
  final int idDgoTipoEje;
  final String siglaPro;
  final String codRecintoElec;
  final String nomRecintoElec;
  final String direcRecintoElec;
  final String latitud;
  final String longitud;
  final String tipoRecinto;
  final double distance;

  factory DataInstalacionesRecinto.fromJson(String str) =>
      DataInstalacionesRecinto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataInstalacionesRecinto.fromMap(Map<String, dynamic> json) =>
      DataInstalacionesRecinto(
        numElectores:ParseModel.parseToInt(json["numElectores"]),
        numJuntMascu: ParseModel.parseToInt(json["numJuntMascu"]),
        numJuntFeme: ParseModel.parseToInt(json["numJuntFeme"]),
        idDgoReciElect: ParseModel.parseToInt(json["idDgoReciElect"]),
        idGenGeoSenplades: ParseModel.parseToInt(json["idGenGeoSenplades"]),
        idGenDivPolitica: ParseModel.parseToInt(json["idGenDivPolitica"]),
        idGenEstado: ParseModel.parseToInt(json["idGenEstado"]),
        idDgoTipoEje:ParseModel.parseToInt( json["idDgoTipoEje"]),
        siglaPro:ParseModel.parseToString( json["siglaPro"]),
        codRecintoElec:ParseModel.parseToString( json["codRecintoElec"]),
        nomRecintoElec:ParseModel.parseToString( json["nomRecintoElec"]),
        direcRecintoElec:ParseModel.parseToString( json["direcRecintoElec"]),
        latitud: ParseModel.parseToString(json["latitud"]),
        longitud:ParseModel.parseToString( json["longitud"]),
        tipoRecinto: ParseModel.parseToString(json["tipoRecinto"]),
        distance: ParseModel.parseToDouble( json["distance"]),
      );

  Map<String, dynamic> toMap() => {
        "numElectores": numElectores,
        "numJuntMascu": numJuntMascu,
        "numJuntFeme": numJuntFeme,
        "idDgoReciElect": idDgoReciElect,
        "idGenGeoSenplades": idGenGeoSenplades,
        "idGenDivPolitica": idGenDivPolitica,
        "idGenEstado": idGenEstado,
        "idDgoTipoEje": idDgoTipoEje,
        "siglaPro": siglaPro,
        "codRecintoElec": codRecintoElec,
        "nomRecintoElec": nomRecintoElec,
        "direcRecintoElec": direcRecintoElec,
        "latitud": latitud,
        "longitud": longitud,
        "tipoRecinto": tipoRecinto,
        "distance": distance,
      };
}
