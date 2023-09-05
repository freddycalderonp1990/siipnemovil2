part of 'models.dart';

TipoOperativoModel tipoOperativoModelFromJson(String str) => TipoOperativoModel.fromJson(json.decode(str));

String tipoOperativoModelToJson(TipoOperativoModel data) => json.encode(data.toJson());

class TipoOperativoModel {
  TipoOperativoModel({
    required this.tipoOperativo,
  });

  List<TipoOperativo> tipoOperativo;

  factory TipoOperativoModel.fromJson(Map<String, dynamic> json) => TipoOperativoModel(
    tipoOperativo: List<TipoOperativo>.from(json["data"].map((x) => TipoOperativo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(tipoOperativo.map((x) => x.toJson())),
  };
}

class TipoOperativo {
  TipoOperativo({
    required this.descripcion,
    required this.idGenTipoTipificacion,
  });

  String descripcion;
  int idGenTipoTipificacion;

  factory TipoOperativo.fromJson(Map<String, dynamic> json) => TipoOperativo(
    descripcion: json["descripcion"],
    idGenTipoTipificacion: int.parse( json["idGenTipoTipificacion"]),
  );

  Map<String, dynamic> toJson() => {
    "descripcion": descripcion,
    "idGenTipoTipificacion": idGenTipoTipificacion,
  };
}
