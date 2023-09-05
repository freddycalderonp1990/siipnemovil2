part of 'models.dart';

ModulosModel modulosModelFromJson(String str) => ModulosModel.fromJson(json.decode(str));

String modulosModelToJson(ModulosModel data) => json.encode(data.toJson());

class ModulosModel {
  ModulosModel({
    required this.modulo,
  });

  List<Modulo> modulo;

  factory ModulosModel.fromJson(Map<String, dynamic> json) => ModulosModel(
    modulo: List<Modulo>.from(json["data"].map((x) => Modulo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(modulo.map((x) => x.toJson())),
  };
}




class Modulo {
  Modulo({
    required this.idGenModulo,
    required this.descripcion,
    required this.detalle,
  });

  String idGenModulo;
  String descripcion;
  String detalle;

  factory Modulo.fromJson(Map<String, dynamic> json) => Modulo(
    idGenModulo: json["idGenModulo"],
    descripcion: json["descripcion"],
    detalle: json["detalle"],
  );

  Map<String, dynamic> toJson() => {
    "idGenModulo": idGenModulo,
    "descripcion": descripcion,
    "detalle": detalle,
  };


}