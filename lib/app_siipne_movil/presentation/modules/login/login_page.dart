part of '../pages.dart';

class LoginPage extends GetView<LoginController> {
  final _formKey = GlobalKey<FormState>();

  var controllerUser = new TextEditingController();
  var controllerPass = new TextEditingController();

  void login({bool validarForm = true}) async {


    var isValid = true;

    if (validarForm) {
      isValid = _formKey.currentState!.validate();
    }

    if (isValid) {
      await controller.login();

    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
    Widget wg = Obx(() => WorkAreaLoginPageWidget(
          mostrarVersion: true,

          imgFondo: SiipneImages.imgFondoLogin,
          peticionServer: controller.peticionServerState,
          title: SiipneStrings.POLICIANACIONAL,
          sizeTittle: 7,
          contenido: <Widget>[
            SizedBox(
              height: responsive.altoP(3),
            ),
            Column(
              children: <Widget>[
                controller.wgLoginUserPass.value
                    ? WgLogin(
                        onPressed: () => login(),
                        controllerPass: controller.controllerPass,
                        controllerUser: controller.controllerUser,
                        formKey: _formKey,
                      )
                    : Container(),

                SizedBox(
                  height: responsive.altoP(3.5),
                ),
              ],
            )
          ],
        ));

/*
Para Mi UPC
    wg= Stack(children: [
      wg,
      Container(

          child: Stack(children: [
            Positioned(
                left:responsive.isVertical()? responsive.altoP(1):responsive.anchoP(1),
                top: responsive.isVertical()? responsive.altoP(1):responsive.anchoP(2),
                child:  SafeArea(
                  child: CupertinoButton(
                    minSize: responsive.isVertical()?responsive.altoP(5):responsive.anchoP(5),
                    padding: EdgeInsets.all(3),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black26,
                    onPressed: (){
                      /*prefsSelectApp.setSelectSiipne(false);
                      prefsSelectApp.setSelecMiUpc(false);*/
                      Get.offAllNamed(SiipneRoutes.HOME);
                    },//volver atras
                    child: Icon(Icons.arrow_back, color: Colors.white,size:responsive.isVertical()? responsive.altoP(3):responsive.anchoP(3),),
                  ),
                )
            )
          ],))
    ],);*/

    return GetBuilder<LoginController>(
      builder: (_c) => wg,
    );
  }


}
