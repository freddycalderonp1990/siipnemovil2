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
      mostrarBtnAtras: true,
      title: "PERMISOS DE APLICACIONES",
      contenido: _getMenu(),
      peticionServer: controller.peticionServerState,
    );
  }

 /* Widget getContenido() {
    final responsive = ResponsiveUtil();

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DesingFotoNameWidget(
            img: controller.user.foto,
            sexo: controller.user.sexo,
            nombres: controller.user.nombres,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: responsive.altoP(2)),
                _getMenu(responsive),
                SizedBox(height: responsive.altoP(4)),
                BtnIconWidget(
                  icon: Icons.exit_to_app,
                  titulo: "SALIR",
                  onPressed: () => controller.cerrarSession(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }*/

  _getMenu() {

    final responsive = ResponsiveUtil();
    Widget wg= Obx(()=>ListView.builder(
      itemCount:controller.listModulos.length,
      itemBuilder: (_, index) {

        final modulo =controller.listModulos[index];

        return Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),child: BtnMenuSiipneMovilWidget(
          horizontal: true,
          colorFondo: Colors.white,
          img: AppSiipneMovilImages.ic_operativos_su,
          title: modulo.descripcion,
          descripcion: modulo.detalle,
          onTap: () {
          },
        ),);



      },
    ));


  return wg;
  }


}
