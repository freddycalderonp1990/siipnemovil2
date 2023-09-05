part of '../../providers_impl_elecciones.dart';

class NovedadesApiProviderImpl extends NovedadesRepository {
  @override
  Future<NovedadesModel> consultarNovedades({required int idDgoTipoEje}) async {
    try {
      String json = await UrlApiProviderElecciones.get(
          segmento: 'novedades-padres/${idDgoTipoEje}');
      return NovedadesModel.fromJson(json);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<NovedadesModel> consultarNovedadesHijas(
      {required int idNovedadesPadre, required int idDgoTipoEje}) async {
    try {
      String json = await UrlApiProviderElecciones.get(
          segmento: 'novedades-hijas/${idNovedadesPadre}/${idDgoTipoEje}');
      return NovedadesModel.fromJson(json);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<bool> registrarNovedadesRecintoElectoral(
      {required NovedadesCreateRequest novedadesCreateRequest}) async {
    try {
      String nameImg=novedadesCreateRequest.nameImg != null
          ? novedadesCreateRequest.nameImg!
          : "";
      Map<String, String> body = {
        "idGenUsuario": novedadesCreateRequest.idGenUsuario.toString(),
        "idDgoPerAsigOpe": novedadesCreateRequest.idDgoPerAsigOpe.toString(),
        "idDgoNovedadesElect":
            novedadesCreateRequest.idDgoNovedadesElect.toString(),
        "ip": novedadesCreateRequest.ip,
        "nameImg": nameImg,
        "observacion": novedadesCreateRequest.observacion,
        "latitud": novedadesCreateRequest.latitud,
        "longitud": novedadesCreateRequest.longitud,
        "idDgoProcElec": novedadesCreateRequest.idDgoProcElec.toString(),
        "documento": novedadesCreateRequest.documento.toString()
      };
      File? image = novedadesCreateRequest.image;



      String segmento = "novedades";
      String json = "";
      if (image != null) {
        print("post con imagen");
        String base64Image = base64Encode(image.readAsBytesSync());





        final file =
            await MyFile.writeFile(palabra: base64Image, name: nameImg);


        print( "nameImg:"+ nameImg);

        json = await UrlApiProviderElecciones.postUploadFile(
            file: file, segmento: segmento, body: body);
      } else {
        print("post sin imagen");
        json =
            await UrlApiProviderElecciones.post(body: body, segmento: segmento);
      }

      InserUpdateModel data =
          InserUpdateModel.fromJson(json, "idDgoNovReciElec");

      if (!data.success) {
        DialogosAwesome.getError(
            descripcion: data.message, btnOkOnPress: () {});
        return false;
      }

      return true;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }


}
