part of 'operativo_polco_local_widgets.dart';
class BtnTipoOperativoWg extends StatelessWidget {
  final String titulo;
  final String stringImg;
  final bool select;
  final VoidCallback? onPressed;

  const BtnTipoOperativoWg(
      {Key? key,
      required this.titulo,
      required this.stringImg,
      required this.select,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    double radius=5.0;
    final responsive = ResponsiveUtil();
    Widget wg = ElevatedButton.icon(
      icon: Container(
        padding: EdgeInsets.all(5),
        height: responsive.diagonalP(5),
        child: Image.asset(SiipneImages.icon_consult_person),
      ),
      label: Expanded(
        child: Text(titulo,
            style: TextStyle(
                color: Colors.white, fontSize: responsive.diagonalP(2))),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
    );

    if (select) {
      wg = ElevatedButton.icon(
        icon: Container(
          padding: EdgeInsets.all(5),
          height: responsive.diagonalP(5),
          child: Image.asset(SiipneImages.icon_consult_person),
        ),
        label: Expanded(
          child: Text(titulo,
              style: TextStyle(
                  color: Colors.white, fontSize: responsive.diagonalP(2))),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: AppColors.colorBotones.withOpacity(0.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: Colors.white.withOpacity(0.5))),
        ),
      );
    }
    wg = Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
        ),

      child: TextButton.icon(
        label: Text(titulo,
            style: TextStyle(
                color: Colors.white, fontSize: responsive.diagonalP(2))),
        icon: Container(

          height: responsive.diagonalP(3),
          child: Image.asset(stringImg),
        ),
        style: TextButton.styleFrom(

          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(color: Colors.white.withOpacity(1))),
        ),
        onPressed: onPressed,
      ),
    );
    if(select) {
      wg = Container(
        decoration: BoxDecoration(
            color: AppColors.colorBotones.withOpacity(0.5),
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                  color: AppColors.colorBordecajas,
                  blurRadius: SiipneConfig.sobraBordecajas)
            ]),

        child: TextButton.icon(
          label: Text(titulo,
              style: TextStyle(
                  color: Colors.white, fontSize: responsive.diagonalP(2))),
          icon: Container(

            height: responsive.diagonalP(3),
            child: Image.asset(stringImg),
          ),
          style: TextButton.styleFrom(

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: BorderSide(color: Colors.white.withOpacity(1))),
          ),
          onPressed: onPressed,
        ),
      );
    }
    return Expanded(
      child: wg,
    );
  }
}
