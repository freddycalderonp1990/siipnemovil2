part of 'apis.dart';

class LoginApi {
  static const String tag = "LoginApi";

  Future<Usuario> getLogin(
      String user, String pass, BuildContext context) async {
    try {
      String titleJson = "usuario";

      Map<String, String> parametros;
      parametros = {
        ConstApi.varOpc: ConstApi.loginApp,
        ConstApi.varUser: user,
        ConstApi.varPass: pass
      };

      final json = await UrlApi.getUrl(context, parametros);

      if (json == null) {
        return null;
      }

      //se verifica que el servidor envie una respuesta valida
      String msj =
          ResponseApi.validateConsultas(json: json, titleJson: titleJson);

      if (msj == ConstApi.varTrue) {
        String datos = getDatosModelFromString(json, titleJson);

        List<Usuario> usuarioList = userModelFromJson(datos).usuario;
        Usuario user = new Usuario();
        if (usuarioList.length > 0) {
          user = usuarioList[0];
        } else {}

        return user;
      } else {
        if (msj == ConstApi.varNoExiste) {

          DialogosWidget.alert(context,
              title: "Usuario",
              message:
                  "Usuario o Contraseña mal ingresados, o no tiene permisos");
        } else {
          DialogosWidget.error(context, message: msj);
        }

        return null;
      }
    }  catch (e) {
      String msj = tag + "-[getLogin] ${e.toString()}";
      print(msj);
      DialogosWidget.error(context, message: msj);
      throw new Exception('${msj}]');
      return null;
    }
  }
}
