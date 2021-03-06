part of '../apis.dart';

class NovedadesElectoralesApi {
  static const String tag = "NovedadesElectoralesApi";

  Future<List<NovedadesElectorale>> getNovedadesPadres({
    @required BuildContext context,
  }) async {
    try {
      String titleJson = "novedadesElectorales";

      Map<String, String> parametros;
      parametros = {
        ConstApi.varOpc: ConstApi.ListaNovedadesElectoralesElectorales,
      };

      //cUANDO SE NECESITA LOS METODOS ESPECIFICO PARA CADA MODULO SE ENVIA POR PARAMETRO EL MODULO CORRESPONDIENTE

      final json = await UrlApi.getUrl(context, parametros,
          modulo: ConstApi.moduloRecintoElectoral);

      if (json == null) {
        return null;
      }

      //se verifica que el servidor envie una respuesta valida
      String msj =
          ResponseApi.validateConsultas(json: json, titleJson: titleJson);

      if (msj == ConstApi.varTrue) {
        String datos = getDatosModelFromString(json, titleJson);

        List<NovedadesElectorale> list =
            novedadesElectoralesModelFromJson(datos).novedadesElectorales;

        if (list.length > 0) {
          return list;
        } else {
          DialogosWidget.alert(context,
              title: "Novedades Electorales",
              message: "No existen Novedades Electorales");
          return new List();
        }
      } else {
        if (msj == ConstApi.varNoExiste) {
          DialogosWidget.alert(context, onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
              title: "Novedades Electorales",
              message: "No existen Novedades Electorales");
        } else {
          DialogosWidget.error(context, message: msj);
        }

        return new List();
      }
    } catch (e) {
      String msj = tag + "[getNovedadesPadres] ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception(msj);
    }
  }

  Future<List<NovedadesElectorale>> getNovedadesHijas({
    @required BuildContext context,
    @required String idNovedadesPadre,
  }) async {
    try {
      String titleJson = "novedadesElectorales";

      Map<String, String> parametros;
      parametros = {
        ConstApi.varOpc: ConstApi.ListaNovedadesElectoralesElectoralesHijas,
        "idNovedadesPadre": idNovedadesPadre,
      };

      //cUANDO SE NECESITA LOS METODOS ESPECIFICO PARA CADA MODULO SE ENVIA POR PARAMETRO EL MODULO CORRESPONDIENTE

      final json = await UrlApi.getUrl(context, parametros,
          modulo: ConstApi.moduloRecintoElectoral);

      if (json == null) {
        return null;
      }

      //se verifica que el servidor envie una respuesta valida
      String msj =
          ResponseApi.validateConsultas(json: json, titleJson: titleJson);

      if (msj == ConstApi.varTrue) {
        String datos = getDatosModelFromString(json, titleJson);

        List<NovedadesElectorale> list =
            novedadesElectoralesModelFromJson(datos).novedadesElectorales;

        if (list.length > 0) {
          return list;
        } else {
          DialogosWidget.alert(context,
              title: "Novedades Electorales",
              message: "No existen Novedades Electorales");
          return new List();
        }
      } else {
        if (msj == ConstApi.varNoExiste) {
          DialogosWidget.alert(context, onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
              title: "Novedades Electorales",
              message: "No existen Novedades Electorales ");
        } else {
          DialogosWidget.error(context, message: msj);
        }

        return new List();
      }
    } catch (e) {
      String msj = tag + "[getNovedadesHijas] ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception(msj);
    }
  }

