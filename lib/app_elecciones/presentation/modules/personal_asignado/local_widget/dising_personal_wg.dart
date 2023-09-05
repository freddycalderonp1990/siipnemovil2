import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../app/core/values/app_images.dart';
import '../../../../../app_elecciones/core/values/app_elecciones_colors.dart';
import '../../../../../app_elecciones/core/values/app_elecciones_images.dart';
import '../../../../../app_siipne_movil/presentation/widgets/customWidgets.dart';

import '../../../../../app/core/utils/responsiveUtil.dart';

class DisingPersonal extends StatelessWidget {
  final int index;
  final String nombrePersonal;
  final GestureTapCallback? onTap;

  const DisingPersonal(
      {super.key,
      required this.index,
      required this.nombrePersonal,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

    return Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: AppEleccionesColors.colorBordecajas, blurRadius: 1)
            ]),
        child: Row(
          children: <Widget>[
            Text(
              (index + 1).toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: responsive.anchoP(4), fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: responsive.altoP(1),
            ),
            Image.asset(
              AppEleccionesImages.iconAgregarPersonal,
              width: responsive.anchoP(5),
              height: responsive.anchoP(5),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                    child: Text(
                  nombrePersonal != null ? nombrePersonal : 'Null',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: responsive.anchoP(4),
                  ),
                )),
              ),
            ),
            onTap != null
                ? BtnIconWidget(
                    onPressed: onTap,
                    titulo: '',
                    stringImg: AppImages.iconCancelar,
                  )
                : Container()
          ],
        ));
  }
}
