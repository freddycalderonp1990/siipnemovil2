part of 'request_siipne_movil.dart';

class RegistroConsultaMigracionRequest {
  final String documento;
  final String nombres;
  final String fechaNacimiento;
  final String idCiudadano;
  final String nacionalidad;
  final String sexo;
  final String estadoCivil;
  final String profesion;
  final int idOperativo;
  final int idGenUsuario;
  final int idGenPersonaUsuario;
  final String latitud;
  final String longitud;
  final String ip;
  final int idVariableResultado;
  final String detalle;

  const RegistroConsultaMigracionRequest({
    required this.documento,
    required this.nombres,
    required this.fechaNacimiento,
    required this.idCiudadano,
    required this.nacionalidad,
    required this.sexo,
    required this.estadoCivil,
    required this.profesion,
    required this.idOperativo,
    required this.idGenUsuario,
    required this.idGenPersonaUsuario,
    required this.latitud,
    required this.longitud,
    required this.ip,
    required this.idVariableResultado,
    this.detalle = '',
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'documento': documento.trim(),
        'nombres': nombres.trim(),
        'fechaNacimiento': fechaNacimiento.trim(),
        'idCiudadano': idCiudadano.trim(),
        'nacionalidad': nacionalidad.trim(),
        'sexo': sexo.trim(),
        'estadoCivil': estadoCivil.trim(),
        'profesion': profesion.trim(),
        'idOperativo': idOperativo,
        'idGenUsuario': idGenUsuario,
        'idGenPersonaUsuario': idGenPersonaUsuario,
        'latitud': latitud.trim(),
        'longitud': longitud.trim(),
        'ip': ip.trim(),
        'idVariableResultado': idVariableResultado,
        'detalle': detalle.trim(),
      };
}
