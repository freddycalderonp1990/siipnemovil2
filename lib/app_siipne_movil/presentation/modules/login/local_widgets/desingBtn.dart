import '../../../../presentation/widgets/customWidgets.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DesingBtn extends StatelessWidget {
  final String? title;
  final String? img;
  final double ancho;
  final GestureTapCallback? onTap;


  const DesingBtn({Key? key, this.title, this.img, this.ancho=60.0, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BtnMenuWidget(

      img: img,
      title: this.title,
      horizontal: false,
      onTap: this.onTap,
      colorFondo: Colors.black26,
      colorTexto: Colors.white,
    );;
  }


}
