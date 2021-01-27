part of '../pages.dart';

class MenuRecintoElectoral extends StatefulWidget {
  @override
  _MenuRecintoElectoralState createState() => _MenuRecintoElectoralState();
}

class _MenuRecintoElectoralState extends State<MenuRecintoElectoral> {
  UserProvider _UserProvider;
  RecintoAbiertoProvider _RecintoProvider;
  bool peticionServer = false;
  bool cargaInicial = true;

  String totalPersonal="0";
  String totalNovedades="0";

  RecintosElectoralesApi _recintosElectoralesApi = new RecintosElectoralesApi();
  NovedadesElectoralesApi _novedadesElectoralesApi =new NovedadesElectoralesApi();

  String idDgoCreaOpReci, nombreRecinto = "", encargadoRecinto, idDgoReciElect;

  double separacionBtnMenu = 1.5;
  Widget wgMenu = Container();

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
    _RecintoProvider = RecintoAbiertoProvider.of(context);

    String Bienvenido = _UserProvider.getUser.sexo == 'H'
        ? VariablesUtil.Bienvenida
        : VariablesUtil.Bienvenido;

    _verificarPersonalEncargadoAsignadoRecElectPorIdGenPersona(
        _UserProvider.getUser.idGenPersona, responsive);
    return WorkAreaPageWidget(
      peticionServer: peticionServer,
      title: nombreRecinto != ""
          ? nombreRecinto
          : "MENÚ SISTEMA RECINTO ELECTORAL",
      imgPerfil: _UserProvider.getUser.foto,
      contenido: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppConfig.radioBordecajas),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white60.withOpacity(0.3),
                            blurRadius: 10)
                      ]),
                  child: Text(
                    Bienvenido + _UserProvider.getUser.apenom,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.anchoP(3.5)),
                  )),
              SizedBox(
                height: responsive.altoP(2),
              ),
              wgMenu
            ],
          ),
        ),
        SizedBox(
          height: responsive.altoP(1),
        ),
        Container(
          width: responsive.anchoP(30),
          child: BtnIconWidget(
            iconData: Icons.exit_to_app,
            title: VariablesUtil.Salir,
            colorTextoIcon: Colors.white,
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
    Navigator.pushReplacementNamed(context, AppConfig.pantallaLogin);
  }

  _getMenu(ResponsiveUtil responsive) {
    return Column(
      children: [
        BtnMenuWidget(
            img: AppConfig.icon_abrir_rec_elec,
            titlte: VariablesUtil.recElecAbrir,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          VerificarGpsPage(pantalla: RecElecAbrir())));
            }),
        SizedBox(
          height: responsive.altoP(separacionBtnMenu),
        ),
        BtnMenuWidget(
            img: AppConfig.icon_registrarse_rec_elect,
            titlte: VariablesUtil.recElecRegistrarseRecintoElectoral,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          VerificarGpsPage(pantalla: RecElecRegistrarse())));
            }),
        SizedBox(
          height: responsive.altoP(separacionBtnMenu),
        ),
      ],
    );
  }

  _getMenuJefe(ResponsiveUtil responsive) {
    return Column(
      children: [
        _wgCodigoRecinto(responsive),
        BtnMenuWidget(
            img: AppConfig.icon_agregar_personal,
            titlte: VariablesUtil.recElecAgregarpersonal,
            onTap: () {
              Navigator.pushNamed(
                  context, AppConfig.pantallaRecElecAddPersonal);
            }),
        SizedBox(
          height: responsive.altoP(separacionBtnMenu),
        ),
        BtnMenuWidget(
            img: AppConfig.icon_registrar_novedades_rec_elec,
            titlte: VariablesUtil.recElecRegistrarNovedades,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerificarGpsPage(
                          pantalla: RecElecRegistrarNovedades())));
            }),
        SizedBox(
          height: responsive.altoP(separacionBtnMenu),
        ),
        BtnMenuWidget(
            img: AppConfig.icon_finalizar_rec_elec,
            titlte: VariablesUtil.recElecFinalizarRecintoElectoral,
            onTap: () =>_getReporteFinal(responsive)),
        SizedBox(
          height: responsive.altoP(separacionBtnMenu),
        ),
        BtnMenuWidget(
            img: AppConfig.icon_eliminar_rec_elec,
            titlte: VariablesUtil.recElecEliminarRecintoElectoral,
            onTap: () {
              DialogosWidget.alertSiNo(context,
                  title: "Eliminar Recinto Electoral",
                  message:
                      "¿Esta seguro que desea eliminar el Recinto Electoral.?",
                  onTap: () {
                Navigator.of(context).pop();
                _EliminarRecintoElectoral(
                    usuario: _UserProvider.getUser.idGenUsuario,
                    idDgoCreaOpReci:
                        _RecintoProvider.getRecintoAbierto.idDgoCreaOpReci);
              });
            }),
      ],
    );
  }

  _getMenuNoJefe(ResponsiveUtil responsive) {
    return Column(
      children: [
        _wgCodigoRecinto(responsive),
        BtnMenuWidget(
            img: AppConfig.icon_registrar_novedades_rec_elec,
            titlte: VariablesUtil.recElecRegistrarNovedades,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerificarGpsPage(
                          pantalla: RecElecRegistrarNovedades())));
            }),
        SizedBox(
          height: responsive.altoP(separacionBtnMenu),
        ),
        BtnMenuWidget(
            img: AppConfig.icon_abandonar_rec_elec,
            titlte: VariablesUtil.recElecAbandonarRecintoElectoral,
            onTap: () {
              DialogosWidget.alertSiNo(context,
                  title: "Abandonar Recinto Electoral",
                  message:
                      "¿Esta seguro que desea abandonar el Recinto Electoral.?",
                  onTap: () {
                Navigator.of(context).pop();
                _AbandonarRecintoElectoral(
                    usuario: _UserProvider.getUser.idGenUsuario,
                    idDgoPerAsigOpe:
                        _RecintoProvider.getRecintoAbierto.idDgoPerAsigOpe);
              });
            }),
      ],
    );
  }

  _wgCodigoRecinto(ResponsiveUtil responsive) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white12.withOpacity(0.5), blurRadius: 10)
                ]),
            child: Text(
              "CÓDIGO RECINTO ELECTORAL:",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.anchoP(4.5)),
            )),
        Container(
          width: responsive.anchoP(30),
          child: BtnIconWidget(
            title: idDgoCreaOpReci,
            colorTextoIcon: Colors.white,
            color: Colors.blue.withOpacity(0.65),
          ),
        ),
        SizedBox(
          height: responsive.altoP(0.5),
        ),
        SizedBox(
          height: responsive.altoP(separacionBtnMenu),
        ),
      ],
    );
  }

