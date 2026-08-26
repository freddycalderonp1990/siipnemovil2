part of 'request_siipne_movil.dart';

class GetVisaExtranjeroRequest {
  final String idCiudadano;
  final int idGenPersonaUsuario;

  const GetVisaExtranjeroRequest({
    required this.idCiudadano,
    required this.idGenPersonaUsuario,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'idCiudadano': idCiudadano.trim(),
        'idGenPersonaUsuario': idGenPersonaUsuario,
      };
}
