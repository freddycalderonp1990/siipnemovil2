part of '../operativo_polco_local_widgets.dart';

class DesingRestriccionVehiculoWg extends StatelessWidget {
  final RestriccionPj data;
  final Color colorTexto;
  final Color colorTitulos;

  const DesingRestriccionVehiculoWg(
      {Key? key,
      required this.data,
      required this.colorTexto,
      required this.colorTitulos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DesingShowDataTitleDetalle(
      title: "RESTRICCIONES DEL VEHÍCULO",
      imagen: getImagen(),

      datos: getContenido(),
      colorTitulos: colorTitulos,
    );
  }

  Widget getImagen() {
    return Image.asset(AppSiipneMovilImages.icon_Dnpj);
    return data.robado
        ? Icon(
      size: 50,
      AppSiipneMovilImages.iconAlerta,
            color:data.robado ?Colors.white: AppColors.colorIcons,
          )
        : Image.asset(AppSiipneMovilImages.icon_Dnpj);
  }

  Widget getContenido() {


    return Column(
      children: [
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: AppSiipneMovilImages.iconDocumento,
            detalle: data.robado ? "ROBADO" : "SIN NOVEDAD",
            title: "NOVEDAD:"),
      ],
    );
  }
}
