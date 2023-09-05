part of '../pages.dart';

class EjesHijosPage extends GetView<EjesHijosController> {
  const EjesHijosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => WorkAreaPageAppWidget(
        btnAtras: true,
        imgPerfil: controller.loginController.user.value.foto.fotoBase64,
        name: controller.loginController.getName(),
        title: "UNIDADES POLCIALES",
        peticionServer: controller.peticionServer,
        contenido: getContenido()));
  }


  Widget getContenido() {
    return Obx(() => ListView.builder(
        itemCount: controller.listDataEjesHijos.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          DataEjes data =
          controller.listDataEjesHijos[i];

          return Column(
            children: [
              BtnMenuImgWidget(
                img: AppImages.iconMenu,

                title: data.descripcion,
                onTap: () {
controller.getPantalla(data);
                },

              ),
              SizedBox(
                height: 10,
              )
            ],
          );
        }));
  }
}
