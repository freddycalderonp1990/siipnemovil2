part of '../pages.dart';

class TipoEjeOtrosPage extends StatefulWidget {
  @override
  _TipoEjeOtrosPageState createState() => _TipoEjeOtrosPageState();
}

class _TipoEjeOtrosPageState extends State<TipoEjeOtrosPage> {
  var peticionServer = false;
  UserProvider _UserProvider;
  ProcesoOperativoProvider _ProcesoOperativoProvider;
  bool cargaInicial = true;
  bool existeDataHija = false;

  TiposEjesApi _TiposEjesApi = new TiposEjesApi();
  List<UnidadesPoliciale> listTipoEjeOtros = new List();
  List<UnidadesPoliciale> listTipoEjeOtrosHijas = new List();
  String tipoEjePadre, tipoEjeHija;
  int idTipoEjeEnviar = 0, idtipoEjePadre = 0, idtipoEjeHija = 0;

  //CONFIGURACIONES
  final anchoContenedor = AppConfig.anchoContenedor;
  final anchoContenedorHijos = AppConfig.anchoContenedorHijos;
  final paddingContenido = 10.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.bloc<MiUbicacionBloc>().iniciarSeguimiento();

    listTipoEjeOtros = new List();
    listTipoEjeOtrosHijas = new List();
    UtilidadesUtil.getTheme();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    _UserProvider = UserProvider.of(context);
    _ProcesoOperativoProvider = ProcesoOperativoProvider.of(context);

    String Bienvenido = _UserProvider.getUser.sexo == 'HOMBRE'
        ? VariablesUtil.Bienvenido
        : VariablesUtil.Bienvenida;

    return WorkAreaPageWidget(
      mostrarVersion: false,
      btnAtras: true,
      imgFondo: AppConfig.imgFondoLogin,
      peticionServer: peticionServer,
      title: "OTROS",
      sizeTittle: 7,
      contenido: [
        Container(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: responsive.altoP(2),
              ),
              MyUbicacionWidget(
                callback: (_) {
                  _getTipoEjePadre();
                },
              ),
              SizedBox(
                height: responsive.altoP(1),
              ),
              getComboTipoEjePadres(),
              SizedBox(
                height: responsive.altoP(1),
              ),
              getComboTipoEjeHijas(),
              SizedBox(
                height: responsive.altoP(4),
              ),
              btnContinuar(responsive),
              SizedBox(
                height: responsive.altoP(4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _cerrarSession() {
    //Aquí (Route <dynamic> route) => false se asegurará de que se eliminen todas las rutas antes de hacer push de la ruta .
    Navigator.of(context).pushNamedAndRemoveUntil(
        AppConfig.pantallaLogin, (Route<dynamic> route) => false);

    //Navigator.pushReplacementNamed(context, AppConfig.pantallaLogin);
  }

  List<String> getDatosTipoEje(List<UnidadesPoliciale> lista) {
    List<String> datos = new List();
    if (lista != null) {
      for (int i = 0; i < lista.length; i++) {
        datos.add(lista[i].descripcion);
      }
    }
    return datos;
  }

  int getIdTipoEje(String descripcion, List<UnidadesPoliciale> lista) {
    int id = 0;
    if (lista != null) {
      for (int i = 0; i < lista.length; i++) {
        if (lista[i].descripcion == descripcion) {
          id = int.parse(lista[i].idDgoTipoEje);

          return id;
        }
      }
    }
    return id;
  }

  Widget getComboTipoEjePadres() {
    List<String> datos = getDatosTipoEje(listTipoEjeOtros);

    return ContenedorDesingWidget(
        anchoPorce: anchoContenedor,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: paddingContenido),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: paddingContenido),
                child: ComboConBusqueda(
                  title: "OTROS",
                  searchHint: 'Seleccione una ',
                  datos: datos,
                  complete: (dato) {
                    setState(() {
                      if (dato == null) {
                        tipoEjePadre = '';
                        idtipoEjePadre = 0;
                        tipoEjeHija = '';
                        idtipoEjeHija = 0;
                        existeDataHija = false;
                        listTipoEjeOtrosHijas=new List();
                      } else {
                        tipoEjePadre = dato;

                        idtipoEjePadre =
                            getIdTipoEje(tipoEjePadre, listTipoEjeOtros);

                        if (listTipoEjeOtrosHijas != null) {
                          if (listTipoEjeOtrosHijas.length > 0) {
                            tipoEjeHija = listTipoEjeOtrosHijas[0].descripcion;
                            idtipoEjeHija = int.parse(
                                listTipoEjeOtrosHijas[0].idDgoTipoEje);
                          }
                        }

                        if (idtipoEjePadre > 0) {
                          print("idtipoEjePadre ${idtipoEjePadre}");
                          _getTipoEjePadreNivel1(idtipoEjePadre);
                        }
                      }
                    });
                  },
                ))));
  }

