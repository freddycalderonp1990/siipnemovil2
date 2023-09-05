part of 'elecciones_request.dart';

class OperativoCreateRequest {
  final int idGenUsuario;
  final int idGenPersona;
  final int idDgoReciElect;
  final String ip;
  final String latitud;
  final String longitud;
  final int idDgoProcElec;
  final int idDgoReciUnidadPolicial;
  final String telefono;

  OperativoCreateRequest(
      {
       required this.idGenUsuario,
     required this.idGenPersona,
        required this.idDgoReciElect,
        required this.ip,
        required this.latitud,
        required this.longitud,
        required  this.idDgoProcElec,
        required  this.idDgoReciUnidadPolicial,
        required  this.telefono});
}
