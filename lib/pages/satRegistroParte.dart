part of 'pages.dart';

class SatRegistroParte extends StatefulWidget {
  @override
  _SatRegistroParteState createState() => _SatRegistroParteState();
}

class _SatRegistroParteState extends State<SatRegistroParte> {
  bool peticionServer = false;

  //CONFIGURACIONES
  final anchoContenedor = AppConfig.anchoContenedor;
  final anchoContenedorHijos = AppConfig.anchoContenedorHijos;

  Color colorIcons = AppConfig.colorIcons;

  List<String> data=new List(3);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    return WorkAreaPageWidget(
      title: VariablesUtil.satRegistrarParte,
      peticionServer: peticionServer,
      btnAtras: true,
      contenido: [
        ContenedorDesingWidget(
            anchoPorce: anchoContenedor, child:
        Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
            height: responsive.isVertical()
                ? responsive.altoP(
              data.length<=0?0: data.length > 5 ? 75 : data.length > 3 ? 50 : 30,
            )
                : responsive.altoP(50),
            child:ListView.builder( shrinkWrap: true,
                itemCount: data != null ? data.length : 0,
        itemBuilder: (context, index) {
         return getModelo(responsive: responsive,index: index);
        }))
        )
      ],
    );
  }

  Widget getModelo({ResponsiveUtil responsive, int index}) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
            boxShadow: [
              BoxShadow(color: AppConfig.colorBordecajas, blurRadius: 1)
            ]),
        width: responsive.anchoP(anchoContenedor) - anchoContenedorHijos,
        margin: EdgeInsets.all(5),
        child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
            child: InkWell(
              child: Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10, top: 5.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            (index + 1).toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsive.anchoP(4),
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                              margin: EdgeInsets.all(5),
                              child:  Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person,color: colorIcons),
                                  DetalleTextWidget(
                                    ancho: responsive.isVertical() ? 65 : 75,
                                    detalle:
                                    "Freddy Nicanor Calderon pazmiño, Freddy Nicanor Calderon pazmiño",
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.date_range,color: colorIcons,),
                                  DetalleTextWidget(
                                  colorDetalle: AppConfig.colorBordecajas,
                                    ancho: responsive.isVertical() ? 65 : 75,
                                    detalle:
                                    "Visita Realizada Visita Realizada Visita Realizada en Enero de 06 de 2021",
                                  )
                                ],
                              )
                            ],
                          ))
                        ],
                      ),
                    ],
                  )),
              onTap: () {
                print("print");
              },
            )));
  }
}
