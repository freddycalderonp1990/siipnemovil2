part of 'pages.dart';

class InicioRapidoPage extends StatefulWidget {
  @override
  _InicioRapidoPageState createState() => _InicioRapidoPageState();
}

class _InicioRapidoPageState extends State<InicioRapidoPage> {


  var peticionServer = false, validateFoto=true, tieneFoto=false;
  UserProvider _UserProvider;

  final prefs = new PreferenciasUsuario();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UtilidadesUtil.getTheme();
  }

  @override
  Widget build(BuildContext context) {

    final responsive = ResponsiveUtil(context);


    _UserProvider = UserProvider.of(context);


    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateTieneFoto(context);
    });
       return WorkAreaPageWidget(
      mostrarVersion: true,

      imgFondo: AppConfig.imgFondoDefault,
      peticionServer: peticionServer,
      title: VariablesUtil.POLICIANACIONAL,
      sizeTittle: 7,
      contenido: <Widget>[
       tieneFoto? getContenido(responsive):Container()
      ],
    );;
  }
  Widget getContenido(ResponsiveUtil responsive ){
    return Column(children: [
      ClipRRect(
        borderRadius:
        BorderRadius.circular(
            100.0),
        child: Container(
          width:
          responsive.anchoP(35),
          height:
          responsive.anchoP(35),
          child: Image.memory(
              prefs.getFoto()),
        ),
      ),
      SizedBox(height: responsive.altoP(2),),
      Text(
        "HOLA" ,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: responsive.anchoP(5)),
      ),

      SizedBox(height: responsive.altoP(0.5),),
      Text(
        prefs.getNombre() ,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: responsive.anchoP(5)),
      ),
      SizedBox(height: responsive.altoP(2),),
      wgHuella(responsive),
      SizedBox(height: responsive.altoP(1),),
      wgOtroUsuario(responsive)
    ],);
  }

  Widget wgHuella(ResponsiveUtil responsive) {
    bool verificaCredecniales = false;
    if (prefs.getUser().length > 0 && prefs.getPass().length > 0) {
      verificaCredecniales = true;
    }

    Widget wg =
         desingBtn(responsive,
        title: "INGRESO CON HUELLA",
        img: AppConfig.icon_huella, onTap: () async {

          bool result = await BiometricUtil.biometrico();
          if (result) {
            _EventoLogin(
                user: prefs.getUser(),
                pass: prefs.getPass(),
                );
          }
        })
        ;

    return wg;
  }

  Widget wgOtroUsuario(ResponsiveUtil responsive) {
    bool verificaCredecniales = false;
    if (prefs.getUser().length > 0 && prefs.getPass().length > 0) {
      verificaCredecniales = true;
    }

    Widget wg =
    desingBtn(responsive,
        title: "¿NO ERES TÚ?",
        img: AppConfig.icon_usuario, onTap: () async {



            DialogosWidget.alertSiNo(context,
                title: "Huella",
                message:
                "Por su seguridad el acceso por huella sera desactivado."
                    "\n\n¿Desea Continuar?",
                onTap: (){
                  prefs.setContadorFallido(0);
                  prefs.setConfigHuella(false);
                  prefs.setAppInicial(false);
                  prefs.clearDatosUser();
                  UtilidadesUtil.pantallasAbrirNuevaCerrarTodas(
                      context: context, pantalla: AppConfig.pantallaLogin);
                });

        })
    ;

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

  _EventoLogin({String user, String pass}) async {
    // _UserProvider.setUser=new Usuario(apenom: 'Freddy Calderon Pazmiño',documento: '1206762401',nombreUsuario: 'nameUser',sexo: 'Masculino');

    try {
      var isValid = true;


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
        }
        else{
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
              builder: (context) =>
                  VerificarGpsPage(pantalla: VerificaOpertaivoRecintoAbiertoPage())));



      /*Navigator.pushReplacementNamed(
              context, AppConfig.pantallaMenuRecintoElectoral);*/
    }
  }

  _validateTieneFoto(BuildContext context){
   if(validateFoto) {
     if (!prefs.getImgValida()) {
       UtilidadesUtil.pantallasAbrirNuevaCerrarTodas(
           context: context, pantalla: AppConfig.pantallaLogin);
     }
     else{
       validateFoto=false;
       setState(() {
         tieneFoto=true;
       });
     }
   }
  }
}
