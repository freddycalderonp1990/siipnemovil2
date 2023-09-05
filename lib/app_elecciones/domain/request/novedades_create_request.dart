
part of 'elecciones_request.dart';
class NovedadesCreateRequest {
  final int idGenUsuario;
  final int idDgoPerAsigOpe;
  final int idDgoNovedadesElect;
  final int idDgoProcElec;
  final String ip;
  final String latitud;
  final String longitud;
  final String? nameImg;
  final File? image;
  final String observacion;
  final String? documento;

  NovedadesCreateRequest({
    required this.idGenUsuario,
    required this.ip,
    required this.latitud,
    required this.longitud,
    required this.idDgoProcElec,
    required this.idDgoPerAsigOpe,
    required this.idDgoNovedadesElect,
    this.nameImg,
    this.image,
    required this.observacion,
    this.documento,
  });
}
