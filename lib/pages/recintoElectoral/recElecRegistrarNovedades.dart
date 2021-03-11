part of '../pages.dart';

class RecElecRegistrarNovedades extends StatefulWidget {
  @override
  _RecElecRegistrarNovedadesState createState() =>
      _RecElecRegistrarNovedadesState();
}

class _RecElecRegistrarNovedadesState extends State<RecElecRegistrarNovedades> {
  UserProvider _UserProvider;
  RecintoAbiertoProvider _RecintoProvider;
  ProcesoOperativoProvider _ProcesoOperativoProvider;

  bool peticionServer = false;
  bool cargaInicial = true;
  bool validarForm = true;
  bool mostrarFoto = false;

  bool selectPadre = true;

  GaleryCameraModel mGaleryCameraModel =
      new GaleryCameraModel(image: null, nombreImg: "");

  DateTime selectedDate = DateTime.now();
  String fecha;

  //CONFIGURACIONES
  final anchoContenedor = AppConfig.anchoContenedor;
  final anchoContenedorHijos = AppConfig.anchoContenedorHijos;
  final paddingContenido = 10.0;
  double sizeIcons;

  final _formKey = GlobalKey<FormState>();

  var controllerCedula = new TextEditingController();
  var controllerTelefono = new TextEditingController();
  var controllerNumBoleta = new TextEditingController();
  var controllerNumCitacion = new TextEditingController();

  var controllerHora = new TextEditingController();
  var controllerMinuto = new TextEditingController();

  var controllerOrganizacion = new TextEditingController();
  var controllerDirigente = new TextEditingController();
  var controllerCantidad = new TextEditingController();


  var controllerMotivo = new TextEditingController();
  var controllerNumericoPersonal = new TextEditingController();

  String observaciones = "";

  bool existeNovedades = true;

  Widget wgCajaTextos = Container();
  Widget wgCajaTextosHijas = Container();

  List<NovedadesElectorale> _listNovedadesPadres = new List();
  List<NovedadesElectorale> _listNovedadesHijas = new List();
  NovedadesElectoralesApi _novedadesElectoralesApi =
      new NovedadesElectoralesApi();

  //Combos
  int selectNovedad = 1; //1=SI, 2=NO

  String novedades;
  String novedadesPadres, novedadesHijas;
  String idNovedades = "0";

  Color colorManifestantes = Colors.green;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UtilidadesUtil.getTheme();
    /*controllerHora.text = "00";
    controllerMinuto.text = "00";*/

    controllerHora.text = DateFormat(AppConfig.formatoSoloHora).format(selectedDate);
    controllerMinuto.text = DateFormat(AppConfig.formatoSoloMinuto).format(selectedDate);
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //Variable para obtener el tamaño de la pantalla
    fecha = DateFormat(AppConfig.formatoFechaHora).format(selectedDate);


    final responsive = ResponsiveUtil(context);
    sizeIcons =
        responsive.isVertical() ? responsive.altoP(3) : responsive.anchoP(5);

    _UserProvider = UserProvider.of(context);
    _RecintoProvider = RecintoAbiertoProvider.of(context);
    _ProcesoOperativoProvider = ProcesoOperativoProvider.of(context);

    _getNovedadesPadres();
    String imgFondo=AppConfig.imgFondoDefault;
    if(_RecintoProvider.getRecintoAbierto.isRecinto){
      imgFondo=AppConfig.imgFondoElecciones;
    }


    return WorkAreaPageWidget(

      imgFondo: imgFondo,
      btnAtras: true,
      peticionServer: peticionServer,
      title: VariablesUtil.recElecRegistrarNovedades,
      contenido: [
        _RecintoProvider.getRecintoAbierto.isJefe
            ? Container(
                width: responsive.anchoP(70),
                child: BtnIconWidget(
                  iconData: Icons.assignment_sharp,
                  title: "Ver Novedades",
                  colorTextoIcon: Colors.white,
                  color: Colors.blue.withOpacity(0.70),
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppConfig.pantallaRecElecNovedadesDetalle);
                  },
                ),
              )
            : Container(),

