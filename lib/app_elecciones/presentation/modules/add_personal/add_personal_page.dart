part of '../pages.dart';

class AddPersonalPage extends GetView<AddPersonalController> {
  const AddPersonalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => WorkAreaPageAppWidget(
          btnAtras: true,
          imgPerfil: controller.loginController.user.value.foto.fotoBase64,
          name: controller.loginController.getName(),
          title: "AGREGAR PERSONAL",
          peticionServer: controller.peticionServer,
          contenido: getContenido(),
        ));
  }

  Widget getContenido() {
    return SingleChildScrollView(
      child: Column(
        children: [
          BtnIconWidget(
            onPressed: () {
             Get.toNamed(EleccionesRoutes.CONUSLTAR_PERSONAL_ASIGNADO);
             
            },
            stringImg: AppEleccionesImages.iconAgregarPersonal,
            select: false,
            titulo: "VER PERSONAL",
          ),
          BusquedaTipoOperativoWg(
            anchoPorcentaje: 95,
            myKey: controller.formKey,
            controller: controller.controllerCedula,
            maxLength: 10,
            icono: Icon(
              Icons.person_outline_outlined,
              color: Colors.blueAccent,
            ),
            keyboardType: TextInputType.number,
            title: "Cédula",
            msjError: "Ingrese una cédula valida",
            onTap: () {
              //Quita el focus
              //Oculta el teclado
              FocusScope.of(Get.context!).requestFocus(new FocusNode());

              controller.consultarDatosPerPorCedula();
            },
          ),
          SizedBox(
            height: 2,
          ),
          controller.dataPerPolicial.value.idGenPersona > 0
              ? wgDatos()
              : Container()
        ],
      ),
    );
  }

  Widget wgDatos() {
    return Column(
      children: [
        Column(
          children: [
            SizedBox(
              height: 2,
            ),
            TituloDetalleTextWidget(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              title: controller.dataPerPolicial.value.siglas + ".",
              detalle: controller.dataPerPolicial.value.apenom,
            ),
            controller.dataPerPolicial.value.idGenPersona > 0
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: getComboUnidadesPoliciales())
                : Container(),
            SizedBox(
              height: 2,
            ),
            Obx(() => controller.dataSelectUnidadesPoliciales.value.id > 0
                ? BtnIconWidget(
                    onPressed: () {
                      //Quita el focus
                      //Oculta el teclado
                      FocusScope.of(Get.context!).requestFocus(new FocusNode());
                      controller.addPersonalIntegrante();
                    },
                    stringImg: AppImages.iconGuardar,
                    select: true,
                    titulo: "GUARDAR",
                  )
                : Container())
          ],
        ),
      ],
    );
  }

  Widget getComboUnidadesPoliciales() {
    return Obx(() => ComboConBusqueda(
        titleSelecioneEl: "Seleccione la Unidad Policial",
        selectValue: controller.dataSelectUnidadesPoliciales,
        data: controller.dataComboUnidadesPoliciales.value,
        complete: (data) {
          controller.dataSelectUnidadesPoliciales.value = data;
          print("daaaa");
        }));
  }
}
