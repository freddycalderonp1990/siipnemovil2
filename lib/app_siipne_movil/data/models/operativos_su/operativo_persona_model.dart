part of '../models_siipne_movil.dart';

OperativoPersonaModel operativoPersonaModelFromJson(String str) =>
    OperativoPersonaModel.fromJson(json.decode(str));

String operativoPersonaModelToJson(OperativoPersonaModel data) =>
    json.encode(data.toJson());

class OperativoPersonaModel {
  final int statusCode;
  final String message;
  final DataConsultaPersona dataConsultaPersona;

  OperativoPersonaModel({
    required this.statusCode,
    required this.message,
    required this.dataConsultaPersona,
  });

  factory OperativoPersonaModel.fromJson(Map<String, dynamic> json) =>
      OperativoPersonaModel(
        statusCode: ParseModel.parseToInt(json["status_code"]),
        message: ParseModel.parseToString(json["message"]),
        dataConsultaPersona: DataConsultaPersona.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": dataConsultaPersona.toJson(),
  };
}

class DataConsultaPersona {
  final DataSiipne dataSiipne;
  final DataDinardap dataDinardap;
  final OrdenCaptura ordenCaptura;
  final DatosAnt datosAnt;
  final int idGenPersona;
  final int idHdrEventoResum;

  DataConsultaPersona({
    required this.dataSiipne,
    required this.dataDinardap,
    required this.ordenCaptura,
    required this.datosAnt,
    required this.idGenPersona,
    required this.idHdrEventoResum,
  });

  factory DataConsultaPersona.fromJson(Map<String, dynamic> json) =>
      DataConsultaPersona(
        dataSiipne: DataSiipne.fromJson(json["dataSiipne"] ?? {}),
        dataDinardap: DataDinardap.fromJson(json["dataDinardap"] ?? {}),
        ordenCaptura: OrdenCaptura.fromJson(json["ordenCaptura"] ?? {}),
        datosAnt: DatosAnt.fromJson(json["datosAnt"] ?? {}),
        idGenPersona: ParseModel.parseToInt(json["idGenPersona"]),
        idHdrEventoResum: ParseModel.parseToInt(json["idHdrEventoResum"]),
      );

  Map<String, dynamic> toJson() => {
    "dataSiipne": dataSiipne.toJson(),
    "dataDinardap": dataDinardap.toJson(),
    "ordenCaptura": ordenCaptura.toJson(),
    "datosAnt": datosAnt.toJson(),
    "idGenPersona": idGenPersona,
    "idHdrEventoResum": idHdrEventoResum,
  };
}

class DataDinardap {
  final bool success;
  final String message;
  final dynamic datosDinardap;

  DataDinardap({
    required this.success,
    required this.message,
    required this.datosDinardap,
  });

  factory DataDinardap.fromJson(Map<String, dynamic> json) => DataDinardap(
    success: ParseModel.parseToBool(json["success"]),
    message: ParseModel.parseToString(json["message"]),
    datosDinardap: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": datosDinardap,
  };
}

class DataSiipne {
  final bool success;
  final String message;
  final DatosSiipne datosSiipne;

  DataSiipne({
    required this.success,
    required this.message,
    required this.datosSiipne,
  });

