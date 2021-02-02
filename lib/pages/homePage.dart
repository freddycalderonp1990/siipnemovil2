


part of 'pages.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserProvider _UserProvider;
  bool peticionServer = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UtilidadesUtil
        .getTheme(); //cambia el color de texto de barra superios del telefono
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //Variable para obtener el tamaño de la pantalla

    final responsive = ResponsiveUtil(context);

    _UserProvider = UserProvider.of(context);
    String Bienvenido = _UserProvider.getUser.sexo == 'H'
        ? VariablesUtil.Bienvenida
        : VariablesUtil.Bienvenido;

    return WorkAreaPageWidget(
      peticionServer: peticionServer,

      imgPerfil: _UserProvider.getUser.foto,
      contenido: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                Bienvenido + _UserProvider.getUser.apenom,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.anchoP(3.5)),
              ),
              SizedBox(
                height: responsive.altoP(1),
              ),
              Text(
                "MENÚ PRINCIPAL",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.anchoP(4.5)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: responsive.altoP(1),
        ),
      /*  BtnMenuWidget( titlte: VariablesUtil.sat,onTap: () {
          _LlamarPage(pantalla: AppConfig.pantallaMenuSat);

        }),*/


        SizedBox(
          height: responsive.altoP(1),
        ),

        BtnMenuWidget( titlte: VariablesUtil.recintoElectorales,onTap: () {
          _LlamarPage(pantalla: AppConfig.pantallaMenuRecintoElectoral);
        }),

        SizedBox(
          height: responsive.altoP(5),
        ),
        Container(
          width: responsive.anchoP(30),
          child: BtnIconWidget(
            iconData: Icons.exit_to_app,
            title: VariablesUtil.Salir,
            color: Colors.blue,
            onTap: () => _cerrarSession(),
          ),
        ),
        SizedBox(
          height: responsive.altoP(3.5),
        ),

      ],
    );
  }



  _cerrarSession() {

    UtilidadesUtil.pantallasAbrirNuevaCerrarTodas(context: context,pantalla: AppConfig.pantallaLogin);
    /*Navigator.pushReplacementNamed(context, AppConfig.pantallaLogin);*/
  }

  Future _LlamarPage({String pantalla}) async {
    Navigator.pushNamed(context, pantalla);

  }
}
