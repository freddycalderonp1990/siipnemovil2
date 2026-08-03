part of '../operativo_polco_local_widgets.dart';

class DesingAlertaDnaWg extends StatelessWidget {
  final AlertaDnaData data;
  final Color colorTexto;
  final Color colorTitulos;

  const DesingAlertaDnaWg(
      {Key? key,
      required this.data,
      this.colorTexto = Colors.black,
      this.colorTitulos = Colors.blueAccent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DesingShowDataTitleDetalle(
      title: "ALERTA DNA",
      imagen: Image.asset(
        AppSiipneMovilImages.icon_Dna,
      ),
      datos: getContenido(),
      colorTitulos: colorTitulos,
    );
  }



  Widget getContenido() {
    return Container(
      child: Column(
        children: [
          IconTitleDetalleWidget2(
              colorTexto: colorTexto,
              icon: AppSiipneMovilImages.iconDocumento,
              detalle: data.descripcion,
              title: "DETALLE:", ),
          IconTitleDetalleWidget2(
              colorTexto: colorTexto,
              icon: AppSiipneMovilImages.iconCalendario,
              detalle: data.fechaParte,
              title: "FECHA PARTE:"),
          IconTitleDetalleWidget2(
              colorTexto: colorTexto,
              icon: AppSiipneMovilImages.iconLey,
              detalle: data.numCasoJef,
              title: "NUM CASO:"),
        ],
      ),
    );
  }
}
