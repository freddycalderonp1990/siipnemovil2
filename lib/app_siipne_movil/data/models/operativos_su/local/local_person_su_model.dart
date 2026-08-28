part of '../../models_siipne_movil.dart';

class LocalPersonSuModel {
  final String documento;
  final String nombres;
  final String sexo;
  final String? pais;
  final String fechaNcaimiento;
  final String edad;
  final String? domicilio;
  final String? estadoCivil;
  final String? madre;
  final String? padre;
  final String? conyugue;
  final String? fechaDefuncion;
  final String? foto;

  LocalPersonSuModel({
    required this.documento,
    required this.nombres,
    required this.sexo,
    required this.fechaNcaimiento,
    required this.edad,
    this.pais,
    this.domicilio,
    this.estadoCivil,
    this.madre,
    this.padre,
    this.conyugue,
    this.fechaDefuncion,
    this.foto,
  });
}
