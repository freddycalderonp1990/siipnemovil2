import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app/core/app_config.dart';
import '../../../../../app/core/values/app_colors.dart';
import '../../../../../app/core/values/app_images.dart';
import '../../../../../app/presentation/widgets/custom_app_widgets.dart';



class PinCodeWidget extends StatelessWidget {
  const PinCodeWidget(
      {Key? key,

      required this.mostrarBtnGuardarPinCode,
      required this.onTapGuardar,
      required this.title,
      required this.onChanged,
        required this.value,
      required this.valueCode})
      : super(key: key);


  final String title;

  final ValueChanged<String>? onChanged;

  final GestureTapCallback onTapGuardar;

  final RxString valueCode;
  final String value;
  final RxBool mostrarBtnGuardarPinCode;

  @override
  Widget build(BuildContext context) {
    return getPin();
  }

  Widget getPin() {
    String _value = valueCode.value;

    List datos = ["", "", "", "", "", ""];



    Widget  wgBtn = Obx(() =>  Row(
            children: [
              !mostrarBtnGuardarPinCode.value
                  ? Container()
                  :  Flexible(
                child: BtnIconAppWidget(
                    title: title,
                    iconString: AppImages.iconGuardar,
                    onTap: onTapGuardar,),
              ),
              datos[0]!=""? Flexible(
                child: BtnIconAppWidget(
                    title: "Limpiar",
                    iconString: AppImages.iconCancelar,
                    onTap: () {
                      mostrarBtnGuardarPinCode.value = false;
                      valueCode.value = "";
                    },),
              ):Container(),
            ],
          ));

    if (_value.length == 1) {
      datos[0] = _value[0];
    } else if (_value.length == 2) {
      datos = ["*", "", "", "", "", ""];
      datos[1] = _value[1];
    } else if (_value.length == 3) {
      datos = ["*", "*", "", "", "", ""];
      datos[2] = _value[2];
    } else if (_value.length == 4) {
      datos = ["*", "*", "*", "", "", ""];
      datos[3] = _value[3];
    } else if (_value.length == 5) {
      datos = ["*", "*", "*", "*", "", ""];
      datos[4] = _value[4];
    } else if (_value.length == 6) {
      datos = ["*", "*", "*", "*", "*", ""];
      datos[5] = _value[5];
      mostrarBtnGuardarPinCode.value = true;
    }

    int intervalo = 3;
    List<Widget> contenido = [];

    List<Widget> fila = [];

    int contador = 1;

    for (int i = 1; i <= 12; i++) {
      if (contador <= intervalo) {
        fila.add(wgBtnTecladoNum(
            bloquear: mostrarBtnGuardarPinCode.value,
            num: i.toString(),
            onChanged: (value) {
              valueCode.value = valueCode.value + value;
              if (onChanged != null) {
                onChanged!(valueCode.value);
              }
            }));
        contador = contador + 1;
      } else {
        print("nueva fila");
        contador = 1;
        contenido.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: fila,
        ));

        i = i - 1;
        fila = [];
      }
    }

    //agregamos el cero al teclado
    contenido.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        wgBtnTecladoNum(
            num: "0",
            onChanged: (value) {
              _value = _value + value;
              valueCode.value = _value;
              if (onChanged != null) {
                onChanged!(valueCode.value);
              }
            })
      ],
    ));

    Widget teclado = Column(
      children: contenido,
    );

    List<Widget> childrenCodeText = [];
    for (int i = 0; i < datos.length; i++) {
      childrenCodeText.add(
        wgBtnTecladoCode(num: datos[i]),
      );
    }

    Widget cabeceraCode = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: childrenCodeText);

    Widget wg = Column(
      children: [
        cabeceraCode,
        SizedBox(
          height: 25,
        ),
        teclado,
        SizedBox(
          height: 15,
        ),
        wgBtn
      ],
    );

    return wg;
  }

  Widget wgBtnTecladoCode({
    required String num,
    ValueChanged<String>? onChanged,
  }) {
    return wgBtnTeclado(
        num: num,
        onChanged: onChanged,
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10));
  }

  Widget wgBtnTecladoNum(
      {required String num,
      ValueChanged<String>? onChanged,
      bool bloquear = false}) {
    return wgBtnTeclado(
        num: num,
        onChanged: bloquear ? (String) {} : onChanged,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20));
  }

  Widget wgBtnTeclado(
      {required String num,
      ValueChanged<String>? onChanged,
      EdgeInsetsGeometry? margin,
      EdgeInsetsGeometry? padding}) {
    return Flexible(
      child: Container(
        margin: margin,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(AppConfig.radioBotones),
          child: InkWell(
              borderRadius: BorderRadius.circular(AppConfig.radioBotones),
              onTap: () {
                if (onChanged != null) {
                  onChanged(num);
                }
              },
              // handle your onTap here
              child: Container(
                  padding: padding,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: AppColors.colorLineas,
                      width: 1.0,
                    ),
                    borderRadius:
                        BorderRadius.circular(AppConfig.radioBordecajas),
                  ),
                  child: TituloTextWidget(title: num))),
        ),
      ),
    );
  }
}
