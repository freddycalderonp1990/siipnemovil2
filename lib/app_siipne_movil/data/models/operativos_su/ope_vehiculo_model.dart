part of '../models_siipne_movil.dart';

OpeVehiculoModel opeVehiculoModelFromJson(String str) {
  if (str.trim().isEmpty) return OpeVehiculoModel.empty();
  try {
    final dynamic decoded = json.decode(str);
    return OpeVehiculoModel.fromJson(_mapVehiculo(decoded));
  } on FormatException {
    return OpeVehiculoModel.empty();
  } catch (_) {
    return OpeVehiculoModel.empty();
  }
}

String opeVehiculoModelToJson(OpeVehiculoModel data) => json.encode(data.toJson());

Map<String, dynamic> _mapVehiculo(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  if (value is List && value.isNotEmpty) return _mapVehiculo(value.first);
  if (value is String && value.trim().isNotEmpty) {
    try {
      return _mapVehiculo(json.decode(value));
    } catch (_) {
      return <String, dynamic>{};
    }
  }
  return <String, dynamic>{};
}

String _stringVehiculo(dynamic value) => value == null ? '' : ParseModel.parseToString(value).trim();

int _intVehiculo(dynamic value) {
  if (value == null || value is bool) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString().trim()) ?? double.tryParse(value.toString().trim())?.toInt() ?? 0;
}

double _doubleVehiculo(dynamic value) {
  if (value == null || value is bool) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString().trim().replaceAll(',', '.')) ?? 0.0;
}

bool _boolVehiculo(dynamic value, {bool defaultValue = false}) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final String valor = value.toString().trim().toLowerCase();
  if (<String>{'true', '1', 'si', 'sí', 's', 'yes', 'y'}.contains(valor)) return true;
  if (<String>{'false', '0', 'no', 'n'}.contains(valor)) return false;
  return defaultValue;
}

class OpeVehiculoModel {
  int statusCode;
  String message;
  DataVehiculo dataVehiculo;

  OpeVehiculoModel({required this.statusCode, required this.message, required this.dataVehiculo});

  factory OpeVehiculoModel.fromJson(Map<String, dynamic> json) => OpeVehiculoModel(
    statusCode: _intVehiculo(json['status_code'] ?? json['statusCode']),
    message: _stringVehiculo(json['message']),
    dataVehiculo: DataVehiculo.fromJson(_mapVehiculo(json['data'] ?? json['dataVehiculo'])),
  );

  factory OpeVehiculoModel.empty() => OpeVehiculoModel(statusCode: 0, message: '', dataVehiculo: DataVehiculo.empty());

  bool get esRespuestaValida => statusCode >= 200 && statusCode < 300;

  Map<String, dynamic> toJson() => {'status_code': statusCode, 'message': message, 'data': dataVehiculo.toJson()};
}

class DataVehiculo {
  DatosVehiculo datosVehiculo;
  Datospropietario datospropietario;
  RestriccionPj restriccionPj;
  int idHdrEventoResum;
  DatosConsultaDuplicadoOperativo datosConsultaDuplicadoOperativo;

  DataVehiculo({required this.datosVehiculo, required this.datospropietario, required this.restriccionPj, required this.idHdrEventoResum, required this.datosConsultaDuplicadoOperativo});

  factory DataVehiculo.fromJson(Map<String, dynamic> json) => DataVehiculo(
    datosVehiculo: DatosVehiculo.fromJson(_mapVehiculo(json['datosVehiculo'] ?? json['datosVehiculoSiipne'])),
    datospropietario: Datospropietario.fromJson(_mapVehiculo(json['datospropietario'] ?? json['datosPropietario'])),
    restriccionPj: RestriccionPj.fromJson(_mapVehiculo(json['restriccionPJ'] ?? json['restriccionPj'])),
    idHdrEventoResum: _intVehiculo(json['idHdrEventoResum']),
    datosConsultaDuplicadoOperativo: DatosConsultaDuplicadoOperativo.fromJson(_mapVehiculo(json['datosConsultaDuplicadoOperativo'])),
  );

  factory DataVehiculo.empty() => DataVehiculo(datosVehiculo: DatosVehiculo.empty(), datospropietario: Datospropietario.empty(), restriccionPj: RestriccionPj.empty(), idHdrEventoResum: 0, datosConsultaDuplicadoOperativo: DatosConsultaDuplicadoOperativo.empty());

  bool get consultaDuplicada => datosConsultaDuplicadoOperativo.existe;

  Map<String, dynamic> toJson() => {
    'datosVehiculo': datosVehiculo.toJson(),
    'datospropietario': datospropietario.toJson(),
    'restriccionPJ': restriccionPj.toJson(),
    'idHdrEventoResum': idHdrEventoResum,
    'datosConsultaDuplicadoOperativo': datosConsultaDuplicadoOperativo.toJson(),
  };
}

class DatosVehiculo {
  bool success;
  String message;
  DatosVehiculoSiipneData data;

  DatosVehiculo({required this.success, required this.message, required this.data});

