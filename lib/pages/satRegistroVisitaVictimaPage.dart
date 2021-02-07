part of 'pages.dart';

class SatRegistroVisitaVictimaPage extends StatefulWidget {
  @override
  _SatRegistroVisitaVictimaPageState createState() =>
      _SatRegistroVisitaVictimaPageState();
}

class _SatRegistroVisitaVictimaPageState
    extends State<SatRegistroVisitaVictimaPage> {
  bool peticionServer = false;

  //CONFIGURACIONES
  final anchoContenedor = AppConfig.anchoContenedor;
  final anchoContenedorHijos = AppConfig
      .anchoContenedorHijos; // para mostra el tamaño de los hijos dentro del contenedor, este valor se resta al ancho total que tenga la pantalla  responsive.anchoP(anchoContenedor)-20.0

  //Variables
  bool tomaContactoConVictima = true;
  String novedades;
  String causa;

  //Combos
  int selectTomaContactoVictima = 1; //1=SI, 2=NO

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    return WorkAreaPageWidget(
      btnAtras: true,
      peticionServer: peticionServer,
      title: VariablesUtil.satRegistroVisitasVictimas,
      contenido: [
        ContenedorDesingWidget(
          margin: EdgeInsets.only(top: 10),
          anchoPorce: anchoContenedor,
          child: Column(
            children: [
              widgetComboTomaContactoVictima(responsive),
              widgetTomaContactoVicitmaSi(responsive),
              widgetTomaContactoVicitmaNo(responsive),
              SizedBox(
                height: responsive.altoP(1),
              )
            ],
          ),
        ),
        SizedBox(
          height: responsive.altoP(3),
        ),
        Container(
          width: responsive.anchoP(anchoContenedor),
          child: BotonesWidget(
            iconData: Icons.save,
            padding: EdgeInsets.symmetric(horizontal: 10),
            title: VariablesUtil.GUARDAR,
            onPressed: () {
              print(novedades);
              print(causa);
            },
          ),
        )
      ],
    );
  }

  Widget widgetComboTomaContactoVictima(ResponsiveUtil responsive) {
    return Container(
        padding: EdgeInsets.all(5),
        width: responsive.anchoP(anchoContenedor) - anchoContenedorHijos,
        child: Column(
          children: [
            TituloTextWidget(
              title: "Toma contacto con la víctima",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  focusColor: Colors.black,
                  value: 1,
                  groupValue: selectTomaContactoVictima,
                  onChanged: getTomaContactoVictima,
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
                  groupValue: selectTomaContactoVictima,
                  onChanged: getTomaContactoVictima,
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

  Widget widgetTomaContactoVicitmaSi(ResponsiveUtil responsive) {
    return tomaContactoConVictima
        ? Container(
            width: responsive.anchoP(anchoContenedor) - anchoContenedorHijos,
            child: ComboConBusqueda(
              title: VariablesUtil.Novedades,
              searchHint: 'Seleccione la ' + VariablesUtil.Novedades,
              datos: ['Ninguna', 'Solicita no ser visitada', 'Otras'],
              complete: (dato) {
                novedades = dato;
              },
            ))
        : Container();
  }

  Widget widgetTomaContactoVicitmaNo(ResponsiveUtil responsive) {
    return tomaContactoConVictima
        ? Container()
        : Container(
            width: responsive.anchoP(anchoContenedor) - anchoContenedorHijos,
            child: ComboConBusqueda(
              title: VariablesUtil.Causa,
              searchHint: 'Seleccione la ' + VariablesUtil.Causa,
              datos: ['Otro', 'Cambio de Domicilio', 'Fallecimiento'],
              complete: (dato1) {
                causa = dato1;
              },
            ));
  }

  //COMBOS

  getTomaContactoVictima(int valueRadio) {
    print(valueRadio);
    if (valueRadio == 1) {
      tomaContactoConVictima = true;
    } else {
      tomaContactoConVictima = false;
    }

    setState(() {
      selectTomaContactoVictima = valueRadio;
    });
  }
}
