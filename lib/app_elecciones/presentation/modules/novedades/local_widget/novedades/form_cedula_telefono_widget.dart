part of '../forms_novedades.dart';

class FormCedulaTelefonoWidget extends StatelessWidget {
  final formKey;
  final TextEditingController controllerCedula;
  final TextEditingController controllerTelefono;
  final double sizeIcons;
  final String titleCedula;

  const FormCedulaTelefonoWidget(
      {Key? key,
        required this.formKey,
        required this.controllerCedula,
        required this.sizeIcons,  this.titleCedula='Cédula', required this.controllerTelefono})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return wgTxtCedulaTelefono();
  }




  Widget wgTxtCedulaTelefono(
      ) {
    final responsive=ResponsiveUtil();
    return Form(
      key: formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.number,
            controller: controllerCedula,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: titleCedula,
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar:ValidateNovedades. validateCedula,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.number,
            controller: controllerTelefono,
            icono: Icon(
              Icons.phone_android,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Teléfono",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar:ValidateNovedades. validateTelefono,
          )
        ],
      ),
    );
  }
}
