import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../app/core/app_config.dart';
import '../../../../../../app/core/utils/responsiveUtil.dart';
import '../../../../../../app/core/utils/utilidadesUtil.dart';
import '../../../../../../app/core/values/app_colors.dart';
import '../../../../../../app/core/values/app_images.dart';
import '../../../../../../app/presentation/widgets/custom_app_widgets.dart';
import '../../controllers.dart';

class WgLogin extends StatefulWidget {
  final controllerUser;

  final controllerPass;

  final VoidCallback? onPressed;

  final formKey;
  final double ancho;
  final bool mostrarFondo;

  const WgLogin({
    Key? key,
    this.controllerUser,
    this.controllerPass,
    this.onPressed,

    this.formKey,
    this.ancho = 50.0,
    this.mostrarFondo = false,
  }) : super(key: key);

  @override
  _WgLoginState createState() => _WgLoginState();
}

class _WgLoginState extends State<WgLogin> {
  @override
  void initState() {
    // createTutorial();

    super.initState();
  }

  GlobalKey keyAllLogin = GlobalKey();

  GlobalKey keyTextUsuario = GlobalKey();
  GlobalKey keyTextClave = GlobalKey();
  GlobalKey keyBtnLogin = GlobalKey();
  GlobalKey keyOlvidoContrasena = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

    Widget desing = OnlyDesingUserPass(
      onPressed: widget.onPressed,
      keyBtnLogin: keyBtnLogin,
      ancho: widget.ancho,
      controllerPass: widget.controllerPass,
      controllerUser: widget.controllerUser,
      formKey: widget.formKey,
      keyTextClave: keyTextClave,
      keyTextUsuario: keyTextUsuario,
    );

    desing = Column(
      children: [
        desing,
        SizedBox(height: 0, key: keyAllLogin),
      ],
    );

    Widget wg = widget.mostrarFondo
        ? Stack(
            children: [
              Container(
                height: responsive.alto! / 2,
                width: responsive.ancho! - 100,
                child: Image.asset(
                  AppImages.imgFondoDefault,
                  fit: BoxFit.cover,
                ),
              ),
              desing,
            ],
          )
        : desing;

    return GetBuilder<LoginController>(id: 'WgLogin', builder: (_) => wg);
  }
}

class OnlyDesingUserPass extends StatelessWidget {
  final double ancho;
  final formKey;
  final controllerUser;
  final controllerPass;
  final keyTextUsuario;
  final keyTextClave;
  final keyBtnLogin;
  final VoidCallback? onPressed;
  const OnlyDesingUserPass({
    super.key,
    this.formKey,
    this.ancho = 50.0,
    this.controllerUser,
    this.controllerPass,
    this.keyTextUsuario,
    this.keyTextClave,
    this.onPressed,
    this.keyBtnLogin,
  });
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
    final sizeTxt = responsive.diagonalP(AppConfig.tamTextoTitulo);

    Widget desing = Column(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: responsive.ancho! - ancho,
            minWidth: responsive.ancho! - ancho,
          ),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      key: keyTextUsuario,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ImputTextWidget(
                        icono: Icon(
                          Icons.person_outline,
                          color: AppColors.colorIcons,
                          size: 34,
                        ),
                        controller: controllerUser,
                        elevation: 1,
                        label: "Usuario",
                        fonSize: sizeTxt,
                        hitText: "Ingrese el usuario",
                        validar: (text) {
                          if (text!.length >= 10) {
                            return null;
                          }
                          return "Usuario no válido";
                        },
                      ),
                    ),
                    SizedBox(height: responsive.altoP(2)),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ImputTextWidget(
                        key: keyTextClave,
                        icono: Icon(
                          Icons.lock_outline,
                          color: AppColors.colorIcons,
                          size: 34,
                        ),
                        elevation: 1,
                        isSegura: true,
                        controller: controllerPass,
                        hitText: "Ingrese la clave",
                        label: "Clave",
                        fonSize: sizeTxt,
                        validar: (text) {
                          if (text.toString().length >= 8) {
                            return null;
                          }
                          return "Clave no válida";
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.altoP(1)),
              desingOlvidoContrasena(),
            ],
          ),
        ),

        SizedBox(height: responsive.altoP(2)),
        ConstrainedBox(
          key: keyBtnLogin,
          constraints: BoxConstraints(
            maxWidth: responsive.ancho! - 80,
            minWidth: responsive.ancho! - 80,
          ),
          child: BotonesWidget(
            iconData: Icons.check_circle,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            title: "INGRESAR",
            onPressed: onPressed,
          ),
        ),
      ],
    );
    return desing;
  }

  Widget desingOlvidoContrasena() {
    return Row(
      children: [
        Transform.translate(
          offset: const Offset(0, -2),
          child: Checkbox(
            value: true,
            onChanged: (v) {},
            activeColor: AppColors.colorAzul,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const Text(
          "Recordar usuario",
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w500,
          ),
        ),

        const Spacer(),

        InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            UtilidadesUtil.abrirUrl(
              "https://siipne.policia.gob.ec/usuarios/Recuperar.php",
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "¿Olvidaste tu contraseña?",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.colorAzul,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
