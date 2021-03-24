part of 'pages.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  var peticionServer = false;
  UserProvider _UserProvider;

  var controllerUser = new TextEditingController();
  var controllerPass = new TextEditingController();

  final prefs = new PreferenciasUsuario();

  bool wgLoginUserPass = false;
  bool wgOcultarLoginUserPass = false;
  bool mostrarWgHuellaUserPass = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UtilidadesUtil.getTheme();

    //cambia el color de texto de barra superios del telefono
    /*controllerUser.text = 'cpfn1206762401';
    controllerPass.text = 'freddyNCP1990';*/

    if (!prefs.getAppInicial()) {

      wgLoginUserPass = true;
      wgOcultarLoginUserPass = true;
    }
  }

  _EventoLogin({String user, String pass, bool validarForm = true}) async {
    // _UserProvider.setUser=new Usuario(apenom: 'Freddy Calderon Pazmiño',documento: '1206762401',nombreUsuario: 'nameUser',sexo: 'Masculino');

    try {
      var isValid = true;

      if (validarForm) {
        isValid = _formKey.currentState.validate();
      }
      final _LoginApi = LoginApi();

      if (isValid) {
        if (peticionServer) return;
        setState(() {
          peticionServer = true;
        });

        final Usuario datosUser = await _LoginApi.getLogin(user, pass, context);

        setState(() {
          peticionServer = false;
        });

        if (int.parse(datosUser.idGenUsuario) > 0) {
          _UserProvider.setUser = datosUser;

          bool checkAccesoBiometrico =
              await BiometricUtil.checkAccesoBiometrico();
          bool verificaCredecniales = false;
          if (prefs.getUser().length > 0 && prefs.getPass().length > 0) {
            verificaCredecniales = true;
          }

          if (checkAccesoBiometrico) {
            if (!verificaCredecniales) {
              DialogosWidget.alertSiNo2(context,
                  title: "BIOMÉTRICO",
                  onTapSi: () async {
                    bool resultHuella = await BiometricUtil.biometrico();

                    if (resultHuella) {
                      prefs.setUser(controllerUser.text);
                      prefs.setPass(controllerPass.text);
                      prefs.setNombre(_UserProvider.getUser.apenom);
                      if (_UserProvider.getUser.fotoString != null) {
                        prefs.setFoto(_UserProvider.getUser.fotoString);
                      } else {
                        //String imgNoImagen=AppConfig.imgNoImagen;

                        prefs.setFoto('');
                      }

                      DialogosWidget.alert(context,
                          title: "BIOMÉTRICO",
                          message:
                              "A configurado con éxito el acceso biométrico.",
                          onTap: () {
                        prefs.setAppInicial(true);
                        prefs.setConfigHuella(true);

                        InciarPantalla(datosUser.actualizarApp);

                        /*  UtilidadesUtil.pantallasAbrirNuevaCerrarTodas(
                          context: context, pantalla: AppConfig.pantallaLogin);*/
                      });
                    } else {
                      DialogosWidget.alert(context,
                          title: "BIOMÉTRICO",
                          message:
                              "Error al configurar, su huella no coincide.",
                          onTap: () {
                        prefs.setAppInicial(false);
                        prefs.setConfigHuella(true);

                        InciarPantalla(datosUser.actualizarApp);
                      });
                    }
                  },
                  message: "¿Desea configurar el acceso biometrico.?",
                  onTapNo: () async {
                    prefs.clearDatosUser();

                    InciarPantalla(datosUser.actualizarApp);
                  });
            } else {
              InciarPantalla(datosUser.actualizarApp);
            }
          } else {
            InciarPantalla(datosUser.actualizarApp);
          }
        }
      }
    } catch (e) {
      setState(() {
        peticionServer = false;
      });
    }
  }

  void InciarPantalla(bool actualizarApp) {
    if (actualizarApp) {
      DialogosWidget.alert(context, title: "Actualizar App", onTap: () {
        Navigator.of(context).pop();

        if (UtilidadesUtil.plataformaIsAndroid()) {
          UtilidadesUtil.abrirUrl(AppConfig.linkAppAndroid);
        } else {
          UtilidadesUtil.abrirUrl(AppConfig.linkAppIos);
        }
      },
          message: "Nueva Versión Disponible"
              "\n\nPara continuar utilizando la aplicación es necesario que descargue la última versión."
              "\n\nSi tiene Problemas intente desinstalar y volver a instalarla.");
    } else {
      //No necesita comprobacion de gps
      /* UtilidadesUtil.pantallasAbrirNuevaCerrarTodas(
          context: context, pantalla: AppConfig.pantallaProcesosOperativos);*/

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerificarGpsPage(
                  pantalla: VerificaOpertaivoRecintoAbiertoPage())));

      /*Navigator.pushReplacementNamed(
              context, AppConfig.pantallaMenuRecintoElectoral);*/
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //Variable para obtener el tamaño de la pantalla

    final responsive = ResponsiveUtil(context);
    final sizeTxt = responsive.anchoP(AppConfig.tamTexto + 2.0);

    print(wgLoginUserPass);
    print(wgOcultarLoginUserPass);

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
          height: responsive.altoP(1.5),
        ),
        Column(
          children: <Widget>[
            wgLoginUserPass
                ? WgLogin(
                    onPressed: () => _EventoLogin(
                        user: controllerUser.text, pass: controllerPass.text),
                    controllerPass: controllerPass,
                    controllerUser: controllerUser,
                    formKey: _formKey,
                  )
                : Container(),
            SizedBox(
              height: responsive.altoP(2),
            ),
            wgUserPass(responsive),
            SizedBox(
              height: responsive.altoP(1),
            ),
            wgHuella(responsive),
            SizedBox(
              height: responsive.altoP(3.5),
            ),
          ],
        )
      ],
    );
  }

  Widget wgHuella(ResponsiveUtil responsive) {
    bool verificaCredecniales = false;
    if (prefs.getUser().length > 0 && prefs.getPass().length > 0) {
      verificaCredecniales = true;
    }

    Widget wg = verificaCredecniales
        ? desingBtn(responsive,
            title: "INGRESO CON HUELLA",
            img: AppConfig.icon_huella, onTap: () async {
            setState(() {
              wgLoginUserPass = false;
              wgOcultarLoginUserPass = false;
            });
            bool result = await BiometricUtil.biometrico();
            if (result) {
              _EventoLogin(
                  user: prefs.getUser(),
                  pass: prefs.getPass(),
                  validarForm: false);
            }
          })
        : Container();

    return wg;
  }

  Widget wgUserPass(ResponsiveUtil responsive) {
    Widget wg = !wgOcultarLoginUserPass
        ? desingBtn(responsive,
            title: "INGRESO CON USUARIO Y CLAVE",
            img: AppConfig.icon_usuario, onTap: () {
            setState(() {
              wgLoginUserPass = true;
              wgOcultarLoginUserPass = true;
            });
          })
        : Container();

    return wg;
  }

  Widget desingBtn(ResponsiveUtil responsive,
      {String title, String img, double ancho = 60, GestureTapCallback onTap}) {
    return BtnMenuWidget(
      img: img,
      titlte: title,
      horizontal: false,
      onTap: onTap,
      colorFondo: Colors.black26,
      colorTexto: Colors.white,
    );
  }
}

