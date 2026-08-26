part of 'operativo_polco_local_widgets.dart';

class DesingShowDataTitleDetalle extends StatelessWidget {
  final String title;
  final Color colorTitulos;
  final Widget imagen;
  final Widget datos;

  const DesingShowDataTitleDetalle({
    Key? key,
    this.colorTitulos = Colors.black,

    required this.title,
    required this.imagen,
    required this.datos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(2),
      width: responsive.anchoP(95),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
        border: Border.all(color: Colors.black, width: 0.2),
      ),
      child: Column(
        children: [
          TextSombrasWidget(
            colorTexto: colorTitulos,
            colorSombra: Colors.black26,
            title: title,
            size: responsive.diagonalP(AppConfig.tamTextoTitulo),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: responsive.diagonalP(8),
                    child: imagen,
                  ),
                ),

                Expanded(flex: 3, child: Container(child: datos)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
