part of '../../domain_repositories.dart';

abstract class NovedadesRepository {
  Future<NovedadesModel> consultarNovedades({required int idDgoTipoEje});

  Future<NovedadesModel> consultarNovedadesHijas({required int idNovedadesPadre,required int idDgoTipoEje});

  Future<bool> registrarNovedadesRecintoElectoral({required NovedadesCreateRequest novedadesCreateRequest});



}