  Future<bool> registrarNovedadesElectorales({
    @required BuildContext context,
    @required String idDgoNovedadesElect,
    @required String idDgoPerAsigOpe,
    @required String observacion,
    @required String usuario,
     String imagen="No Imagen",
  }) async {
    try {
      String titleJson = "insertNovedadesElectorales";
      String ip = await UtilidadesUtil.getIp();

      Map<String, String> parametros;
      parametros = {
        ConstApi.varOpc: ConstApi.InsertarNovedadesElectorales,
        "idDgoNovedadesElect": idDgoNovedadesElect,
        "idDgoPerAsigOpe": idDgoPerAsigOpe,
        "observacion": observacion,
        "usuario": usuario,
        "ip": ip,
        "imagen":imagen,
      };

      //cUANDO SE NECESITA LOS METODOS ESPECIFICO PARA CADA MODULO SE ENVIA POR PARAMETRO EL MODULO CORRESPONDIENTE

      final json = await UrlApi.getUrl(context, parametros,
          modulo: ConstApi.moduloRecintoElectoral);

      if (json == null) {
        return null;
      }

      //se verifica que el servidor envie una respuesta valida
      String msj = ResponseApi.validateInsert(json: json, titleJson: titleJson);

      if (msj == ConstApi.varTrue) {
        DialogosWidget.alert(context, onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
            title: "Novedades Electorales",
            message: "Registro de Novedad con Exito");
        return true;
      } else {
        DialogosWidget.alert(context, onTap: () {
          Navigator.of(context).pop();
        },
            title: "Novedades Electorales",
            message:
                "Error al Registrar la Novedad. Vuelva a intentar o contacte con el administrador del sistema.");
        return false;
      }
    } catch (e) {
      String msj = tag + "[registrarNovedadesElectorales] ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception(msj);
    }
  }

  Future<List<NovedadesElectoralesDetalle>> getDetalleNovedadesPorRecinto(
      {@required BuildContext context,
      @required String idDgoCreaOpReci,
      bool mostrarMsj = true}) async {
    try {
      String titleJson = "novedadesElectoralesDetalle";

      Map<String, String> parametros;
      parametros = {
        ConstApi.varOpc: ConstApi.ConsultarNovedadesRecintoElectoralReporte,
        "idDgoCreaOpReci": idDgoCreaOpReci,
      };

      //cUANDO SE NECESITA LOS METODOS ESPECIFICO PARA CADA MODULO SE ENVIA POR PARAMETRO EL MODULO CORRESPONDIENTE

      final json = await UrlApi.getUrl(context, parametros,
          modulo: ConstApi.moduloRecintoElectoral);

      if (json == null) {
        return null;
      }

      //se verifica que el servidor envie una respuesta valida
      String msj =
          ResponseApi.validateConsultas(json: json, titleJson: titleJson);

      if (msj == ConstApi.varTrue) {
        String datos = getDatosModelFromString(json, titleJson);

        List<NovedadesElectoralesDetalle> list =
            novedadesElectoralesDetalleModelFromJson(datos)
                .novedadesElectoralesDetalle;

        if (list.length > 0) {
          return list;
        } else {
          if (mostrarMsj) {
            DialogosWidget.alert(context,
                title: "Novedades Electorales",
                message: "No existen Novedades en Este Recinto Electoral");
          }
          return new List();
        }
      } else {
        if (msj == ConstApi.varNoExiste) {
          if (mostrarMsj) {
            DialogosWidget.alert(context,
                title: "Novedades Electorales",
                message: "No existen Novedades en Este Recinto Electoral");
          }
        } else {
          DialogosWidget.error(context, message: msj);
        }

        return new List();
      }
    } catch (e) {
      String msj = tag + "[getDetalleNovedadesPorRecinto] ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception(msj);
    }
  }

   Future<bool> guardarImgRecElectNovedades(
      {@required BuildContext context,
        @required File image,
        @required String nameImg}) async {

    try {
      String titleJson = "insertImgRecElectNovedades";
      String base64Image = base64Encode(image.readAsBytesSync());
      bool result = false;

      Map<String, String> parametros = {
        ConstApi.varOpc: ConstApi.GuardarImgRecElectNovedades,
      };

      final file =
      await MyFile.writeFile(palabra: base64Image.toString(), name: nameImg);

      final json = await UrlApi.getUrl(context, parametros,
          modulo: ConstApi.moduloRecintoElectoral, file: file);

      //se verifica que el servidor envie una respuesta valida
      String msj = ResponseApi.validateInsert(json: json, titleJson: titleJson);

      print("msj  {$msj}");

      if (msj == ConstApi.varTrue) {
        print("guarad img");
        return true;
      }
      else {
        print("no guarad img");
        return false;
      }
    }
    catch(e){
      String msj = tag + "[guardarImgRecElectNovedades] ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception(msj);
    }
  }
}
