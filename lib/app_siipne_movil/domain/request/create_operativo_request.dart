part of 'request_siipne_movil.dart';

class CreateOperativoRequest {
  final double latitud;
  final double longitud;
  final int dataModuloIdGenTipoTipificacionEcu;
  final int dataModuloIdTipoServicio;
  final int idTipoOperativo;

  final String ip;
  final int idGenPersona;
  final int idGenUsuario;
  final String realiza;

  CreateOperativoRequest({
    required this.latitud,
    required this.longitud,
    required this.dataModuloIdGenTipoTipificacionEcu,
    required this.idTipoOperativo,
    required this.dataModuloIdTipoServicio,
    required this.ip,
    required this.idGenPersona,
    required this.idGenUsuario,
    required this.realiza,
  });

  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "latitud": latitud,
      "longitud": longitud,
      "idGenTipoTipificacionEcu": dataModuloIdGenTipoTipificacionEcu,
      "idTipoServicio": dataModuloIdTipoServicio,
      "idTipoOperativo": idTipoOperativo,

      "ip": ip,
      "idGenPersona": idGenPersona,
      "idGenUsuario": idGenUsuario,
      "realiza": realiza,
    };
  }
}