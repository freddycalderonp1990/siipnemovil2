import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app/core/values/app_images.dart';
import '../../../../../app/presentation/widgets/custom_app_widgets.dart';
import '../../../../core/siipne_config.dart';
import '../../../../../app/core/utils/responsiveUtil.dart';
import '../../../../core/values/siipne_images.dart';
import '../../../../core/values/siipne_strings.dart';
import '../../../../presentation/widgets/customWidgets.dart';
import '../../controllers.dart';

class WgLogin extends StatefulWidget {
  final controllerUser;

  final controllerPass;

  final VoidCallback? onPressed;
  final formKey;
  final double ancho;
  final bool mostrarFondo;

  const WgLogin(
      {Key? key,
      this.controllerUser,
      this.controllerPass,
      this.onPressed,
      this.formKey,
      this.ancho = 50.0,
      this.mostrarFondo = false})
      : super(key: key);

  @override
  _WgLoginState createState() => _WgLoginState();
}

class _WgLoginState extends State<WgLogin> {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
    final sizeTxt = responsive.anchoP(SiipneConfig.tamTexto + 2.0);

    Widget desing = Column(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: responsive.ancho! - widget.ancho,
            minWidth: responsive.ancho! - widget.ancho,
          ),
          child: Form(
              key: widget.formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, //PARA PROBAR CONTAINER
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                    child: ImputTextWidget(

                      imgString: AppImages.icon_usuario,
                      controller: widget.controllerUser,
                      elevation: 1,
                      label: SiipneStrings.Usuario,
                      fonSize: sizeTxt,
                      hitText: SiipneStrings.ingreseUsuario,
                      validar: (text) {
                        if (text!.length >= 1) {
                          return null;
                        }
                        return SiipneStrings.caracteresNoValidos;
                      },
                    ),
                  ),
                  SizedBox(
                    height: responsive.altoP(2),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, //PARA PROBAR CONTAINER
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                    child: ImputTextWidget(
                      imgString: AppImages.icon_clave,
                      elevation: 1,
                      isSegura: true,
                      controller: widget.controllerPass,
                      hitText: SiipneStrings.ingreseClave,
                      label: SiipneStrings.Clave,
                      fonSize: sizeTxt,
                      validar: (text) {
                        if (text.toString().length >= 1) {
                          return null;
                        }
                        return SiipneStrings.claveNoValida;
                      },
                    ),
                  )
                ],
              )),
        ),
        SizedBox(
          height: responsive.altoP(4),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: responsive.ancho! - 80,
            minWidth: responsive.ancho! - 80,
          ),
          child: BotonesWidget(
            iconData: Icons.arrow_forward,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            title: SiipneStrings.LOGIN,
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );

    Widget wg = widget.mostrarFondo
        ? Stack(
            children: [
              Container(
                height: responsive.alto! / 2,
                width: responsive.ancho! - 100,
                child: Image.asset(
                  SiipneImages.imgFondoLogin,
                  fit: BoxFit.cover,
                ),
              ),
              desing
            ],
          )
        : desing;

    return GetBuilder<LoginController>(
        id: 'WgLogin',
        builder: (_) => _.wgLoginUserPass.value ? wg : Container());
  }
}
