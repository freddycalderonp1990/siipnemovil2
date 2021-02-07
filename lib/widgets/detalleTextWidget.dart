part of 'customWidgets.dart';
class DetalleTextWidget extends StatefulWidget {
  final String detalle;


  final  Color colorDetalle ;
  final double ancho;

  const DetalleTextWidget({Key key, this.detalle, this.colorDetalle=Colors.black, this.ancho=47}) : super(key: key);


  @override
  _DetalleTextWidgetState createState() => _DetalleTextWidgetState();
}

class _DetalleTextWidgetState extends State<DetalleTextWidget> {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    return  Padding(
        padding:
        const EdgeInsets.only(left: 5, right: 10, top: 0, bottom: 0),
        child: Container(
          width: responsive.anchoP(widget.ancho),
          child: Text(
            widget.detalle,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: widget.colorDetalle,
                fontSize: responsive.anchoP(AppConfig.tamTexto)),
          ),
        ));
  }
}
