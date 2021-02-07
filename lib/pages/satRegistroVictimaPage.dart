part of 'pages.dart';

class SatRegistroVictimaPage extends StatefulWidget {
  @override
  _SatRegistroVictimaPageState createState() => _SatRegistroVictimaPageState();
}

class _SatRegistroVictimaPageState extends State<SatRegistroVictimaPage> {
  var fecha = "";
  DateTime selectedDate = DateTime.now();
  bool mostrarDatos = false;

  bool peticionServer = false;
  UserProvider _UserProvider;

  //CONFIGURACIONES
  final anchoContenedor = AppConfig.anchoContenedor;
  final anchoContenedorHijos =AppConfig.anchoContenedorHijos
      ; // para mostra el tamaño de los hijos dentro del contenedor, este valor se resta al ancho total que tenga la pantalla  responsive.anchoP(anchoContenedor)-20.0
  Color colorIcons = AppConfig.colorIcons;

  //Variables para datos de la víctima
  bool isNacionalVictima = true;
  final _keyCedulaVicitma = GlobalKey<FormState>();

  int selectNacionalidadVictima = 1; //1=Nacional, 2 Extranjero
  String nacionalidadVictima = VariablesUtil.NACIONAL;

  TextEditingController controllerCedulaVictima = new TextEditingController();
  TextEditingController controllerNombresVictima = new TextEditingController();
  TextEditingController controllerApellidosVictima =
      new TextEditingController();
  TextEditingController controllerEdadVictima = new TextEditingController();
  final _KeyDatosVictima = GlobalKey<FormState>();
  TextEditingController controllerDireccionVictima =
      new TextEditingController();
  TextEditingController controllerReferenciaVictima =
      new TextEditingController();
  String tipoVivienda, tipoResidencia, relacionConAgresor, medidasProteccion;
  TextEditingController controllerTelefonoPersonalVictima =
      new TextEditingController();
  TextEditingController controllerTelefonoContactoVictima =
      new TextEditingController();
  List<int> selectedItemsMedidasproteccion = new List();

  //Variables para datos del agresor
  bool isNacionalAgresor = true;
  final _keyCedulaAgresor = GlobalKey<FormState>();

  int selectNacionalidadAgresor = 1; //1=Nacional, 2 Extranjero
  String nacionalidadAgresor = VariablesUtil.NACIONAL;
  TextEditingController controllerCedulaAgresor = new TextEditingController();
  TextEditingController controllerNombresAgresor = new TextEditingController();
  TextEditingController controllerApellidosAgresor =
      new TextEditingController();
  final _KeyDatosAgresor = GlobalKey<FormState>();

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
    _UserProvider = UserProvider.of(context);
    fecha = DateFormat(AppConfig.formatoFechaHora).format(selectedDate);
    final responsive = ResponsiveUtil(context);

