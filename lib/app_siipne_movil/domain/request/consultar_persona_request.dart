part of 'request_siipne_movil.dart';

class ConsultarPersonaRequest {
  final int idOperativo;
  final String documento;
  final double latitud;
  final double longitud;
  final String ip;
  final int idGenUsuario;
  final int idVariableResultado;

  ConsultarPersonaRequest({
    required this.idOperativo,
    required this.documento,
    required this.latitud,
    required this.longitud,
    required this.ip,
    required this.idGenUsuario,
    required this.idVariableResultado,
  });

  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "idOperativo": idOperativo,
      "documento": documento,
      "latitud": latitud,
      "longitud": longitud,
      "ip": ip,
      "idGenUsuario": idGenUsuario,
      "idVariableResultado": idVariableResultado,
    };
  }
}