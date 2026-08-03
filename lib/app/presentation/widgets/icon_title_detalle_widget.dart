part of 'custom_app_widgets.dart';

class IconTitleDetalleWidget extends StatelessWidget {
  final String nameStringImg;
  final String title;
  final String detalle;
  final MainAxisAlignment mainAxisAlignment;
  final double sizeText;
  final bool todoElAncho;
  final Color colorTexto;

  const IconTitleDetalleWidget(
      {Key? key,
      required this.nameStringImg,
      required this.detalle,
        required this.title,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.sizeText = AppConfig.tamTexto, this.todoElAncho=false,  this.colorTexto=Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget wg = Row(mainAxisAlignment: mainAxisAlignment, children: [
      OnlyIconWidget(
        size: AppConfig.tamIcons-0.9,
        nameStringImg: nameStringImg,
      ),
      TituloTextWidget(
       colorTitulo: colorTexto,
        title: title,
      ),
      Flexible(
        child: DetalleTextWidget(
          colorDetalle: colorTexto,
          todoElAncho: todoElAncho,
          sizeText: sizeText,
          detalle: detalle,
        ),
      )
    ]);

    return wg;
  }
}


class IconTitleDetalleWidget2 extends StatelessWidget {


  final IconData? icon;
  final String title;
  final String? detalle;
  final MainAxisAlignment mainAxisAlignment;
  final double sizeText;
  final bool todoElAncho;
  final Color colorTexto;

  const IconTitleDetalleWidget2(
      {Key? key,
        required this.icon,
        this.detalle,
        required this.title,
        this.mainAxisAlignment = MainAxisAlignment.start,
        this.sizeText = AppConfig.tamTexto,
        this.todoElAncho = false,
        this.colorTexto = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();


    if(detalle==null){
      return const SizedBox.shrink();
    }
    Widget wg = Row(mainAxisAlignment: mainAxisAlignment, children: [





      Icon(
        icon,
        size: responsive.diagonalP(1.5),
        color: AppColors.colorIcons,
      ),
      TextSombrasWidget(
        colorTexto: Colors.black,
        colorSombra: AppColors.colorPlomo,
        title: title,
        size: responsive.diagonalP(AppConfig.tamTexto - 0.4),
      ),
      SizedBox(width: 5,),
      Flexible(
        child: TextSombrasWidget(
          colorTexto: colorTexto,
          colorSombra: AppColors.colorPlomo,
          title: detalle!,
          size: responsive.diagonalP(AppConfig.tamTexto - 0.5),
        ),
      ),
    ]);

    return wg;
  }
}
