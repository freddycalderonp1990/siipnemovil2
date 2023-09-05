part of 'operativo_polco_local_widgets.dart';
class DesingDatosWg extends StatelessWidget {
  final String title;
  final String dato1;
  final String dato2;
  final String dato3;
  final String stringImg;
  final double sizeImg;


  const DesingDatosWg({Key? key, required this.title, required this.dato1,required this.dato2,required this.dato3, required this.stringImg, this.sizeImg=45}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
    return  Container(
      padding: EdgeInsets.all(5),
      width: responsive.anchoP(95),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SiipneConfig.radioBordecajas),
        border: Border.all(color: Colors.black.withOpacity(0.5), width: 0.5),
      ),
      child: Column(
        children: [
          Text(
           title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.blueAccent.withOpacity(0.9),
                fontWeight: FontWeight.bold,
                fontSize: responsive.diagonalP(2.3)),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height:sizeImg,
                    child: Image.asset(
                    stringImg,
                  ),),
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                           dato1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.9),

                                fontSize: responsive.diagonalP(1.5)),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Flexible(
                                          child: Text(dato2)),
                                    ],
                                  )),
                              SizedBox(
                                width: 1,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(child: Text(dato3)),
                                    ],
                                  ))
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

