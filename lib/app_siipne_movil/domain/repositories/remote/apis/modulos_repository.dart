

part of '../../domain_repositories.dart';

abstract class ModulosRepository {
  //Se define que cosas quiero hacer
  //se definen los contartos

  Future<List<Modulo>> getModulos({required int idGenUsuario,required int idGenPersona});

}