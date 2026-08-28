part of '../models_siipne_movil.dart';

VisaExtranjeroModel visaExtranjeroModelFromJson(String source) =>
    VisaExtranjeroModel.fromJson(_migracionDecodeMap(source));

class VisaExtranjeroModel {
  final int statusCode;
  final String message;
  final DataVisaExtranjero data;

  const VisaExtranjeroModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory VisaExtranjeroModel.fromJson(Map<String, dynamic> json) {
    return VisaExtranjeroModel(
      statusCode: _migracionInt(json['status_code'] ?? json['statusCode']),
      message: _migracionString(json['message']),
      data: DataVisaExtranjero.fromJson(_migracionFirstMap(json['data'])),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status_code': statusCode,
        'message': message,
        'data': data.toJson(),
      };
}

class DataVisaExtranjero {
  final String idCiudadano;
  final String tieneVisas;
  final VisasSimiecMigracion visasSimiec;

  const DataVisaExtranjero({
    required this.idCiudadano,
    required this.tieneVisas,
    required this.visasSimiec,
  });

  factory DataVisaExtranjero.empty() {
    return const DataVisaExtranjero(
      idCiudadano: '',
      tieneVisas: 'NO',
      visasSimiec: VisasSimiecMigracion(
        visas: <VisaSimiecMigracion>[],
      ),
    );
  }

  factory DataVisaExtranjero.fromJson(Map<String, dynamic> json) {
    final dynamic rawVisas = json['visasSIMIEC'] ??
        json['visasSimiec'] ??
        json['visaSIMIEC'];
    final bool esVisaDirecta = rawVisas is Map &&
        _migracionMap(rawVisas).containsKey('numeroVisa');
    final VisasSimiecMigracion visas = rawVisas is List || esVisaDirecta
        ? VisasSimiecMigracion.fromItems(rawVisas)
        : VisasSimiecMigracion.fromJson(_migracionMap(rawVisas));
    final String indicador = _migracionString(json['tieneVisas']);

    return DataVisaExtranjero(
      idCiudadano: _migracionString(json['idCiudadano']),
      tieneVisas: indicador.isNotEmpty
          ? indicador
          : visas.visas.isEmpty
              ? 'NO'
              : 'SI',
      visasSimiec: visas,
    );
  }

  bool get poseeVisas => tieneVisas.toUpperCase() == 'SI';

  Map<String, dynamic> toJson() => <String, dynamic>{
        'idCiudadano': idCiudadano,
        'tieneVisas': tieneVisas,
        'visasSIMIEC': visasSimiec.toJson(),
      };
}

class VisasSimiecMigracion {
  final List<VisaSimiecMigracion> visas;

  const VisasSimiecMigracion({required this.visas});

  factory VisasSimiecMigracion.fromItems(dynamic value) {
    return VisasSimiecMigracion(
      visas: _migracionItems(value)
          .map((dynamic item) =>
              VisaSimiecMigracion.fromJson(_migracionMap(item)))
          .toList(),
    );
  }

  factory VisasSimiecMigracion.fromJson(Map<String, dynamic> json) {
    return VisasSimiecMigracion.fromItems(json['visaSIMIEC']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'visaSIMIEC':
            visas.map((VisaSimiecMigracion item) => item.toJson()).toList(),
      };
}

class VisaSimiecMigracion {
  final String lugarExpedicion;
  final String validaDesde;
  final String validaHasta;
  final String numeroEntradas;
  final String numeroVisa;
  final String tipo;
  final String actividad;
  final String tipoDocumento;
  final String numeroDocumento;
  final String estado;
  final String motivo;
  final String vigencia;

  const VisaSimiecMigracion({
    required this.lugarExpedicion,
    required this.validaDesde,
    required this.validaHasta,
    required this.numeroEntradas,
    required this.numeroVisa,
    required this.tipo,
    required this.actividad,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.estado,
    required this.motivo,
    required this.vigencia,
  });

  factory VisaSimiecMigracion.fromJson(Map<String, dynamic> json) {
    return VisaSimiecMigracion(
      lugarExpedicion: _migracionString(json['lugarExpedicion']),
      validaDesde: _migracionString(json['validaDesde']),
      validaHasta: _migracionString(json['validaHasta']),
      numeroEntradas: _migracionString(json['numeroEntradas']),
      numeroVisa: _migracionString(json['numeroVisa']),
      tipo: _migracionString(json['tipo']),
      actividad: _migracionString(json['actividad']),
      tipoDocumento: _migracionString(json['tipoDocumento']),
      numeroDocumento: _migracionString(json['numeroDocumento']),
      estado: _migracionString(json['estado']),
      motivo: _migracionString(json['motivo']),
      vigencia: _migracionString(json['vigencia']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'lugarExpedicion': lugarExpedicion,
        'validaDesde': validaDesde,
        'validaHasta': validaHasta,
        'numeroEntradas': numeroEntradas,
        'numeroVisa': numeroVisa,
        'tipo': tipo,
        'actividad': actividad,
        'tipoDocumento': tipoDocumento,
        'numeroDocumento': numeroDocumento,
        'estado': estado,
        'motivo': motivo,
        'vigencia': vigencia,
      };
}
