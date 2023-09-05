part of '../pages.dart';

class MenuJefePage extends GetView<MenuJefeController> {
  const MenuJefePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
    return Obx(() => WorkAreaPageAppWidget(
        imgPerfil: controller.loginController.user.value.foto.fotoBase64,
        name: controller.loginController.getName(),
        title:
            "CÓDIGO DEL OPERATIVO: ${controller.dataProcesosAbierto.value.codigoRecinto.toString()}",
        peticionServer: controller.peticionServer,
        contenido: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppConfig.radioBordecajas),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white60.withOpacity(0.3),
                            blurRadius: 10)
                      ]),
                  child: Obx(() => Text(
                        controller.dataProcesosAbierto.value.nomRecintoElec,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.anchoP(3.5)),
                      ))),
              SizedBox(
                height: 10,
              ),
              getMenu(),
              SizedBox(
                height: 10,
              ),
              BtnIconWidget(
                select: true,
                stringImg: AppImages.iconMenu,
                titulo: " Ir al Menú ",
                onPressed: () {
                  Get.offAllNamed(AppRoutes.HOME_APP);
                },
              )
            ],
          ),
        )));
  }

  Widget getMenu() {
    return AppEleccionesConfig.dataProcesosAbierto.isJefe
        ? getMenuJefe()
        : getMenuIntegrante();
  }

  Widget getMenuJefe() {
    return Column(
      children: [
        BtnMenuImgWidget(
          title: "AGREGAR PERSONAL",
          onTap: () {
            Get.toNamed(EleccionesRoutes.ADD_PERSONAL);
          },
          img: AppEleccionesImages.iconAgregarPersonal,
        ),
        SizedBox(
          height: 10,
        ),
        BtnMenuImgWidget(
          title: "REGISTRAR NOVEDADES",
          onTap: () {
            Get.toNamed(EleccionesRoutes.NOVEDADES, arguments: {
              'idDgoTipoEje': controller.dataProcesosAbierto.value.idDgoTipoEje
            });
          },
          img: AppEleccionesImages.iconRegistrarNovedadesRecElec,
        ),
        SizedBox(
          height: 10,
        ),
        BtnMenuImgWidget(
          title: "FINALIZAR OPERATIVO",
          onTap: () {
            controller.finalizarOperativo();
          },
          img: AppEleccionesImages.iconFinalizarRecElec,
        ),
        SizedBox(
          height: 10,
        ),
        BtnMenuImgWidget(
          title: "ELIMINAR OPERATIVO",
          onTap: () {},
          img: AppEleccionesImages.iconEliminarOperativo,
        ),
      ],
    );
  }

  Widget getMenuIntegrante() {
    return Column(
      children: [
        BtnMenuImgWidget(
          title: "REGISTRAR NOVEDADES",
          onTap: () {
            Get.toNamed(EleccionesRoutes.NOVEDADES, arguments: {
              'idDgoTipoEje': controller.dataProcesosAbierto.value.idDgoTipoEje
            });
          },
          img: AppEleccionesImages.iconRegistrarNovedadesRecElec,
        ),
        SizedBox(
          height: 10,
        ),
        BtnMenuImgWidget(
          title: "ABANDONAR OPERATIVO",
          onTap: () {
            controller.abandonarRecintoInstalacion();
          },
          img: AppEleccionesImages.iconFinalizarRecElec,
        ),
      ],
    );
  }
}
