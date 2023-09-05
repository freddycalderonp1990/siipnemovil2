part of 'models.dart';

class ProcesosRecAbiertoModel {
  ProcesosRecAbiertoModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.dataProcesosAbierto,
  });

  final bool success;
  final int statusCode;
  final String message;
  final DataProcesosAbierto dataProcesosAbierto;

  factory ProcesosRecAbiertoModel.fromJson(String str) =>
      ProcesosRecAbiertoModel.fromMap(json.decode(str));



  factory ProcesosRecAbiertoModel.fromMap(Map<String, dynamic> json) =>
      ProcesosRecAbiertoModel(
        success: ParseModel.parseToBool(json["success"]),
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        dataProcesosAbierto: json["data"] == null
            ? DataProcesosAbierto.empty()
            : DataProcesosAbierto.fromMap(json["data"]),
      );


}

class DataProcesosAbierto {
  DataProcesosAbierto({
    required this.idDgoProcElec,
    required this.descProcElecc,
    required this.idDgoTipoEje,
    required this.idDgoCreaOpReci,
    required this.idDgoPerAsigOpe,
    required this.codigoRecinto,
    required this.fechaIni,
    required this.nomRecintoElec,
    required this.idDgoReciElect,
    required this.encargado,
    required this.documento,
    required this.cargo,
    required this.isJefe,
    required this.isRecinto,
    required this.crearCodigo
  });

  final int idDgoProcElec;
  final String descProcElecc;
  final int idDgoTipoEje;
  final int idDgoCreaOpReci;
  final int idDgoPerAsigOpe;
  final int codigoRecinto;
  final String fechaIni;
  final String nomRecintoElec;
  final int idDgoReciElect;
  final String encargado;
  final String documento;
  final String cargo;
  final bool isJefe;
  final bool isRecinto;
  final bool crearCodigo;

  factory DataProcesosAbierto.empty() => DataProcesosAbierto(
      idDgoProcElec: 0,
      descProcElecc: "",
      idDgoTipoEje: 0,
      idDgoCreaOpReci: 0,
      idDgoPerAsigOpe: 0,
      codigoRecinto: 0,
      fechaIni: "",
      nomRecintoElec: "",
      idDgoReciElect: 0,
      encargado: "",
      documento: "",
      cargo: "",
      isJefe: false,
      isRecinto: false,
    crearCodigo: false
  );

  factory DataProcesosAbierto.fromJson(String str) =>
      DataProcesosAbierto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataProcesosAbierto.fromMap(Map<String, dynamic> json) =>
      DataProcesosAbierto(
          idDgoProcElec: ParseModel.parseToInt(json["idDgoProcElec"]),
          descProcElecc: ParseModel.parseToString(json["descProcElecc"]),
          idDgoTipoEje: ParseModel.parseToInt(json["idDgoTipoEje"]),
          idDgoCreaOpReci: ParseModel.parseToInt(json["idDgoCreaOpReci"]),
          idDgoPerAsigOpe: ParseModel.parseToInt(json["idDgoPerAsigOpe"]),
          codigoRecinto: ParseModel.parseToInt(json["codigoRecinto"]),
          fechaIni: ParseModel.parseToStringFecha(json["fechaIni"]),
          nomRecintoElec: ParseModel.parseToString(json["nomRecintoElec"]),
          idDgoReciElect: ParseModel.parseToInt(json["idDgoReciElect"]),
          encargado: ParseModel.parseToString(json["encargado"]),
          documento: ParseModel.parseToString(json["documento"]),
          cargo: ParseModel.parseToString(json["cargo"]),
          isJefe: ParseModel.parseToBool(json["isJefe"]),
          isRecinto: ParseModel.parseToBool(json["isRecinto"]),
      crearCodigo: ParseModel.parseToBool(json["crearCodigo"]));

  Map<String, dynamic> toMap() => {
        "idDgoProcElec": idDgoProcElec,
        "descProcElecc": descProcElecc,
        "idDgoTipoEje": idDgoTipoEje,
        "idDgoCreaOpReci": idDgoCreaOpReci,
        "idDgoPerAsigOpe": idDgoPerAsigOpe,
        "codigoRecinto": codigoRecinto,
        "fechaIni": fechaIni,
        "nomRecintoElec": nomRecintoElec,
        "idDgoReciElect": idDgoReciElect,
        "encargado": encargado,
        "documento": documento,
        "cargo": cargo,
      };
}
