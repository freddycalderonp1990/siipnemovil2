part of '../forms_novedades.dart';

class FormCedulaWidget extends StatelessWidget {
  final formKey;
  final TextEditingController controllerCedula;
  final double sizeIcons;

  const FormCedulaWidget(
      {Key? key,
        required this.formKey,
        required this.controllerCedula,
        required this.sizeIcons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return wgTxtCedula();
  }

  Widget wgTxtCedula() {
    final responsive = ResponsiveUtil();

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
            label: AppEleccionesStrings.cedula,
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar: ValidateNovedades.validateCedula,
          ),
        ],
      ),
    );
  }
}
