part of 'request_siipne_movil.dart';

class ActualizarResultadoRequest {
  final int idHdrEventoResum;
  final int idHdrTipoResum;

  ActualizarResultadoRequest({
    required this.idHdrEventoResum,
    required this.idHdrTipoResum,
  });

  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "idHdrEventoResum": idHdrEventoResum,
      "idHdrTipoResum":idHdrTipoResum

    };
  }
}