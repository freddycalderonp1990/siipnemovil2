part of '../forms_novedades.dart';

class FormNumericoPersonalWidget extends StatelessWidget {
  final formKey;
  final TextEditingController controllerNumericoPersonal;
  final double sizeIcons;

  const FormNumericoPersonalWidget(
      {Key? key,
        required this.formKey,
        required this.controllerNumericoPersonal,
        required this.sizeIcons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return wgTxtNumericoPersonal();
  }
  Widget wgTxtNumericoPersonal() {
    final responsive=ResponsiveUtil();
    return Form(
      key: formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.number,
            controller: controllerNumericoPersonal,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Númerico del Personal",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar:ValidateNovedades. validateNumPersonal,
          ),
        ],
      ),
    );
  }
}
