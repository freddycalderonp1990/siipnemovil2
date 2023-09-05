part of '../forms_novedades.dart';

class FormDesplazamientoAutoridadesWidget extends StatelessWidget {
  final formKey;
  final TextEditingController controllerNombre;
  final TextEditingController controllerCargo;
  final TextEditingController controllerGrado;
  final double sizeIcons;

  const FormDesplazamientoAutoridadesWidget(
      {Key? key,
        required this.formKey,
        required this.controllerNombre,
        required this.controllerCargo,
        required this.controllerGrado,
        required this.sizeIcons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return wgTxtDesplazamientosAutoridades();
  }

  Widget wgTxtDesplazamientosAutoridades() {
    final responsive=ResponsiveUtil();
    return Form(
      key: formKey,
      child: Column(
        children: [
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerNombre,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Nombre",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar:ValidateNovedades. validateNombre,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerCargo,
            icono: Icon(
              Icons.category,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Cargo/Función",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
            validar: ValidateNovedades.validateCargo,
          ),
          ImputTextWidget(
            keyboardType: TextInputType.text,
            controller: controllerGrado,
            icono: Icon(
              Icons.assignment_sharp,
              color: Colors.black38,
              size: sizeIcons,
            ),
            label: "Grado (Opcional)",
            fonSize: responsive.anchoP(AppEleccionesConfig.tamTextoTitulo),
          ),
        ],
      ),
    );
  }
}
