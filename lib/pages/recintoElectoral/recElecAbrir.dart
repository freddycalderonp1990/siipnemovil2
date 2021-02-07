part of '../pages.dart';

class RecElecAbrir extends StatefulWidget {
  @override
  _RecElecAbrirState createState() => _RecElecAbrirState();
}

class _RecElecAbrirState extends State<RecElecAbrir> {
  UserProvider _UserProvider;
  bool peticionServer = false;
  bool cargarRecintosElectorales = false, cargaInicial = true;

  //CONFIGURACIONES
  final anchoContenedor = AppConfig.anchoContenedor;
  final anchoContenedorHijos = AppConfig.anchoContenedorHijos;
  final paddingContenido = 10.0;

  List<RecintosElectoral> _recintosElectorales = new List();
  AbrirRecintoElectoral _abrirRecintoElectoral = new AbrirRecintoElectoral();

  String provincia, canto, recintoElectoral;
  int idRecintoElectoral = 0;
  String textoDistancia;

  RecintosElectoralesApi _recintosElectoralesApi = new RecintosElectoralesApi();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.bloc<MiUbicacionBloc>().iniciarSeguimiento();
    UtilidadesUtil.getTheme();
  }

  @override
  void dispose() {
    context.bloc<MiUbicacionBloc>().cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //Variable para obtener el tamaño de la pantalla

    final responsive = ResponsiveUtil(context);

    _UserProvider = UserProvider.of(context);

    return WorkAreaPageWidget(
      btnAtras: true,
      peticionServer: _recintosElectorales.length > 0 ? peticionServer : true,
      title: VariablesUtil.recElecAbrir,
      contenido: [
        cabecera(context),
        SizedBox(
          height: responsive.altoP(1),
        ),
        getComboRecintoElectoral(),
        SizedBox(
          height: responsive.altoP(3),
        ),
        recintoElectoral != null ? btnAbrir(responsive) : Container(),
      ],
    );
  }

  Widget cabecera(BuildContext context) {
    final responsive = ResponsiveUtil(context);

    return ContenedorDesingWidget(
        anchoPorce: anchoContenedor,
        child: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
            builder: (context, state) => getUbicacion(responsive, state)));
  }

  Widget getUbicacion(ResponsiveUtil responsive, MiUbicacionState state) {
    if (!state.existeUbicacion)
      return Center(child: Text('Obteniendo Ubicando...'));

    if (_UserProvider.getUser.ubicacionSeleccionada == null) {
      _UserProvider.getUser.ubicacionSeleccionada = state.ubicacion;
    }

    String latitud =
        _UserProvider.getUser.ubicacionSeleccionada.latitude.toString();
    String longitud =
        _UserProvider.getUser.ubicacionSeleccionada.longitude.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getRecintosElectorales();
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Container(
            width: responsive.anchoP(anchoContenedor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Colors.red,
                    size: responsive.isVertical()
                        ? responsive.altoP(2)
                        : responsive.anchoP(5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: Text(
                    VariablesUtil.Ubicacion,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.anchoP(AppConfig.tamTextoTitulo)),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: responsive.anchoP(15.5),
                            child: Text(
                              "Latitud: ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      responsive.anchoP(AppConfig.tamTexto)),
                            ),
                          ),
                          Text(
                            latitud,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    responsive.anchoP(AppConfig.tamTexto)),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: responsive.anchoP(15.5),
                            child: Text(
                              "Longitud: ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      responsive.anchoP(AppConfig.tamTexto)),
                            ),
                          ),
                          Text(
                            longitud,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    responsive.anchoP(AppConfig.tamTexto)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: responsive.anchoP(1),
                ),
              ],
            ),
          ),
          SizedBox(
            height: responsive.altoP(0.4),
          )
        ],
      ),
    );
  }

  Widget getComboRecintoElectoral() {
    List<String> datos = getDatosRecinto(_recintosElectorales);

    return ContenedorDesingWidget(
        anchoPorce: anchoContenedor,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: paddingContenido),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: paddingContenido),
                child: ComboConBusqueda(
                  title: VariablesUtil.recintoElectoral,
                  searchHint: 'Seleccione el ' + VariablesUtil.recintoElectoral,
                  datos: datos,
                  complete: (dato) {
                    setState(() {
                      recintoElectoral = dato;
                      idRecintoElectoral =
                          getIdRecintoElectoral(recintoElectoral);
                    });
                  },
                ))));
  }

  Widget btnAbrir(ResponsiveUtil responsive) {
    return Container(
      width: responsive.anchoP(anchoContenedor),
      child: BotonesWidget(
          iconData: Icons.open_in_browser_outlined,
          padding: EdgeInsets.symmetric(horizontal: 10),
          title: VariablesUtil.ABRIR,
          onPressed: () {
            DialogosWidget.alertSiNo(context,
                title: "Abrir Recinto Electoral",
                message:
                    "Usted es la persona encargada o jefe designada a este recinto electoral",
                onTap: () {
              Navigator.of(context).pop();
              _AbrirRecintoElectoral(_UserProvider.getUser.idGenUsuario,
                  idRecintoElectoral.toString());
            });
          }),
    );
  }

  List<String> getDatosRecinto(List<RecintosElectoral> _recintosElectorales) {
    List<String> datos = new List();
    for (int i = 0; i < _recintosElectorales.length; i++) {
      //datos.add(_recintosElectorales[i].nomRecintoElec + "\n(Distancia " +_recintosElectorales[i].distance+"m)");
      datos.add(_recintosElectorales[i].nomRecintoElec);
    }
    return datos;
  }

  int getIdRecintoElectoral(String nomRecintoElec) {
    int id = 0;
    for (int i = 0; i < _recintosElectorales.length; i++) {
      if (_recintosElectorales[i].nomRecintoElec == nomRecintoElec) {
        id = int.parse(_recintosElectorales[i].idDgoReciElect);
        return id;
      }
    }
    return id;
  }

  _getRecintosElectorales() async {
    try {
      String latitud =
          _UserProvider.getUser.ubicacionSeleccionada.latitude.toString();
      String longitud =
          _UserProvider.getUser.ubicacionSeleccionada.longitude.toString();

      if (!cargaInicial) return;

      if (peticionServer) return;

      setState(() {
        peticionServer = true;
      });

      _recintosElectorales =
          await _recintosElectoralesApi.getRecintosElectoralesCercanos(
              context: context, latitud: latitud, longitud: longitud);

      context.bloc<MiUbicacionBloc>().cancelarSeguimiento();

      setState(() {
        peticionServer = false;
        cargaInicial = false;
      });
    } catch (e) {
      setState(() {
        peticionServer = false;
      });
    }
  }

  _AbrirRecintoElectoral(String usuario, String idRecintoElectoral) async {
    try {
      print("hola");
      if (peticionServer) return;

      setState(() {
        peticionServer = true;
      });

      String latitud =
          _UserProvider.getUser.ubicacionSeleccionada.latitude.toString();
      String longitud =
          _UserProvider.getUser.ubicacionSeleccionada.longitude.toString();
      print("que pasaaaa");
      _abrirRecintoElectoral =
          await _recintosElectoralesApi.abrirRecintoElectoral(
              context: context,
              idDgoReciElect: idRecintoElectoral,
              idGenPersona: _UserProvider.getUser.idGenPersona,
              usuario: usuario,
              latitud: latitud,
              longitud: longitud);

      if (_abrirRecintoElectoral.estado == "A") {
        DialogosWidget.alert(context,
            title: VariablesUtil.INFORMACION,
            message: _abrirRecintoElectoral.apenom +
                "\nYa ha realizado la apertura del recinto electoral \n\n" +
                recintoElectoral +
                "\nFECHA INICIO: " +
                _abrirRecintoElectoral.fechaIni +
                "\n\nSi usted necesita abrir este mismo recinto electoral debe de eliminar  el que se encuentra abierto.");
      } else {
        DialogosWidget.alert(context,
            title: "CODIGO",
            message:
                "El Codigo para que el personal se anexe al recinto electoral es: " +
                    _abrirRecintoElectoral.idDgoCreaOpReci, onTap: () {

          UtilidadesUtil.pantallasAbrirNuevaCerrarTodas(context: context,pantalla: AppConfig.pantallaMenuRecintoElectoral);

         /* Navigator.pushReplacementNamed(
              context, AppConfig.pantallaMenuRecintoElectoral);*/
        });
      }



      setState(() {
        peticionServer = false;
        cargaInicial = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        cargaInicial = false;
        peticionServer = false;
      });
    }
  }
}
