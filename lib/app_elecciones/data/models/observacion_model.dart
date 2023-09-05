part of 'models.dart';
class ObservacionModel {
  ObservacionModel({
   this.idDgoNovedadesElect,
   this.cedula,
   this.numBoleta,
   this.numCitacion,
   this.hora,
   this.motivo,
   this.organizacion,
   this.dirigente,
   this.cantidad,
   this.telefono,
   this.nombre,
   this.cargo,
   this.grado,
   this.funcion,
   this.instalacion,
   this.medioComunicacion,
   this.descripcion,
   this.direccion,
   this.unidad,
    this.numerico
  });

  final int? idDgoNovedadesElect;
  final String? cedula;
  final String? numBoleta;
  final String? numCitacion;
  final String? hora;
  final String? motivo;
  final String? organizacion;
  final String? dirigente;
  final int? cantidad;
  final String? telefono;
  final String? nombre;
  final String? cargo;
  final String? grado;
  final String? funcion;
  final String? instalacion;
  final String? medioComunicacion;
  final String? descripcion;
  final String? direccion;
  final String? unidad;
  final int? numerico;

  factory ObservacionModel.fromJson(String str) => ObservacionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ObservacionModel.fromMap(Map<String, dynamic> json) => ObservacionModel(
    idDgoNovedadesElect: json["idDgoNovedadesElect"],
    cedula: json["cedula"],
    numBoleta: json["numBoleta"],
    numCitacion: json["numCitacion"],
    hora: json["hora"],
    motivo: json["motivo"],
    organizacion: json["organizacion"],
    dirigente: json["dirigente"],
    cantidad: json["cantidad"],
    telefono: json["telefono"],
    nombre: json["nombre"],
    cargo: json["cargo"],
    grado: json["grado"],
    funcion: json["funcion"],
    instalacion: json["instalacion"],
    medioComunicacion: json["medioComunicacion"],
    descripcion: json["descripcion"],
    direccion: json["direccion"],
    unidad: json["unidad"],
  );

  Map<String, dynamic> toMap() {

    Map<String, dynamic>? data2;

    Map<String, dynamic> data= {
      "idDgoNovedadesElect": idDgoNovedadesElect,
      "cedula": cedula,
      "numBoleta": numBoleta,
      "numCitacion": numCitacion,
      "hora": hora,
      "motivo": motivo,
      "organizacion": organizacion,
      "dirigente": dirigente,
      "cantidad": cantidad,
      "telefono": telefono,
      "nombre": nombre,
      "cargo": cargo,
      "grado": grado,
      "funcion": funcion,
      "instalacion": instalacion,
      "medioComunicacion": medioComunicacion,
      "descripcion": descripcion,
      "direccion": direccion,
      "unidad": unidad,
      "numerico": numerico,
    };



    data.removeWhere((key, value) => key == null || value == null);





    return data;

  }
}
