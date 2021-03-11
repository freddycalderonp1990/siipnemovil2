part of 'apis.dart';

class TiposEjesApi {
  static const String tag = "TiposEjesApi";
  Future<  List<UnidadesPoliciale>> getUnidadesPoliciales({BuildContext context,@required String usuario}) async {
    try {
      String titleJson = "unidadesPoliciales";
      Map<String, String> parametros;
      parametros = {
        ConstApi.varOpc: ConstApi.ConsultarUnidadesPoliciales,
        "usuario": usuario,
      };

      final json = await UrlApi.getUrl(context, parametros,);

      //se verifica que el servidor envie una respuesta valida
      String msj =
      ResponseApi.validateConsultas(json: json, titleJson: titleJson);

      if (msj == ConstApi.varTrue) {

        String datos= getDatosModelFromString(json, titleJson);


        List<UnidadesPoliciale> _UnidadesPoliciale = unidadesPolicialesModelFromJson(datos).unidadesPoliciales;

        if(_UnidadesPoliciale==null){
          _UnidadesPoliciale=new List();
        }
        return _UnidadesPoliciale;

      } else {
        DialogosWidget.error(context, message: msj);
        return null;
      }
    }  catch (e) {
      String msj = tag + " No se pudo cargar las Unidades Policiales [ ${e.toString()} ]";

      DialogosWidget.error(context, message: msj);
      throw new Exception('[getUnidadesPoliciales-${msj}]');

    }
  }

  Future<  List<UnidadesPoliciale>> getTipoEjePorIdPadre({BuildContext context,@required String usuario,@required String idDgoTipoEje,bool mostrarMsj=true}) async {
    try {
      String titleJson = "unidadesPoliciales";
      Map<String, String> parametros;
      parametros = {
        ConstApi.varOpc: ConstApi.ConsultarTiposEjesPorIdPadre,
        "usuario": usuario,
        "idDgoTipoEje": idDgoTipoEje,
      };

      final json = await UrlApi.getUrl(context, parametros,);

      //se verifica que el servidor envie una respuesta valida
      String msj =
      ResponseApi.validateConsultas(json: json, titleJson: titleJson);

      if (msj == ConstApi.varTrue) {

        String datos= getDatosModelFromString(json, titleJson);


        List<UnidadesPoliciale> _UnidadesPoliciale = unidadesPolicialesModelFromJson(datos).unidadesPoliciales;
        if(_UnidadesPoliciale==null){

          _UnidadesPoliciale=new List();
        }
        return _UnidadesPoliciale;

      } else {
        if(mostrarMsj) {
          DialogosWidget.error(context, message: msj);
        }
        return null;
      }
    }  catch (e) {
      String msj = tag + " No se pudo cargar [ ${e.toString()} ]";
  if(mostrarMsj) {
    DialogosWidget.error(context, message: msj);
  }

      throw new Exception('[getTipoEjePorIdPadre-${msj}]');

    }
  }

  Future<  List<UnidadesPoliciale>> getTipoEjeOtros({BuildContext context,@required String usuario}) async {
    try {
      String titleJson = "unidadesPoliciales";
      Map<String, String> parametros;
      parametros = {
        ConstApi.varOpc: ConstApi.ConsultarTipoEjeOtros,
        "usuario": usuario,

      };

      final json = await UrlApi.getUrl(context, parametros,);

      //se verifica que el servidor envie una respuesta valida
      String msj =
      ResponseApi.validateConsultas(json: json, titleJson: titleJson);

      if (msj == ConstApi.varTrue) {

        String datos= getDatosModelFromString(json, titleJson);


        List<UnidadesPoliciale> _UnidadesPoliciale = unidadesPolicialesModelFromJson(datos).unidadesPoliciales;

        if(_UnidadesPoliciale==null){
          _UnidadesPoliciale=new List();
        }
        return _UnidadesPoliciale;

      } else {
        DialogosWidget.error(context, message: msj);
        return null;
      }
    }  catch (e) {
      String msj = tag + " No se pudo cargar Tipo Ejej Otros [ ${e.toString()} ]";

      DialogosWidget.error(context, message: msj);
      throw new Exception('[getTipoEjeOtros-${msj}]');

    }
  }


  Future<  TipoEjesActivos> getTipoEjesActivosEnProcesoOperativos({BuildContext context,@required String usuario,@required String idDgoProcElec}) async {
    try {
      String titleJson = "tipoEjesActivos";
      Map<String, String> parametros;
      parametros = {
        ConstApi.varOpc: ConstApi.ConsultarTipoEjesActivosEnProcesoOperativos,
        "usuario": usuario,
        "idDgoProcElec": idDgoProcElec,
      };

      final json = await UrlApi.getUrl(context, parametros,);


      //se verifica que el servidor envie una respuesta valida
      String msj =
      ResponseApi.validateConsultas(json: json, titleJson: titleJson);

      if (msj == ConstApi.varTrue) {

        String datos= getDatosModelFromString(json, titleJson);


        TipoEjesActivos tipoEjesActivos = tipoEjesActivosModelFromJson(datos).tipoEjesActivos;

        if(tipoEjesActivos==null){
       //   _UnidadesPoliciale=new List();
        }
        return tipoEjesActivos;

      } else {
        DialogosWidget.error(context, message: msj);
        return null;
      }
    }  catch (e) {
      String msj = tag + " No se pudo cargar Tipo Eje Activos [ ${e.toString()} ]";

      DialogosWidget.error(context, message: msj);
      throw new Exception('[getTipoEjesActivosEnProcesoOperativos-${msj}]');

    }
  }
}
