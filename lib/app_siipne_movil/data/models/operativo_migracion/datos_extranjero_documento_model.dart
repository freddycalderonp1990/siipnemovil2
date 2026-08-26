part of '../models_siipne_movil.dart';

DatosExtranjeroDocumentoModel datosExtranjeroDocumentoModelFromJson(
  String source,
) => DatosExtranjeroDocumentoModel.fromJson(
      _migracionDecodeMap(source),
    );

class DatosExtranjeroDocumentoModel {
  final int statusCode;
  final String message;
  final List<DataExtranjeroDocumento> data;

  const DatosExtranjeroDocumentoModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DatosExtranjeroDocumentoModel.fromJson(Map<String, dynamic> json) {
    return DatosExtranjeroDocumentoModel(
      statusCode: _migracionInt(json['status_code'] ?? json['statusCode']),
      message: _migracionString(json['message']),
      data: _migracionItems(json['data'])
          .map((dynamic item) =>
              DataExtranjeroDocumento.fromJson(_migracionMap(item)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status_code': statusCode,
        'message': message,
        'data': data.map((DataExtranjeroDocumento item) => item.toJson()).toList(),
      };
}

class DataExtranjeroDocumento {
  final String idCiudadano;
  final List<DatosBiograficosMigracion> datosBiograficos;
  final List<DocumentoExtranjeroMigracion> documentos;

  const DataExtranjeroDocumento({
    required this.idCiudadano,
    required this.datosBiograficos,
    required this.documentos,
  });

  factory DataExtranjeroDocumento.empty() {
    return const DataExtranjeroDocumento(
      idCiudadano: '',
      datosBiograficos: <DatosBiograficosMigracion>[],
      documentos: <DocumentoExtranjeroMigracion>[],
    );
  }

  factory DataExtranjeroDocumento.fromJson(Map<String, dynamic> json) {
    return DataExtranjeroDocumento(
      idCiudadano: _migracionString(json['idCiudadano']),
      datosBiograficos: _migracionItems(json['datosBiograficos'])
          .map((dynamic item) =>
              DatosBiograficosMigracion.fromJson(_migracionMap(item)))
          .toList(),
      documentos: _migracionItems(json['documentos'])
          .map((dynamic item) =>
              DocumentoExtranjeroMigracion.fromJson(_migracionMap(item)))
          .toList(),
    );
  }

  DatosBiograficosMigracion? get datosBiograficosPrincipal =>
      datosBiograficos.isEmpty ? null : datosBiograficos.first;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'idCiudadano': idCiudadano,
        'datosBiograficos': datosBiograficos
            .map((DatosBiograficosMigracion item) => item.toJson())
            .toList(),
        'documentos': documentos
            .map((DocumentoExtranjeroMigracion item) => item.toJson())
            .toList(),
      };
}

class DatosBiograficosMigracion {
  final String nombres;
  final String apellidos;
  final String nombresCompletos;
  final String fechaNacimiento;
  final String paisNacimiento;
  final String paisResidencia;
  final String genero;
  final String estadoCivil;
  final String profesion;

  const DatosBiograficosMigracion({
    required this.nombres,
    required this.apellidos,
    required this.nombresCompletos,
    required this.fechaNacimiento,
    required this.paisNacimiento,
    required this.paisResidencia,
    required this.genero,
    required this.estadoCivil,
    required this.profesion,
  });

  factory DatosBiograficosMigracion.fromJson(Map<String, dynamic> json) {
    return DatosBiograficosMigracion(
      nombres: _migracionString(json['nombres']),
      apellidos: _migracionString(json['apellidos']),
      nombresCompletos: _migracionString(json['nombresCompletos']),
      fechaNacimiento: _migracionString(json['fechaNacimiento']),
      paisNacimiento: _migracionString(json['paisNacimiento']),
      paisResidencia: _migracionString(json['paisResidencia']),
      genero: _migracionString(json['genero']),
      estadoCivil: _migracionString(json['estadoCivil']),
      profesion: _migracionString(json['profesion']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'nombres': nombres,
        'apellidos': apellidos,
        'nombresCompletos': nombresCompletos,
        'fechaNacimiento': fechaNacimiento,
        'paisNacimiento': paisNacimiento,
        'paisResidencia': paisResidencia,
        'genero': genero,
        'estadoCivil': estadoCivil,
        'profesion': profesion,
      };
}

class DocumentoExtranjeroMigracion {
  final String tipoDocumento;
  final String numeroDocumento;
  final String nacionalidadDocumento;
  final String sistema;

  const DocumentoExtranjeroMigracion({
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.nacionalidadDocumento,
    required this.sistema,
  });

  factory DocumentoExtranjeroMigracion.fromJson(Map<String, dynamic> json) {
    return DocumentoExtranjeroMigracion(
      tipoDocumento: _migracionString(json['tipoDocumento']),
      numeroDocumento: _migracionString(json['numeroDocumento']),
      nacionalidadDocumento:
          _migracionString(json['nacionalidadDocumento']),
      sistema: _migracionString(json['sistema']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'tipoDocumento': tipoDocumento,
        'numeroDocumento': numeroDocumento,
        'nacionalidadDocumento': nacionalidadDocumento,
        'sistema': sistema,
      };
}
