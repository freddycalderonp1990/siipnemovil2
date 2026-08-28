part of 'request_siipne_movil.dart';

class GetVisasElectronicasRequest {
  final String apellidos;
  final String nombres;
  final String fechaNacimiento;
  final String nacionalidad;

  const GetVisasElectronicasRequest({
    required this.apellidos,
    required this.nombres,
    required this.fechaNacimiento,
    required this.nacionalidad,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'apellidos': apellidos.trim(),
        'nombres': nombres.trim(),
        'fechaNacimiento': fechaNacimiento.trim(),
        'nacionalidad': nacionalidad.trim().toUpperCase(),
      };
}