  factory DatosVehiculo.fromJson(Map<String, dynamic> json) => DatosVehiculo(
    success: _boolVehiculo(json['success']),
    message: _stringVehiculo(json['message']),
    data: DatosVehiculoSiipneData.fromJson(_mapVehiculo(json['data'])),
  );

  factory DatosVehiculo.empty() => DatosVehiculo(success: false, message: '', data: DatosVehiculoSiipneData.empty());

  Map<String, dynamic> toJson() => {'success': success, 'message': message, 'data': data.toJson()};
}

class DatosVehiculoSiipneData {
  int idGenVehiculo;
  int idGenMarca;
  String marca;
  int idGenModelo;
  String modelo;
  int idGenColor;
  String color;
  String color2;
  int idGenCombus;
  String combustible;
  String motor;
  String chasis;
  String placa;
  String placaAnterior;
  String cilindraje;
  int anoFabricacion;
  int idGenClase;
  String clase;
  int idGenTipVehi;
  String tipoVehiculo;
  int idGenServicio;
  String descServicio;
  String fuente;
  String msjSwAnt;
  double tiempoRespuesta;

  DatosVehiculoSiipneData({required this.idGenVehiculo, required this.idGenMarca, required this.marca, required this.idGenModelo, required this.modelo, required this.idGenColor, required this.color, required this.color2, required this.idGenCombus, required this.combustible, required this.motor, required this.chasis, required this.placa, required this.placaAnterior, required this.cilindraje, required this.anoFabricacion, required this.idGenClase, required this.clase, required this.idGenTipVehi, required this.tipoVehiculo, required this.idGenServicio, required this.descServicio, required this.fuente, required this.msjSwAnt, required this.tiempoRespuesta});

  factory DatosVehiculoSiipneData.fromJson(Map<String, dynamic> json) => DatosVehiculoSiipneData(
    idGenVehiculo: _intVehiculo(json['idGenVehiculo']),
    idGenMarca: _intVehiculo(json['idGenMarca']),
    marca: _stringVehiculo(json['marca']),
    idGenModelo: _intVehiculo(json['idGenModelo']),
    modelo: _stringVehiculo(json['modelo']),
    idGenColor: _intVehiculo(json['idGenColor']),
    color: _stringVehiculo(json['color']),
    color2: _stringVehiculo(json['color2']),
    idGenCombus: _intVehiculo(json['idGenCombus']),
    combustible: _stringVehiculo(json['combustible']),
    motor: _stringVehiculo(json['motor']),
    chasis: _stringVehiculo(json['chasis']),
    placa: _stringVehiculo(json['placa']),
    placaAnterior: _stringVehiculo(json['placaAnterior']),
    cilindraje: _stringVehiculo(json['cilindraje']),
    anoFabricacion: _intVehiculo(json['anoFabricacion']),
    idGenClase: _intVehiculo(json['idGenClase']),
    clase: _stringVehiculo(json['clase']),
    idGenTipVehi: _intVehiculo(json['idGenTipVehi']),
    tipoVehiculo: _stringVehiculo(json['tipoVehiculo']),
    idGenServicio: _intVehiculo(json['idGenServicio']),
    descServicio: _stringVehiculo(json['descServicio']),
    fuente: _stringVehiculo(json['fuente']),
    msjSwAnt: _stringVehiculo(json['msjSwAnt']),
    tiempoRespuesta: _doubleVehiculo(json['tiempoRespuesta']),
  );

  factory DatosVehiculoSiipneData.empty() => DatosVehiculoSiipneData(idGenVehiculo: 0, idGenMarca: 0, marca: '', idGenModelo: 0, modelo: '', idGenColor: 0, color: '', color2: '', idGenCombus: 0, combustible: '', motor: '', chasis: '', placa: '', placaAnterior: '', cilindraje: '', anoFabricacion: 0, idGenClase: 0, clase: '', idGenTipVehi: 0, tipoVehiculo: '', idGenServicio: 0, descServicio: '', fuente: '', msjSwAnt: '', tiempoRespuesta: 0.0);

  bool get tieneIdentificacion => idGenVehiculo > 0 || placa.isNotEmpty || chasis.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'idGenVehiculo': idGenVehiculo,
    'idGenMarca': idGenMarca,
    'marca': marca,
    'idGenModelo': idGenModelo,
    'modelo': modelo,
    'idGenColor': idGenColor,
    'color': color,
    'color2': color2,
    'idGenCombus': idGenCombus,
    'combustible': combustible,
    'motor': motor,
    'chasis': chasis,
    'placa': placa,
    'placaAnterior': placaAnterior,
    'cilindraje': cilindraje,
    'anoFabricacion': anoFabricacion,
    'idGenClase': idGenClase,
    'clase': clase,
    'idGenTipVehi': idGenTipVehi,
    'tipoVehiculo': tipoVehiculo,
    'idGenServicio': idGenServicio,
    'descServicio': descServicio,
    'fuente': fuente,
    'msjSwAnt': msjSwAnt,
    'tiempoRespuesta': tiempoRespuesta,
  };
}

class Datospropietario {
  bool success;
  String message;
  DatospropietarioData data;

  Datospropietario({required this.success, required this.message, required this.data});

