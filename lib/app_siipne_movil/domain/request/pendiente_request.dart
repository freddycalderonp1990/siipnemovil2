part of 'request_siipne_movil.dart';

class GetOperativosPendientesRequest {
  final int idGenPersona;
  final int idGenUsuario;

  GetOperativosPendientesRequest({
    required this.idGenPersona,
    required this.idGenUsuario,
  });

  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "idGenPersona": idGenPersona,
      "idGenUsuario": idGenUsuario,
    };
  }
}