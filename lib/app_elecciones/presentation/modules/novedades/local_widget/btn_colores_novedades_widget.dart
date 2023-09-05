import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../app/core/app_config.dart';
import '../../../../../app/core/utils/responsiveUtil.dart';
import '../../../../core/values/app_elecciones_colors.dart';

class BtnColoresNovedadesWidget extends StatelessWidget {
  final String title;
  final Color color;

  const BtnColoresNovedadesWidget({Key? key, required this.title, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getBtnColores();
  }

  Widget getBtnColores() {
    final responsive = ResponsiveUtil();
    return Container(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
      width: responsive.anchoP(20),
      height: responsive.altoP(2),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
          boxShadow: [
            BoxShadow(
                color: AppEleccionesColors.colorBordecajas,
                blurRadius: AppConfig.sobraBordecajas)
          ]),
    );
  }
}
