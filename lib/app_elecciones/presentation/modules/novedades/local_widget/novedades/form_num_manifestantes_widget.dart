part of '../forms_novedades.dart';

class FormNumManifestantesWidget extends StatelessWidget {
  final formKey;
  final TextEditingController controllerOrganizacion;
  final TextEditingController controllerDirigente;
  final TextEditingController controllerCantidad;
  final double sizeIcons;

  const FormNumManifestantesWidget(
      {Key? key,
      required this.formKey,
      required this.controllerOrganizacion,
      required this.controllerDirigente,
      required this.controllerCantidad,
      required this.sizeIcons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return wgTxtNumeroManifestantes();
  }

  Widget wgTxtNumeroManifestantes() {
    final responsive=ResponsiveUtil();
    return Form(
      key: formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerOrganizacion,
            icono: Icon(
              Icons.category,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Organización Social o Política",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar:ValidateNovedades. validateOrganizacion,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerDirigente,
            icono: Icon(
              Icons.category,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Dirigente",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar: ValidateNovedades.validateDirigente,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.number,
            controller: controllerCantidad,
            onChanged: (valor) {
              if (valor != null) {
                if (int.parse(valor) > 100) {}
              }
            },
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Cantidad",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar:ValidateNovedades. validateCantidad,
          ),
        ],
      ),
    );
  }
}
