part of '../pages.dart';

class CrearCodigoUnidadPolicialPage extends StatefulWidget {

  final int idDgoTipoEje;

  const CrearCodigoUnidadPolicialPage({Key key, this.idDgoTipoEje}) : super(key: key);
  @override
  _CrearCodigoUnidadPolicialPageState createState() => _CrearCodigoUnidadPolicialPageState();
}

class _CrearCodigoUnidadPolicialPageState extends State<CrearCodigoUnidadPolicialPage> {
  UserProvider _UserProvider;
  ProcesoOperativoProvider _ProcesoOperativoProvider;

  bool peticionServer = false;
  bool cargarRecintosElectorales = false, cargaInicial = true;

  //CONFIGURACIONES
  final anchoContenedor = AppConfig.anchoContenedor;
  final anchoContenedorHijos = AppConfig.anchoContenedorHijos;
  final paddingContenido = 10.0;

  List<RecintosElectoral> _recintosElectorales = new List();
  AbrirRecintoElectoral _abrirRecintoElectoral = new AbrirRecintoElectoral();

  String  recintoElectoral;
  int idRecintoElectoral = 0;
  String textoDistancia;

  RecintosElectoralesApi _recintosElectoralesApi = new RecintosElectoralesApi();

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

    _UserProvider = UserProvider.of(context);
    _ProcesoOperativoProvider = ProcesoOperativoProvider.of(context);

    return WorkAreaPageWidget(

      btnAtras: true,
      peticionServer: _recintosElectorales.length > 0 ? peticionServer : true,
      title: "GENERAR CÓDIGO",
      contenido: [
        MyUbicacionWidget(

          callback:(_) {
            getRecintosElectoralesInstalaciones();
          },),
        SizedBox(
          height: responsive.altoP(1),
        ),
        getComboInstalacionesUnidadesPoliciales(),
        SizedBox(
          height: responsive.altoP(3),
        ),
        recintoElectoral != null ? btnAbrir(responsive) : Container(),
      ],
    );
  }


  Widget getComboInstalacionesUnidadesPoliciales() {
    List<String> datos = getDatosInstalaciones(_recintosElectorales);

    return ContenedorDesingWidget(
        anchoPorce: anchoContenedor,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: paddingContenido),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: paddingContenido),
                child: ComboConBusqueda(
                  title: VariablesUtil.UnidadPolicial,
                  searchHint: 'Seleccione la ' + VariablesUtil.UnidadPolicial,
                  datos: datos,
                  complete: (dato) {
                    setState(() {
                      recintoElectoral = dato;
                      idRecintoElectoral =
                          getIdInstalaciones(recintoElectoral);
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
                title: "Abrir Operativo",
                message:
                "Usted es la persona encargada o jefe designada a este Operativo",
                onTap: () {
                  Navigator.of(context).pop();
                  _AbrirRecintoElectoral(_UserProvider.getUser.idGenUsuario,
                      idRecintoElectoral.toString());
                });
          }),
    );
  }

  List<String> getDatosInstalaciones(List<RecintosElectoral> _recintosElectorales) {
    List<String> datos = new List();
    for (int i = 0; i < _recintosElectorales.length; i++) {
      //datos.add(_recintosElectorales[i].nomRecintoElec + "\n(Distancia " +_recintosElectorales[i].distance+"m)");
      datos.add(_recintosElectorales[i].nomRecintoElec);
    }
    return datos;
  }

  int getIdInstalaciones(String nomRecintoElec) {
    int id = 0;
    for (int i = 0; i < _recintosElectorales.length; i++) {
      if (_recintosElectorales[i].nomRecintoElec == nomRecintoElec) {
        id = int.parse(_recintosElectorales[i].idDgoReciElect);
        return id;
      }
    }
    return id;
  }

  getRecintosElectoralesInstalaciones() async {
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

      String idDgoProcElec =
          _ProcesoOperativoProvider.getProcesosOperativo.idDgoProcElec;
      //le asigno 1 porque es el id que le corresponde a recintos electorales
      //para solo mostrar los recintos electorales
      String idDgoTipoEje = widget.idDgoTipoEje.toString();

      _recintosElectorales =
      await _recintosElectoralesApi.getRecintosElectoralesCercanos(
        title: VariablesUtil.UNIDADESPOLICIALES,
          msj1: "No existen Unidades Policiales Cercanas",
          context: context,
          latitud: latitud,
          longitud: longitud,
          idDgoProcElec: idDgoProcElec,
          idDgoTipoEje: idDgoTipoEje);



      setState(() {
        peticionServer = false;
        cargaInicial = false;
      });
    } catch (e) {
      setState(() {
        peticionServer = false;
        cargaInicial = false;

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

      String idDgoProcElec= _ProcesoOperativoProvider.getProcesosOperativo.idDgoProcElec;

      _abrirRecintoElectoral =
      await _recintosElectoralesApi.abrirRecintoElectoral(
          context: context,
          idDgoReciElect: idRecintoElectoral,
          idGenPersona: _UserProvider.getUser.idGenPersona,
          usuario: usuario,
          latitud: latitud,
          longitud: longitud,
          idDgoProcElec: idDgoProcElec);

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
              UtilidadesUtil.pantallasAbrirNuevaCerrarTodas(
                  context: context,
                  pantalla: AppConfig.pantallaVerificarOperativoRecintoAbierto);

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