        SizedBox(
          height: responsive.altoP(2),
        ),
        MyUbicacionWidget(

          callback:(_) {

          },),
        SizedBox(
          height: responsive.altoP(1),
        ),
        getCombos(responsive),
        int.parse(idNovedades) > 0
            ? ContenedorDesingWidget(
                margin: EdgeInsets.only(top: 10),
                anchoPorce: anchoContenedor,
                child: Column(
                  children: [
                    //widgetCheckBoxNovedades(responsive),

                    wgCajaTextos,
                    wgCajaTextosHijas,
                    SizedBox(
                      height: responsive.altoP(2),
                    )
                  ],
                ),
              )
            : Container(),
        mostrarFoto ? wgFoto(responsive) : Container(),
        SizedBox(
          height: responsive.altoP(3),
        ),
        btnGuardar(responsive)
      ],
    );
  }





  Widget widgetCheckBoxNovedades(ResponsiveUtil responsive) {
    return Container(
        padding: EdgeInsets.all(5),
        width: responsive.anchoP(anchoContenedor) - anchoContenedorHijos,
        child: Column(
          children: [
            TituloTextWidget(
              title: "Existe Novedades",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  focusColor: Colors.black,
                  value: 1,
                  groupValue: selectNovedad,
                  onChanged: getNovedad,
                ),
                new Text(
                  VariablesUtil.SI,
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.anchoP(AppConfig.tamTextoTitulo),
                    color: Colors.black,
                  ),
                ),
                new Radio(
                  focusColor: Colors.black,
                  value: 2,
                  groupValue: selectNovedad,
                  onChanged: getNovedad,
                ),
                new Text(
                  VariablesUtil.NO,
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.anchoP(AppConfig.tamTextoTitulo),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget wgTxtCedula(
      {ResponsiveUtil responsive, String title = VariablesUtil.cedula}) {
    return Form(
      key: _formKey,
      child: Column(children: [
        ImputTextWidget(
          keyboardType: TextInputType.number,
          controller: controllerCedula,
          icono: Icon(
            Icons.assignment_sharp,
            color: Colors.black38,
            size: sizeIcons,
          ),
          label: title,
          fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
          validar: validateCedula,
        ),

      ],),
    );
  }

  Widget wgTxtCedulaTelefono(
      {ResponsiveUtil responsive, String title = VariablesUtil.cedula}) {
    return Form(
      key: _formKey,
      child: Column(children: [
        ImputTextWidget(
          keyboardType: TextInputType.number,
          controller: controllerCedula,
          icono: Icon(
            Icons.assignment_sharp,
            color: Colors.black38,
            size: sizeIcons,
          ),
          label: title,
          fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
          validar: validateCedula,
        ),
        ImputTextWidget(
          keyboardType: TextInputType.number,
          controller: controllerTelefono,
          icono: Icon(
            Icons.phone_android,
            color: Colors.black38,
            size: sizeIcons,
          ),
          label: "Teléfono",
          fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
          validar: validateTelefono,
        )
      ],),
    );
  }

  Widget wgTxtCedulaBoleta(ResponsiveUtil responsive) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerNumBoleta,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: VariablesUtil.numBoleta,
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateNumBoleta,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.number,
            controller: controllerCedula,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: VariablesUtil.cedula,
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateCedula,
          ),
        ],
      ),
    );
  }

  Widget wgTxtCedulaCitacion(ResponsiveUtil responsive) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerNumCitacion,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: VariablesUtil.numCitacion,
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateNumCitacion,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.number,
            controller: controllerCedula,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: VariablesUtil.cedula,
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateCedula,
          ),
        ],
      ),
    );
  }

  Widget wgTxtMotivo(ResponsiveUtil responsive) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerMotivo,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Motivo",
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateNumCitacion,
          ),
        ],
      ),
    );
  }

  Widget wgTxtNumericoPersonal(ResponsiveUtil responsive) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.number,
            controller: controllerNumericoPersonal,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Númerico del Personal",
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateNumPersonal,
          ),
        ],
      ),
    );
  }

  Widget wgTxtNumeroManifestantes(responsive) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerOrganizacion,
            icono: Icon(
              Icons.category,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Organización Social o Política",
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateOrganizacion,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerDirigente,
            icono: Icon(
              Icons.category,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Dirigente",
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateDirigente,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.number,
            controller: controllerCantidad,
            onChanged: (valor) {
              if (valor != null) {
                if (int.parse(valor) > 100) {}
              }
            },
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Cantidad",
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateCantidad,
          ),
        ],
      ),
    );
  }

  Widget wgTxtNumeroQuemaUrnas(responsive) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerOrganizacion,
            icono: Icon(
              Icons.category,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Organización Social o Política",
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateOrganizacion,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerDirigente,
            icono: Icon(
              Icons.category,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Dirigente",
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateDirigente,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.number,
            controller: controllerCantidad,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Cantidad",
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateCantidad,
          ),
        ],
      ),
    );
  }

  Widget wgTxtNumeroTomaRecintos(responsive) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerCantidad,
            icono: Icon(
              Icons.category,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Organización Social o Política",
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateOrganizacion,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerDirigente,
            icono: Icon(
              Icons.category,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Dirigente",
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateDirigente,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.number,
            controller: controllerCantidad,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Cantidad",
            fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            validar: validateCantidad,
          ),
        ],
      ),
    );
  }

  getNovedad(int valueRadio) {
    if (valueRadio == 1) {
      existeNovedades = true;
    } else {
      existeNovedades = false;
    }

    setState(() {
      novedades = "";
      selectNovedad = valueRadio;
    });
  }

  String validateCedula(String value) {
    if (value.length < 10) {
      return VariablesUtil.ingreseCedula;
    }

    return null;
  }

  String validateTelefono(String value) {
    if (value.length < 8) {
      return "Ingrese el número de Teléfono";
    }

    return null;
  }



  String validateNumBoleta(String value) {
    if (value.length < 5) {
      return VariablesUtil.ingreseBoleta;
    }

    return null;
  }

  String validateNumPersonal(String value) {

    if (value.length==0 || int.parse( value) < 1) {
      return "Ingrese el Númerico del Personal";
    }

    return null;
  }



  String validateNumCitacion(String value) {
    if (value.length < 3) {
      return VariablesUtil.ingreseCitacion;
    }

    return null;
  }

  String validateOrganizacion(String value) {
    if (value.length < 3) {
      return "Ingrese Organización";
    }

    return null;
  }

  String validateDirigente(String value) {
    if (value.length < 3) {
      return "Ingrese al Dirigente";
    }

    return null;
  }

  String validateCantidad(String value) {
    if (value.length == 0 || int.parse(value) == 0) {
      return "Ingrese una cantidad";
    }

    return null;
  }

  Widget getComboNovedades() {
    return existeNovedades
        ? Container(
            padding: EdgeInsets.all(paddingContenido),
            child: ComboConBusqueda(
              title: VariablesUtil.tipoNovedad,
              searchHint: 'Seleccione el ' + VariablesUtil.tipoNovedad,
              datos: ['Boletas', 'Detención', 'Riñas', 'Otros'],
              complete: (dato) {
                setState(() {
                  novedades = dato;
                });
              },
            ))
        : Container();
  }

  Widget btnGuardar(ResponsiveUtil responsive) {
    return int.parse(idNovedades) > 0
        ? Container(
            width: responsive.anchoP(anchoContenedor),
            child: BotonesWidget(
              iconData: Icons.save,
              padding: EdgeInsets.symmetric(horizontal: 10),
              title: VariablesUtil.GUARDAR,
              onPressed: () => _EventoRegistrarNovedadesElectorales(),
            ),
          )
        : Container();
  }

  _EventoRegistrarNovedadesElectorales() async {
    bool isValid=true;
    if(validarForm){
      isValid = _formKey.currentState.validate();
    }


    print("isValid");
    print(isValid);

    if (isValid) {
      if (mostrarFoto) {
        if (mGaleryCameraModel.image == null) {
          DialogosWidget.alert(context,
              title: "Imagen", message: "Selelcione una Imagen");
        } else {
          bool insertImg = await guardarImgRecElectNovedades(
              galeryCameraModel: mGaleryCameraModel);

          if (insertImg) {
            await _RegistrarNovedades(
                usuario: _UserProvider.getUser.idGenUsuario,
                observacion: getObservacion(),
                idDgoPerAsigOpe:
                    _RecintoProvider.getRecintoAbierto.idDgoPerAsigOpe,
                idDgoNovedadesElect: idNovedades,
              imagen:mGaleryCameraModel.nombreImg
            );
          }
        }
      } else {
        await _RegistrarNovedades(
            usuario: _UserProvider.getUser.idGenUsuario,
            observacion: getObservacion(),
            idDgoPerAsigOpe: _RecintoProvider.getRecintoAbierto.idDgoPerAsigOpe,
            idDgoNovedadesElect: idNovedades);
      }
    }
  }

  List<String> getDatos(List<NovedadesElectorale> _listNovedadesPadres) {
    List<String> datos = new List();
    for (int i = 0; i < _listNovedadesPadres.length; i++) {
      datos.add(_listNovedadesPadres[i].descripcion);
    }
    return datos;
  }

  //Sirve para padres,e hijas
  int getIdNovedades(String novedad, List<NovedadesElectorale> listNovedades) {
    int id = 0;
    for (int i = 0; i < listNovedades.length; i++) {
      if (listNovedades[i].descripcion == novedad) {
        id = int.parse(listNovedades[i].idDgoNovedadesElect);
        return id;
      }
    }
  }

  Widget wgCajasTexto(String novedadesPadres, ResponsiveUtil responsive) {
    Widget wg = Container();
    if (novedadesPadres != null) {
      switch (novedadesPadres.trim().toUpperCase()) {
        case "NOVEDADES":
          mostrarFoto = true;
          // wg = wgTxtCedula(responsive);

          break;
        case "DELITOS":
          mostrarFoto = false;
          validarForm=true;
          wg = wgTxtCedula(responsive: responsive);
          break;
        case "DETENIDOS":
          mostrarFoto = false;
          validarForm=true;
          wg = wgTxtCedulaBoleta(responsive);
          break;
        case "CITACIONES":
          mostrarFoto = false;
          validarForm=true;
          wg = wgTxtCedulaCitacion(responsive);
          break;

        case "UMO":
          mostrarFoto = true;

         // wg = wgTxtCedulaCitacion(responsive);
          break;

        default:
          wg = Container();
      }
      setState(() {});
    }
    return wg;
  }

  Widget wgCajasTextoNovedades(
      int idDgoNovedadesElect, ResponsiveUtil responsive) {
    Widget wg = Container();
    print("suiii");
    print(idDgoNovedadesElect);
    switch (idDgoNovedadesElect) {
      case 17:
        //1. RECINTOS ELECTORALES INSTALADOS
        wg = Container();
        validarForm = false;
        break;
      case 18:
        //2. RECINTOS ELECTORALES NO INSTALADOS
        wg = Container();
        validarForm = false;
        break;
      case 19:
        //3. RECINTO ELECTORAL INSTALADO CON RETARDO POR DIFERENTES CAUSAS
        validarForm = false;
        wg = Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: responsive.altoP(1),
              ),
              getComboHora(responsive),
              getComboMinuto(responsive)
            ],
          ),
        );

        break;
      case 20:
        //4. RECINTOS ELECTORALES SUSPENDIDO POR DIFERENTES CAUSAS
        wg = wgTxtMotivo(responsive);
        validarForm=true;
        break;
      case 21:
        //5. AGRESIONES A SERVIDORES POLICIALES
        wg = wgTxtCedula(responsive: responsive, title: VariablesUtil.cedulaSP);
        validarForm=true;
        break;
      case 22:
        //6. PRESENCIA DE MANIFESTANTES / CONCENTRACIONES / MARCHAS
        wg = Column(
          children: [
            wgTxtNumeroManifestantes(responsive),
            SizedBox(
              height: responsive.altoP(1),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getBtnColores(
                      responsive: responsive,
                      color: Colors.green.withOpacity(0.8),
                      title: "1-50"),
                  getBtnColores(
                      responsive: responsive,
                      color: Colors.yellow.withOpacity(0.8),
                      title: "51-200"),
                  getBtnColores(
                      responsive: responsive,
                      color: Colors.orange.withOpacity(0.8),
                      title: "201-500"),
                  getBtnColores(
                      responsive: responsive,
                      color: Colors.red.withOpacity(0.8),
                      title: "501-Más"),
                ],
              ),
            )
          ],
        );
        validarForm=true;
        break;
      case 23:
        //7. QUEMA DE URNAS / PAPELETAS
        validarForm=true;
        wg = Column(
          children: [
            wgTxtNumeroQuemaUrnas(responsive),
            SizedBox(
              height: responsive.altoP(1),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getBtnColores(
                      responsive: responsive,
                      color: Colors.green.withOpacity(0.8),
                      title: "1-50"),
                  getBtnColores(
                      responsive: responsive,
                      color: Colors.yellow.withOpacity(0.8),
                      title: "51-200"),
                  getBtnColores(
                      responsive: responsive,
                      color: Colors.orange.withOpacity(0.8),
                      title: "201-500"),
                  getBtnColores(
                      responsive: responsive,
                      color: Colors.red.withOpacity(0.8),
                      title: "501-Más"),
                ],
              ),
            )
          ],
        );
        break;
      case 28:
        //8. TOMA DE RECINTOS / DELEGACIONES / BODEGAS / INSTALACIONES DEL CNE
        validarForm=true;
        wg = Column(
          children: [
            wgTxtNumeroTomaRecintos(responsive),
            SizedBox(
              height: responsive.altoP(1),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getBtnColores(
                      responsive: responsive,
                      color: Colors.green.withOpacity(0.8),
                      title: "1-50"),
                  getBtnColores(
                      responsive: responsive,
                      color: Colors.yellow.withOpacity(0.8),
                      title: "51-200"),
                  getBtnColores(
                      responsive: responsive,
                      color: Colors.orange.withOpacity(0.8),
                      title: "201-500"),
                  getBtnColores(
                      responsive: responsive,
                      color: Colors.red.withOpacity(0.8),
                      title: "501-Más"),
                ],
              ),
            )
          ],
        );
        break;
      case 29:
        //9. PRESENCIA DE VENTAS AMBULANTES
        wg = Container();
        validarForm = false;
        break;
      case 30:
        //10. ATENCIÓN MÉDICA POR DIFERENTES CAUSAS
        validarForm=true;
        wg = wgTxtCedulaTelefono(responsive: responsive);
        break;
      case 31:
        //11. SERVIDORES POLICIALES INFECTADOS (SOSPECHA/POSITIVO)
        wg = wgTxtCedulaTelefono(responsive: responsive, title: VariablesUtil.cedulaSP);
        validarForm=true;
        break;

      default:

        wg = Container();
    }

    return wg;
  }


  Widget wgCajasTextoHumo(
      int idDgoNovedadesElect, ResponsiveUtil responsive) {
    Widget wg = Container();

    switch (idDgoNovedadesElect) {
      case 33:
      //1. NUMERICO DE PERSONAL
        wg = wgTxtNumericoPersonal(responsive);
        validarForm = true;
        break;
      case 34:
      //2. PLANTONES
        wg = wgorganizacionDirigenteCantidad(responsive);
        validarForm = true;
        break;
      case 35:
      //3. MARCHAS
        wg = wgorganizacionDirigenteCantidad(responsive);
        validarForm = true;
        break;


      case 36:
      //4. CIERRE DE VIAS
        wg = wgorganizacionDirigenteCantidad(responsive);
        validarForm = true;
        break;

      case 37:
      //5. TOMA DE ENTIDADES
        wg = wgorganizacionDirigenteCantidad(responsive);
        validarForm = true;
        break;


      default:

        wg = Container();
    }

    return wg;
  }


  Widget wgorganizacionDirigenteCantidad(ResponsiveUtil responsive){
    return   Column(
      children: [
        wgTxtNumeroManifestantes(responsive),
        SizedBox(
          height: responsive.altoP(1),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getBtnColores(
                  responsive: responsive,
                  color: Colors.green.withOpacity(0.8),
                  title: "1-50"),
              getBtnColores(
                  responsive: responsive,
                  color: Colors.yellow.withOpacity(0.8),
                  title: "51-200"),
              getBtnColores(
                  responsive: responsive,
                  color: Colors.orange.withOpacity(0.8),
                  title: "201-500"),
              getBtnColores(
                  responsive: responsive,
                  color: Colors.red.withOpacity(0.8),
                  title: "501-Más"),
            ],
          ),
        )
      ],
    );

  }
  String getObservacion() {
    String observacion = "";
    if (novedadesPadres != null) {
      switch (novedadesPadres.trim().toUpperCase()) {
        case "NOVEDADES":
         // observacion = '{"cedula": "${controllerCedula.text}"}';
        observacion=getObservacionNovedades();
          break;
        case "DELITOS":
          mostrarFoto=false;
          observacion = '{"cedula": "${controllerCedula.text}"}';
          break;
        case "DETENIDOS":
          mostrarFoto=false;
          observacion =
              '{"cedula": "${controllerCedula.text}", "numBoleta": "${controllerNumBoleta.text}"}';
          break;
        case "CITACIONES":
          mostrarFoto=false;
          observacion =
              '{"cedula": "${controllerCedula.text}", "numCitacion": "${controllerNumCitacion.text}"}';
          break;

        case "UMO":
          print("ingresaa");
        observacion=getObservacionUmo();

          break;

        default:
          observacion = "";
      }
    }
    return observacion;
  }

  String getObservacionNovedades() {
    String observacion = "";
    if (mostrarFoto) {
      switch (int.parse(idNovedades)) {
        case 17:
            break;
        case 18:
          break;
        case 19:
        //3. RECINTO ELECTORAL INSTALADO CON RETARDO POR DIFERENTES CAUSAS

          observacion = '{"hora": "${controllerHora.text}:${controllerMinuto.text}"}';

          break;
        case 20:
        //4. RECINTOS ELECTORALES SUSPENDIDO POR DIFERENTES CAUSAS
          observacion = '{"motivo": "${controllerMotivo.text}"}';
          validarForm=true;
          break;
        case 21:
        //5. AGRESIONES A SERVIDORES POLICIALES
          observacion = '{"cedula": "${controllerCedula.text}"}';
          validarForm=true;
          break;
        case 22:
        //6. PRESENCIA DE MANIFESTANTES / CONCENTRACIONES / MARCHAS
          observacion =  '{"organizacion": "${controllerOrganizacion.text}", "dirigente": "${controllerDirigente.text}" , "cantidad": "${controllerCantidad.text}"}';
          break;
        case 23:
        //7. QUEMA DE URNAS / PAPELETAS
          observacion =  '{"organizacion": "${controllerOrganizacion.text}", "dirigente": "${controllerDirigente.text}" , "cantidad": "${controllerCantidad.text}"}';
          break;
        case 28:
        //8. TOMA DE RECINTOS / DELEGACIONES / BODEGAS / INSTALACIONES DEL CNE
          observacion =  '{"organizacion": "${controllerOrganizacion.text}", "dirigente": "${controllerDirigente.text}" , "cantidad": "${controllerCantidad.text}"}';
          break;
        case 29:
        //9. PRESENCIA DE VENTAS AMBULANTES

          break;
        case 30:
        //10. ATENCIÓN MÉDICA POR DIFERENTES CAUSAS

          observacion = '{"cedula": "${controllerCedula.text}", "telefono": "${controllerTelefono.text}"}';
          break;
        case 31:
        //11. SERVIDORES POLICIALES INFECTADOS (SOSPECHA/POSITIVO)
          observacion = '{"cedula": "${controllerCedula.text}"}';

          break;

        default:

          observacion = "";
      }


    }
    return observacion;
  }

  String getObservacionUmo() {
    String observacion = "";
    if (mostrarFoto) {
      switch (int.parse(idNovedades)) {
        case 33:
        //1. NUMERICO DE PERSONAL
          observacion = '{"cantidad": "${controllerNumericoPersonal.text}"}';
          print("aqui");
          validarForm = true;
          break;
        case 34:
        //2. PLANTONES
          observacion =  '{"organizacion": "${controllerOrganizacion.text}", "dirigente": "${controllerDirigente.text}" , "cantidad": "${controllerCantidad.text}"}';
          validarForm = true;
          break;
        case 35:
        //3. MARCHAS
          observacion =  '{"organizacion": "${controllerOrganizacion.text}", "dirigente": "${controllerDirigente.text}" , "cantidad": "${controllerCantidad.text}"}';
          validarForm = true;
          break;


        case 36:
        //4. CIERRE DE VIAS
          observacion =  '{"organizacion": "${controllerOrganizacion.text}", "dirigente": "${controllerDirigente.text}" , "cantidad": "${controllerCantidad.text}"}';
          validarForm = true;
          break;

        case 37:
        //5. TOMA DE ENTIDADES
          observacion =  '{"organizacion": "${controllerOrganizacion.text}", "dirigente": "${controllerDirigente.text}" , "cantidad": "${controllerCantidad.text}"}';
          validarForm = true;
          break;

        default:

          observacion = "";
      }


    }
    return observacion;
  }




  Widget getComboHora(ResponsiveUtil responsive) {
    List<String> datos = new List();

    for (int i = 0; i < 24; i++) {
      if (i < 10) {
        datos.add("0" + i.toString());
      } else {
        datos.add(i.toString());
      }
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: paddingContenido),
        child: ComboConBusqueda(
          selectValue: controllerHora.text,
          title: "Hora",
          searchHint: 'Seleccione la Hora',
          datos: datos,
          complete: (dato) {
            setState(() {
              controllerHora.text = dato;
            });
          },
        ));
  }

  Widget getComboMinuto(ResponsiveUtil responsive) {
    List<String> datos = new List();

    for (int i = 0; i < 60; i++) {
      if (i < 10) {
        datos.add("0" + i.toString());
      } else {
        datos.add(i.toString());
      }
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: paddingContenido),
        child: ComboConBusqueda(
          selectValue: controllerMinuto.text,
          title: "Minuto",
          searchHint: 'Minuto',
          datos: datos,
          complete: (dato) {
            setState(() {
              controllerMinuto.text = dato;
            });
          },
        ));
  }

  Widget getComboNovedadesPadres(ResponsiveUtil responsive) {
    List<String> datos = getDatos(_listNovedadesPadres);

    return _listNovedadesPadres.length > 0
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: paddingContenido),
            child: ComboConBusqueda(
              title: VariablesUtil.tipoNovedad,
              searchHint: 'Seleccione el ' + VariablesUtil.tipoNovedad,
              datos: datos,
              complete: (dato) {
                selectPadre = true;
                setState(() {
                  wgCajaTextosHijas=Container();
                  novedadesPadres = dato;

                  novedadesHijas = null;
                  idNovedades = "0";

                  if (novedadesPadres != null) {
                    wgCajaTextos = wgCajasTexto(novedadesPadres, responsive);
                    if (_listNovedadesHijas.length > 0) {
                      novedadesHijas = _listNovedadesHijas[0].descripcion;

                      idNovedades = "0";
                      idNovedades = _listNovedadesHijas[0].idDgoNovedadesElect;
                    }

                    int idNovedadPadre =
                        getIdNovedades(novedadesPadres, _listNovedadesPadres);
                    _getNovedadesHijas(idNovedadPadre);
                  }
                });
              },
            ))
        : Container(
            child: DetalleTextWidget(
              detalle: "No exiten tipos de Novedades",
            ),
          );
  }

  Widget getComboNovedadesHijos(ResponsiveUtil responsive) {
    List<String> datos = getDatos(_listNovedadesHijas);

    Widget wg = _listNovedadesHijas.length > 0
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: paddingContenido),
            child: ComboConBusqueda(
              selectValue:
                  selectPadre ?novedadesHijas: "",
              title: VariablesUtil.novedad,
              searchHint: 'Seleccione la ' + VariablesUtil.novedad,
              datos: datos,
              complete: (dato) {
                selectPadre = false;
                setState(() {
                  novedadesHijas = dato;
                  idNovedades = "0";
                  if (novedadesHijas != null) {
                    idNovedades =
                        getIdNovedades(novedadesHijas, _listNovedadesHijas)
                            .toString();

                    if(novedadesPadres=="NOVEDADES") {
                      wgCajaTextosHijas = wgCajasTextoNovedades(
                          int.parse(idNovedades), responsive);
                    }
                    else if(novedadesPadres=="UMO"){
                      wgCajaTextosHijas = wgCajasTextoHumo(
                          int.parse(idNovedades), responsive);
                    }

                    print("cambia");
                  }
                });
              },
            ))
        : Container(
            child: DetalleTextWidget(
              detalle: "No exiten Novedades",
            ),
          );

    return wg;
  }

  _getNovedadesPadres() async {
    if (!cargaInicial) return;

    if (peticionServer) return;

    setState(() {
      peticionServer = true;
    });



    _listNovedadesPadres =
        await _novedadesElectoralesApi.getNovedadesPadres(context: context,idDgoTipoEje:_RecintoProvider.getRecintoAbierto.idDgoTipoEje);

    if (_listNovedadesHijas.length > 0) {
      novedadesHijas = _listNovedadesHijas[0].descripcion;
    }

    setState(() {
      peticionServer = false;
      cargaInicial = false;
    });
  }

  Widget wgFoto(ResponsiveUtil responsive) {
    Widget wgSolicitarFoto = Column(
      children: [
        mGaleryCameraModel.image == null
            ? TituloTextWidget(
                title: "Selecciona una Imagen",
              )
            : TituloTextWidget(
                title: "Cambiar la Imagen",
              ),
        SizedBox(
          height: responsive.altoP(1),
        ),
        Material(
            child: InkWell(
          onTap: () {
            DialogosWidget.selectPicture(context, onTapCamara: () {
              getImageCamera();
              Navigator.of(context).pop();
            }, onTapGalery: () {
              getImageGallery();
              Navigator.of(context).pop();
            });
          },
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(AppConfig.icon_camara,
                  width: responsive.altoP(6.0)),
            ),
          ),
        )),
        mGaleryCameraModel.image == null
            ? Container()
            : ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.file(
                  mGaleryCameraModel.image,
                  fit: BoxFit.fill,
                  height: responsive.altoP(30.0),
                  width: responsive.altoP(34.0),
                )),
        SizedBox(
          height: responsive.altoP(1),
        ),
      ],
    );

    Widget wg = wgSolicitarFoto;

    return ContenedorDesingWidget(
        margin: EdgeInsets.only(top: 10),
        anchoPorce: anchoContenedor,
        child: wg);
  }

  Future getImageGallery() async {
    try {
      setState(() {
        peticionServer = true;
      });

      GaleryCameraModel _mGaleryCameraModel =
          await UtilidadesUtil.getImageGallery(
              "ImgRecElectNovedades_id_" + idNovedades);

      if (_mGaleryCameraModel.image != null) {
        setState(() {
          this.mGaleryCameraModel = _mGaleryCameraModel;
        });
      }
      setState(() {
        peticionServer = false;
      });
    } catch (e) {
      setState(() {
        peticionServer = false;
      });
    }
  }

  Future getImageCamera() async {
    try {
      setState(() {
        peticionServer = true;
      });

      GaleryCameraModel _mGaleryCameraModel =
          await UtilidadesUtil.getImageCamera(
              "ImgRecElectNovedades_id_" + idNovedades);

      if (_mGaleryCameraModel.image != null) {
        setState(() {
          this.mGaleryCameraModel = _mGaleryCameraModel;
        });
      }

      setState(() {
        peticionServer = false;
      });
    } catch (e) {
      setState(() {
        peticionServer = false;
      });
    }
  }

  Widget getCombos(ResponsiveUtil responsive) {
    return ContenedorDesingWidget(
        anchoPorce: anchoContenedor,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: paddingContenido),
          child: Column(
            children: [
              getComboNovedadesPadres(responsive),
              novedadesPadres != null
                  ? getComboNovedadesHijos(responsive)
                  : Container(),
            ],
          ),
        ));
  }

  _getNovedadesHijas(int idNovedadPadre) async {
    if (idNovedadPadre == 0) return;

    if (peticionServer) return;
    setState(() {
      peticionServer = true;
    });
    _listNovedadesHijas = await _novedadesElectoralesApi.getNovedadesHijas(
        context: context, idNovedadesPadre: idNovedadPadre.toString(),idDgoTipoEje: _RecintoProvider.getRecintoAbierto.idDgoTipoEje);

    setState(() {
      peticionServer = false;
    });
  }

  _RegistrarNovedades({
    @required String idDgoNovedadesElect,
    @required String idDgoPerAsigOpe,
    @required String observacion,
    @required String usuario,
    String imagen="null"
  }) async {
    if (idDgoPerAsigOpe == 0) return;

    if (peticionServer) return;
    setState(() {
      peticionServer = true;
    });


    String latitud =
    _UserProvider.getUser.ubicacionSeleccionada.latitude.toString();
    String longitud =
    _UserProvider.getUser.ubicacionSeleccionada.longitude.toString();


    await _novedadesElectoralesApi.registrarNovedadesElectorales(
        context: context,
        idDgoPerAsigOpe: idDgoPerAsigOpe,
        usuario: usuario,
        idDgoNovedadesElect: idDgoNovedadesElect,
        observacion: observacion,
        imagen:imagen,
      latitud: latitud,
      longitud: longitud
    );

    setState(() {
      peticionServer = false;
    });
  }

  Future<bool> guardarImgRecElectNovedades(
      {GaleryCameraModel galeryCameraModel}) async {
    try {
      setState(() {
        peticionServer = true;
      });
      bool resImg = await _novedadesElectoralesApi.guardarImgRecElectNovedades(
          context: context,
          image: galeryCameraModel.image,
          nameImg: galeryCameraModel.nombreImg);
      setState(() {
        peticionServer = false;
      });
      return resImg;
    } catch (e) {
      setState(() {
        peticionServer = false;
      });
    }
  }

  Widget getBtnColores({ResponsiveUtil responsive, String title, Color color}) {
    return Container(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
      width: responsive.anchoP(20),
      height: responsive.altoP(2),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
          boxShadow: [
            BoxShadow(
                color: AppConfig.colorBordecajas,
                blurRadius: AppConfig.sobraBordecajas)
          ]),
    );
  }
}

class WgCambiarFecha extends StatefulWidget {
  final String fecha;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectedDate;

  const WgCambiarFecha(
      {Key key, this.fecha, this.selectedDate, this.onSelectedDate})
      : super(key: key);

  @override
  _WgCambiarFechaState createState() => _WgCambiarFechaState();
}

class _WgCambiarFechaState extends State<WgCambiarFecha> {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            height: responsive.altoP(1),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TituloDetalleTextWidget(
                title: "Fecha y hora:",
                mostrarBorder: true,
                detalle: widget.fecha,
              ),
              BtnIconWidget(
                paddinHorizontal: 80.0,
                iconData: Icons.date_range,
                title: "Cambiar",
                colorTextoIcon: Colors.white,
                color: Colors.blue.withOpacity(0.70),
                onTap: () {
                  showDialogoFechaHoraWidget(context,
                      mostrarHora: true,
                      initialDate: widget.selectedDate,
                      onSelectedDate: widget.onSelectedDate);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
