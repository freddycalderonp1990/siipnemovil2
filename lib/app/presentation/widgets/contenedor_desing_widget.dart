part of 'custom_app_widgets.dart';

class ContenedorDesingWidget extends StatelessWidget {
  final Widget child;
  final double anchoPorce;
  final double? altoPorce;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? paddin;

  const ContenedorDesingWidget({
    super.key,
    required this.child,
    this.anchoPorce=97.0,
    this.altoPorce,
    this.margin,
    this.paddin,
  });

  @override
  Widget build(BuildContext context){
    final responsive=ResponsiveUtil();

    final Widget contenido=Container(
      width:responsive.anchoP(anchoPorce),
      height:altoPorce!=null
          ?responsive.altoP(altoPorce!)
          :null,
      padding:paddin,
      margin:margin,
      decoration:BoxDecoration(
        color:Colors.white.withOpacity(.90),
        borderRadius:BorderRadius.circular(
          AppConfig.radioBordecajas,
        ),
        border:Border.all(
          color:AppColors.colorBordecajas,
          width:2,
        ),
      ),
      child:child,
    );

    if(altoPorce!=null){
      return contenido;
    }

    return Align(
      alignment:Alignment.topCenter,
      child:IntrinsicHeight(
        child:contenido,
      ),
    );
  }
}