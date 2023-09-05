part of '../forms_novedades.dart';

class FormOrganisacionesDirigentesCantidadWidget extends StatelessWidget {
  final formKey;
  final TextEditingController controllerOrganizacion;
  final TextEditingController controllerDirigente;
  final TextEditingController controllerCantidad;
  final double sizeIcons;

  const FormOrganisacionesDirigentesCantidadWidget(
      {Key? key,
        required this.formKey,
        required this.controllerOrganizacion,
        required this.controllerDirigente,
        required this.controllerCantidad,
        required this.sizeIcons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return wgorganizacionDirigenteCantidad();
  }

  Widget wgorganizacionDirigenteCantidad() {
    final responsive=ResponsiveUtil();

    return Column(
      children: [
        wgTxtNumeroManifestantes(responsive),
        SizedBox(
          height: responsive.altoP(1),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BtnColoresNovedadesWidget(
             
                  color: Colors.green.withOpacity(0.8),
                  title: "1-50"),
              BtnColoresNovedadesWidget(
                
                  color: Colors.yellow.withOpacity(0.8),
                  title: "51-200"),
              BtnColoresNovedadesWidget(
                 
                  color: Colors.orange.withOpacity(0.8),
                  title: "201-500"),
              BtnColoresNovedadesWidget(
                
                  color: Colors.red.withOpacity(0.8),
                  title: "501-Más"),
            ],
          ),
        )
      ],
    );
  }



  Widget wgTxtNumeroManifestantes(responsive) {
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
            validar: ValidateNovedades.validateCantidad,
          ),
        ],
      ),
    );
  }
}
