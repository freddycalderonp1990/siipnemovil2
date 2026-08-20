part of 'request_siipne_movil.dart';

class InsertAcuerdoSiipneRequest {
  final int idGenPersona;
  final String pathDocumento;
  final String ip;

  InsertAcuerdoSiipneRequest({
    required this.idGenPersona,
    required this.pathDocumento,
    required this.ip,
  });

  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "idGenPersona": idGenPersona,
      "pathDocumento": pathDocumento,
      "ip": ip,
    };
  }
}