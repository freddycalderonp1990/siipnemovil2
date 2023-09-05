part of 'models.dart';

class PersonaModel {
  PersonaModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  bool success;
  int statusCode;
  String message;
  PersonaModelData data;


  factory PersonaModel.fromJson(String str) =>
      PersonaModel.fromMap(json.decode(str));



  factory PersonaModel.fromMap(Map<String, dynamic> json) =>
      PersonaModel(
        success: ParseModel.parseToBool(json["success"]),
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        data: ParseModel.parseToBool(json["success"])? PersonaModelData.fromMap(json["data"]):PersonaModelData.empty(),
      );

}

class PersonaModelData {
  PersonaModelData({
    required this.operativoCerrado,
    required this.dataSiipne,
    required this.dataDinardap,
    required this.ordenCaptura,
    required this.desaparecidoDinased,
    required this.alertaDna,
    required this.alertaInmediataPj,
    required this.datosAnt,
    required this.toqueQueda,
    required this.foto,
    required this.idHdrEventoResum,
    required this.idGenPersona,
  });

  bool operativoCerrado;
  DataSiipne dataSiipne;
  DataDinardap dataDinardap;
  OrdenCaptura ordenCaptura;
  DesaparecidoDinased desaparecidoDinased;
  AlertaDna alertaDna;
  AlertaInmediataPj alertaInmediataPj;
  DatosAnt datosAnt;
  ToqueQueda toqueQueda;
  Foto foto;
  int idHdrEventoResum;
  int idGenPersona;

  factory PersonaModelData.empty()=>
      PersonaModelData(operativoCerrado: true,
          dataSiipne: DataSiipne.empty(),
          dataDinardap: DataDinardap.empty(),
          ordenCaptura: OrdenCaptura.empty(),
          desaparecidoDinased: DesaparecidoDinased.empty(),
          alertaDna: AlertaDna.empty(),
          alertaInmediataPj: AlertaInmediataPj.empty(),
          datosAnt: DatosAnt.empty(),
          toqueQueda: ToqueQueda.empty(),
          foto: Foto.empty(),
          idHdrEventoResum: 0,
          idGenPersona: 0);

  factory PersonaModelData.fromJson(String str) =>
      PersonaModelData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PersonaModelData.fromMap(Map<String, dynamic> json) =>
      PersonaModelData(
        operativoCerrado:
        json["operativoCerrado"] == null ? false : json["operativoCerrado"],
        dataSiipne: json["dataSiipne"] == null
            ? DataSiipne.empty()
            : DataSiipne.fromMap(json["dataSiipne"]),
        dataDinardap: json["dataDinardap"] == null
            ? DataDinardap.empty()
            : DataDinardap.fromMap(json["dataDinardap"]),
        ordenCaptura: json["ordenCaptura"] == null
            ? OrdenCaptura.empty()
            : OrdenCaptura.fromMap(json["ordenCaptura"]),
        desaparecidoDinased: json["desaparecidoDinased"] == null
            ? DesaparecidoDinased.empty()
            : DesaparecidoDinased.fromMap(json["desaparecidoDinased"]),
        alertaDna: json["alertaDNA"] == null
            ? AlertaDna.empty()
            : AlertaDna.fromMap(json["alertaDNA"]),
        alertaInmediataPj: json["alertaInmediataPj"] == null
            ? AlertaInmediataPj.empty()
            : AlertaInmediataPj.fromMap(json["alertaInmediataPj"]),
        datosAnt: json["datosAnt"] == null
            ? DatosAnt.empty()
            : DatosAnt.fromMap(json["datosAnt"]),
        toqueQueda: json["toqueQueda"] == null
            ? ToqueQueda.empty()
            : ToqueQueda.fromMap(json["toqueQueda"]),
        foto: json["foto"] == null ? Foto.empty() : Foto.fromJson(json["foto"]),
        idHdrEventoResum: json["idHdrEventoResum"] == null
            ? 0
            : int.parse(json["idHdrEventoResum"].toString()),
        idGenPersona: json["idGenPersona"] == null
            ? 0
            : int.parse(json["idGenPersona"].toString()),
      );

