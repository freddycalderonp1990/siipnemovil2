part of '../pages.dart';

class ProcesosOperativosEleccionesPage
    extends GetView<ProcesosOperativosEleccionesController> {
  ProcesosOperativosEleccionesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => WorkAreaPageAppWidget(
          btnAtras: true,
          imgPerfil: controller.loginController.user.value.foto.fotoBase64,
          name: controller.loginController.getName(),
          title: AppConfig.ubicacionLista.value
              ? "PROCESOS / OPERATIVOS"
              : "OBTENIENDO SU UBICACIÓN",
          peticionServer: controller.peticionServer,
          contenido: getContenidoBtn(),
        ));
  }

  Widget getContenidoBtn() {
    return Obx(() => ListView.builder(
        itemCount: controller.listDataProcesosDisponibles.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          DataProcesosDisponible data =
              controller.listDataProcesosDisponibles[i];

          return Column(
            children: [
              BtnMenuImgWidget(
                descripcion: data.descProcElecc,
                title: data.tipo,
                onTap: () {
                  controller.getPantalla(data);
                },
                img: AppEleccionesImages.iconMenu,
              ),
              SizedBox(
                height: 10,
              )
            ],
          );
        }));
  }
}
