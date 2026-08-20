part of '../models_siipne_movil.dart';

OpeVehiculoModel opeVehiculoModelFromJson(String str) {
  try {
    final dynamic data = json.decode(str);
    return OpeVehiculoModel.fromJson(
      data is Map<String, dynamic> ? data : <String, dynamic>{},
    );
  } catch (_) {
    return OpeVehiculoModel.empty();
  }
}

String opeVehiculoModelToJson(OpeVehiculoModel data) =>
    json.encode(data.toJson());

Map<String, dynamic> _mapVehiculo(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

bool _boolVehiculo(dynamic value, {bool defaultValue = false}) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is num) return value == 1;

  final String valor = ParseModel.parseToString(value).trim().toLowerCase();

  if (valor == 'true' ||
      valor == '1' ||
      valor == 'si' ||
      valor == 'sí' ||
      valor == 's') {
    return true;
  }

  if (valor == 'false' || valor == '0' || valor == 'no' || valor == 'n') {
    return false;
  }

  return defaultValue;
}

class OpeVehiculoModel {
  int statusCode;
  String message;
  DataVehiculo dataVehiculo;

  OpeVehiculoModel({
    required this.statusCode,
    required this.message,
    required this.dataVehiculo,
  });

  factory OpeVehiculoModel.fromJson(Map<String, dynamic> json) {
    return OpeVehiculoModel(
      statusCode: ParseModel.parseToInt(json["status_code"]),
      message: ParseModel.parseToString(json["message"]),
      dataVehiculo: DataVehiculo.fromJson(
        _mapVehiculo(json["data"] ?? json["dataVehiculo"]),
      ),
    );
  }

  factory OpeVehiculoModel.empty() {
    return OpeVehiculoModel(
      statusCode: 0,
      message: '',
      dataVehiculo: DataVehiculo.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": dataVehiculo.toJson(),
  };
}

class DataVehiculo {
  DatosVehiculoSiipne datosVehiculoSiipne;
  Datospropietario datospropietario;
  RestriccionPj restriccionPj;
  int idHdrEventoResum;

  DataVehiculo({
    required this.datosVehiculoSiipne,
    required this.datospropietario,
    required this.restriccionPj,
    required this.idHdrEventoResum,
  });

  factory DataVehiculo.fromJson(Map<String, dynamic> json) {
    return DataVehiculo(
      datosVehiculoSiipne: DatosVehiculoSiipne.fromJson(
        _mapVehiculo(json["datosVehiculoSiipne"]),
      ),
      datospropietario: Datospropietario.fromJson(
        _mapVehiculo(json["datospropietario"] ?? json["datosPropietario"]),
      ),
      restriccionPj: RestriccionPj.fromJson(
        _mapVehiculo(json["restriccionPJ"]),
      ),
      idHdrEventoResum: ParseModel.parseToInt(json["idHdrEventoResum"]),
    );
  }

  factory DataVehiculo.empty() {
    return DataVehiculo(
      datosVehiculoSiipne: DatosVehiculoSiipne.empty(),
      datospropietario: Datospropietario.empty(),
      restriccionPj: RestriccionPj.empty(),
      idHdrEventoResum: 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "datosVehiculoSiipne": datosVehiculoSiipne.toJson(),
    "datospropietario": datospropietario.toJson(),
    "restriccionPJ": restriccionPj.toJson(),
    "idHdrEventoResum": idHdrEventoResum,
  };
}

class DatosVehiculoSiipne {
  bool success;
  String message;
  DatosVehiculoSiipneData data;

