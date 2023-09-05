part of 'forms_novedades.dart';

class FormDetenidosWidget extends StatelessWidget{

final formKey;
final TextEditingController controllerNumBoleta;
final TextEditingController controllerCedula;
final double sizeIcons;

  const FormDetenidosWidget({Key? key,required this.formKey, required this.controllerNumBoleta, required this.sizeIcons, required this.controllerCedula}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return wgTxtCedulaBoleta();
  }

  Widget wgTxtCedulaBoleta() {
    final responsive=ResponsiveUtil();
    return Form(
      key: formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerNumBoleta,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: AppEleccionesStrings.numBoleta,
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar:ValidateNovedades. validateNumBoleta,
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
