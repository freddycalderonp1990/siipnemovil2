part of 'pages.dart';

class MenuSatPage extends StatefulWidget {
  @override
  _MenuSatPageState createState() => _MenuSatPageState();
}

class _MenuSatPageState extends State<MenuSatPage> {
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

    return WorkAreaPageWidget(
      btnAtras: true,
      peticionServer: peticionServer,
      title: "MENÚ SISTEMA ALERTAS TEMPRANAS",
      imgPerfil: _UserProvider.getUser.foto,
      contenido: <Widget>[

        SizedBox(
          height: responsive.altoP(1),
        ),
        BtnMenuWidget(
            titlte: VariablesUtil.satRegistroVictimas,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          VerificarGpsPage(pantalla: SatRegistroVictimaPage())));
            }),
        SizedBox(
          height: responsive.altoP(2),
        ),
        BtnMenuWidget(
            titlte: VariablesUtil.satVisitasVictimas,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          VerificarGpsPage(pantalla: SatMapaVisitasVictimasPage())));
            }),
        SizedBox(
          height: responsive.altoP(2),
        ),
        BtnMenuWidget(
            titlte: VariablesUtil.satRegistrarParte,
            onTap: () {
              Navigator.pushNamed(context, AppConfig.pantallaSatRegistroParte);
            }),
        SizedBox(
          height: responsive.altoP(3.5),
        ),
      ],
    );
  }



}
