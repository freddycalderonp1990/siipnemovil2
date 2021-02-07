
part of 'customWidgets.dart';

class WorkAreaPageWidget2 extends StatefulWidget {
  final bool peticionServer;
  final String title;
  final List<Widget> contenido;
  final bool btnAtras;
  final Widget widgetBtnFinal;
  final EdgeInsetsGeometry paddin;
  final FloatingActionButtonLocation ubicacionBtnFinal;
  final imgPerfil;

  const WorkAreaPageWidget2({
    this.peticionServer = false,
    @required this.title = 'No title',
    @required this.contenido,
    this.btnAtras = false,
    this.widgetBtnFinal,
    this.paddin,
    this.ubicacionBtnFinal = FloatingActionButtonLocation.centerFloat,
    this.imgPerfil = null,
  });

  @override
  _WorkAreaPageWidget2State createState() => _WorkAreaPageWidget2State();
}

class _WorkAreaPageWidget2State extends State<WorkAreaPageWidget2> {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);

    return Scaffold(
        floatingActionButtonLocation: widget.ubicacionBtnFinal,
        floatingActionButton: widget.widgetBtnFinal,

        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
                color: Colors.black,
                child: Stack(children: <Widget>[
                  //    CabeceraWidget.circuloDerecha(context),
                  //  CabeceraWidget.circuloIzquierda(context),
                  Container(
                    height: responsive.alto,
                    width: responsive.ancho,
                    color: Colors.red,
                    child:   Image.asset(
                      AppConfig.imgFondo,
                      fit: BoxFit.cover,
                    ),
                  ),
                  CabeceraWidget.imgMinisterio(context),

                  SingleChildScrollView(
                      padding: widget.paddin,
                      child: Container(
                          child: SafeArea(
                              child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: responsive.anchoP(100),
                            margin: EdgeInsets.only(
                              top: responsive.anchoP(20.0),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    AppConfig.radioBordecajas),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white30, blurRadius: 25)
                                ]),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  widget.imgPerfil != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Container(
                                            width: responsive.anchoP(22),
                                            height: responsive.anchoP(22),
                                            child:
                                                Image.memory(widget.imgPerfil),
                                          ),
                                        )
                                      : Container(),
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: responsive.anchoP(5)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: widget.contenido != null
                                ? widget.contenido
                                : [Container()],
                          ),
                        ],
                      )))),

                  widget.btnAtras ? BtnAtrasWidget() : Container(),

                  CargandoWidget(
                    mostrar: widget.peticionServer,
                  )
                ]))));
  }
}
