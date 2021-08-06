// To parse this JSON data, do
//
//     final serviciosPolcoModel = serviciosPolcoModelFromJson(jsonString);

import 'dart:convert';

ServiciosPolcoModel serviciosPolcoModelFromJson(String str) => ServiciosPolcoModel.fromJson(json.decode(str));

String serviciosPolcoModelToJson(ServiciosPolcoModel data) => json.encode(data.toJson());

class ServiciosPolcoModel {
  List<Servicio> servicio;

  ServiciosPolcoModel({
    this.servicio,
  });

  factory ServiciosPolcoModel.fromJson(Map<String, dynamic> json) => ServiciosPolcoModel(
    servicio: List<Servicio>.from(json["Servicio"].map((x) => Servicio.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Servicio": List<dynamic>.from(servicio.map((x) => x.toJson())),
  };
}

class Servicio {
  String idUpcServicio;
  String servicio;
  String resumen;
  String img;

  Servicio({
    this.idUpcServicio,
    this.servicio,
    this.resumen,
    this.img,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) => Servicio(
    idUpcServicio: json["idUpcServicio"],
    servicio: json["servicio"],
    resumen: json["resumen"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "idUpcServicio": idUpcServicio,
    "servicio": servicio,
    "resumen": resumen,
    "img": img,
  };
}
