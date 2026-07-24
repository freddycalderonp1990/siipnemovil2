part of 'request_siipne_movil.dart';
class GetPermisosModulosRequest {
  final int idGenPersona;
  final int idGenUsuario;
  final bool showAll;

  GetPermisosModulosRequest({required this.idGenPersona, required this.idGenUsuario, required this.showAll});


  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "idGenPersona":idGenPersona,
      "idGenUsuario":idGenUsuario,
      "showAll": showAll
    };


  }
}
