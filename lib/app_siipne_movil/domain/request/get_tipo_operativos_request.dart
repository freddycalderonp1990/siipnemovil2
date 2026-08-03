part of 'request_siipne_movil.dart';
class GetTipoOperativosRequest {
  final int idGenModulo;


  GetTipoOperativosRequest({required this.idGenModulo,});


  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "idGenModulo":idGenModulo,
    };


  }
}
