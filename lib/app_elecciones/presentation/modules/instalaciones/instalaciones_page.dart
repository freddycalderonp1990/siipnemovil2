part of '../pages.dart';

class InstalacionesPage extends GetView<InstalacionesController> {
  const InstalacionesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => WorkAreaPageAppWidget(
      btnAtras: true,
          imgPerfil: controller.loginController.user.value.foto.fotoBase64,
          name: controller.loginController.getName(),
          title: AppConfig.ubicacionLista.value
              ? "GENERAR CÓDIGO"
              : "OBTENIENDO SU UBICACIÓN",
          peticionServer: controller.peticionServer,
          contenido: getContenido(),
        ));
  }

  Widget getContenido() {

    return Obx(() => Column(
          children: [
            ComboConBusqueda(
              selectValue: controller.dataSelect,
                data: controller.dataCombo.value, complete: (data) {
                  controller.dataSelect.value=data;
                  print("daaaa");

            }),
            formulario()
          ],
        ));
  }

  Widget formulario(){
    final responsive = ResponsiveUtil();

    double sizeIcons =
    responsive.isVertical() ? responsive.altoP(3) : responsive.anchoP(5);


    return Obx(() => controller.dataSelect.value.id>0? Column(
      children: [

       ContenedorDesingWidget(
           margin: EdgeInsets.symmetric(vertical: 5),
           anchoPorce: 100,
           child: Column(
             children: [
               Form(
                   key: controller.formKey,
                   child: ImputTextWidget(
                     keyboardType: TextInputType.number,
                     controller: controller.controllerTelefono,
                     icono: Icon(
                       Icons.phone_android,
                       color: Colors.black38,
                       size: sizeIcons,
                     ),
                     label: "Teléfono",
                     fonSize: responsive.anchoP(AppConfig.tamTextoTitulo),
                     validar: (value) {
                       if (value!.length < 8) {
                         return "Ingrese el número de Teléfono";
                       }

                       return null;
                     },
                   )),
               SizedBox(
                 height: responsive.altoP(1.5),
               )
             ],
           )),
        BtnIconWidget(
          select: true,
          stringImg: SiipneImages.icon_consult_person,
          titulo: " ABRIR ",
          onPressed: () {

            DialogosAwesome.getInformationSiNo(descripcion:   "Usted es la persona encargada o jefe designada a este Operativo"
                "\n \nRecuerde crear el código si se encuentra de servicio en el operativo, para prevenir el mal uso todo será registrado."
                "\n \nUtilice la aplicación con responsabilidad.",
                btnCancelOnPress: (){},


                btnOkOnPress: (){
              controller.crearCodigo();
            });


          },
        )
      ],
    ):Container());
  }
}
