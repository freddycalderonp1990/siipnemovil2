import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../app/core/app_config.dart';
import '../../../../../app/core/utils/responsiveUtil.dart';
import '../../../../../app/core/values/app_colors.dart';

class BtnIconOperativoWidget extends StatelessWidget {
  final String titulo;
  final String tipo;
  final bool select;
  final VoidCallback? onPressed;

  final Color colorTxt;
  final Color colorLineas;
  final IconData? icon;
  final Color colorIcon;

  const BtnIconOperativoWidget({
    Key? key,
    this.titulo = '',
    this.tipo = 'N',
    this.select = false,
    required this.onPressed,
    this.colorTxt = Colors.black,
    this.colorLineas = AppColors.colorAzul,
    this.icon,
    this.colorIcon = AppColors.colorAzul,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = 10.0;
    final responsive = ResponsiveUtil();
    Widget wg = const SizedBox.shrink();

    Widget iconWd = icon == null
        ? const SizedBox.shrink()
        : Icon(icon, color: colorIcon);

    wg = Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: TextButton.icon(
        label: tipo == 'N'
            ? Text(
                titulo,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: colorTxt,
                  fontSize: responsive.diagonalP(AppConfig.tamTexto),
                ),
              )
            : Text(''),
        icon: Container(
          height: responsive.diagonalP(AppConfig.tamIcons),
          child: iconWd,
        ),
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: colorLineas),
          ),
        ),
        onPressed: onPressed,
      ),
    );
    if (select) {
      wg = Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
        child: TextButton.icon(
          label: tipo == 'N'
              ? Text(
                  titulo,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: colorTxt,
                    fontSize: responsive.diagonalP(AppConfig.tamTexto),
                  ),
                )
              : Text(''),
          icon: Container(
            height: responsive.diagonalP(AppConfig.tamIcons + 1),
            child: iconWd,
          ),
          style: TextButton.styleFrom(
            side: BorderSide(width: 2, color: Colors.white),
            backgroundColor: AppColors.colorBotones,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(color: colorLineas),
            ),
          ),
          onPressed: onPressed,
        ),
      );
    }

    return wg;

    return Expanded(child: wg);
  }
}
