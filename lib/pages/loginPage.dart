part of 'package:siipnemovil2/pages/pages.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var user_ = "", pass = "";
  var peticionServer = false;
  UserProvider _UserProvider;

  var controllerUser = new TextEditingController();
  var controllerPass = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UtilidadesUtil.getTheme();

    //cambia el color de texto de barra superios del telefono
    controllerUser.text = 'cpfn1206762401';
    controllerPass.text = 'freddyNCP1990';
  }

  _EventoLogin() async {
    // _UserProvider.setUser=new Usuario(apenom: 'Freddy Calderon Pazmiño',documento: '1206762401',nombreUsuario: 'nameUser',sexo: 'Masculino');

    try {
      final isValid = _formKey.currentState.validate();
      final _LoginApi = LoginApi();

      if (isValid) {
        if (peticionServer) return;
        setState(() {
          peticionServer = true;
        });

        final Usuario datosUser =
            await _LoginApi.getLogin(user_, pass, context);

        setState(() {
          peticionServer = false;
        });

        if (int.parse(datosUser.idGenUsuario) > 0) {
          _UserProvider.setUser = datosUser;

          if (datosUser.actualizarApp) {
            DialogosWidget.alert(context, title: "Actualizar App", onTap: () {
              Navigator.of(context).pop();

              if (UtilidadesUtil.plataformaIsAndroid()) {

                UtilidadesUtil.abrirUrl(AppConfig.linkAppAndroid);
              }

            },
                message: "Nueva Versión Disponible"
                    "\n\nPara continuar utilizando la aplicación es necesario que descargue la última versión."
                    "\n\nSi tiene Problemas intente desinstalar y volver a instalarla.");
          } else {
            UtilidadesUtil.pantallasAbrirNuevaCerrarTodas(
                context: context,
                pantalla: AppConfig.pantallaMenuRecintoElectoral);
            /*Navigator.pushReplacementNamed(
              context, AppConfig.pantallaMenuRecintoElectoral);*/
          }
        }
      }
    } catch (e) {
      setState(() {
        peticionServer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //Variable para obtener el tamaño de la pantalla

    final responsive = ResponsiveUtil(context);
    final sizeTxt = responsive.anchoP(AppConfig.tamTexto + 2.0);

    _UserProvider = UserProvider.of(context);

    return WorkAreaPageWidget(
      mostrarVersion: true,
      imgFondo: AppConfig.imgFondoLogin,
      peticionServer: peticionServer,
      title: VariablesUtil.POLICIANACIONAL,
      sizeTittle: 7,
      contenido: <Widget>[
        Text(
          VariablesUtil.DIRECCION,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: responsive.diagonalP(1.6),
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
        SizedBox(
          height: responsive.altoP(1),
        ),
        responsive.isVertical()
            ? Container(
                //img paquito
                width: responsive.anchoP(10),
                height: responsive.anchoP(10),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.transparent, blurRadius: 25)
                    ]),
                child: Align(
                  alignment: Alignment.center,
                  /*child: Image.asset(
              AppConfig.escudopolicia,
            ),*/
                ),
              )
            : Container(),
        SizedBox(
          height: responsive.altoP(1),
        ),
        Text(
          VariablesUtil.DIRECCIONDNSP,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: responsive.diagonalP(1.6),
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
        SizedBox(
          height: responsive.altoP(1),
        ),
        Column(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: responsive.ancho - 50,
                minWidth: responsive.ancho - 50,
              ),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white, //PARA PROBAR CONTAINER
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        child: ImputTextWidget(
                          imgString: AppConfig.icon_usuario,
                          controller: controllerUser,
                          elevation: 1,
                          label: VariablesUtil.Usuario,
                          fonSize: sizeTxt,
                          hitText: VariablesUtil.ingreseUsuario,
                          validar: (String text) {
                            if (text.length >= 1) {
                              user_ = text;
                              return null;
                            }
                            return VariablesUtil.caracteresNoValidos;
                          },
                        ),
                      ),
                      SizedBox(
                        height: responsive.altoP(2),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white, //PARA PROBAR CONTAINER
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        child: ImputTextWidget(
                          imgString: AppConfig.icon_clave,
                          elevation: 1,
                          isSegura: true,
                          controller: controllerPass,
                          hitText: VariablesUtil.ingreseClave,
                          label: VariablesUtil.Clave,
                          fonSize: sizeTxt,
                          validar: (String text) {
                            if (text.length >= 1) {
                              pass = text;
                              return null;
                            }
                            return VariablesUtil.claveNoValida;
                          },
                        ),
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: responsive.altoP(4),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: responsive.ancho - 80,
                minWidth: responsive.ancho - 80,
              ),
              child: BotonesWidget(
                iconData: Icons.arrow_forward,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                title: VariablesUtil.LOGIN,
                onPressed: () => _EventoLogin(),
              ),
            ),
            SizedBox(
              height: responsive.altoP(3.5),
            ),
          ],
        )
      ],
    );
  }
}
