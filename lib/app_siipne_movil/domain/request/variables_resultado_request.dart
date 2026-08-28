part of 'request_siipne_movil.dart';

class GetVariablesResultadosRequest {
  final int idOperativo;

  GetVariablesResultadosRequest({required this.idOperativo});

  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {"idOperativo": idOperativo};
  }
}