//Metodo para saber si el usuario esta asignado a un recinto electoral
  //en caso de true es personal asignado y no jefe
  _verificarPersonalEncargadoAsignadoRecElectPorIdGenPersona(
      String idGenPersona, ResponsiveUtil responsive) async {
    try {
      if (!cargaInicial) return;
      if (peticionServer) return;

      setState(() {
        peticionServer = true;
      });
      RecintosElectoralesAbiertos _RecintosElectoralesAbiertos =
          await _recintosElectoralesApi
              .verificarPersonalEncargadoAsignadoRecElectPorIdGenPersona(
                  context: context, idGenPersona: idGenPersona);

      if (_RecintosElectoralesAbiertos.idDgoCreaOpReci == "0") {
        //Carga el menu normal
        wgMenu = _getMenu(responsive);
      } else {
        idDgoCreaOpReci = _RecintosElectoralesAbiertos.idDgoCreaOpReci;
        nombreRecinto = _RecintosElectoralesAbiertos.nomRecintoElec;
        encargadoRecinto = _RecintosElectoralesAbiertos.encargado;

        idDgoReciElect = _RecintosElectoralesAbiertos.idDgoReciElect;

        _RecintoProvider.setRecinto(_RecintosElectoralesAbiertos);

        if (_RecintosElectoralesAbiertos.isJefe) {
          wgMenu = _getMenuJefe(responsive);
        } else {
          wgMenu = _getMenuNoJefe(responsive);
        }
      }

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

  _EliminarRecintoElectoral(
      {@required String usuario, @required String idDgoCreaOpReci}) async {
    try {
      if (peticionServer) return;

      setState(() {
        peticionServer = true;
      });

      bool res = await _recintosElectoralesApi.eliminarRecintoElectoralAbierto(
        context: context,
        idDgoCreaOpReci: idDgoCreaOpReci,
        usuario: usuario,
      );

      setState(() {
        peticionServer = false;
      });
    } catch (e) {
      setState(() {
        peticionServer = false;
      });
    }
  }

  _AbandonarRecintoElectoral(
      {@required String usuario, @required String idDgoPerAsigOpe}) async {
    try {
      if (peticionServer) return;

      setState(() {
        peticionServer = true;
      });

      bool res = await _recintosElectoralesApi.abandonarRecintoElectoral(
        context: context,
        idDgoPerAsigOpe: idDgoPerAsigOpe,
        usuario: usuario,
      );

      setState(() {
        peticionServer = false;
      });
    } catch (e) {
      setState(() {
        peticionServer = false;
      });
    }
  }

  _getReporteFinal(ResponsiveUtil responsive) async{

    await _ConusltarPersonalAsignado(responsive);

    /* DialogosWidget.alertSiNo(context,
                  title: "Finaliza Proceso Electoral",
                  message:
                  "¿Esta seguro que desea finalizar el proceso electoral.?",
                  onTap: () {
                    Navigator.of(context).pop();
                    _FinalizarRecintoElectoral(usuario: _UserProvider.getUser.idGenUsuario,idDgoCreaOpReci: _RecintoProvider.getRecintoAbierto.idDgoCreaOpReci);
                  });*/
  }

  _FinalizarRecintoElectoral(
      {@required String usuario, @required String idDgoCreaOpReci}) async {
    try {
      if (peticionServer) return;

      setState(() {
        peticionServer = true;
      });

      bool res = await _recintosElectoralesApi.finalizarRecintoElectoral(
        context: context,
        idDgoCreaOpReci: idDgoCreaOpReci,
        usuario: usuario,
      );

      setState(() {
        peticionServer = false;
      });
    } catch (e) {
      setState(() {
        peticionServer = false;
      });
    }
  }


  _ConusltarPersonalAsignado(ResponsiveUtil responsive) async {
    try {

      if (peticionServer) return;

      setState(() {
        peticionServer = true;
      });

      List<PersonalRecintoElectoral>  _ListPersonalRecintoElectoral = await _recintosElectoralesApi
          .consultarDatosPersonalAsignadoRecintoElectoral(
        context: context,
        idDgoCreaOpReci: _RecintoProvider.getRecintoAbierto.idDgoCreaOpReci,
      );
      totalPersonal=_ListPersonalRecintoElectoral.length.toString();

      setState(() {
        peticionServer = false;

      });

      _ConusltarNovedadesRecinto(responsive);
    } catch (e) {
      print("un error ${e.toString()}");
      setState(() {
        peticionServer = false;

      });
    }
  }

  _ConusltarNovedadesRecinto(ResponsiveUtil responsive) async {
    try {

      if (peticionServer) return;

      setState(() {
        peticionServer = true;
      });

      List<NovedadesElectoralesDetalle> _ListNovedadesRecinto = await _novedadesElectoralesApi
          .getDetalleNovedadesPorRecinto(
        mostrarMsj: false,
        context: context,
        idDgoCreaOpReci: _RecintoProvider.getRecintoAbierto.idDgoCreaOpReci,
      );
  totalNovedades=_ListNovedadesRecinto.length.toString();

  print("termina consulta");
      setState(() {
        peticionServer = false;

      });




      print("ahora dibujp consulta");
      Widget wg=Column(
        children: [
          Container(
            width: responsive.anchoP(70),
            child: TituloTextWidget(
              textAlign: TextAlign.center,
              title:
              _RecintoProvider.getRecintoAbierto.nomRecintoElec,
            ),
          ),
          TituloDetalleTextWidget(
            title: "Total Personal",
            detalle: totalPersonal,
            mostrarBorder: true,
          ),
          TituloDetalleTextWidget(
            title: "Total Novedades",
            detalle: totalNovedades,
            mostrarBorder: true,
          ),
          DialogosWidget.getDialogoMsj(
              "¿Esta seguro que desea finalizar el proceso electoral.?")
        ],
      );


      DialogosWidget.alertPersonalizableSiNo(context,
          title: "Finaliza Proceso Electoral",
          widget: wg,
          onPress: (){
            Navigator.of(context).pop();
            _FinalizarRecintoElectoral(usuario: _UserProvider.getUser.idGenUsuario,idDgoCreaOpReci: _RecintoProvider.getRecintoAbierto.idDgoCreaOpReci);
          });








    } catch (e) {
      print("un error ${e.toString()}");
      setState(() {
        peticionServer = false;

      });
    }
  }
}
