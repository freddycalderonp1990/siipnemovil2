part of 'request_siipne_movil.dart';

class GetDatosPoliciasOperativoRequest {
  final int idHdrEvento;

  GetDatosPoliciasOperativoRequest({required this.idHdrEvento});

  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {"idHdrEvento": idHdrEvento};
  }
}
