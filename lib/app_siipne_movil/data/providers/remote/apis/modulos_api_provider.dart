part of '../../providers_impl.dart';

class ModulosApiProviderImpl extends ModulosRepository {
  @override
  Future<List<Modulo>> getModulos({required int idGenUsuario,required  int idGenPersona}) async {
    try {
      Object? body = {
        "idGenUsuario": idGenUsuario.toString(),
        "idGenPersona": idGenPersona.toString()
      };
      String json = await UrlApiProviderSiipneMovil.post( body: body, segmento: 'modulos');
      List<Modulo> data= modulosModelFromJson(json).modulo;


      return data;

    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }


}