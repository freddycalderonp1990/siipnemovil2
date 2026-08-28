part of 'request_siipne_movil.dart';

class GetMovimientosMigratoriosRequest {
  final String idCiudadano;
  final int idGenPersonaUsuario;

  const GetMovimientosMigratoriosRequest({
    required this.idCiudadano,
    required this.idGenPersonaUsuario,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'idCiudadano': idCiudadano.trim(),
        'idGenPersonaUsuario': idGenPersonaUsuario,
      };
}
