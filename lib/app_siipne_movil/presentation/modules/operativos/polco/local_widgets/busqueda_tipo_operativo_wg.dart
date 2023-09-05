part of 'operativo_polco_local_widgets.dart';

class BusquedaTipoOperativoWg extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String title;
  final String msjError;
  final GlobalKey<FormState> myKey;
  final int maxLength;
  final TextInputType keyboardType;
  final Icon? icono;
  final double anchoPorcentaje;
  final TextEditingController controller;

  const BusquedaTipoOperativoWg({ this.onTap,required this.title,required this.msjError,required this.myKey, this.maxLength=11, this.keyboardType=TextInputType.text, this.icono, this.anchoPorcentaje=100, required this.controller}) ;

  @override
  Widget build(BuildContext context) {


    final responsive = ResponsiveUtil();
    return Container(

        padding: EdgeInsets.only(bottom: 2,top: 0),
        width: responsive.anchoP(anchoPorcentaje),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SiipneConfig.radioBordecajas),
          border: Border.all(color: AppColors.colorBordecajas, width: 1),
        ),
        child: Container(
          margin: EdgeInsets.only(left: 0.0, right: 20.0),


          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: responsive.altoP(1),
              ),
              Expanded(
                  child: Form(
                    key: myKey,
                    child: ImputTextWidget(
                      controller: controller,
                      keyboardType: keyboardType,
                      maxLength: maxLength,
                      icono: icono,
                      activar: true,
                      colorLabel: Colors.blue,
                      label: title,
                      fonSize: responsive.diagonalP(2),
                      validar: (value) {
                        if (value.toString().length == 0) {
                          return msjError;
                        }
                      },
                    ),
                  )),
              SizedBox(
                width: responsive.altoP(1),
              ),
              BtnIconWidget(

                onPressed: onTap,
                stringImg:  AppImages.icon_buscar,
              ),
            ],
          ),
        ));
  }
}
