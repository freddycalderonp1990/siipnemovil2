part of 'customWidgets.dart';

class BtnMenuWidget2 extends StatefulWidget {
  final img;
  final String? titlte;
  final String? descripcion;
  final GestureTapCallback? onTap;

  final Color colorTexto;
  final Color colorFondo;

  const BtnMenuWidget2(
      {this.img = null,
      this.titlte = '',
      this.onTap,
      this.colorTexto = Colors.black,
      this.colorFondo = Colors.white,
      this.descripcion});

  @override
  _BtnMenuWidget2 createState() => _BtnMenuWidget2();
}

class _BtnMenuWidget2 extends State<BtnMenuWidget2> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final responsive = ResponsiveUtil();

    Widget horizontal = Container(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(1),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            width: responsive.anchoP(20),
            height: responsive.anchoP(20),
            child: widget.img != null
                ? Container(
                    child: Image.asset(
                      widget.img,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  )
                : Image.asset(
                    AppImages.iconNoImg,
                  ),
          ),
          SizedBox(
            width: responsive.altoP(0.5),
          ),
          Flexible(
              child:


              Material(
            color: Colors.white,

            borderRadius: BorderRadius.circular(10),

            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: widget.onTap,
              // handle your onTap here
              child: Container(

                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                width: responsive.anchoP(100),
                height: responsive.anchoP(25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            widget.titlte!,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: widget.colorTexto != null
                                    ? widget.colorTexto
                                    : Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive
                                    .anchoP(SiipneConfig.tamTextoTitulo)),
                          ),
                        ),
                        widget.descripcion != null
                            ? Flexible(
                                child: Text(
                                  widget.descripcion!,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: widget.colorTexto != null
                                          ? widget.colorTexto
                                          : Colors.black,

                                      fontSize: responsive
                                          .anchoP(SiipneConfig.tamTextoTitulo)),
                                ),
                              )
                            : Container()
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );

    return horizontal;
  }
}
