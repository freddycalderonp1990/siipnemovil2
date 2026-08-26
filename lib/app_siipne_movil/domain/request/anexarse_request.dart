part of 'request_siipne_movil.dart';

class GetDatosAnexarseOperativoRequest {
  final int idHdrEvento;

  GetDatosAnexarseOperativoRequest({required this.idHdrEvento});

  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {"idHdrEvento": idHdrEvento};
  }
}
