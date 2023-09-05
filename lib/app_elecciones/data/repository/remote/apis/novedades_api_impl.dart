part of '../../data_repositories.dart';

class NovedadesApiImpl extends NovedadesRepository {
  final NovedadesApiProviderImpl _novedadesApiProviderImpl =
  Get.find();

  @override
  Future<NovedadesModel> consultarNovedades({required int idDgoTipoEje}) async {
    try {
      return _novedadesApiProviderImpl
          .consultarNovedades(idDgoTipoEje: idDgoTipoEje);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<NovedadesModel> consultarNovedadesHijas({required int idNovedadesPadre, required int idDgoTipoEje})async {
    try {
      return _novedadesApiProviderImpl
          .consultarNovedadesHijas(idNovedadesPadre: idNovedadesPadre, idDgoTipoEje: idDgoTipoEje);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<bool> registrarNovedadesRecintoElectoral({required NovedadesCreateRequest novedadesCreateRequest}) async {
    try {
      return _novedadesApiProviderImpl
          .registrarNovedadesRecintoElectoral(novedadesCreateRequest: novedadesCreateRequest);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }
}