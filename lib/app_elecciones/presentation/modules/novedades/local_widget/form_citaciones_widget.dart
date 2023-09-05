part of 'forms_novedades.dart';

class FormCitacionesWidget extends StatelessWidget {
  final formKey;
  final TextEditingController controllerNumCitacion;
  final TextEditingController controllerCedula;
  final double sizeIcons;



  const FormCitacionesWidget(
      {super.key,
      required this.controllerNumCitacion,
      required this.controllerCedula,
      required this.sizeIcons,
      required this.formKey});

  @override
  Widget build(BuildContext context) {
    return wgTxtCedulaCitacion();
  }

  Widget wgTxtCedulaCitacion() {
    final responsive = ResponsiveUtil();
    return Form(
      key: formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerNumCitacion,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: AppEleccionesStrings.numCitacion,
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar: ValidateNovedades.validateNumCitacion,
          ),
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