    return WorkAreaPageWidget(
      peticionServer: peticionServer,

      title: VariablesUtil.satRegistroVictimas,
      btnAtras: true,
      contenido: <Widget>[
        Text(
          fecha,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: responsive.anchoP(3.5)),
        ),
        cabecera(context),
        SizedBox(
          height: responsive.altoP(1),
        ),
        datosVictima(context),
        SizedBox(
          height: responsive.altoP(1),
        ),
        relacionConAgresor != null ? datosAgresor(context) : Container(),
        SizedBox(
          height: responsive.altoP(3),
        ),
        Container(
          width: responsive.anchoP(anchoContenedor),
          child: BotonesWidget(
            iconData: Icons.save,
            padding: EdgeInsets.symmetric(horizontal: 10),
            title: VariablesUtil.GUARDAR,
            onPressed: () => {},
          ),
        )
      ],
    );
  }

  Widget cabecera(BuildContext context) {
    final responsive = ResponsiveUtil(context);

    return ContenedorDesingWidget(
        anchoPorce: anchoContenedor,
        child: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
            builder: (context, state) => getContenido(responsive, state)));
  }

  Widget getContenido(ResponsiveUtil responsive, MiUbicacionState state) {
    if (!state.existeUbicacion)
      return Center(child: Text('Obteniendo Ubicando...'));

    if(_UserProvider.getUser.ubicacionSeleccionada==null){
      _UserProvider.getUser.ubicacionSeleccionada=state.ubicacion;
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
                            _UserProvider.getUser.ubicacionSeleccionada.latitude.toString(),
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
                            _UserProvider.getUser.ubicacionSeleccionada.longitude.toString(),
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
                Container(
                  padding: EdgeInsets.only(left: 5.0),
                  child: BtnIconWidget(
                    elevation: 0.5,
                    title: "",
                    onTap: () {
                      Navigator.pushNamed(context, AppConfig.pantallaSatMapasRegistroVictimas);
                    },
                    colorTextoIcon: Colors.red,
                    iconData: Icons.location_on_outlined,
                  ),
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

  _EventoBuscarDatosPorCedulaVictima() async {
    if (peticionServer) return;
    final isValid = _keyCedulaVicitma.currentState.validate();
    /* final _VehiculoApi = VehiculoApi();

    if (isValid) {
      setState(() {
        //setState cambia el estado del widget como se va a mostrar un CargandoWidget se necesita actualizar el widget
        peticionServer = true;
      });

      VehiculoModel _vehiculo = await _VehiculoApi.getPlaca( context,placa:placa,idGenPersona:_UserProvider.getUser.idGenPersona );

      setState(() {
        peticionServer = false;
      });
      if (_vehiculo != null) {
        if (_vehiculo.vehiculos.msj == ConstApi.varExiste) {
          datoVehiculo = _vehiculo.vehiculos.datos[0];
          if (datoVehiculo.codeMsj2 <= 0) {
            setState(() {
              placaEncontrada = true;
            });
          } else {
            DialogosWidget.alert(context,
                title: VariablesUtil.PLACA, message: datoVehiculo.msj2);
          }
        } else {
          DialogosWidget.alert(context,
              title: VariablesUtil.PLACA, message: VariablesUtil.placaNoExiste);
        }
      }
    }*/
  }

  //VALIDACIONES DE LA VÍCTIMA
  String validateCedulaVictima(String value) {
    if (value.length < 10) {
      return VariablesUtil.ingreseCedulaVictima;
    }

    return null;
  }

  String validateNombresVictima(String value) {
    if (value.length < 10) {
      return VariablesUtil.ingreseNombreVictima;
    }
    return null;
  }

  String validateApellidosVictima(String value) {
    if (value.length < 10) {
      return VariablesUtil.ingreseApellidoVictima;
    }
    return null;
  }

  String validateEdadVictima(String value) {
    if (value.length > 0 && int.parse(value) > 0) {
      return VariablesUtil.ingreseEdadVictima;
    }
    return null;
  }

  String validateDireccionVictima(String value) {
    if (value.length < 10) {
      return VariablesUtil.ingreseDireccionVictima;
    }
    return null;
  }

  String validateTelefonoPersonal(String value) {
    if (value.length < 10) {
      return VariablesUtil.ingreseTelefonoPersonalVictima;
    }
    return null;
  }

  //VALIDACIONES DEL AGRESOR
  String validateCedulaAgresor(String value) {
    if (value.length < 10) {
      return VariablesUtil.ingreseCedulaAgresor;
    }

    return null;
  }

  String validateNombresAgresor(String value) {
    if (value.length < 10) {
      return VariablesUtil.ingreseNombreAgresor;
    }
    return null;
  }

  String validateApellidosAgresor(String value) {
    if (value.length < 10) {
      return VariablesUtil.ingreseApellidoAgresor;
    }
    return null;
  }

  String validateEdadAgresor(String value) {
    if (value.length > 0 && int.parse(value) > 0) {
      return VariablesUtil.ingreseEdadAgresor;
    }
    return null;
  }

  //WIDGET VíCTIMA

  Widget datosVictima(BuildContext context) {
    final responsive = ResponsiveUtil(context);

    return ContenedorDesingWidget(
      anchoPorce: anchoContenedor,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          'DATOS DE LA VÍCTIMA',
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
                  widgetComboNacionalidadVictima(responsive),
                  widgetCedulaVictima(responsive),
                  widgetEdiTextDatosVictima(responsive)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget widgetComboNacionalidadVictima(ResponsiveUtil responsive) {
    return Container(
      width: responsive.anchoP(anchoContenedor) - anchoContenedorHijos,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
            focusColor: Colors.black,
            value: 1,
            groupValue: selectNacionalidadVictima,
            onChanged: getNacionalidadVictima,
          ),
          new Text(
            VariablesUtil.NACIONAL,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: responsive.anchoP(AppConfig.tamTextoTitulo),
              color: Colors.black,
            ),
          ),
          new Radio(
            focusColor: Colors.black,
            value: 2,
            groupValue: selectNacionalidadVictima,
            onChanged: getNacionalidadVictima,
          ),
          new Text(
            VariablesUtil.EXTRANJERO,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: responsive.anchoP(AppConfig.tamTextoTitulo),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetCedulaVictima(ResponsiveUtil responsive) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      // handle your onTap here
      child: Container(
        margin: EdgeInsets.only(left: 0.0, right: 20.0),
        width: responsive.anchoP(anchoContenedor) - anchoContenedorHijos,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: responsive.altoP(1),
            ),
            Expanded(
                child: Form(
              key: _keyCedulaVicitma,
              child: ImputTextWidget(
                controller: controllerCedulaVictima,
                icono: Icon(
                  Icons.tab,
                  color: colorIcons,
                ),
                activar: true,
                label: VariablesUtil.CedulaVictima,
                fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
                validar: validateCedulaVictima,
              ),
            )),
            SizedBox(
              width: responsive.altoP(1),
            ),
            isNacionalVictima
                ? BtnIconWidget(
                    onTap: () => _EventoBuscarDatosPorCedulaVictima(),
                    iconData: Icons.search,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget widgetEdiTextDatosVictima(ResponsiveUtil responsive) {
    final double fonSize = responsive.anchoP(AppConfig.tamTextoTitulo);
    return Container(
      width: responsive.anchoP(anchoContenedor) - anchoContenedorHijos,
      child: Form(
        key: _KeyDatosVictima,
        child: Column(
          children: [
            ImputTextWidget(
              elevation: 1,
              icono: Icon(
                Icons.person,
                color: colorIcons,
              ),
              controller: controllerNombresVictima,
              label: VariablesUtil.Nombres,
              fonSize: fonSize,
              validar: validateNombresVictima,
              activar: !isNacionalVictima,
            ),
            ImputTextWidget(
              elevation: 1,
              icono: Icon(
                Icons.person,
                color: colorIcons,
              ),
              controller: controllerApellidosVictima,
              label: VariablesUtil.Apellidos,
              fonSize: fonSize,
              validar: validateApellidosVictima,
              activar: !isNacionalVictima,
            ),
            ImputTextWidget(
              elevation: 1,
              icono: Icon(
                Icons.calendar_today_sharp,
                color: colorIcons,
              ),
              controller: controllerApellidosVictima,
              keyboardType: TextInputType.number,
              label: VariablesUtil.Edad,
              fonSize: fonSize,
              validar: validateEdadVictima,
              activar: !isNacionalVictima,
            ),
            ImputTextWidget(
              elevation: 1,
              icono: Icon(
                Icons.directions,
                color: colorIcons,
              ),
              controller: controllerDireccionVictima,
              label: VariablesUtil.Direccion,
              fonSize: fonSize,
              validar: validateDireccionVictima,
            ),
            ImputTextWidget(
              elevation: 1,
              icono: Icon(
                Icons.directions,
                color: colorIcons,
              ),
              controller: controllerReferenciaVictima,
              label: VariablesUtil.Referencia,
              fonSize: fonSize,
            ),
            ComboConBusqueda(
              title: VariablesUtil.TipoVivienda,
              searchHint: 'Seleccione el ' + VariablesUtil.TipoVivienda,
              datos: ['1', '2', '3'],
              complete: (dato) {
                tipoVivienda = dato;
              },
            ),
            ComboConBusqueda(
              title: VariablesUtil.TipoResidencia,
              searchHint: 'Seleccione el ' + VariablesUtil.TipoResidencia,
              datos: ['1', '2', '3'],
              complete: (dato) {
                tipoResidencia = dato;
              },
            ),
            ImputTextWidget(
              elevation: 1,
              icono: Icon(
                Icons.phone_android,
                color: colorIcons,
              ),
              controller: controllerTelefonoPersonalVictima,
              keyboardType: TextInputType.number,
              label: VariablesUtil.TelefonoPersonal,
              fonSize: fonSize,
              validar: validateTelefonoPersonal,
            ),
            ImputTextWidget(
              elevation: 1,
              icono: Icon(
                Icons.phone_android,
                color: colorIcons,
              ),
              controller: controllerTelefonoContactoVictima,
              keyboardType: TextInputType.number,
              label: VariablesUtil.TelefonoContacto,
              fonSize: fonSize,
            ),
            ComboConBusqueda(
              title: VariablesUtil.RelacionAgresor,
              searchHint: 'Seleccione la ' + VariablesUtil.RelacionAgresor,
              datos: ['1', '2', '3'],
              complete: (dato) {
                print('siiiii = {$dato}');

                setState(() {
                  relacionConAgresor = dato;
                });
              },
            ),
            ComboSeleccionMultiple(
              title: VariablesUtil.MedidasProteccion,
              searchHint:
                  'Seleccione la o las ' + VariablesUtil.MedidasProteccion,
              datos: [
                'Mantén una distancia de seguridad con personas que tosan o estornuden',
                'Cuando tosas o estornudes, cúbrete la nariz y la boca con el codo flexionado o con un pañuelo',
                'En caso de que tengas fiebre, tos o dificultad para respirar, busca atención médica, En caso de que tengas fiebre, tos o dificultad para respirar, busca atención médica,En caso de que tengas fiebre, tos o dificultad para respirar, busca atención médica'
              ],
              selectedItems: selectedItemsMedidasproteccion,
              complete: (dato) {
                print(dato);

                selectedItemsMedidasproteccion = dato;
              },
            ),
            SizedBox(
              height: responsive.altoP(1),
            )
          ],
        ),
      ),
    );
  }

  //WIDGET AGRESOR

  Widget datosAgresor(BuildContext context) {
    final responsive = ResponsiveUtil(context);

    return ContenedorDesingWidget(
      anchoPorce: anchoContenedor,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          'DATOS DEl AGRESOR',
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
                  widgetComboNacionalidadAgresor(responsive),
                  widgetCedulaAgresor(responsive),
                  widgetEdiTextDatosAgresor(responsive)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget widgetComboNacionalidadAgresor(ResponsiveUtil responsive) {
    return Container(
      width: responsive.anchoP(anchoContenedor) - anchoContenedorHijos,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
            focusColor: Colors.black,
            value: 1,
            groupValue: selectNacionalidadAgresor,
            onChanged: getNacionalidadAgresor,
          ),
          new Text(
            VariablesUtil.NACIONAL,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: responsive.anchoP(AppConfig.tamTextoTitulo),
              color: Colors.black,
            ),
          ),
          new Radio(
            focusColor: Colors.black,
            value: 2,
            groupValue: selectNacionalidadAgresor,
            onChanged: getNacionalidadAgresor,
          ),
          new Text(
            VariablesUtil.EXTRANJERO,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: responsive.anchoP(AppConfig.tamTextoTitulo),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetCedulaAgresor(ResponsiveUtil responsive) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      // handle your onTap here
      child: Container(
        margin: EdgeInsets.only(left: 0.0, right: 20.0),
        width: responsive.anchoP(anchoContenedor) - anchoContenedorHijos,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: responsive.altoP(1),
            ),
            Expanded(
                child: Form(
              key: _keyCedulaAgresor,
              child: ImputTextWidget(
                icono: Icon(
                  Icons.tab,
                  color: colorIcons,
                ),
                activar: true,
                label: VariablesUtil.CedulaAgresor,
                fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
                validar: validateCedulaAgresor,
              ),
            )),
            SizedBox(
              width: responsive.altoP(1),
            ),
            isNacionalAgresor
                ? BtnIconWidget(
                    onTap: () => _EventoBuscarDatosPorCedulaVictima(),
                    iconData: Icons.search,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget widgetEdiTextDatosAgresor(ResponsiveUtil responsive) {
    return Container(
      width: responsive.anchoP(anchoContenedor) - anchoContenedorHijos,
      child: Form(
        key: _KeyDatosAgresor,
        child: Column(
          children: [
            ImputTextWidget(
              elevation: 1,
              icono: Icon(
                Icons.person,
                color: colorIcons,
              ),
              controller: controllerNombresAgresor,
              label: VariablesUtil.Nombres,
              fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
              validar: validateNombresAgresor,
              activar: !isNacionalAgresor,
            ),
            ImputTextWidget(
              elevation: 1,
              icono: Icon(
                Icons.person,
                color: colorIcons,
              ),
              controller: controllerApellidosAgresor,
              label: VariablesUtil.Apellidos,
              fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
              validar: validateApellidosAgresor,
              activar: !isNacionalAgresor,
            ),
            ImputTextWidget(
              elevation: 1,
              icono: Icon(
                Icons.calendar_today_sharp,
                color: colorIcons,
              ),
              controller: controllerApellidosAgresor,
              keyboardType: TextInputType.number,
              label: VariablesUtil.Edad,
              fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
              validar: validateEdadAgresor,
              activar: !isNacionalAgresor,
            ),
            SizedBox(
              height: responsive.altoP(1),
            )
          ],
        ),
      ),
    );
  }

  getNacionalidadVictima(int valueRadio) {
    print(valueRadio);
    if (valueRadio == 1) {
      nacionalidadVictima = VariablesUtil.NACIONAL;
      isNacionalVictima = true;
    } else {
      nacionalidadVictima = VariablesUtil.EXTRANJERO;
      isNacionalVictima = false;
    }

    setState(() {
      selectNacionalidadVictima = valueRadio;
    });
  }

  getNacionalidadAgresor(int valueRadio) {
    print(valueRadio);
    if (valueRadio == 1) {
      nacionalidadAgresor = VariablesUtil.NACIONAL;
      isNacionalAgresor = true;
    } else {
      nacionalidadAgresor = VariablesUtil.EXTRANJERO;
      isNacionalAgresor = false;
    }

    setState(() {
      selectNacionalidadAgresor = valueRadio;
    });
  }
}
