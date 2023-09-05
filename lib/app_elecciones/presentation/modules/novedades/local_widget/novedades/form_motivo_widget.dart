part of '../forms_novedades.dart';
class FormMotivoWidget extends StatelessWidget {
  final formKey;
  final TextEditingController controllerMotivo;
  final double sizeIcons;

  const FormMotivoWidget({Key? key,required this.formKey, required this.controllerMotivo, required this.sizeIcons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return wgTxtMotivo();
  }

  Widget wgTxtMotivo(

      ) {

    final responsive=ResponsiveUtil();
    return Form(
      key: formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerMotivo,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Motivo",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar: ValidateNovedades.validateMotivo,
          ),
        ],
      ),
    );
  }
}
