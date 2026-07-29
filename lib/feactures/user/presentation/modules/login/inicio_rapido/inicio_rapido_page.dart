part of '../../pages.dart';

class InicioRapidoPage extends GetView<InicioRapidoController> {
  @override
  Widget build(BuildContext context) {
    /*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsBloc>().requestPermission(
        appName: NamApps.todas,
        idGenUsuario: controller.user.value.idGenUsuario,
      );
    });
    */

    final responsive = ResponsiveUtil();

    Widget wg = Obx(()=>WorkAreaPageLoginWidget(
      imgFondo: AppImages.imgFondoLogin,
      imgPerfil: controller.user.value.foto,
      mostrarBtnHome: controller.mostrarBtnHome.value,

      onPressedBtnHome: () {
        // controller.setAppPageSelect(PageAppsSelect.Bienvenida);
      },


      peticionServer: controller.peticionServerState,

      contenido: getContenido(responsive),
    ));

    return GetBuilder<LoginController>(builder: (_c) => wg);
  }

  Widget getContenido(ResponsiveUtil responsive) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => DesingTextNameUser(
              sizeText: responsive.diagonalP(AppConfig.tamTextoTitulo - 0.4),
              sexo: controller.user.value.sexo,
              text: controller.user.value.nombres,
            ),
          ),

          SizedBox(height: responsive.altoP(2)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: responsive.anchoP(10)),

            child: Column(
              children: [
                wgHuella(),
                SizedBox(height: responsive.altoP(2)),
                wgOtroUsuario(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget wgHuella() {
    Widget wg = DesignBtnLoginRapidoWidget(
      icon: Icons.fingerprint_rounded,

      titulo: "Huella / Face ID",
      descripcion: "Ingresar con biometría",
      onTap: () => controller.loginConBiometrico(),
    );

    return wg;
  }

  Widget wgOtroUsuario() {
    Widget wg = BtnMenuWidget(
      img: AppImages.icon_clave,
      title: "Ingresa con Usuario y Clave",
      horizontal: false,
      onTap: () => controller.ingresoConOtroUsuario(),
      colorFondo: AppColors.colorIcons,
      colorTexto: Colors.white,
    );

    wg = DesignBtnLoginRapidoWidget(
      icon: Icons.lock_person_rounded,

      titulo: "Usuario y contraseña",
      descripcion: "Ingresar de forma tradicional",
      onTap: () => controller.ingresoConOtroUsuario(),
    );

    return wg;
  }
}
