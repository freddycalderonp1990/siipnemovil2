part of 'request_siipne_movil.dart';

class ConsultarVehiculoRequest {
  final int idOperativo;
  final String placa;
  final double latitud;
  final double longitud;
  final String ip;
  final int idGenUsuario;
  final int idVariableResultado;
  final String userName;

  ConsultarVehiculoRequest({
    required this.idOperativo,
    required this.placa,
    required this.latitud,
    required this.longitud,
    required this.ip,
    required this.idGenUsuario,
    required this.idVariableResultado,
    required this.userName
  });

  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "idOperativo": idOperativo,
      "placa": placa,
      "latitud": latitud,
      "longitud": longitud,
      "ip": ip,
      "idGenUsuario": idGenUsuario,
      "idVariableResultado": idVariableResultado,
      "userName":userName
    };
  }
}
