import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../app/core/utils/responsiveUtil.dart';

class TitleDetalleWg extends StatelessWidget {
  final title;
  final descripcion;

  const TitleDetalleWg({Key? key, this.title = "", this.descripcion = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: responsive.diagonalP(1.5)),
          ),
          TextSpan(
              text: descripcion,
              style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: responsive.diagonalP(1.5))),
        ],
      ),
    );
  }
}