class WgLogin extends StatefulWidget {
  final controllerUser;

  final controllerPass;

  final VoidCallback onPressed;
  final formKey;
  final double ancho;
  final bool mostrarFondo;

  const WgLogin(
      {Key key,
      this.controllerUser,
      this.controllerPass,
      this.onPressed,
      this.formKey,
      this.ancho = 50.0,
      this.mostrarFondo = false})
      : super(key: key);

  @override
  _WgLoginState createState() => _WgLoginState();
}

class _WgLoginState extends State<WgLogin> {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    final sizeTxt = responsive.anchoP(AppConfig.tamTexto + 2.0);

    Widget desing = Column(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: responsive.ancho - widget.ancho,
            minWidth: responsive.ancho - widget.ancho,
          ),
          child: Form(
              key: widget.formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, //PARA PROBAR CONTAINER
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    child: ImputTextWidget(
                      imgString: AppConfig.icon_usuario,
                      controller: widget.controllerUser,
                      elevation: 1,
                      label: VariablesUtil.Usuario,
                      fonSize: sizeTxt,
                      hitText: VariablesUtil.ingreseUsuario,
                      validar: (String text) {
                        if (text.length >= 1) {
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
                      controller: widget.controllerPass,
                      hitText: VariablesUtil.ingreseClave,
                      label: VariablesUtil.Clave,
                      fonSize: sizeTxt,
                      validar: (String text) {
                        if (text.length >= 1) {
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
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );

    return widget.mostrarFondo
        ? Stack(
            children: [
              Container(
                height: responsive.alto / 2,
                width: responsive.ancho - 100,
                child: Image.asset(
                  AppConfig.imgFondoLogin,
                  fit: BoxFit.cover,
                ),
              ),
              desing
            ],
          )
        : desing;
  }
}
