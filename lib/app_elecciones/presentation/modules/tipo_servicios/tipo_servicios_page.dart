part of '../pages.dart';

class TipoServiciosPage extends GetView<TipoServiciosController> {
  const TipoServiciosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => WorkAreaPageAppWidget(
        btnAtras: true,
        imgPerfil: controller.loginController.user.value.foto.fotoBase64,
        name: controller.loginController.getName(),
        title: "TIPO DE SERVICIO",
        peticionServer: controller.peticionServer,
        contenido: getContenido()));
  }

  getContenido() {
    return Column(
      children: [
        TituloTextWidget(title: "Porceso/Operativo: ${controller.dataProcesosDisponible.descProcElecc}",colorTitulo: Colors.white),

        DetalleTextWidget(detalle: "Seleccione el servicio al que fue designado",todoElAncho: true,colorDetalle: Colors.white),
        SizedBox(
          height: 15,
        ),
        controller.dataEjesAsignados.value.tipoEjeRecintos
            ? getDesing("SERVICIO EN RECINTOS",AppEleccionesImages.iconAbrirRecElect)
            : Container(),
        controller.dataEjesAsignados.value.tipoEjeUnidadesPoliciales
            ? getDesing("UNIDADES POLICIALES",AppEleccionesImages.iconAgregarPersonal)
            : Container(),
        controller.dataEjesAsignados.value.tipoEjeOtros
            ? getDesing("OTROS",AppEleccionesImages.iconRegistrarNovedadesRecElec)
            : Container(),
      ],
    );
  }

  getDesing(String titulo,String img,{String? pantalla}) {
    return Column(
      children: [
        BtnMenuImgWidget(
          title: titulo,
          onTap: () {
            Get.toNamed(EleccionesRoutes.EJES_UNIDADES_POLICIALES);

          },
          img: img,
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
