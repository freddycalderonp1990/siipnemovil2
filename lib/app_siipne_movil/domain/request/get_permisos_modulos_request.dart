part of 'request_siipne_movil.dart';
class GetPermisosModulosRequest {
  final int idGenPersona;
  final int idGenUsuario;


  GetPermisosModulosRequest({required this.idGenPersona, required this.idGenUsuario, });


  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "idGenPersona":idGenPersona,
      "idGenUsuario":idGenUsuario,
      "showAll": true
    };


  }
}
