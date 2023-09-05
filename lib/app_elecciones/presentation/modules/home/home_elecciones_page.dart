part of '../pages.dart';

class HomeEleccionesPage extends GetView<HomeEleccionesController> {
  HomeEleccionesPage({Key? key}) : super(key: key);

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
      imgPerfil: controller.loginController.user.value.foto.fotoBase64,
      name: controller.loginController.getName(),
      title: "MENÚ",
      peticionServer: controller.peticionServer,
      contenido: Column(
        children: [
          BtnMenuImgWidget(
            title: "CREAR CÓDIGO",
            onTap: () {
              controller.getPageProcesosOperativos();
            },
            img: AppEleccionesImages.iconAbrirRecElect,
          ),
          SizedBox(
            height: 10,
          ),
          BtnMenuImgWidget(
            title: "ANEXARSE",
            onTap: () {},
            img: AppEleccionesImages.iconRegistrarseRecElect,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
