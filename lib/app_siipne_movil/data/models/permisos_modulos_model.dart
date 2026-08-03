part of 'models_siipne_movil.dart';

PermisosModulosModel permisosModulosModelFromJson(String str) =>
    PermisosModulosModel.fromJson(json.decode(str));

String permisosModulosModelToJson(PermisosModulosModel data) =>
    json.encode(data.toJson());

class PermisosModulosModel {
  final int statusCode;
  final String message;
  final List<DataModulo> dataModulos;

  PermisosModulosModel({
    required this.statusCode,
    required this.message,
    required this.dataModulos,
  });

  factory PermisosModulosModel.fromJson(Map<String, dynamic> json) =>
      PermisosModulosModel(
        statusCode: json["status_code"],
        message: json["message"],
        dataModulos: List<DataModulo>.from(
          json["data"].map((x) => DataModulo.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": List<dynamic>.from(dataModulos.map((x) => x.toJson())),
  };
}

class DataModulo {
  final int idGenModulo;
  final String descripcion;
  final String detalle;
  final int idHdrTipoServicio;
  final int idGenTipoTipificacionEcu;

  DataModulo({
    required this.idGenModulo,
    required this.descripcion,
    required this.detalle,
    required this.idHdrTipoServicio,
    required this.idGenTipoTipificacionEcu,
  });

  factory DataModulo.empty() => DataModulo(
    idGenModulo: 0,
    descripcion: "",
    detalle: "",
    idHdrTipoServicio: 0,
    idGenTipoTipificacionEcu: 0,
  );

  factory DataModulo.fromJson(Map<String, dynamic> json) => DataModulo(
    idGenModulo: ParseModel.parseToInt(json["idGenModulo"]),
    descripcion: ParseModel.parseToString(json["descripcion"]),
    detalle: ParseModel.parseToString(json["detalle"]),
    idHdrTipoServicio: ParseModel.parseToInt(json["idHdrTipoServicio"]),
    idGenTipoTipificacionEcu: ParseModel.parseToInt(
      json["idGenTipoTipificacionEcu"],
    ),
  );

  Map<String, dynamic> toJson() => {
    "idGenModulo": idGenModulo,
    "descripcion": descripcion,
    "detalle": detalle,
    "idHdrTipoServicio": idHdrTipoServicio,
    "idGenTipoTipificacionEcu": idGenTipoTipificacionEcu,
  };
}