  Map<String, dynamic> toMap() =>
      {
        "operativoCerrado": operativoCerrado == null ? null : operativoCerrado,
        "dataSiipne": dataSiipne == null ? null : dataSiipne.toMap(),
        "dataDinardap":
        dataDinardap == null ? null : dataDinardap.toMap(),
        "ordenCaptura": ordenCaptura == null ? null : ordenCaptura.toMap(),
        "desaparecidoDinased":
        desaparecidoDinased == null ? null : desaparecidoDinased.toMap(),
        "alertaDNA": alertaDna == null ? null : alertaDna.toMap(),
        "alertaInmediataPj":
        alertaInmediataPj == null ? null : alertaInmediataPj.toMap(),
        "datosAnt": datosAnt == null ? null : datosAnt.toMap(),
        "toqueQueda": toqueQueda == null ? null : toqueQueda.toMap(),
        "foto": foto == null ? null : foto.toJson(),
        "idHdrEventoResum": idHdrEventoResum == null ? null : idHdrEventoResum,
        "idGenPersona": idGenPersona == null ? 0 : idGenPersona,
      };
}

class AlertaDna {
  AlertaDna({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  AlertaDnaData data;

  factory AlertaDna.empty() =>
      AlertaDna(success: false, message: "", data: AlertaDnaData.empty());

  factory AlertaDna.fromJson(String str) => AlertaDna.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AlertaDna.fromMap(Map<String, dynamic> json) =>
      AlertaDna(
        success: ParseModel.parseToBool(json["success"]),
        message: ParseModel.parseToString(json["message"]),
        data: json["data"] == null
            ? AlertaDnaData.empty()
            : ParseModel.parseToString(json["message"]) == false
            ? AlertaDnaData.empty()
            : AlertaDnaData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toMap(),
      };
}

class AlertaDnaData {
  AlertaDnaData({
    required this.idGenPersona,
    required this.descripcion,
    required this.fechaParte,
    required this.numCasoJef,
    required this.imagen,
  });

  int idGenPersona;
  String descripcion;
  String fechaParte;
  String numCasoJef;
  String imagen;

  factory AlertaDnaData.empty() =>
      AlertaDnaData(
          idGenPersona: 0,
          descripcion: "",
          fechaParte: "",
          numCasoJef: "",
          imagen: "");

  factory AlertaDnaData.fromJson(String str) =>
      AlertaDnaData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AlertaDnaData.fromMap(Map<String, dynamic> json) =>
      AlertaDnaData(
        idGenPersona: ParseModel.parseToInt(json["idGenPersona"]),
        descripcion: ParseModel.parseToString(json['descripcion']),
        fechaParte: ParseModel.parseToString(json["fechaParte"]),
        numCasoJef: ParseModel.parseToString(json["numCasoJef"]),
        imagen: ParseModel.parseToString(json["imagen"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "idGenPersona": idGenPersona == null ? 0 : idGenPersona,
        "descripcion": descripcion == null ? "null" : descripcion,
        "fechaParte": fechaParte == null ? "null" : fechaParte,
        "numCasoJef": numCasoJef == null ? "null" : numCasoJef,
        "imagen": imagen == null ? "null" : imagen,
      };
}

class AlertaInmediataPj {
  AlertaInmediataPj({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  AlertaInmediataPjData data;

  factory AlertaInmediataPj.empty() =>
      AlertaInmediataPj(
          success: false, message: "", data: AlertaInmediataPjData.empty());

  factory AlertaInmediataPj.fromJson(String str) =>
      AlertaInmediataPj.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AlertaInmediataPj.fromMap(Map<String, dynamic> json) =>
      AlertaInmediataPj(
        success: ParseModel.parseToBool(json["success"]),
        message: ParseModel.parseToString(json["message"]),
        data: json["data"] == null
            ? AlertaInmediataPjData.empty()
            : ParseModel.parseToBool(json["success"]) == false
            ? AlertaInmediataPjData.empty()
            : AlertaInmediataPjData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toMap(),
      };
}

class AlertaInmediataPjData {
  AlertaInmediataPjData({
    required this.idGenPersona,
    required this.descripcion,
    required this.unidadComunicar,
    required this.telefonoAlertaInmediata,
    required this.urlFotoAlertaInmediata,
  });

  int idGenPersona;
  String descripcion;
  String unidadComunicar;
  String telefonoAlertaInmediata;
  String urlFotoAlertaInmediata;

  factory AlertaInmediataPjData.empty() =>
      AlertaInmediataPjData(
          idGenPersona: 0,
          descripcion: "",
          unidadComunicar: "",
          telefonoAlertaInmediata: "",
          urlFotoAlertaInmediata: "");

  factory AlertaInmediataPjData.fromJson(String str) =>
      AlertaInmediataPjData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AlertaInmediataPjData.fromMap(Map<String, dynamic> json) =>
      AlertaInmediataPjData(
        idGenPersona: ParseModel.parseToInt(json["idGenPersona"]),
        descripcion: ParseModel.parseToString(json["descripcion"]),
        unidadComunicar: ParseModel.parseToString(json["unidadComunicar"]),
        telefonoAlertaInmediata:
        ParseModel.parseToString(json["telefonoAlertaInmediata"]),
        urlFotoAlertaInmediata:
        ParseModel.parseToString(json["urlFotoAlertaInmediata"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "idGenPersona": idGenPersona == null ? 0 : idGenPersona,
        "descripcion": descripcion == null ? null : descripcion,
        "unidadComunicar": unidadComunicar == null ? null : unidadComunicar,
        "telefonoAlertaInmediata":
        telefonoAlertaInmediata == null ? null : telefonoAlertaInmediata,
        "urlFotoAlertaInmediata":
        urlFotoAlertaInmediata == null ? null : urlFotoAlertaInmediata,
      };
}

class DataDinardap {
  DataDinardap({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  DataDinardapData data;

  factory DataDinardap.empty() =>
      DataDinardap(
          success: false, message: "", data: DataDinardapData.empty());

  factory DataDinardap.fromJson(String str) =>
      DataDinardap.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataDinardap.fromMap(Map<String, dynamic> json) =>
      DataDinardap(
        success: ParseModel.parseToBool(json["success"]),
        message: ParseModel.parseToString(json["message"]),
        data: json["data"] == null
            ? DataDinardapData.empty()
            : ParseModel.parseToBool(json["success"]) == false
            ? DataDinardapData.empty()
            : DataDinardapData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() =>
      {"success": success == null ? null : success, "data": null};
}

class DataDinardapData {
  DataDinardapData({
    required this.cedula,
    required this.nombre,
    required this.genero,
    required this.fechaNacimiento,
    required this.lugarNacimiento,
    required this.edad,
    required this.nacionalidad,
    required this.estadoCivil,
    required this.individualDactilar,
    required this.conyuge,
    required this.nombrePadre,
    required this.nombreMadre,
    required this.domicilio,
    required this.callesDomicilio,
    required this.fechaMatrimonio,
    required this.fechaDefuncion,
    required this.profesion,
    required this.cedulaPadre,
    required this.cedulaMadre,
    required this.cedulaConyuge,
    required this.fotografia,
  });

  final String cedula;
  final String nombre;
  final String genero;
  final String fechaNacimiento;
  final String lugarNacimiento;
  final Edad? edad;
  final String nacionalidad;
  final String estadoCivil;
  final String individualDactilar;
  final String conyuge;
  final String nombrePadre;
  final String nombreMadre;
  final String domicilio;
  final String callesDomicilio;
  final String fechaMatrimonio;
  final String fechaDefuncion;
  final String profesion;
  final String cedulaPadre;
  final String cedulaMadre;
  final String cedulaConyuge;
  final String fotografia;

  factory DataDinardapData.empty() =>
      DataDinardapData(
          cedula: "",
          nombre: "",
          genero: "",
          fechaNacimiento: "",
          lugarNacimiento: "",
          edad: null,
          nacionalidad: "",
          estadoCivil: "",
          individualDactilar: "",
          conyuge: "",
          nombrePadre: "",
          nombreMadre: "",
          domicilio: "",
          callesDomicilio: "",
          fechaMatrimonio: "",
          fechaDefuncion: "",
          profesion: "",
          cedulaPadre: "",
          cedulaMadre: "",
          cedulaConyuge: "",
          fotografia: "");

  factory DataDinardapData.fromJson(String str) =>
      DataDinardapData.fromMap(json.decode(str));

  factory DataDinardapData.fromMap(Map<String, dynamic> json) =>
      DataDinardapData(
        cedula: ParseModel.parseToString(json["cedula"]),
        nombre: ParseModel.parseToString(json["nombre"]),
        genero: ParseModel.parseToString(json["genero"]),
        fechaNacimiento: ParseModel.parseToString(json["fechaNacimiento"]),
        lugarNacimiento: ParseModel.parseToString(json["lugarNacimiento"]),
        nacionalidad: ParseModel.parseToString(json["nacionalidad"]),
        estadoCivil: ParseModel.parseToString(json["estadoCivil"]),
        individualDactilar:
        ParseModel.parseToString(json["individualDactilar"]),
        conyuge: ParseModel.parseToString(json["conyuge"]),
        nombrePadre: ParseModel.parseToString(json["nombrePadre"]),
        nombreMadre: ParseModel.parseToString(json["nombreMadre"]),
        domicilio: ParseModel.parseToString(json["domicilio"]),
        callesDomicilio: ParseModel.parseToString(json["callesDomicilio"]),
        fechaMatrimonio: ParseModel.parseToString(json["fechaMatrimonio"]),
        fechaDefuncion: ParseModel.parseToString(json["fechaDefuncion"]),
        profesion: ParseModel.parseToString(json["profesion"]),
        cedulaPadre: ParseModel.parseToString(json["cedulaPadre"]),
        cedulaMadre: ParseModel.parseToString(json["cedulaMadre"]),
        cedulaConyuge: ParseModel.parseToString(json["cedulaConyuge"]),
        fotografia: ParseModel.parseToString(json["fotografia"]),
        edad: json["edad"] == null ? null : Edad.fromMap(json["edad"]),
      );
}

class Edad {
  Edad({
    required this.anos,
    required this.meses,
    required this.dias,
  });

  int anos;
  int meses;
  int dias;

  factory Edad.fromJson(String str) => Edad.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Edad.fromMap(Map<String, dynamic> json) =>
      Edad(
        anos: ParseModel.parseToInt(json["anos"].toString()),
        meses: ParseModel.parseToInt(json["meses"].toString()),
        dias: ParseModel.parseToInt(json["dias"].toString()),
      );

  Map<String, dynamic> toMap() =>
      {
        "anos": anos == null ? null : anos,
        "meses": meses == null ? null : meses,
        "dias": dias == null ? null : dias,
      };
}

class DataSiipne {
  DataSiipne({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  DataSiipneData data;

  factory DataSiipne.empty() =>
      DataSiipne(success: false, message: "", data: DataSiipneData.empty());

  factory DataSiipne.fromJson(String str) =>
      DataSiipne.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataSiipne.fromMap(Map<String, dynamic> json) =>
      DataSiipne(
        success: ParseModel.parseToBool(json["success"]),
        message: ParseModel.parseToString(json["message"]),
        data: json["data"] == null
            ? DataSiipneData.empty()
            : ParseModel.parseToBool(json["success"]) == false
            ? DataSiipneData.empty()
            : DataSiipneData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toMap(),
      };
}

class DataSiipneData {
  DataSiipneData({
    required this.idGenPersona,
    required this.documento,
    required this.apenom,
    required this.codigoDactilar,
    required this.sexo,
    required this.fechaNacimiento,
    required this.edad,
  });

  int idGenPersona;
  String documento;
  String apenom;
  String codigoDactilar;
  String sexo;
  String fechaNacimiento;
  Edad? edad;

  factory DataSiipneData.empty() =>
      DataSiipneData(
          idGenPersona: 0,
          documento: "",
          apenom: "",
          codigoDactilar: "",
          sexo: "sexo",
          fechaNacimiento: "",
          edad: null);

  factory DataSiipneData.fromJson(String str) =>
      DataSiipneData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataSiipneData.fromMap(Map<String, dynamic> json) =>
      DataSiipneData(
        idGenPersona: ParseModel.parseToInt(json["idGenPersona"]),
        documento: ParseModel.parseToString(json["documento"]),
        apenom: ParseModel.parseToString(json["apenom"]),
        codigoDactilar: ParseModel.parseToString(json["codigoDactilar"]),
        sexo: ParseModel.parseToString(json["sexo"]),
        fechaNacimiento: ParseModel.parseToString(json["fechaNacimiento"]),
        edad: json["edad"] == null ? null : Edad.fromMap(json["edad"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "idGenPersona": idGenPersona == null ? null : idGenPersona,
        "documento": documento == null ? null : documento,
        "apenom": apenom == null ? null : apenom,
        "codigoDactilar": codigoDactilar == null ? null : codigoDactilar,
        "sexo": sexo == null ? null : sexo,
        "fechaNacimiento": fechaNacimiento,
        "edad": edad!.toMap(),
      };
}

class DatosAnt {
  DatosAnt({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  DatosAntData data;

  factory DatosAnt.empty() =>
      DatosAnt(success: false, message: "", data: DatosAntData.empty());

  factory DatosAnt.fromJson(String str) => DatosAnt.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DatosAnt.fromMap(Map<String, dynamic> json) =>
      DatosAnt(
        success: ParseModel.parseToBool(json["success"]),
        message: ParseModel.parseToString(json["message"]),
        data: json["data"] == null
            ? DatosAntData.empty()
            : ParseModel.parseToBool(json["success"]) == false
            ? DatosAntData.empty()
            : DatosAntData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toMap(),
      };
}

class DatosAntData {
  DatosAntData({
    required this.infracciones,
    required this.licencias,
    required this.nombreCompleto,
    required this.bloqueos,
    required this.celular,
    required this.direccion,
    required this.email,
    required this.estadoCivil,
    required this.fechaNacimiento,
    required this.nacionalidad,
    required this.puntos,
    required this.sexo,
    required this.telefono,
    required this.tipoSangre,
  });

  final Infracciones infracciones;
  final List<Licencia> licencias;
  final String nombreCompleto;
  final String bloqueos;
  final String celular;
  final String direccion;
  final String email;
  final String estadoCivil;
  final String fechaNacimiento;
  final String nacionalidad;
  final double puntos;
  final String sexo;
  final String telefono;

  final String tipoSangre;

  factory DatosAntData.empty() =>
      DatosAntData(
          infracciones: Infracciones.empty(),
          licencias: [],
          nombreCompleto: "",
          bloqueos: "",
          celular: "",
          direccion: "",
          email: "",
          estadoCivil: "",
          fechaNacimiento: "",
          nacionalidad: "",
          puntos: 0,
          sexo: "",
          telefono: "",
          tipoSangre: "");

  factory DatosAntData.fromJson(String str) =>
      DatosAntData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DatosAntData.fromMap(Map<String, dynamic> json) =>
      DatosAntData(
        infracciones: json["infracciones"] == null
            ? Infracciones.empty()
            : Infracciones.fromMap(json["infracciones"]),
        licencias: json["licencias"] == null
            ? []
            : List<Licencia>.from(
            json["licencias"].map((x) => Licencia.fromMap(x))),
        nombreCompleto: ParseModel.parseToString(json["nombreCompleto"]),
        bloqueos: ParseModel.parseToString(json["bloqueos"]),
        celular: ParseModel.parseToString(json["celular"]),
        direccion: ParseModel.parseToString(json["direccion"]),
        email: ParseModel.parseToString(json["email"]),
        estadoCivil: ParseModel.parseToString(json["estadoCivil"]),
        fechaNacimiento: ParseModel.parseToString(json["fechaNacimiento"]),
        nacionalidad: ParseModel.parseToString(json["nacionalidad"]),
        puntos: ParseModel.parseToDouble(json["puntos"]),
        sexo: ParseModel.parseToString(json["sexo"]),
        telefono: ParseModel.parseToString(json["telefono"]),
        tipoSangre: ParseModel.parseToString(json["tipoSangre"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "infracciones": infracciones.toMap(),
        "licencias": List<dynamic>.from(licencias.map((x) => x.toMap())),
        "nombreCompleto": nombreCompleto,
        "bloqueos": bloqueos,
        "celular": celular,
        "direccion": direccion,
        "email": email,
        "estadoCivil": estadoCivil,
        "fechaNacimiento": fechaNacimiento,
        "nacionalidad": nacionalidad,
        "puntos": puntos,
        "sexo": sexo,
        "telefono": telefono,
        "tipoSangre": tipoSangre,
      };
}

class Infracciones {
  Infracciones({
    required this.datos,
    required this.valor,
    required this.cantidad,
  });

  final List<DatosInfracione> datos;
  final double valor;
  final int cantidad;

  factory Infracciones.empty() =>
      Infracciones(datos: [], valor: 0, cantidad: 0);

  factory Infracciones.fromJson(String str) =>
      Infracciones.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Infracciones.fromMap(Map<String, dynamic> json) =>
      Infracciones(
        datos: json["datos"] == null
            ? []
            : List<DatosInfracione>.from(
            json["datos"].map((x) => DatosInfracione.fromMap(x))),
        valor: ParseModel.parseToDouble(json["valor"]),
        cantidad: ParseModel.parseToInt(json["cantidad"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "datos": List<dynamic>.from(datos.map((x) => x.toMap())),
        "valor": valor,
        "cantidad": cantidad,
      };
}

class DatosInfracione {
  DatosInfracione({
    required this.idEmpresa,
    required this.empresa,
    required this.valor,
    required this.cantidad,
  });

  final int idEmpresa;
  final String empresa;
  final double valor;
  final int cantidad;

  factory DatosInfracione.fromJson(String str) =>
      DatosInfracione.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DatosInfracione.fromMap(Map<String, dynamic> json) =>
      DatosInfracione(
        idEmpresa: ParseModel.parseToInt(json["idEmpresa"]),
        empresa: ParseModel.parseToString(json["empresa"]),
        valor: ParseModel.parseToDouble(json["valor"]),
        cantidad: ParseModel.parseToInt(json["cantidad"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "idEmpresa": idEmpresa,
        "empresa": empresa,
        "valor": valor,
        "cantidad": cantidad,
      };
}

class Licencia {
  Licencia({
    required this.fechaDesde,
    required this.fechaHasta,
    required this.tipo,
  });

  final String fechaDesde;
  final String fechaHasta;
  final String tipo;

  factory Licencia.fromJson(String str) => Licencia.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Licencia.fromMap(Map<String, dynamic> json) =>
      Licencia(
        fechaDesde: ParseModel.parseToString(json["fechaDesde"]),
        fechaHasta: ParseModel.parseToString(json["fechaHasta"]),
        tipo: ParseModel.parseToString(json["tipo"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "fechaDesde": fechaDesde,
        "fechaHasta": fechaHasta,
        "tipo": tipo,
      };
}

class DesaparecidoDinased {
  DesaparecidoDinased({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  DesaparecidoDinasedData data;

  factory DesaparecidoDinased.empty() =>
      DesaparecidoDinased(
          success: false, message: "", data: DesaparecidoDinasedData.empty());

  factory DesaparecidoDinased.fromJson(String str) =>
      DesaparecidoDinased.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DesaparecidoDinased.fromMap(Map<String, dynamic> json) =>
      DesaparecidoDinased(
        success: ParseModel.parseToBool(json["success"]),
        message: ParseModel.parseToString(json["message"]),
        data: json["data"] == null
            ? DesaparecidoDinasedData.empty()
            : ParseModel.parseToBool(json["success"]) == false
            ? DesaparecidoDinasedData.empty()
            : DesaparecidoDinasedData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toMap(),
      };
}

class DesaparecidoDinasedData {
  DesaparecidoDinasedData({required this.idUpcAlertaDesaparecido,
    required this.descripcion,
    required this.unidadComunica,
    required this.fechaAlerta,
    required this.fotoDesaparecido,
    required this.edad,
    required this.nombres,
    required this.documento,
    required this.lugarDesaparicion});

  int idUpcAlertaDesaparecido;
  String documento;
  String nombres;
  String edad;
  String descripcion;
  String lugarDesaparicion;
  String unidadComunica;
  String fechaAlerta;
  String fotoDesaparecido;

  factory DesaparecidoDinasedData.empty() =>
      DesaparecidoDinasedData(
          idUpcAlertaDesaparecido: 0,
          descripcion: "",
          unidadComunica: "",
          fechaAlerta: "",
          fotoDesaparecido: "",
          edad: "",
          nombres: "",
          documento: "",
          lugarDesaparicion: "");

  factory DesaparecidoDinasedData.fromJson(String str) =>
      DesaparecidoDinasedData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DesaparecidoDinasedData.fromMap(Map<String, dynamic> json) =>
      DesaparecidoDinasedData(
          idUpcAlertaDesaparecido:
          ParseModel.parseToInt(json["idUpcAlertaDesaparecido"]),
          descripcion: ParseModel.parseToString(json["descripcion"]),
          unidadComunica: ParseModel.parseToString(json["unidadComunica"]),
          fechaAlerta: ParseModel.parseToString(json["fechaAlerta"]),
          fotoDesaparecido: ParseModel.parseToString(json["fotoDesaparecido"]),
          documento: ParseModel.parseToString(json["documento"]),
          edad: ParseModel.parseToString(json["edad"]),
          lugarDesaparicion:
          ParseModel.parseToString(json["lugarDesaparicion"]),
          nombres: ParseModel.parseToString(json["nombres"]));

  Map<String, dynamic> toMap() =>
      {
        "idUpcAlertaDesaparecido":
        idUpcAlertaDesaparecido == null ? null : idUpcAlertaDesaparecido,
        "descripcion": descripcion == null ? null : descripcion,
        "unidadComunica": unidadComunica == null ? null : unidadComunica,
        "fechaAlerta": fechaAlerta == null ? null : fechaAlerta,
        "fotoDesaparecido": fotoDesaparecido == null ? null : fotoDesaparecido,
      };
}

class OrdenCaptura {
  OrdenCaptura({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  OrdenCapturaData data;

  factory OrdenCaptura.empty() =>
      OrdenCaptura(success: false, message: "", data: OrdenCapturaData.empty());

  factory OrdenCaptura.fromJson(String str) =>
      OrdenCaptura.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrdenCaptura.fromMap(Map<String, dynamic> json) =>
      OrdenCaptura(
        success: ParseModel.parseToBool(json["success"]),
        message: ParseModel.parseToString(json["message"]),
        data: json["data"] == null
            ? OrdenCapturaData.empty()
            : ParseModel.parseToBool(json["success"]) == false
            ? OrdenCapturaData.empty()
            : OrdenCapturaData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toMap(),
      };
}

class OrdenCapturaData {
  OrdenCapturaData({
    required this.idGenPersona,
    required this.juzgado,
    required this.documento,
    required this.numoficio,
  });

  int idGenPersona;
  String juzgado;
  String documento;
  String numoficio;

  factory OrdenCapturaData.empty() =>
      OrdenCapturaData(
          idGenPersona: 0, juzgado: "", documento: "", numoficio: "");

  factory OrdenCapturaData.fromJson(String str) =>
      OrdenCapturaData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrdenCapturaData.fromMap(Map<String, dynamic> json) =>
      OrdenCapturaData(
        idGenPersona: ParseModel.parseToInt(json["idGenPersona"]),
        juzgado: ParseModel.parseToString(json["juzgado"]),
        documento: ParseModel.parseToString(json["documento"]),
        numoficio: ParseModel.parseToString(json["numoficio"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "idGenPersona": idGenPersona == null ? null : idGenPersona,
        "juzgado": juzgado == null ? null : juzgado,
        "documento": documento == null ? null : documento,
        "numoficio": numoficio == null ? null : numoficio,
      };
}

class ToqueQueda {
  ToqueQueda({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory ToqueQueda.empty() => ToqueQueda(success: false, message: "");

  factory ToqueQueda.fromJson(String str) =>
      ToqueQueda.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ToqueQueda.fromMap(Map<String, dynamic> json) =>
      ToqueQueda(
        success: ParseModel.parseToBool(json["success"]),
        message: ParseModel.parseToString(json["message"]),
      );

  Map<String, dynamic> toMap() =>
      {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