  factory Datospropietario.fromJson(Map<String, dynamic> json) => Datospropietario(success: _boolVehiculo(json['success']), message: _stringVehiculo(json['message']), data: DatospropietarioData.fromJson(_mapVehiculo(json['data'])));

  factory Datospropietario.empty() => Datospropietario(success: false, message: '', data: DatospropietarioData.empty());

  Map<String, dynamic> toJson() => {'success': success, 'message': message, 'data': data.toJson()};
}

class DatospropietarioData {
  String propietario;
  String docPropietario;
  String fechaCaducidad;
  String institucionRenova;
  String telefono;
  String correo;
  String foto64;
  String fechaDefuncion;

  DatospropietarioData({required this.propietario, required this.docPropietario, required this.fechaCaducidad, required this.institucionRenova, required this.telefono, required this.correo, required this.foto64, required this.fechaDefuncion});

  factory DatospropietarioData.fromJson(Map<String, dynamic> json) => DatospropietarioData(
    propietario: _stringVehiculo(json['propietario']),
    docPropietario: _stringVehiculo(json['docPropietario']),
    fechaCaducidad: _stringVehiculo(json['fechaCaducidad']),
    institucionRenova: _stringVehiculo(json['institucionRenova']),
    telefono: _stringVehiculo(json['telefono']),
    correo: _stringVehiculo(json['correo']),
    foto64: _stringVehiculo(json['foto64']),
    fechaDefuncion: _stringVehiculo(json['fechaDefuncion']),
  );

  factory DatospropietarioData.empty() => DatospropietarioData(propietario: '', docPropietario: '', fechaCaducidad: '', institucionRenova: '', telefono: '', correo: '', foto64: '', fechaDefuncion: '');

  Map<String, dynamic> toJson() => {'propietario': propietario, 'docPropietario': docPropietario, 'fechaCaducidad': fechaCaducidad, 'institucionRenova': institucionRenova, 'telefono': telefono, 'correo': correo, 'foto64': foto64, 'fechaDefuncion': fechaDefuncion};
}

class RestriccionPj {
  bool success;
  String message;
  RestriccionPjData data;

  RestriccionPj({required this.success, required this.message, required this.data});

  factory RestriccionPj.fromJson(Map<String, dynamic> json) => RestriccionPj(success: _boolVehiculo(json['success']), message: _stringVehiculo(json['message']), data: RestriccionPjData.fromJson(_mapVehiculo(json['data'])));

  factory RestriccionPj.empty() => RestriccionPj(success: false, message: '', data: RestriccionPjData.empty());

  Map<String, dynamic> toJson() => {'success': success, 'message': message, 'data': data.toJson()};
}

class RestriccionPjData {
  bool robado;
  String detBusqueda;
  String empresa;
  String direccion;
  String fechaIncidente;

  RestriccionPjData({required this.robado, required this.detBusqueda, required this.fechaIncidente, required this.empresa, required this.direccion});

  factory RestriccionPjData.fromJson(Map<String, dynamic> json) => RestriccionPjData(robado: _boolVehiculo(json['robado']), detBusqueda: _stringVehiculo(json['detBusqueda']), fechaIncidente: _stringVehiculo(json['fechaIncidente']), empresa: _stringVehiculo(json['empresa']), direccion: _stringVehiculo(json['direccion']));

  factory RestriccionPjData.empty() => RestriccionPjData(robado: false, detBusqueda: '', empresa: '', direccion: '', fechaIncidente: '');

  Map<String, dynamic> toJson() => {'robado': robado, 'detBusqueda': detBusqueda, 'fechaIncidente': fechaIncidente, 'empresa': empresa, 'direccion': direccion};
}

class DatosConsultaDuplicadoOperativo {
  int idHdrEvento;
  String zona;
  String subzona;
  String distrito;
  String circuito;
  String subcircuito;
  String fecha;

  DatosConsultaDuplicadoOperativo({required this.idHdrEvento, required this.zona, required this.subzona, required this.distrito, required this.circuito, required this.subcircuito, required this.fecha});

  factory DatosConsultaDuplicadoOperativo.fromJson(Map<String, dynamic> json) => DatosConsultaDuplicadoOperativo(
    idHdrEvento: _intVehiculo(json['idHdrEvento']),
    zona: _stringVehiculo(json['zona']),
    subzona: _stringVehiculo(json['subzona']),
    distrito: _stringVehiculo(json['distrito']),
    circuito: _stringVehiculo(json['circuito']),
    subcircuito: _stringVehiculo(json['subcircuito']),
    fecha: _stringVehiculo(json['fecha']),
  );

  factory DatosConsultaDuplicadoOperativo.empty() => DatosConsultaDuplicadoOperativo(idHdrEvento: 0, zona: '', subzona: '', distrito: '', circuito: '', subcircuito: '',fecha:'');

  bool get existe => idHdrEvento > 0;

  Map<String, dynamic> toJson() => {'idHdrEvento': idHdrEvento, 'zona': zona, 'subzona': subzona, 'distrito': distrito, 'circuito': circuito, 'subcircuito': subcircuito,'fecha':fecha};
}