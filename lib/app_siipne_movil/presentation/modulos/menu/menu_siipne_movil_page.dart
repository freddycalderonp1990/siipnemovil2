part of '../pages.dart';

class MenuSiipneMovilPage extends GetView<MenuSiipneMovilController> {
  const MenuSiipneMovilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //aqui obtenemos el token
    // context.read<NotificationsBloc>().requestPermission(appName: NamApps.Censo, idGenUsuario: controller.user.idGenUsuario);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsBloc>().requestPermission(
        appName: NamApps.SiipneMovil,
        idGenUsuario: controller.user.idGenUsuario,
      );
    });

    return WorkAreaPageSiipneMovilWidget(
      showGps: true,
      mostrarBtnAtras: false,
      title: "PERMISOS DE APLICACIONES",
      contenido: getContenido(),
      peticionServer: controller.peticionServerState,
    );
  }

  getContenido() {
    return Stack(
      children: [
        Column(
          children: [
            DesingFotoNameWidget(
              img: controller.user.foto,
              sexo: controller.user.sexo,
              nombres: controller.user.nombres,
            ),
            Expanded(child: _getMenu()),
          ],
        ),

        Obx(
          () => controller.mostrarIndicador.value
              ? Positioned(
                  bottom: 18,
                  left: 0,
                  right: 0,
                  child: IndicadorScroll(),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  _getMenu() {
    final responsive = ResponsiveUtil();
    Widget wg = Obx(
      () => ListView.builder(
        padding: EdgeInsets.zero,
        controller: controller.scrollController,
        itemCount: controller.listModulos.length,
        itemBuilder: (_, index) {
          final modulo = controller.listModulos[index];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: BtnMenuSiipneMovilWidget(
              horizontal: true,
              colorFondo: Colors.white,
              img: AppSiipneMovilImages.ic_operativos_su,
              title: modulo.descripcion,
              descripcion: modulo.detalle,
              onTap: () {
                controller.goToNextPage(modulo);
              },
            ),
          );
        },
      ),
    );

    return wg;
  }
}
