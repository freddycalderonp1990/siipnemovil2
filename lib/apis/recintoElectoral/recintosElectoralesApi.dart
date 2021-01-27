part of '../apis.dart';

class RecintosElectoralesApi {
  static const String tag = "RecintosElectoralesApi";

  Future<List<RecintosElectoral>> getRecintosElectoralesCercanos({
    @required BuildContext context,
    @required String latitud,
    @required String longitud,
  }) async {
    try {
      String titleJson = "recintosElectorales";

      Map<String, String> parametros;
      parametros = {
        ConstApi.varOpc: ConstApi.ConsultarRecintosElectorales,
        "latitud": latitud,
        "longitud": longitud
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

        List<RecintosElectoral> list =
            RecintosElectoralsModelFromJson(datos).RecintosElectorals;

        if (list.length > 0) {
          return list;
        } else {
          DialogosWidget.alert(context,
              title: "Recintos Electorales",
              message: "No existen Recintos Electorales Cercanos");
          return new List();
        }
      } else {
        if (msj == ConstApi.varNoExiste) {
          DialogosWidget.alert(context, onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
              title: "Recintos Electorales",
              message: "No existen Recintos Electorales Cercanos");
        } else {
          DialogosWidget.error(context, message: msj);
        }

        return new List();
      }
    } catch (e) {
      String msj = tag + " error en getLogin= ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception('[getRecintosElectoralesCercanos-${msj}]');
    }
  }

  Future<AbrirRecintoElectoral> abrirRecintoElectoral({
    @required BuildContext context,
    @required String usuario,
    @required String idGenPersona,
    @required String idDgoReciElect,
    @required String latitud,
    @required String longitud,
  }) async {
    try {
      String titleJson = "AbrirRecintoElectoral";

      Map<String, String> parametros;
      String ip = await UtilidadesUtil.getIp();
      parametros = {
        ConstApi.varOpc: ConstApi.AbrirRecintoElectoral,
        "usuario": usuario,
        "idGenPersona": idGenPersona,
        "idDgoReciElect": idDgoReciElect,
        "ip": ip,
        "latitud": latitud,
        "longitud": longitud,
      };

      print("abrirRecintoElectoral");

      //cUANDO SE NECESITA LOS METODOS ESPECIFICO PARA CADA MODULO SE ENVIA POR PARAMETRO EL MODULO CORRESPONDIENTE

      final json = await UrlApi.getUrl(context, parametros,
          modulo: ConstApi.moduloRecintoElectoral);

      if (json == null) {
        return null;
      }

      //se verifica que el servidor envie una respuesta valida
      String msj =
          ResponseApi.validateConsultas(json: json, titleJson: titleJson);

      print(msj);

      if (msj == ConstApi.varTrue) {


        String datos = getDatosModelFromString(json, titleJson);

        print(datos);
        AbrirRecintoElectoral abrirRecintoElectoral =
            abrirRecintoElectoralModelFromJson(datos).abrirRecintoElectoral;

        return abrirRecintoElectoral;
      }
      else{

        DialogosWidget.alert(context,
            title: "Recintos Electorales",
            message: "No se realizó el registro. " + msj);
      }


    } catch (e) {
      String msj = tag + "abrirRecintoElectoral - ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception('[abrirRecintoElectoral-${msj}]');
    }
  }

//Sirve para agregar y registrar personal en recinto electoral
  Future<ResgistroPersEnRecElectoral> asignarPersonalEnRecintoElectoral({
    @required BuildContext context,
    @required String idDgoCreaOpReci,
    @required String idGenPersona,
    @required String usuario,
    @required String latitud,
    @required String longitud,
    @required String idDgoReciElect,

  }) async {
    try {
      String titleJson = "resgistroPersEnRecElectoral";

      Map<String, String> parametros;
      String ip = await UtilidadesUtil.getIp();
      parametros = {
        ConstApi.varOpc: ConstApi.AsignarPersonalEnRecintoElectoral,
        "idDgoCreaOpReci": idDgoCreaOpReci,
        "idGenPersona": idGenPersona,
        "usuario": usuario,
        "ip": ip,
        "latitud": latitud,
        "longitud": longitud,
        "idDgoReciElect": idDgoReciElect,
      };

      //cUANDO SE NECESITA LOS METODOS ESPECIFICO PARA CADA MODULO SE ENVIA POR PARAMETRO EL MODULO CORRESPONDIENTE

      final json = await UrlApi.getUrl(context, parametros,
          modulo: ConstApi.moduloRecintoElectoral);

      if (json == null) {
        return null;
      }

      //se verifica que el servidor envie una respuesta valida
      String msj =
          ResponseApi.validateConsultasExiste(json: json, titleJson: titleJson);

      //Verificamos si existe

      ResgistroPersEnRecElectoral _resgistroPersEnRecElectoral =
          new ResgistroPersEnRecElectoral(nomRecintoElec: "");

      if (msj == ConstApi.varExiste) {
        String datos = getDatosModelFromString(json, titleJson);
        _resgistroPersEnRecElectoral =
            resgistroPersEnRecElectoralModelFromJson(datos)
                .resgistroPersEnRecElectoral;

        DialogosWidget.alert(context,
            title: "Recintos Electorales",
            message: "Ya se encuentra asignado al recinto electoral \n" +
                _resgistroPersEnRecElectoral.nomRecintoElec +
                "\n\nJefe/Encargado\n" +
                _resgistroPersEnRecElectoral.encargado +
                "\n\nPara poder ser asignado a un nuevo recinto electoral abandone el recinto anterior y vuelva a intentar.");

        return _resgistroPersEnRecElectoral;
      } else {
        //validamos de que se inserte
        //se verifica que el servidor envie una respuesta valida
        String msj =
            ResponseApi.validateConsultas(json: json, titleJson: titleJson);

        if (msj == ConstApi.varTrue) {
          DialogosWidget.alert(context, onTap: () {
            Navigator.pushReplacementNamed(
                context, AppConfig.pantallaMenuRecintoElectoral);
          },
              title: "Recintos Electorales",
              message: "Registro Realizado con exito!.");
        } else {
          DialogosWidget.alert(context,
              title: "Recintos Electorales",
              message: "No se realizó el registro. " + msj);
        }
      }
    } catch (e) {
      String msj = tag + "asignarPersonalEnRecintoElectoral - ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception('[asignarPersonalEnRecintoElectoral-${msj}]');
    }
  }

