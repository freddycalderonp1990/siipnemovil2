part of '../pages.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WorkAreaPageAppWidget(
        btnAtras: true,
        pantallaIrAtras: () {
          print(
            "object",
          );
          Get.offAllNamed(AppRoutes.HOME_APP);
        },
        name: controller.loginController.getName(),
        title: "MODULOS - SIIPNE MÓVIL 2",
        peticionServer: controller.peticionServerState,
        imgPerfil: controller.loginController.user.value.foto.fotoBase64,
        contenido: Column(
          children: [
            Obx(() => controller.modulos.length > 0
                ? Container(
                    child: BtnIconWidget(
                      select: true,
                      stringImg: SiipneImages.icon_consult_person,
                      titulo: "Anexarse",
                      onPressed: () {
                        /*DialogosDesingWidget.getDialogoX(
                        title: "Anexarse", contenido: Text("Codigo"));*/
                      },
                    ),
                  )
                : Container()),
            Expanded(child: getMenu())
          ],
        ));
  }

  getMenu() {
    Widget wg = Obx(() => GridDashboard(
          homeController: controller,
          modulos: controller.modulos.value,
        ));

    return wg;
  }
}
