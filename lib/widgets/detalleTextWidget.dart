part of 'customWidgets.dart';
class DetalleTextWidget extends StatefulWidget {
  final String detalle;


  final  Color colorDetalle ;
  final double ancho;
  final  EdgeInsetsGeometry padding;
  final bool todoElAncho;

  const DetalleTextWidget({Key key, this.detalle, this.colorDetalle=Colors.black, this.ancho=47, this.padding, this.todoElAncho=false}) : super(key: key);


  @override
  _DetalleTextWidgetState createState() => _DetalleTextWidgetState();
}

class _DetalleTextWidgetState extends State<DetalleTextWidget> {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);

    Widget text=Text(
      widget.detalle,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: widget.colorDetalle,
          fontSize: responsive.anchoP(AppConfig.tamTexto)),
    );
    return  Padding(
        padding:widget.padding==null?EdgeInsets.only(left: 5, right: 10, top: 0, bottom: 0):widget.padding,

        child:!widget.todoElAncho? Container(
          width: responsive.anchoP(widget.ancho),
          child: text,
        ):Container(

          child: text,
        ) );
  }
}
