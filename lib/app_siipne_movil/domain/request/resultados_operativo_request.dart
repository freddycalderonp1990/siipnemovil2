part of 'request_siipne_movil.dart';

class ResultadosOperativoRequest {
  final int idHdrEvento;

  ResultadosOperativoRequest({required this.idHdrEvento});

  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {"idHdrEvento": idHdrEvento};
  }
}
