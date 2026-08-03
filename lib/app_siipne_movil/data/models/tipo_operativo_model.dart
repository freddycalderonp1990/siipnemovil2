part of 'models_siipne_movil.dart';

TipoOperativoModel tipoOperativoModelFromJson(String str) =>
    TipoOperativoModel.fromJson(json.decode(str));

String tipoOperativoModelToJson(TipoOperativoModel data) =>
    json.encode(data.toJson());

class TipoOperativoModel {
  final int statusCode;
  final String message;
  final List<DataTipoOperativo> dataTipoOperativos;

  TipoOperativoModel({
    required this.statusCode,
    required this.message,
    required this.dataTipoOperativos,
  });

  factory TipoOperativoModel.fromJson(Map<String, dynamic> json) =>
      TipoOperativoModel(
        statusCode: json["status_code"],
        message: json["message"],
        dataTipoOperativos: List<DataTipoOperativo>.from(
          json["data"].map((x) => DataTipoOperativo.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": List<dynamic>.from(dataTipoOperativos.map((x) => x.toJson())),
  };
}

class DataTipoOperativo {
  final int idOperativo;
  final int idGenTipoTipificacion;
  final int idPadre;
  final String descripcion;
  final int nivel;

  DataTipoOperativo({
    required this.idOperativo,
    required this.idGenTipoTipificacion,
    required this.descripcion,
    required this.nivel, required this.idPadre,
  });
  factory DataTipoOperativo.empty()=>DataTipoOperativo(idOperativo: 0, idGenTipoTipificacion: 0, descripcion: '', nivel: 0, idPadre: 0);

  factory DataTipoOperativo.fromJson(Map<String, dynamic> json) =>
      DataTipoOperativo(
        idOperativo: ParseModel.parseToInt(json["idOperativo"]),
        idGenTipoTipificacion: ParseModel.parseToInt(
          json["idGenTipoTipificacion"],
        ),
        idPadre: ParseModel.parseToInt(json["idPadre"]),
        descripcion: ParseModel.parseToString(json["descripcion"]),
        nivel: ParseModel.parseToInt(json["nivel"]),
      );

  Map<String, dynamic> toJson() => {
    "idOperativo": idOperativo,
    "idGenTipoTipificacion": idGenTipoTipificacion,
    "descripcion": descripcion,
    "nivel": nivel,
  };
}
