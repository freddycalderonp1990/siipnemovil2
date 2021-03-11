part of '../pages.dart';

class RecElecRegistrarse extends StatefulWidget {
  @override
  _RecElecRegistrarseState createState() => _RecElecRegistrarseState();
}

class _RecElecRegistrarseState extends State<RecElecRegistrarse> {
  UserProvider _UserProvider;
  RecintoAbiertoProvider _RecintoProvider;
  bool peticionServer = false;

  //CONFIGURACIONES
  final anchoContenedor = AppConfig.anchoContenedor;
  final anchoContenedorHijos = AppConfig.anchoContenedorHijos;
  final paddingContenido = 10.0;

  String idDgoCreaOpReci = "0";

  RecintosElectoralesApi _recintosElectoralesApi = new RecintosElectoralesApi();

  double sizeIcons;

  final _formKey = GlobalKey<FormState>();
  var controllerCodigoRecinto = new TextEditingController();

  DatosRecintoElectoralClass _datosRecintoElectoralClass =
      new DatosRecintoElectoralClass(nomRecintoElec: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UtilidadesUtil.getTheme();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //Variable para obtener el tamaño de la pantalla

    final responsive = ResponsiveUtil(context);
    sizeIcons =
        responsive.isVertical() ? responsive.altoP(3) : responsive.anchoP(5);
    _UserProvider = UserProvider.of(context);
    _RecintoProvider=RecintoAbiertoProvider.of(context);
    final separcion = 0.5;
    String imgFondo=AppConfig.imgFondoDefault;
    if(_RecintoProvider.getRecintoAbierto.isRecinto){
      imgFondo=AppConfig.imgFondoElecciones;
    }


    return WorkAreaPageWidget(
btnAtras: true,
      imgFondo: imgFondo,
      peticionServer: peticionServer,
      title: "ANEXARSE",
      contenido: [
        MyUbicacionWidget(

          callback:(_) {

          },),
        SizedBox(
          height: responsive.altoP(separcion),
        ),
        wgConsultarRecinto(),
        SizedBox(
          height: responsive.altoP(separcion),
        ),
        wgDatosRecinto(),
        SizedBox(
          height: responsive.altoP(3),
        ),
        btnRegistrarse(responsive),
      ],
    );
  }



  Widget wgConsultarRecinto() {
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
                key: _formKey,
                child: ImputTextWidget(
                  keyboardType: TextInputType.number,
                  controller: controllerCodigoRecinto,
                  icono: Icon(
                    Icons.assignment_sharp,
                    color: Colors.black38,
                    size: sizeIcons,
                  ),
                  label: VariablesUtil.codigo,
                  fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
                  validar: validateCodigoRecinto,
                ),
              )),
              SizedBox(
                width: responsive.altoP(1),
              ),
              BtnIconWidget(
                onTap: () => _EventoBuscarRecintoElectoralPorCodigo(),
                iconData: Icons.search,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget wgDatosRecinto() {
    final responsive = ResponsiveUtil(context);

    return _datosRecintoElectoralClass.nomRecintoElec != ""
        ? ContenedorDesingWidget(
            anchoPorce: anchoContenedor,
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                'DATOS DEL OPERATIVO',
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
                          title: "Instalación",
                          detalle: _datosRecintoElectoralClass.nomRecintoElec,
                          mostrarBorder: true,
                        ),
                        TituloDetalleTextWidget(
                          title: "Encargado",
                          detalle: _datosRecintoElectoralClass.encargado,
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

  Widget btnRegistrarse(ResponsiveUtil responsive) {
    return _datosRecintoElectoralClass.nomRecintoElec != ""
        ? Container(
            width: responsive.anchoP(anchoContenedor),
            child: BotonesWidget(
              iconData: Icons.app_registration,
              padding: EdgeInsets.symmetric(horizontal: 10),
              title: VariablesUtil.REGISTRARSE,
              onPressed: () => {
                _asignarPersonalEnRecintoElectoral(
                    idGenPersona: _UserProvider.getUser.idGenPersona,
                    usuario: _UserProvider.getUser.idGenUsuario,
                    idDgoCreaOpReci: idDgoCreaOpReci)
              },
            ),
          )
        : Container();
  }

  String validateCodigoRecinto(String value) {
    if (value.length == 0) {
      return VariablesUtil.codigoOperativoNoValido;
    }

    return null;
  }

  _EventoBuscarRecintoElectoralPorCodigo() async {
    if (peticionServer) return;
    final isValid = _formKey.currentState.validate();

    if (isValid) {
      _consultarDatosEncargadoRecintoPoridCreaRecinto(
          controllerCodigoRecinto.text);
    }
  }

  _consultarDatosEncargadoRecintoPoridCreaRecinto(idDgoCreaOpReci) async {
    try {
      String latitud =
          _UserProvider.getUser.ubicacionSeleccionada.latitude.toString();
      String longitud =
          _UserProvider.getUser.ubicacionSeleccionada.longitude.toString();

      if (peticionServer) return;

      setState(() {
        peticionServer = true;
      });

      _datosRecintoElectoralClass = await _recintosElectoralesApi
          .consultarDatosEncargadoRecintoPoridCreaRecinto(
              context: context, idDgoCreaOpReci: idDgoCreaOpReci);



      this.idDgoCreaOpReci = idDgoCreaOpReci;

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
          idDgoTipoEje:_datosRecintoElectoralClass.idDgoTipoEje ,
          idDgoReciElect: _datosRecintoElectoralClass.idDgoReciElect);

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
