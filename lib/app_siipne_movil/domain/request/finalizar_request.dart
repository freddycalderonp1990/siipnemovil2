part of 'request_siipne_movil.dart';

class FinalizarOperativoRequest {
  final int idHdrEvento;

  FinalizarOperativoRequest({
    required this.idHdrEvento,
  });

  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "idHdrEvento": idHdrEvento,
    };
  }
}