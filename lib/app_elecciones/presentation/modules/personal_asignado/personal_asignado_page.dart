part of '../pages.dart';

class PersonalAsignadoPage extends GetView<PersonalAsignadoController> {
  const PersonalAsignadoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => WorkAreaPageAppWidget(
          btnAtras: true,
          imgPerfil: controller.loginController.user.value.foto.fotoBase64,
          name: controller.loginController.getName(),
          title: "REPORTE DEL PERSONAL",
          peticionServer: controller.peticionServer,
          contenido: getContenido(),
        ));
  }

  Widget getContenido() {
    return Column(
      children: [
        _wgJefe(),
        Flexible(child: _PersonalActivo()),
      ],
    );
  }

  Widget _wgJefe() {
    final responsive = ResponsiveUtil();
    return ContenedorDesingWidget(
        paddin: EdgeInsets.all(5),
        child: Obx(() => Column(
              children: [
                TituloDetalleTextWidget(
                  title: "Encargado",
                  detalle: controller.dataPerJefe.value.personalName,
                ),
                TituloDetalleTextWidget(
                  title: "Fecha Inicio",
                  detalle: controller.dataPerJefe.value.fechaIni,
                ),
                TituloDetalleTextWidget(
                  title: "Total Personal",
                  detalle: controller.listDataPerAsigandoActivo.value.length
                      .toString(),
                ),
                SizedBox(
                  height: 5,
                )
              ],
            )));
  }

  Widget _PersonalActivo() {
    final responsive = ResponsiveUtil();
    return Obx(() => controller.listDataPerAsigandoActivo.value.length > 0
        ? ContenedorDesingWidget(
            paddin: EdgeInsets.all(5),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.listDataPerAsigandoActivo.value.length,
                itemBuilder: (context, index) {
                  DataPerAsignado data =
                      controller.listDataPerAsigandoActivo[index];

                  return !data.isJefe
                      ? DisingPersonal(
                          index: index,
                          nombrePersonal: data.personalName,
                          onTap: () {
                            DialogosAwesome.getWarningSiNo(
                                title: "INACTIVAR",
                                descripcion:
                                    "¿Esta seguro que desea inactivar a ${data.personalName}. del Operativo?",
                                btnOkOnPress: () {
                                  controller.abandonarRecintoInstalacion(
                                      data.idDgoPerAsigOpe);
                                },
                                btnCancelOnPress: () {});
                          },
                        )
                      : Container();
                }))
        : Container());
  }
}
