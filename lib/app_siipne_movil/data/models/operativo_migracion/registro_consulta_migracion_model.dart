part of '../models_siipne_movil.dart';

RegistroConsultaMigracionModel registroConsultaMigracionModelFromJson(
  String source,
) => RegistroConsultaMigracionModel.fromJson(
      _migracionDecodeMap(source),
    );

class RegistroConsultaMigracionModel {
  final int statusCode;
  final String message;
  final DataRegistroConsultaMigracion data;

  const RegistroConsultaMigracionModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory RegistroConsultaMigracionModel.fromJson(Map<String, dynamic> json) {
    return RegistroConsultaMigracionModel(
      statusCode: _migracionInt(json['status_code'] ?? json['statusCode']),
      message: _migracionString(json['message']),
      data: DataRegistroConsultaMigracion.fromJson(
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

class DataRegistroConsultaMigracion {
  final int idGenPersona;
  final int idHdrEventoResum;
  final String documento;
  final String nombres;
  final String idCiudadano;
  final String nacionalidad;
  final List<dynamic> foto;

  const DataRegistroConsultaMigracion({
    required this.idGenPersona,
    required this.idHdrEventoResum,
    required this.documento,
    required this.nombres,
    required this.idCiudadano,
    required this.nacionalidad,
    required this.foto,
  });

  factory DataRegistroConsultaMigracion.empty() {
    return const DataRegistroConsultaMigracion(
      idGenPersona: 0,
      idHdrEventoResum: 0,
      documento: '',
      nombres: '',
      idCiudadano: '',
      nacionalidad: '',
      foto: <dynamic>[],
    );
  }

  factory DataRegistroConsultaMigracion.fromJson(Map<String, dynamic> json) {
    return DataRegistroConsultaMigracion(
      idGenPersona: _migracionInt(json['idGenPersona']),
      idHdrEventoResum: _migracionInt(json['idHdrEventoResum']),
      documento: _migracionString(json['documento']),
      nombres: _migracionString(json['nombres']),
      idCiudadano: _migracionString(json['idCiudadano']),
      nacionalidad: _migracionString(json['nacionalidad']),
      foto: List<dynamic>.from(_migracionItems(json['foto'])),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'idGenPersona': idGenPersona,
        'idHdrEventoResum': idHdrEventoResum,
        'documento': documento,
        'nombres': nombres,
        'idCiudadano': idCiudadano,
        'nacionalidad': nacionalidad,
        'foto': foto,
      };
}
