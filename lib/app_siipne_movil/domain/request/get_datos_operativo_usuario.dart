part of 'request_siipne_movil.dart';
class GetDatosOperativoUsuarioRequest {
  final int idGenUsuario;
  final String fechaInicio;
  final String fechaFin;

  GetDatosOperativoUsuarioRequest({required this.idGenUsuario,required this.fechaInicio, required this.fechaFin });
  Map<String, dynamic> toJson() {
    return {
      "idGenUsuario":idGenUsuario,
      "fechaInicio":fechaInicio,
      "fechaFin": fechaFin
    };
  }
}
