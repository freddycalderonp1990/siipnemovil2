part of '../models_siipne_movil.dart';

VisasElectronicasModel visasElectronicasModelFromJson(String source) =>
    VisasElectronicasModel.fromJson(_migracionDecodeMap(source));

class VisasElectronicasModel {
  final int statusCode;
  final String message;
  final DataVisasElectronicas data;

  const VisasElectronicasModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory VisasElectronicasModel.fromJson(Map<String, dynamic> json) {
    return VisasElectronicasModel(
      statusCode: _migracionInt(json['status_code'] ?? json['statusCode']),
      message: _migracionString(json['message']),
      data: DataVisasElectronicas.fromDynamic(json['data']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status_code': statusCode,
        'message': message,
        'data': data.toJson(),
      };
}

class DataVisasElectronicas {
  final String mensaje;
  final List<VisaElectronicaMigracion> datosVisa;

  const DataVisasElectronicas({
    required this.mensaje,
    required this.datosVisa,
  });

  factory DataVisasElectronicas.empty() {
    return const DataVisasElectronicas(
      mensaje: '',
      datosVisa: <VisaElectronicaMigracion>[],
    );
  }

  factory DataVisasElectronicas.fromDynamic(dynamic value) {
    if (value is List) {
      return DataVisasElectronicas(
        mensaje: value.isEmpty ? '' : 'Datos encontrados',
        datosVisa: _migracionItems(value)
            .map((dynamic item) =>
                VisaElectronicaMigracion.fromJson(_migracionMap(item)))
            .toList(),
      );
    }
    return DataVisasElectronicas.fromJson(_migracionMap(value));
  }

  factory DataVisasElectronicas.fromJson(Map<String, dynamic> json) {
    final dynamic rawVisas = json.containsKey('datosVisa')
        ? json['datosVisa']
        : json.containsKey('numeroVisa')
            ? json
            : null;
    return DataVisasElectronicas(
      mensaje: _migracionString(json['mensaje']),
      datosVisa: _migracionItems(rawVisas)
          .map((dynamic item) =>
              VisaElectronicaMigracion.fromJson(_migracionMap(item)))
          .toList(),
    );
  }

  bool get tieneDatos => datosVisa.isNotEmpty;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'mensaje': mensaje,
        'datosVisa': datosVisa
            .map((VisaElectronicaMigracion item) => item.toJson())
            .toList(),
      };
}

class VisaElectronicaMigracion {
  final String actividad;
  final String fotoVisa;
  final String numeroPasaporte;
  final String numeroVisa;
  final String fechaEmision;
  final String fechaCaducidad;
  final String fotoVisa2;

  const VisaElectronicaMigracion({
    required this.actividad,
    required this.fotoVisa,
    required this.numeroPasaporte,
    required this.numeroVisa,
    required this.fechaEmision,
    required this.fechaCaducidad,
    required this.fotoVisa2,
  });

  factory VisaElectronicaMigracion.fromJson(Map<String, dynamic> json) {
    return VisaElectronicaMigracion(
      actividad: _migracionString(json['actividad']),
      fotoVisa: _migracionBase64(json['fotoVisa']),
      numeroPasaporte: _migracionString(json['numeroPasaporte']),
      numeroVisa: _migracionString(json['numeroVisa']),
      fechaEmision:
          _migracionString(json['fechaeEmision'] ?? json['fechaEmision']),
      fechaCaducidad: _migracionString(json['fechaCaducidad']),
      fotoVisa2: _migracionBase64(json['fotoVisa2']),
    );
  }

  String get fotoPrincipal => fotoVisa.isNotEmpty ? fotoVisa : fotoVisa2;

  bool get tieneFoto => fotoPrincipal.isNotEmpty;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'actividad': actividad,
        'fotoVisa': fotoVisa,
        'numeroPasaporte': numeroPasaporte,
        'numeroVisa': numeroVisa,
        'fechaeEmision': fechaEmision,
        'fechaCaducidad': fechaCaducidad,
        'fotoVisa2': fotoVisa2,
      };



}