  Widget getComboTipoEjeHijas() {
    print("getComboTipoEjePadresHIjas");
    List<String> datos = getDatosTipoEje(listTipoEjeOtrosHijas);

    if (datos.length > 0) {
      existeDataHija = true;
    } else {
      existeDataHija = false;
    }

    return existeDataHija
        ? ContenedorDesingWidget(
            anchoPorce: anchoContenedor,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: paddingContenido),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: paddingContenido),
                    child: ComboConBusqueda(
                      selectValue: idtipoEjePadre > 0 ? tipoEjeHija : "",
                      title: "OTROS",
                      searchHint: 'Seleccione una',
                      datos: datos,
                      complete: (dato) {
                        setState(() {
                          tipoEjeHija = dato;
                          idtipoEjeHija =
                              getIdTipoEje(tipoEjeHija, listTipoEjeOtrosHijas);
                        });
                      },
                    ))))
        : Container();
  }

  _getTipoEjePadre() async {
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

      listTipoEjeOtros = await _TiposEjesApi.getTipoEjeOtros(
          context: context, usuario: _UserProvider.getUser.idGenUsuario);

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

  _getTipoEjePadreNivel1(int idtipoEjePadre) async {
    try {
      String latitud =
          _UserProvider.getUser.ubicacionSeleccionada.latitude.toString();
      String longitud =
          _UserProvider.getUser.ubicacionSeleccionada.longitude.toString();

      if (peticionServer) return;

      setState(() {
        peticionServer = true;
      });

      print("consulto");

      listTipoEjeOtrosHijas = await _TiposEjesApi.getTipoEjePorIdPadre(
          context: context,
          mostrarMsj: false,
          usuario: _UserProvider.getUser.idGenUsuario,
          idDgoTipoEje: idtipoEjePadre.toString());

      setState(() {
        peticionServer = false;
      });
    } catch (e) {
      setState(() {
        peticionServer = false;
      });
    }
  }

  Widget btnContinuar(ResponsiveUtil responsive) {
    Widget wg = Container(
      width: responsive.anchoP(anchoContenedor),
      child: BotonesWidget(
          iconData: Icons.navigate_next,
          padding: EdgeInsets.symmetric(horizontal: 10),
          title: VariablesUtil.CONTINUAR,
          onPressed: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VerificarGpsPage(pantalla: CrearCodigoOtrosPage(idDgoTipoEje: idTipoEjeEnviar,))));
          }),
    );

    if (idtipoEjeHija > 0) {
      idTipoEjeEnviar = idtipoEjeHija;
    } else if (idtipoEjePadre > 0) {
      idTipoEjeEnviar = idtipoEjePadre;
    } else {
      wg = Container();
    }

    if (existeDataHija) {
      if (idtipoEjeHija == 0) {
        wg = Container();
      }
    }

    if (idtipoEjePadre == 0) {
      wg = Container();
    }

    return wg;
  }
}
