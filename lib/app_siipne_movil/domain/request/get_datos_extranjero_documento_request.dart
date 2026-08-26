part of 'request_siipne_movil.dart';

class GetDatosExtranjeroDocumentoRequest {
  final String documento;
  final String nacionalidad;
  final int idGenPersonaUsuario;

  const GetDatosExtranjeroDocumentoRequest({
    required this.documento,
    required this.nacionalidad,
    required this.idGenPersonaUsuario,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'documento': documento.trim(),
        'nacionalidad': nacionalidad.trim().toUpperCase(),
        'idGenPersonaUsuario': idGenPersonaUsuario,
      };
}