  Future<RecintosElectoralesAbiertos>
      verificarPersonalEncargadoAsignadoRecElectPorIdGenPersona({
    @required BuildContext context,
    @required String idGenPersona,
  }) async {
    try {
      String titleJson = "recintosElectoralesAbiertos";
      Map<String, String> parametros;

      parametros = {
        ConstApi.varOpc:
            ConstApi.VerificarPersonalEncargadoAsignadoRecElectPorIdGenPersona,
        "idGenPersona": idGenPersona,
      };

      print("consulto");

      //cUANDO SE NECESITA LOS METODOS ESPECIFICO PARA CADA MODULO SE ENVIA POR PARAMETRO EL MODULO CORRESPONDIENTE

      final json = await UrlApi.getUrl(context, parametros,
          modulo: ConstApi.moduloRecintoElectoral);

      if (json == null) {
        return null;
      }

      //se verifica que el servidor envie una respuesta valida
      String msj =
          ResponseApi.validateConsultas(json: json, titleJson: titleJson);

      //Verificamos si existe

      RecintosElectoralesAbiertos _RecintosElectoralesAbiertos =
          new RecintosElectoralesAbiertos(
              nomRecintoElec: "", idDgoCreaOpReci: "0",idDgoReciElect: "0");

      if (msj == ConstApi.varTrue) {
        String datos = getDatosModelFromString(json, titleJson);
        _RecintosElectoralesAbiertos =
            recintosElectoralesAbiertosModelFromJson(datos)
                .recintosElectoralesAbiertos;
      }

      return _RecintosElectoralesAbiertos;
    } catch (e) {
      String msj = tag +
          "verificarPersonalEncargadoAsignadoRecElectPorIdGenPersona - ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception(
          '[verificarPersonalEncargadoAsignadoRecElectPorIdGenPersona-${msj}]');
    }
  }

  Future<DatosRecintoElectoralClass>
      consultarDatosEncargadoRecintoPoridCreaRecinto({
    @required BuildContext context,
    @required String idDgoCreaOpReci,
  }) async {
    try {
      String titleJson = "datosRecintoElectoral";

      Map<String, String> parametros;

      parametros = {
        ConstApi.varOpc:
            ConstApi.ConsultarDatosEncargadoRecintoPoridCreaRecinto,
        "idDgoCreaOpReci": idDgoCreaOpReci,
      };

      //CUANDO SE NECESITA LOS METODOS ESPECIFICO PARA CADA MODULO SE ENVIA POR PARAMETRO EL MODULO CORRESPONDIENTE

      final json = await UrlApi.getUrl(context, parametros,
          modulo: ConstApi.moduloRecintoElectoral);

      if (json == null) {
        return null;
      }

      //se verifica que el servidor envie una respuesta valida
      String msj =
          ResponseApi.validateConsultas(json: json, titleJson: titleJson);
      print("validateConsultas");
      print(msj);

      if (msj == ConstApi.varTrue) {
        String datos = getDatosModelFromString(json, titleJson);

        print(datos);
        DatosRecintoElectoralClass _datos =
            datosRecintoElectoralFromJson(datos).datosRecintoElectoral;

        return _datos;
      } else {
        DialogosWidget.alert(context,
            title: "Recintos Electorales",
            message:
                "No existen Recintos Electorales Abiertos con este Codigo");
        return new DatosRecintoElectoralClass(nomRecintoElec: "");
      }
    } catch (e) {
      String msj = tag +
          "consultarDatosEncargadoRecintoPoridCreaRecinto - ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception(
          '[consultarDatosEncargadoRecintoPoridCreaRecinto-${msj}]');
    }
  }




  Future<bool> eliminarRecintoElectoralAbierto({
    @required BuildContext context,
    @required String idDgoCreaOpReci,
    @required String usuario,

  }) async {
    try {
      String titleJson = "eliminarRecintoElectoral";

      Map<String, String> parametros;
      String ip = await UtilidadesUtil.getIp();
      parametros = {
        ConstApi.varOpc: ConstApi.EliminarRecintoElectoralAbierto,
        "usuario": usuario,
        "idDgoCreaOpReci": idDgoCreaOpReci,
        "ip": ip,
      };

      //cUANDO SE NECESITA LOS METODOS ESPECIFICO PARA CADA MODULO SE ENVIA POR PARAMETRO EL MODULO CORRESPONDIENTE

      final json = await UrlApi.getUrl(context, parametros,
          modulo: ConstApi.moduloRecintoElectoral);

      if (json == null) {
        return null;
      }

      //se verifica que el servidor envie una respuesta valida
      String msj =
      ResponseApi.validateInsert(json: json, titleJson: titleJson);

      print(msj);

      if (msj == ConstApi.varTrue) {

        DialogosWidget.alert(context,
            title: "Recintos Electorales",
            message: "Recinto Electoral eliminado con exito!. " + msj,
        onTap: (){
          Navigator.pushReplacementNamed(
              context, AppConfig.pantallaMenuRecintoElectoral);

        
        });
        return true;
      }

      else{

        DialogosWidget.alert(context,
            title: "Recintos Electorales",
            message: "Error al eliminar el Recinto. Vuelva a intentarlo, o consulte con el administrador del sistema " + msj);
        return false;
      }


    } catch (e) {
      String msj = tag + "eliminarRecintoElectoralAbierto - ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception('[eliminarRecintoElectoralAbierto-${msj}]');
    }
  }


  Future<bool> abandonarRecintoElectoral({
    @required BuildContext context,
    @required String idDgoPerAsigOpe,
    @required String usuario,

  }) async {
    try {
      String titleJson = "abandonarRecintoElectoral";

      Map<String, String> parametros;
      String ip = await UtilidadesUtil.getIp();
      parametros = {
        ConstApi.varOpc: ConstApi.AbandonarRecintoElectoral,
        "usuario": usuario,
        "idDgoPerAsigOpe": idDgoPerAsigOpe,
        "ip": ip,
      };

      //cUANDO SE NECESITA LOS METODOS ESPECIFICO PARA CADA MODULO SE ENVIA POR PARAMETRO EL MODULO CORRESPONDIENTE

      final json = await UrlApi.getUrl(context, parametros,
          modulo: ConstApi.moduloRecintoElectoral);

      if (json == null) {
        return null;
      }

      //se verifica que el servidor envie una respuesta valida
      String msj =
      ResponseApi.validateInsert(json: json, titleJson: titleJson);

      print(msj);

      if (msj == ConstApi.varTrue) {

        DialogosWidget.alert(context,
            title: "Recintos Electorales",
            message: "Usted abandono con éxito el recinto Electoral!. " ,
            onTap: (){
              Navigator.pushReplacementNamed(
                  context, AppConfig.pantallaMenuRecintoElectoral);
            });
        return true;
      }

      else{

        DialogosWidget.alert(context,
            title: "Recintos Electorales",
            message: "Error al abandonar el Recinto Electoral. Vuelva a intentarlo, o consulte con el administrador del sistema " + msj);
        return false;
      }


    } catch (e) {
      String msj = tag + "[abandonarRecintoElectoral] - ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception(msj);
    }
  }


  Future<bool> finalizarRecintoElectoral({
    @required BuildContext context,
    @required String idDgoCreaOpReci,
    @required String usuario,

  }) async {
    try {
      String titleJson = "finalizarRecintoElectoral";

      Map<String, String> parametros;
      String ip = await UtilidadesUtil.getIp();
      parametros = {
        ConstApi.varOpc: ConstApi.FinalizarRecintoElectoral,
        "usuario": usuario,
        "idDgoCreaOpReci": idDgoCreaOpReci,
        "ip": ip,
      };

      //cUANDO SE NECESITA LOS METODOS ESPECIFICO PARA CADA MODULO SE ENVIA POR PARAMETRO EL MODULO CORRESPONDIENTE

      final json = await UrlApi.getUrl(context, parametros,
          modulo: ConstApi.moduloRecintoElectoral);

      if (json == null) {
        return null;
      }

      //se verifica que el servidor envie una respuesta valida
      String msj =
      ResponseApi.validateInsert(json: json, titleJson: titleJson);

      print(msj);

      if (msj == ConstApi.varTrue) {

        DialogosWidget.alert(context,
            title: "Recintos Electorales",
            message: "Usted finalizó con éxito el recinto Electoral!. " ,
            onTap: (){
              Navigator.pushReplacementNamed(
                  context, AppConfig.pantallaMenuRecintoElectoral);
            });
        return true;
      }

      else{

        DialogosWidget.alert(context,
            title: "Recintos Electorales",
            message: "Error al finalizar el Recinto Electoral. Vuelva a intentarlo, o consulte con el administrador del sistema " + msj);
        return false;
      }


    } catch (e) {
      String msj = tag + "[finalizarRecintoElectoral] - ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception(msj);
    }
  }



  Future<List<PersonalRecintoElectoral>>
  consultarDatosPersonalAsignadoRecintoElectoral({
    @required BuildContext context,
    @required String idDgoCreaOpReci,
  }) async {
    try {
      String titleJson = "personalRecintoElectoral";

      Map<String, String> parametros;

      parametros = {
        ConstApi.varOpc:
        ConstApi.ConsultarPersonalAsignadoRecintoElectoral,
        "idDgoCreaOpReci": idDgoCreaOpReci,
      };

      //CUANDO SE NECESITA LOS METODOS ESPECIFICO PARA CADA MODULO SE ENVIA POR PARAMETRO EL MODULO CORRESPONDIENTE
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
        List<PersonalRecintoElectoral> _datos =
            personalRecintoElectoralModelFromJson(datos).personalRecintoElectoral;

        return _datos;
      } else {
        DialogosWidget.alert(context,
            title: "Personal",
            message:
            "No existe personal asignado");
        return new List();
      }
    } catch (e) {
      String msj = tag +
          "consultarDatosPersonalAsignadoRecintoElectoral - ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);

      throw new Exception(
          '[consultarDatosPersonalAsignadoRecintoElectoral-${msj}]');
    }
  }

}
