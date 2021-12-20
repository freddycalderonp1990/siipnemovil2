part of 'combosWidget.dart';

class ComboConBusqueda extends StatefulWidget {
  final String title;
  final ValueChanged<String> complete;
  final List<String> datos;
  final String hint;
  final String searchHint;
  final String selectValue;

  const ComboConBusqueda(
      {Key key,
      this.complete,
      @required this.datos,
      this.title = '',
      this.hint = 'Seleccione...',
      this.searchHint, this.selectValue})
      : super(key: key);

  @override
  _ComboConBusquedaState createState() => _ComboConBusquedaState();
}

class _ComboConBusquedaState extends State<ComboConBusqueda> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);

    return Container(
      margin: EdgeInsets.only(
        bottom: 5,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(color: AppConfig.colorBordecajas, blurRadius: 1)
          ]),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 5),
              width: responsive.anchoP(35),
              constraints: BoxConstraints(maxWidth: responsive.anchoP(30)),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.anchoP(AppConfig.tamTextoTitulo),
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: SearchableDropdown.single(

                value: widget.selectValue,
                clearIcon: Icon(
                  Icons.clear,
                ),
                iconDisabledColor: AppConfig.colorBordecajas.withOpacity(0.5),
                iconEnabledColor: AppConfig.colorBordecajas,
                onClear: () {
                  widget.complete(null);
                },
                displayItem: (item, selected) {
                  return (Row(children: [
                    selected
                        ? Icon(
                            Icons.check,
                            color: AppConfig.colorBordecajas,
                          )
                        : Icon(
                            Icons.check_box_outline_blank,
                            color: Colors.grey,
                          ),
                    SizedBox(width: 7),
                    Expanded(
                      child: item,
                    ),
                  ]));
                },
                items: setDatos(widget.datos, responsive),
                hint: Text(widget.hint,
                    style: TextStyle(
                      fontSize: responsive.anchoP(AppConfig.tamTextoTitulo),
                      color: Colors.black,
                    )),
                searchHint: SearchHintDesing(
                  valor: widget.searchHint,
                ),
                closeButton: "Cerrar",
                onChanged: (value) {
                  widget.complete(value);
                },
                isExpanded: true,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem> setDatos(
      List<String> datos, ResponsiveUtil responsive) {
    List<DropdownMenuItem> items = new List();

    for (int i = 0; i < datos.length; i++) {
      String valor = datos[i];
      if(valor!=null) {
        items.add(DropdownMenuItem(
          child: DesingDatos(
            valor: valor,
          ),
          value: valor,
        ));
      }
    }

    return items;
  }
}

class DesingDatos extends StatelessWidget {
  final String valor;

  const DesingDatos({Key key, this.valor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(color: AppConfig.colorBordecajas, blurRadius: 1)
            ]),
        child: Text(
          valor,
          style: TextStyle(
            fontSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            color: Colors.black,
          ),
        ));
  }
}

class SearchHintDesing extends StatelessWidget {
  final String valor;

  const SearchHintDesing({Key key, this.valor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    return Expanded(
      child: Text(valor,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: responsive.anchoP(AppConfig.tamTextoTitulo),
            color: Colors.black,
          )),
    );
  }
}
