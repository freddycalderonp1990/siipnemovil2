part of 'request_siipne_movil.dart';

class ConsultarPersonaRequest {
  final int idOperativo;
  final String documento;
  final double latitud;
  final double longitud;
  final String ip;
  final int idGenUsuario;
  final int idVariableResultado;
  final int hdrIdHdrResum;
  final String tipoRelacion;

  ConsultarPersonaRequest({
    required this.idOperativo,
    required this.documento,
    required this.latitud,
    required this.longitud,
    required this.ip,
    required this.idGenUsuario,
    required this.idVariableResultado,
    this.hdrIdHdrResum = 0,
    this.tipoRelacion = '',
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "idOperativo": idOperativo,
      "documento": documento,
      "latitud": latitud,
      "longitud": longitud,
      "ip": ip,
      "idGenUsuario": idGenUsuario,
      "idVariableResultado": idVariableResultado,
    };

    if (hdrIdHdrResum > 0) {
      data["hdr_idHdrEventoResum"] = hdrIdHdrResum;
    }

    if (tipoRelacion.trim().isNotEmpty) {
      data["tipoRelacion"] = tipoRelacion.trim().toUpperCase();
    }

    return data;
  }
}
