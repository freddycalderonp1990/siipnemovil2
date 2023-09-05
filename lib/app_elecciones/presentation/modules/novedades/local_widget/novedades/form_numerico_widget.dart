part of '../forms_novedades.dart';

class FormNumericoWidget extends StatelessWidget {
  final formKey;
  final TextEditingController controllerNumerico;
  final double sizeIcons;

  const FormNumericoWidget(
      {Key? key,
        required this.formKey,
        required this.controllerNumerico,
        required this.sizeIcons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return wgTxtNumerico();
  }
  Widget wgTxtNumerico() {
    final responsive=ResponsiveUtil();
    return Form(
      key: formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.number,
            controller: controllerNumerico,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Numérico",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar:ValidateNovedades. validateNumerico,
          ),

        ],
      ),
    );
  }
}
