part of 'pages.dart';

//Se encarga de verificar los permisos y si se encuentra activo el GPS
// se debe enviar en pantalla, la pantalla que queremos mostrar cuando _todo esta correcto
//si los permisos y la ubicacion del GPS se encuentra activa se redirecciona de manera automatica a la pantala especificada


class VerificarGpsPage extends StatefulWidget {
  final Widget pantalla;

  const VerificarGpsPage({Key key, @required this.pantalla}) : super(key: key);
  @override
  _VerificarGpsPageState createState() => _VerificarGpsPageState();
}

class _VerificarGpsPageState extends State<VerificarGpsPage> {
  @override
  Widget build(BuildContext context) {
    return  myGps(pantalla:widget.pantalla,);

  }
}
