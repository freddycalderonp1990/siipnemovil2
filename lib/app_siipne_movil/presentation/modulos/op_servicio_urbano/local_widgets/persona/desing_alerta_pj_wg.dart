part of '../operativo_polco_local_widgets.dart';

class DesingAlertaPjWg extends StatelessWidget {
  final AlertaInmediataPjData data;
  final Color colorTexto;
  final Color colorTitulos;

  const DesingAlertaPjWg(
      {Key? key,
      required this.data,
      this.colorTexto = Colors.black,
      this.colorTitulos = Colors.blueAccent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DesingShowDataTitleDetalle(

      title: "ALERTA PJ",
      imagen: Image.asset(
        AppSiipneMovilImages.icon_Dnpj,
      ),
      datos: getContenido(),
      colorTitulos: colorTitulos,
    );
  }

  Widget getContenido() {
    return Column(
      children: [
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: AppSiipneMovilImages.iconDocumento,
            detalle: data.descripcion,
            title: "DETALLE:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: Icons.phone_android,
            detalle: data.telefonoAlertaInmediata,
            title: "Llamar al:"),
        BtnIconOperativoWidget(
          select: true,
          //stringImg: AppImages.iconTelefono,
          titulo: "Llamar",
          onPressed: () {
            UtilidadesUtil.lanzarLlamada(
                data.telefonoAlertaInmediata);
          },
        )
      ],
    );
  }
}
