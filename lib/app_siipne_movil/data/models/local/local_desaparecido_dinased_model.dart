part of '../models.dart';

class LocalDesaparecidoDinasedModel {
  final String documento;
  final String nombres;
  final String edad;
  final String descripcion;
  final String lugarDesaparicion;
  final String unidadComunica;
  final String fechaAlerta;
  final String fotoDesaparecido;

  final String? foto;

  LocalDesaparecidoDinasedModel({required this.documento,
    required this.nombres,
    required this.edad,
    required this.lugarDesaparicion,
    required this.unidadComunica,
    required this.fotoDesaparecido,
    required this.descripcion,
    required this.fechaAlerta,
    this.foto});

  factory LocalDesaparecidoDinasedModel.empty()=>
      LocalDesaparecidoDinasedModel(documento: "",
          nombres: "",
          edad: "",
          lugarDesaparicion: "",
          unidadComunica: "",
          fotoDesaparecido: "",
          descripcion: "",
          fechaAlerta: "");


}