  DatosVehiculoSiipne({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DatosVehiculoSiipne.fromJson(Map<String, dynamic> json) {
    return DatosVehiculoSiipne(
      success: _boolVehiculo(json["success"]),
      message: ParseModel.parseToString(json["message"]),
      data: DatosVehiculoSiipneData.fromJson(_mapVehiculo(json["data"])),
    );
  }

  factory DatosVehiculoSiipne.empty() {
    return DatosVehiculoSiipne(
      success: false,
      message: '',
      data: DatosVehiculoSiipneData.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class DatosVehiculoSiipneData {
  int idGenVehiculo;
  int idGenMarca;
  String marca;
  int idGenModelo;
  String modelo;
  int idGenColor;
  String color;
  int idGenCombus;
  String combustible;
  String motor;
  String chasis;
  String placa;
  String cilindraje;
  int anoFabricacion;
  int idGenClase;
  String clase;
  int idGenTipVehi;
  String tipoVehiculo;
  int idGenServicio;
  String descServicio;

  DatosVehiculoSiipneData({
    required this.idGenVehiculo,
    required this.idGenMarca,
    required this.marca,
    required this.idGenModelo,
    required this.modelo,
    required this.idGenColor,
    required this.color,
    required this.idGenCombus,
    required this.combustible,
    required this.motor,
    required this.chasis,
    required this.placa,
    required this.cilindraje,
    required this.anoFabricacion,
    required this.idGenClase,
    required this.clase,
    required this.idGenTipVehi,
    required this.tipoVehiculo,
    required this.idGenServicio,
    required this.descServicio,
  });

  factory DatosVehiculoSiipneData.fromJson(Map<String, dynamic> json) {
    return DatosVehiculoSiipneData(
      idGenVehiculo: ParseModel.parseToInt(json["idGenVehiculo"]),
      idGenMarca: ParseModel.parseToInt(json["idGenMarca"]),
      marca: ParseModel.parseToString(json["marca"]),
      idGenModelo: ParseModel.parseToInt(json["idGenModelo"]),
      modelo: ParseModel.parseToString(json["modelo"]),
      idGenColor: ParseModel.parseToInt(json["idGenColor"]),
      color: ParseModel.parseToString(json["color"]),
      idGenCombus: ParseModel.parseToInt(json["idGenCombus"]),
      combustible: ParseModel.parseToString(json["combustible"]),
      motor: ParseModel.parseToString(json["motor"]),
      chasis: ParseModel.parseToString(json["chasis"]),
      placa: ParseModel.parseToString(json["placa"]),
      cilindraje: ParseModel.parseToString(json["cilindraje"]),
      anoFabricacion: ParseModel.parseToInt(json["anoFabricacion"]),
      idGenClase: ParseModel.parseToInt(json["idGenClase"]),
      clase: ParseModel.parseToString(json["clase"]),
      idGenTipVehi: ParseModel.parseToInt(json["idGenTipVehi"]),
      tipoVehiculo: ParseModel.parseToString(json["tipoVehiculo"]),
      idGenServicio: ParseModel.parseToInt(json["idGenServicio"]),
      descServicio: ParseModel.parseToString(json["descServicio"]),
    );
  }

  factory DatosVehiculoSiipneData.empty() {
    return DatosVehiculoSiipneData(
      idGenVehiculo: 0,
      idGenMarca: 0,
      marca: '',
      idGenModelo: 0,
      modelo: '',
      idGenColor: 0,
      color: '',
      idGenCombus: 0,
      combustible: '',
      motor: '',
      chasis: '',
      placa: '',
      cilindraje: '',
      anoFabricacion: 0,
      idGenClase: 0,
      clase: '',
      idGenTipVehi: 0,
      tipoVehiculo: '',
      idGenServicio: 0,
      descServicio: '',
    );
  }

  Map<String, dynamic> toJson() => {
    "idGenVehiculo": idGenVehiculo,
    "idGenMarca": idGenMarca,
    "marca": marca,
    "idGenModelo": idGenModelo,
    "modelo": modelo,
    "idGenColor": idGenColor,
    "color": color,
    "idGenCombus": idGenCombus,
    "combustible": combustible,
    "motor": motor,
    "chasis": chasis,
    "placa": placa,
    "cilindraje": cilindraje,
    "anoFabricacion": anoFabricacion,
    "idGenClase": idGenClase,
    "clase": clase,
    "idGenTipVehi": idGenTipVehi,
    "tipoVehiculo": tipoVehiculo,
    "idGenServicio": idGenServicio,
    "descServicio": descServicio,
  };
}

class Datospropietario {
  bool success;
  String message;
  DatospropietarioData data;

  Datospropietario({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Datospropietario.fromJson(Map<String, dynamic> json) {
    return Datospropietario(
      success: _boolVehiculo(json["success"]),
      message: ParseModel.parseToString(json["message"]),
      data: DatospropietarioData.fromJson(_mapVehiculo(json["data"])),
    );
  }

  factory Datospropietario.empty() {
    return Datospropietario(
      success: false,
      message: '',
      data: DatospropietarioData.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class DatospropietarioData {
  String propietario;
  String docPropietario;
  String fechaCaducidad;
  String institucionRenova;
  String telefono;
  String correo;
  String fototo64;
  String fechaDefuncion;

  DatospropietarioData({
    required this.propietario,
    required this.docPropietario,
    required this.fechaCaducidad,
    required this.institucionRenova,
    required this.telefono,
    required this.correo,
    required this.fototo64,
    required this.fechaDefuncion
  });

  factory DatospropietarioData.fromJson(Map<String, dynamic> json) {
    return DatospropietarioData(
      propietario: ParseModel.parseToString(json["propietario"]),
      docPropietario: ParseModel.parseToString(json["docPropietario"]),
      fechaCaducidad: ParseModel.parseToString(json["fechaCaducidad"]),
      institucionRenova: ParseModel.parseToString(json["institucionRenova"]),
      telefono: ParseModel.parseToString(json["telefono"]),
      correo: ParseModel.parseToString(json["correo"]),
      fototo64: ParseModel.parseToString(json["fototo64"]),
      fechaDefuncion: ParseModel.parseToString(json["fechaDefuncion"]),
    );
  }

  factory DatospropietarioData.empty() {
    return DatospropietarioData(
      propietario: '',
      docPropietario: '',
      fechaCaducidad: '',
      institucionRenova: '',
      telefono: '',
      correo: '',
      fototo64: '',
      fechaDefuncion:'',
    );
  }

  Map<String, dynamic> toJson() => {
    "propietario": propietario,
    "docPropietario": docPropietario,
    "fechaCaducidad": fechaCaducidad,
    "institucionRenova": institucionRenova,
    "telefono": telefono,
    "correo": correo,
    "fototo64": fototo64,
    "fechaDefuncion":fechaDefuncion
  };
}

class RestriccionPj {
  bool success;
  String message;
  RestriccionPjData data;

  RestriccionPj({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RestriccionPj.fromJson(Map<String, dynamic> json) {
    return RestriccionPj(
      success: _boolVehiculo(json["success"]),
      message: ParseModel.parseToString(json["message"]),
      data: RestriccionPjData.fromJson(_mapVehiculo(json["data"])),
    );
  }

  factory RestriccionPj.empty() {
    return RestriccionPj(
      success: false,
      message: '',
      data: RestriccionPjData.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class RestriccionPjData {
  bool robado;
  String detBusqueda;

  RestriccionPjData({required this.robado, required this.detBusqueda});

  factory RestriccionPjData.fromJson(Map<String, dynamic> json) {
    return RestriccionPjData(
      robado: _boolVehiculo(json["robado"]),
      detBusqueda: ParseModel.parseToString(json["detBusqueda"]),
    );
  }

  factory RestriccionPjData.empty() {
    return RestriccionPjData(robado: false, detBusqueda: '');
  }

  Map<String, dynamic> toJson() => {
    "robado": robado,
    "detBusqueda": detBusqueda,
  };
}