  factory DataSiipne.fromJson(Map<String, dynamic> json) => DataSiipne(
    success: ParseModel.parseToBool(json["success"]),
    message: ParseModel.parseToString(json["message"]),
    datosSiipne: DatosSiipne.fromJson(json["data"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": datosSiipne.toJson(),
  };
}

class DatosSiipne {
  final int idGenPersona;
  final String documento;
  final String apenom;
  final String codigoDactilar;
  final String sexo;
  final String fechaNacimiento;
  final String grado;
  final String sigla;
  final String pais;
  final Edad edad;
  final String fechaDefuncion;
  final String foto64;

  DatosSiipne({
    required this.idGenPersona,
    required this.documento,
    required this.apenom,
    required this.codigoDactilar,
    required this.sexo,
    required this.fechaNacimiento,
    required this.grado,
    required this.sigla,
    required this.pais,
    required this.edad,
    required this.fechaDefuncion,
    required this.foto64,
  });

  factory DatosSiipne.fromJson(Map<String, dynamic> json) => DatosSiipne(
    idGenPersona: ParseModel.parseToInt(json["idGenPersona"]),
    documento: ParseModel.parseToString(json["documento"]),
    apenom: ParseModel.parseToString(json["apenom"]),
    codigoDactilar: ParseModel.parseToString(json["codigoDactilar"]),
    sexo: ParseModel.parseToString(json["sexo"]),
    fechaNacimiento: ParseModel.parseToString(json["fechaNacimiento"]),
    grado: ParseModel.parseToString(json["grado"]),
    sigla: ParseModel.parseToString(json["sigla"]),
    pais: ParseModel.parseToString(json["pais"]),
    edad: Edad.fromJson(json["edad"] ?? {}),
    fechaDefuncion: ParseModel.parseToString(json["fechaDefuncion"]),
    foto64: ParseModel.parseToString(json["foto64"]),
  );

  Map<String, dynamic> toJson() => {
    "idGenPersona": idGenPersona,
    "documento": documento,
    "apenom": apenom,
    "codigoDactilar": codigoDactilar,
    "sexo": sexo,
    "fechaNacimiento": fechaNacimiento,
    "grado": grado,
    "sigla": sigla,
    "pais": pais,
    "edad": edad.toJson(),
    "fechaDefuncion": fechaDefuncion,
    "foto64": foto64,
  };
}

class Edad {
  final String anos;
  final String meses;
  final String dias;

  Edad({required this.anos, required this.meses, required this.dias});

  factory Edad.fromJson(Map<String, dynamic> json) => Edad(
    anos: ParseModel.parseToString(json["anos"]),
    meses: ParseModel.parseToString(json["meses"]),
    dias: ParseModel.parseToString(json["dias"]),
  );

  Map<String, dynamic> toJson() => {"anos": anos, "meses": meses, "dias": dias};
}

class DatosAnt {
  final bool success;
  final String message;
  final DataAnt data;

  DatosAnt({required this.success, required this.message, required this.data});

  factory DatosAnt.fromJson(Map<String, dynamic> json) => DatosAnt(
    success: ParseModel.parseToBool(json["success"]),
    message: ParseModel.parseToString(json["message"]),
    data: DataAnt.fromJson(json["data"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class DataAnt {
  final String nombreCompleto;
  final String nombres;
  final String apellido1;
  final String apellido2;
  final String sexo;
  final String fechaNacimiento;
  final String tipoSangre;
  final String nacionalidad;
  final String direccion;
  final String celular;
  final String email;
  final String estadoCivil;
  final String puntos;
  final bool tieneLicencia;
  final List<LicenciaAnt> licencias;
  final InfraccionesAnt infracciones;
  final List<dynamic> restricciones;

  DataAnt({
    required this.nombreCompleto,
    required this.nombres,
    required this.apellido1,
    required this.apellido2,
    required this.sexo,
    required this.fechaNacimiento,
    required this.tipoSangre,
    required this.nacionalidad,
    required this.direccion,
    required this.celular,
    required this.email,
    required this.estadoCivil,
    required this.puntos,
    required this.tieneLicencia,
    required this.licencias,
    required this.infracciones,
    required this.restricciones,
  });

  factory DataAnt.fromJson(Map<String, dynamic> json) => DataAnt(
    nombreCompleto: ParseModel.parseToString(json["nombreCompleto"]),
    nombres: ParseModel.parseToString(json["nombres"]),
    apellido1: ParseModel.parseToString(json["apellido1"]),
    apellido2: ParseModel.parseToString(json["apellido2"]),
    sexo: ParseModel.parseToString(json["sexo"]),
    fechaNacimiento: ParseModel.parseToString(json["fechaNacimiento"]),
    tipoSangre: ParseModel.parseToString(json["tipoSangre"]),
    nacionalidad: ParseModel.parseToString(json["nacionalidad"]),
    direccion: ParseModel.parseToString(json["direccion"]),
    celular: ParseModel.parseToString(json["celular"]),
    email: ParseModel.parseToString(json["email"]),
    estadoCivil: ParseModel.parseToString(json["estadoCivil"]),
    puntos: ParseModel.parseToString(json["puntos"]),
    tieneLicencia: ParseModel.parseToBool(json["tieneLicencia"]),
    licencias: json["licencias"] is List
        ? List<LicenciaAnt>.from(
            json["licencias"].map((x) => LicenciaAnt.fromJson(x)),
          )
        : <LicenciaAnt>[],
    infracciones: InfraccionesAnt.fromJson(json["infracciones"] ?? {}),
    restricciones: json["restricciones"] is List
        ? List<dynamic>.from(json["restricciones"])
        : <dynamic>[],
  );

  Map<String, dynamic> toJson() => {
    "nombreCompleto": nombreCompleto,
    "nombres": nombres,
    "apellido1": apellido1,
    "apellido2": apellido2,
    "sexo": sexo,
    "fechaNacimiento": fechaNacimiento,
    "tipoSangre": tipoSangre,
    "nacionalidad": nacionalidad,
    "direccion": direccion,
    "celular": celular,
    "email": email,
    "estadoCivil": estadoCivil,
    "puntos": puntos,
    "tieneLicencia": tieneLicencia,
    "licencias": licencias.map((x) => x.toJson()).toList(),
    "infracciones": infracciones.toJson(),
    "restricciones": restricciones,
  };
}

class LicenciaAnt {
  final String tipo;
  final String fechaDesde;
  final String fechaHasta;

  LicenciaAnt({
    required this.tipo,
    required this.fechaDesde,
    required this.fechaHasta,
  });

  factory LicenciaAnt.fromJson(Map<String, dynamic> json) => LicenciaAnt(
    tipo: ParseModel.parseToString(json["tipo"]),
    fechaDesde: ParseModel.parseToString(json["fechaDesde"]),
    fechaHasta: ParseModel.parseToString(json["fechaHasta"]),
  );

  Map<String, dynamic> toJson() => {
    "tipo": tipo,
    "fechaDesde": fechaDesde,
    "fechaHasta": fechaHasta,
  };
}

class InfraccionesAnt {
  final String valor;
  final String cantidad;

  InfraccionesAnt({required this.valor, required this.cantidad});

  factory InfraccionesAnt.fromJson(Map<String, dynamic> json) =>
      InfraccionesAnt(
        valor: ParseModel.parseToString(json["valor"]),
        cantidad: ParseModel.parseToString(json["cantidad"]),
      );

  Map<String, dynamic> toJson() => {"valor": valor, "cantidad": cantidad};
}

class OrdenCaptura {
  final bool success;
  final String message;
  final List<DatosCaptura> ordenesCaptura;

  OrdenCaptura({
    required this.success,
    required this.message,
    required this.ordenesCaptura,
  });

  factory OrdenCaptura.fromJson(Map<String, dynamic> json) {
    final dynamic data = json["data"];
    final List<DatosCaptura> ordenes = data is List
        ? data
              .whereType<Map>()
              .map(
                (item) =>
                    DatosCaptura.fromJson(Map<String, dynamic>.from(item)),
              )
              .where((item) => item.tieneDatos)
              .toList()
        : data is Map
        ? <DatosCaptura>[
            DatosCaptura.fromJson(Map<String, dynamic>.from(data)),
          ].where((item) => item.tieneDatos).toList()
        : <DatosCaptura>[];
    return OrdenCaptura(
      success: ParseModel.parseToBool(json["success"]),
      message: ParseModel.parseToString(json["message"]),
      ordenesCaptura: ordenes,
    );
  }

  bool get tieneOrdenes => success && ordenesCaptura.isNotEmpty;
  int get totalOrdenes => ordenesCaptura.length;
  DatosCaptura get datosCaptura =>
      ordenesCaptura.isNotEmpty ? ordenesCaptura.first : DatosCaptura.empty();

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": ordenesCaptura.map((item) => item.toJson()).toList(),
  };
}

class DatosCaptura {
  final String juzgado;
  final String numoficio;
  final String fechaBoleta;
  final String causa;
  final String delito;
  final String tipoBoleta;
  final String unidadRegistro;
  final String pais;

  DatosCaptura({
    required this.juzgado,
    required this.numoficio,
    required this.fechaBoleta,
    required this.causa,
    required this.delito,
    required this.tipoBoleta,
    required this.unidadRegistro,
    required this.pais,
  });

  factory DatosCaptura.empty() => DatosCaptura(
    juzgado: "",
    numoficio: "",
    fechaBoleta: "",
    causa: "",
    delito: "",
    tipoBoleta: "",
    unidadRegistro: "",
    pais: "",
  );

  bool get tieneDatos =>
      juzgado.trim().isNotEmpty &&
      numoficio.trim().isNotEmpty &&
      fechaBoleta.trim().isNotEmpty &&
      causa.trim().isNotEmpty &&
      delito.trim().isNotEmpty &&
      tipoBoleta.trim().isNotEmpty &&
      unidadRegistro.trim().isNotEmpty &&
      pais.trim().isNotEmpty;

  factory DatosCaptura.fromJson(Map<String, dynamic> json) => DatosCaptura(
    juzgado: ParseModel.parseToString(json["juzgado"]),
    numoficio: ParseModel.parseToString(json["numoficio"]),
    fechaBoleta: ParseModel.parseToString(json["fechaBoleta"]),
    causa: ParseModel.parseToString(json["causa"]),
    delito: ParseModel.parseToString(json["delito"]),
    tipoBoleta: ParseModel.parseToString(json["tipoBoleta"]),
    unidadRegistro: ParseModel.parseToString(json["unidadRegistro"]),
    pais: ParseModel.parseToString(json["pais"]),
  );

  Map<String, dynamic> toJson() => {
    "juzgado": juzgado,
    "numoficio": numoficio,
    "fechaBoleta": fechaBoleta,
    "causa": causa,
    "delito": delito,
    "tipoBoleta": tipoBoleta,
    "unidadRegistro": unidadRegistro,
    "pais": pais,
  };
}
