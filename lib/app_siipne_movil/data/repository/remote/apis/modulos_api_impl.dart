part of '../../data_repositories.dart';

class ModulosApiImpl extends ModulosRepository {

  final ModulosApiProviderImpl _modulosApiProviderImpl = Get.find();

  @override
  Future<List<Modulo>> getModulos({required int idGenUsuario,required  int idGenPersona}) async {
    try {
      List<Modulo> modulos = await _modulosApiProviderImpl.getModulos(idGenUsuario:idGenUsuario,idGenPersona:idGenPersona);

      return modulos;
    }  catch (e){
      throw ExceptionHelper.captureError(e);
    }
  }

}