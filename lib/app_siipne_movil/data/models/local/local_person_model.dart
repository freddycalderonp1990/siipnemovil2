part of '../models.dart';

class LocalPersonModel {
  final String nombres;
  final String sexo;
  final String fechaNcaimiento;
  final String edad;
  final String? domicilio;
  final String? estadoCivil;
  final String? madre;
  final String? padre;
  final String? conyugue;
  final String? foto;

  LocalPersonModel(
      {required this.nombres,
      required this.sexo,
      required this.fechaNcaimiento,
      required this.edad,
      this.domicilio,
      this.estadoCivil,
      this.madre,
      this.padre,
      this.conyugue,
      this.foto});
}
