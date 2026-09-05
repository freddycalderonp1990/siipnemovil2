part of 'request_siipne_movil.dart';

class GetDatosOperativoUsuarioRequest {
  final int idGenPersona;
  final String fechaInicio;
  final String fechaFin;

  GetDatosOperativoUsuarioRequest({
    required this.idGenPersona,
    required this.fechaInicio,
    required this.fechaFin,
  });
  Map<String, dynamic> toJson() {
    return {
      "idGenPersona": idGenPersona,
      "fechaInicio": fechaInicio,
      "fechaFin": fechaFin,
    };
  }
}
