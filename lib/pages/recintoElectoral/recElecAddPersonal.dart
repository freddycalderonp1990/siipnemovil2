part of '../pages.dart';

class RecElecAddPersonal extends StatefulWidget {
  @override
  _RecElecAddPersonalState createState() => _RecElecAddPersonalState();
}

class _RecElecAddPersonalState extends State<RecElecAddPersonal> {
  UserProvider _UserProvider;
  RecintoAbiertoProvider _RecintoProvider;
  bool peticionServer = false;

  //CONFIGURACIONES
  final anchoContenedor = AppConfig.anchoContenedor;
  final anchoContenedorHijos = AppConfig.anchoContenedorHijos;
  final paddingContenido = 10.0;

  RecintosElectoralesApi _recintosElectoralesApi = new RecintosElectoralesApi();
  GenPersonaApi _genPersonaApi = new GenPersonaApi();

  double sizeIcons;

  String idGenPersona = "0";

  DatosPer _datosPers = new DatosPer(idGenPersona: "0");

  final _formKeyDocumento = GlobalKey<FormState>();
  var controllerDocumento = new TextEditingController();

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
    final responsive = ResponsiveUtil(context);
    sizeIcons =
        responsive.isVertical() ? responsive.altoP(3) : responsive.anchoP(5);
    _UserProvider = UserProvider.of(context);
    _RecintoProvider = RecintoAbiertoProvider.of(context);
    final separcion = 0.5;

    return WorkAreaPageWidget(
      btnAtras: true,
      peticionServer: peticionServer,
      title: VariablesUtil.recElecAgregarpersonal,
      contenido: [
        _RecintoProvider.getRecintoAbierto.isJefe
            ? Container(
                width: responsive.anchoP(70),
                child: BtnIconWidget(
                  iconData: Icons.person,
                  title: "VER PERSONAL",
                  colorTextoIcon: Colors.white,
                  color: Colors.blue.withOpacity(0.70),
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppConfig.pantallaRecElecPersonalDetalle);
                  },
                ),
              )
            : Container(),
        SizedBox(
          height: responsive.anchoP(1),
        ),
        wgCabecera(),
        SizedBox(
          height: responsive.altoP(separcion),
        ),
        wgConsultaIdGenPersonaPorDocumento(),
        SizedBox(
          height: responsive.altoP(separcion),
        ),
        wgDatosPersona(),
        SizedBox(
          height: responsive.altoP(3),
        ),
        btnAsignar(responsive),
      ],
    );
  }

  Widget wgCabecera() {
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
                    size: sizeIcons,
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
                            _UserProvider.getUser.ubicacionSeleccionada.latitude
                                .toString(),
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
                            _UserProvider
                                .getUser.ubicacionSeleccionada.longitude
                                .toString(),
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

  Widget wgConsultaIdGenPersonaPorDocumento() {
    final responsive = ResponsiveUtil(context);
    final sizeTxt = responsive.anchoP(AppConfig.tamTexto + 2.0);

    return ContenedorDesingWidget(
      anchoPorce: anchoContenedor,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),

        // handle your onTap here
        child: Container(
          margin: EdgeInsets.only(left: 0.0, right: 20.0),
          width: responsive.anchoP(55),
          height: responsive.anchoP(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: responsive.altoP(1),
              ),
              Expanded(
                  child: Form(
                key: _formKeyDocumento,
                child: ImputTextWidget(
                  keyboardType: TextInputType.number,
                  controller: controllerDocumento,
                  icono: Icon(
                    Icons.assignment_sharp,
                    color: Colors.black38,
                    size: sizeIcons,
                  ),
                  label: VariablesUtil.cedula,
                  fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
                  validar: validateDocumento,
                ),
              )),
              SizedBox(
                width: responsive.altoP(1),
              ),
              BtnIconWidget(
                onTap: () => _EventoBuscaridGenPersonaPorDocumento(),
                iconData: Icons.search,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget wgDatosPersona() {
    final responsive = ResponsiveUtil(context);

    return _datosPers.idGenPersona != "0"
        ? ContenedorDesingWidget(
            anchoPorce: anchoContenedor,
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                'DATOS',
                style: TextStyle(
                  fontSize: responsive.anchoP(AppConfig.tamTextoTitulo),
                ),
              ),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: responsive.altoP(1),
                        ),
                        TituloDetalleTextWidget(
                          title: "Nombres",
                          detalle: _datosPers.siglas + "." + _datosPers.apenom,
                          mostrarBorder: true,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  Widget btnAsignar(ResponsiveUtil responsive) {
    return _datosPers.idGenPersona != "0"
        ? Container(
            width: responsive.anchoP(anchoContenedor),
            child: BotonesWidget(
              iconData: Icons.app_registration,
              padding: EdgeInsets.symmetric(horizontal: 10),
              title: VariablesUtil.AGREGAR,
              onPressed: () => {
                _asignarPersonalEnRecintoElectoral(
                    idGenPersona: _datosPers.idGenPersona,
                    usuario: _UserProvider.getUser.idGenUsuario,
                    idDgoCreaOpReci:
                        _RecintoProvider.getRecintoAbierto.idDgoCreaOpReci)
              },
            ),
          )
        : Container();
  }

  String validateDocumento(String value) {
    if (value.length < 10) {
      return VariablesUtil.errorCedulaNoValida;
    } else if (_UserProvider.getUser.documento == controllerDocumento.text) {
      return VariablesUtil.ingreseCedulaDistinta;
    }

    return null;
  }

  _EventoBuscaridGenPersonaPorDocumento() async {
    if (peticionServer) return;
    final isValid = _formKeyDocumento.currentState.validate();

    if (isValid) {
      _consultarDatosPersonaPorDocumento(
          usuario: _UserProvider.getUser.idGenUsuario,
          cedula: controllerDocumento.text);
    }
  }

  _consultarDatosPersonaPorDocumento(
      {@required String cedula, @required String usuario}) async {
    try {
      if (peticionServer) return;

      setState(() {
        peticionServer = true;
      });

      _datosPers = await _genPersonaApi.getDatosPersona(
          context: context, usuario: usuario, cedula: cedula);

      print("_datosPers.apenom");

      print(_datosPers.apenom);

      setState(() {
        peticionServer = false;
      });
    } catch (e) {
      print("un error ${e.toString()}");
      setState(() {
        peticionServer = false;
      });
    }
  }

  _asignarPersonalEnRecintoElectoral(
      {@required String idDgoCreaOpReci,
      @required String usuario,
      @required String idGenPersona}) async {
    try {
      if (peticionServer) return;

      setState(() {
        peticionServer = true;
      });

      String latitud =
          _UserProvider.getUser.ubicacionSeleccionada.latitude.toString();
      String longitud =
          _UserProvider.getUser.ubicacionSeleccionada.longitude.toString();

      await _recintosElectoralesApi.asignarPersonalEnRecintoElectoral(
          context: context,
          idDgoCreaOpReci: idDgoCreaOpReci,
          usuario: usuario,
          idGenPersona: idGenPersona,
          latitud: latitud,
          longitud: longitud,
          idDgoReciElect: _RecintoProvider.getRecintoAbierto.idDgoReciElect);

      setState(() {
        peticionServer = false;
      });
    } catch (e) {
      print("un error ${e.toString()}");
      setState(() {
        peticionServer = false;
      });
    }
  }
}
