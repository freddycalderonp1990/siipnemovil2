part of 'models.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.user,
  });

  User user;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: User.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": user.toJson(),
      };
}

class User {
  User({
    required this.idGenUsuario,
    required this.idGenPersona,
    required this.nombreUsuario,
    required this.apenom,
    required this.documento,
    required this.sexoPerson,
    required this.token,
    required this.session,
    required this.motivo,
    required this.actualizarApp,
    required this.foto,
  });

  int idGenUsuario;
  int idGenPersona;
  String nombreUsuario;
  String apenom;
  String documento;
  String sexoPerson;
  Token token;
  bool session;
  String motivo;
  bool actualizarApp;
  Foto foto;

  factory User.empty({String name = ''}) => User(
      idGenUsuario: 0,
      idGenPersona: 0,
      nombreUsuario: '',
      apenom: name,
      documento: '',
      sexoPerson: '',
      token: Token(request: '', expired: ''),
      session: false,
      motivo: '',
      actualizarApp: false,
      foto: Foto(fotoBase64: '', success: false));

  factory User.fromJson(Map<String, dynamic> json) => User(
        idGenUsuario: ParseModel.parseToInt(json["idGenUsuario"]),
        idGenPersona: ParseModel.parseToInt(json["idGenPersona"]),
        nombreUsuario: ParseModel.parseToString(json["nombreUsuario"]),
        apenom: ParseModel.parseToString(json["apenom"]),
        documento: ParseModel.parseToString(json["documento"]),
        sexoPerson: ParseModel.parseToString(json["sexoPerson"]),
        session: ParseModel.parseToBool(json["session"]),
        motivo: ParseModel.parseToString(json["motivo"]),
        actualizarApp: ParseModel.parseToBool(json["actualizarApp"]),
        foto: json["foto"]==null?Foto.empty(): Foto.fromJson(json["foto"]),
    token:json["token"]==null?Token.empty(): Token.fromJson(json["token"]),
      );

  Map<String, dynamic> toJson() => {
        "idGenUsuario": idGenUsuario,
        "idGenPersona": idGenPersona,
        "nombreUsuario": nombreUsuario,
        "apenom": apenom,
        "documento": documento,
        "sexoPerson": sexoPerson,
        "token": token.toJson(),
        "session": session,
        "motivo": motivo,
        "actualizarApp": actualizarApp,
        "foto": foto.toJson(),
      };
}

class Foto {
  Foto({
    required this.success,
    required this.fotoBase64,
  });

  bool success;
  String fotoBase64;



  factory Foto.fromJson(Map<String, dynamic> json) => Foto(
        success: json["success"],
        fotoBase64: json["success"] ? json["fotoBase64"] : "",
      );


  factory Foto.empty()=>Foto(fotoBase64: '',success: false);

  Map<String, dynamic> toJson() => {
        "success": success,
        "fotoBase64": fotoBase64,
      };
}

class Token {
  Token({
    required this.request,
    required this.expired,
  });

  String request;
  String expired;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        request: json["request"],
        expired: json["expired"],
      );

  factory Token.empty()=>Token(request: '',expired: '');

  Map<String, dynamic> toJson() => {
        "request": request,
        "expired": expired,
      };
}
