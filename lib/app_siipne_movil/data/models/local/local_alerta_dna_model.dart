part of '../models.dart';

class LocalAlertaDnaModel {
  final String descripcion;

  final String fechaParte;

  final String documento;

  final String? foto;

  LocalAlertaDnaModel(
      {required this.descripcion,
      required this.fechaParte,
      required this.documento,
      this.foto});
}
