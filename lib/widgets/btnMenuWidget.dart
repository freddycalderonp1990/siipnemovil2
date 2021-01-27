
part of 'customWidgets.dart';

class BtnMenuWidget  extends StatefulWidget {

  final img;
  final String titlte;
  final GestureTapCallback onTap;


  const BtnMenuWidget( {this.img=null,this.titlte, this.onTap}) ;

  @override
  _BtnMenuWidgetState createState() => _BtnMenuWidgetState();
}



class _BtnMenuWidgetState extends State<BtnMenuWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final responsive = ResponsiveUtil(context);
    return   Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
          boxShadow: [
            BoxShadow(
                color: AppConfig.colorBordecajas,
                blurRadius: AppConfig.sobraBordecajas)
          ]),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap:widget.onTap,
          // handle your onTap here
          child: Container(

            margin:
            EdgeInsets.only(left: 20.0, right: 20.0),
            width: responsive.anchoP(70),
            height: responsive.anchoP(17),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: responsive.anchoP(15),
                  height: responsive.anchoP(15),
                  child: widget.img!=null? Image.asset(
                    widget.img,
                  ):Image.asset(
                    AppConfig.iconNoImg,
                  ),
                ),
                SizedBox(
                  width: responsive.altoP(1),
                ),
                Expanded(
                    child: Text(
                      widget.titlte,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: responsive
                              .anchoP(AppConfig.tamTextoTitulo)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

}