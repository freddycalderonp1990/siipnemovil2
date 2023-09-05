part of 'elecciones_request.dart';

class AddPersonalRequest {
  final int idGenUsuario;
  final int idDgoCreaOpReci;
  final String ip;
  final int idDgoPerAsigOpe;
  final int idDgoReciElect;
  final int idGenPersona;
  final int idRecintoUnidadPolicial;
  final int idDgoTipoEje;
  final String latitud;
  final String longitud;

  AddPersonalRequest({
    required this.idGenUsuario,
    required this.idDgoCreaOpReci,
    required this.ip,
    required this.idDgoPerAsigOpe,
    required this.idDgoTipoEje,
    required this.idDgoReciElect,
    required this.idGenPersona,
    required this.idRecintoUnidadPolicial,
    required this.latitud,
    required this.longitud,
  });
}
