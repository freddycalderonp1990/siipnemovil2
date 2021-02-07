// To parse this JSON data, do
//
//     final usuarioModel = usuarioModelFromJson(jsonString);

part of 'models.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  UserModel({
    this.usuario,
  });

  List<Usuario> usuario;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        usuario: json["datos"] == null
            ? null
            : List<Usuario>.from(json["datos"].map((x) => Usuario.fromJson(x))),
      );
}

class Usuario {
  Usuario(
      {this.idGenUsuario,
      this.idGenPersona,
      this.nombreUsuario,
      this.apenom,
      this.documento,
      this.sexo,
      this.foto,
      this.ubicacionSeleccionada,
      this.actualizarApp = false});

  String idGenUsuario;
  String idGenPersona;
  String nombreUsuario;
  String apenom;
  String documento;
  String sexo;
  Uint8List foto;
  LatLng ubicacionSeleccionada;
  bool actualizarApp;

  factory Usuario.fromJson(Map<String, dynamic> json) {
    String img = json["foto"];
    Uint8List imgDecode = null;
    if (img != null) {
      final decodedBytes = base64Decode(img);
      print(decodedBytes);
      imgDecode = decodedBytes;
    }

    return Usuario(
        idGenUsuario:
            json["idGenUsuario"] == null ? null : json["idGenUsuario"],
        idGenPersona:
            json["idGenPersona"] == null ? null : json["idGenPersona"],
        nombreUsuario:
            json["nombreUsuario"] == null ? "null" : json["nombreUsuario"],
        apenom: json["apenom"] == null ? "null" : json["apenom"],
        documento: json["documento"] == null ? "null" : json["documento"],
        actualizarApp:
            json["actualizarApp"] == null ? false : json["actualizarApp"],
        sexo: json["sexoPerson"] == null ? "null" : json["sexoPerson"],
        foto: imgDecode);
  }
}
