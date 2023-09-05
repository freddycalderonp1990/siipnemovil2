part of '../pages.dart';

class EjesUnidadesPolicialesPage
    extends GetView<EjesUnidadesPolicialesController> {
  const EjesUnidadesPolicialesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => WorkAreaPageAppWidget(
        btnAtras: true,
        imgPerfil: controller.loginController.user.value.foto.fotoBase64,
        name: controller.loginController.getName(),
        title: "TIPOS DE EJES",
        peticionServer: controller.peticionServer,
        contenido: getContenido()));
  }

  Widget getContenido() {
    return Obx(() => ListView.builder(
        itemCount: controller.listDataEjesUnidadesPoliciales.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          DataEjes data = controller.listDataEjesUnidadesPoliciales[i];

          return Column(
            children: [
              BtnMenuImgWidget(
                title: data.descripcion,
                img: AppImages.iconMenu,
                onTap: () {
                  Get.toNamed(EleccionesRoutes.EJES_HIJOS, arguments: data);
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
