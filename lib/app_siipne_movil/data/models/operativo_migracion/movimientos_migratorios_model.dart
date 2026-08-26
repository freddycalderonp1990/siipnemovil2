part of '../models_siipne_movil.dart';

MovimientosMigratoriosModel movimientosMigratoriosModelFromJson(
  String source,
) => MovimientosMigratoriosModel.fromJson(
      _migracionDecodeMap(source),
    );

class MovimientosMigratoriosModel {
  final int statusCode;
  final String message;
  final DataMovimientosMigratorios data;

  const MovimientosMigratoriosModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory MovimientosMigratoriosModel.fromJson(Map<String, dynamic> json) {
    return MovimientosMigratoriosModel(
      statusCode: _migracionInt(json['status_code'] ?? json['statusCode']),
      message: _migracionString(json['message']),
      data: DataMovimientosMigratorios.fromJson(
        _migracionFirstMap(json['data']),
      ),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status_code': statusCode,
        'message': message,
        'data': data.toJson(),
      };
}

class DataMovimientosMigratorios {
  final String idCiudadano;
  final int totalMovMigratorios;
  final MovimientosMigratorios movimientosMigratorios;

  const DataMovimientosMigratorios({
    required this.idCiudadano,
    required this.totalMovMigratorios,
    required this.movimientosMigratorios,
  });

  factory DataMovimientosMigratorios.empty() {
    return const DataMovimientosMigratorios(
      idCiudadano: '',
      totalMovMigratorios: 0,
      movimientosMigratorios: MovimientosMigratorios(
        movimientoMigratorio: <MovimientoMigratorio>[],
      ),
    );
  }

  factory DataMovimientosMigratorios.fromJson(Map<String, dynamic> json) {
    final dynamic rawMovimientos =
        json['movimientosMigratorios'] ?? json['movimientoMigratorio'];
    final bool esMovimientoDirecto = rawMovimientos is Map &&
        _migracionMap(rawMovimientos).containsKey('tipoMovimiento');
    final MovimientosMigratorios movimientos =
        rawMovimientos is List || esMovimientoDirecto
        ? MovimientosMigratorios.fromItems(rawMovimientos)
        : MovimientosMigratorios.fromJson(_migracionMap(rawMovimientos));
    final int totalInformado = _migracionInt(json['totalMovMigratorios']);

    return DataMovimientosMigratorios(
      idCiudadano: _migracionString(json['idCiudadano']),
      totalMovMigratorios: totalInformado > 0
          ? totalInformado
          : movimientos.movimientoMigratorio.length,
      movimientosMigratorios: movimientos,
    );
  }

  List<MovimientoMigratorio> get movimientos =>
      movimientosMigratorios.movimientoMigratorio;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'idCiudadano': idCiudadano,
        'totalMovMigratorios': totalMovMigratorios,
        'movimientosMigratorios': movimientosMigratorios.toJson(),
      };
}

class MovimientosMigratorios {
  final List<MovimientoMigratorio> movimientoMigratorio;

  const MovimientosMigratorios({required this.movimientoMigratorio});

  factory MovimientosMigratorios.fromItems(dynamic value) {
    return MovimientosMigratorios(
      movimientoMigratorio: _migracionItems(value)
          .map((dynamic item) =>
              MovimientoMigratorio.fromJson(_migracionMap(item)))
          .toList(),
    );
  }

  factory MovimientosMigratorios.fromJson(Map<String, dynamic> json) {
    return MovimientosMigratorios.fromItems(json['movimientoMigratorio']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'movimientoMigratorio': movimientoMigratorio
            .map((MovimientoMigratorio item) => item.toJson())
            .toList(),
      };
}

class MovimientoMigratorio {
  final String fechaHoraMovimiento;
  final String tipoMovimiento;
  final String paisOrigen;
  final String paisDestino;
  final String ciudadOrigen;
  final String ciudadDestino;
  final String puertoRegistro;
  final String motivoViaje;
  final String categoriaMigratoria;
  final String nacionalidadDocumentoMovMigra;
  final String numeroDocumentoMovMigra;
  final String tipoDocumentoMovMigra;
  final String tiempoDeclarado;
  final String compania;
  final String unidadTransporte;

  const MovimientoMigratorio({
    required this.fechaHoraMovimiento,
    required this.tipoMovimiento,
    required this.paisOrigen,
    required this.paisDestino,
    required this.ciudadOrigen,
    required this.ciudadDestino,
    required this.puertoRegistro,
    required this.motivoViaje,
    required this.categoriaMigratoria,
    required this.nacionalidadDocumentoMovMigra,
    required this.numeroDocumentoMovMigra,
    required this.tipoDocumentoMovMigra,
    required this.tiempoDeclarado,
    required this.compania,
    required this.unidadTransporte,
  });

  factory MovimientoMigratorio.fromJson(Map<String, dynamic> json) {
    return MovimientoMigratorio(
      fechaHoraMovimiento: _migracionString(json['fechaHoraMovimiento']),
      tipoMovimiento: _migracionString(json['tipoMovimiento']),
      paisOrigen: _migracionString(json['paisOrigen']),
      paisDestino: _migracionString(json['paisDestino']),
      ciudadOrigen: _migracionString(json['ciudadOrigen']),
      ciudadDestino: _migracionString(json['ciudadDestino']),
      puertoRegistro: _migracionString(json['puertoRegistro']),
      motivoViaje: _migracionString(json['motivoViaje']),
      categoriaMigratoria: _migracionString(json['categoriaMigratoria']),
      nacionalidadDocumentoMovMigra:
          _migracionString(json['nacionalidadDocumentoMovMigra']),
      numeroDocumentoMovMigra:
          _migracionString(json['numeroDocumentoMovMigra']),
      tipoDocumentoMovMigra:
          _migracionString(json['tipoDocumentoMovMigra']),
      tiempoDeclarado: _migracionString(json['tiempoDeclarado']),
      compania: _migracionString(json['compania']),
      unidadTransporte: _migracionString(json['unidadTransporte']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'fechaHoraMovimiento': fechaHoraMovimiento,
        'tipoMovimiento': tipoMovimiento,
        'paisOrigen': paisOrigen,
        'paisDestino': paisDestino,
        'ciudadOrigen': ciudadOrigen,
        'ciudadDestino': ciudadDestino,
        'puertoRegistro': puertoRegistro,
        'motivoViaje': motivoViaje,
        'categoriaMigratoria': categoriaMigratoria,
        'nacionalidadDocumentoMovMigra': nacionalidadDocumentoMovMigra,
        'numeroDocumentoMovMigra': numeroDocumentoMovMigra,
        'tipoDocumentoMovMigra': tipoDocumentoMovMigra,
        'tiempoDeclarado': tiempoDeclarado,
        'compania': compania,
        'unidadTransporte': unidadTransporte,
      };
}
