part of '../operativo_polco_local_widgets.dart';

class DesingOrdenCapturaWg extends StatelessWidget {
  final String juzgado;
  final String documento;
  final String oficio;
  final Color colorTexto;
  final Color colorTitulos;

  const DesingOrdenCapturaWg({
    Key? key,
    required this.juzgado,
    required this.documento,
    required this.oficio,
    this.colorTexto = Colors.black,
    this.colorTitulos = Colors.blueAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DesingShowDataTitleDetalle(
      title: "BOLETAS DE CAPTURA",
      imagen: Image.asset(AppSiipneMovilImages.icon_Dnpj),
      datos: getContenido(),
      colorTitulos: colorTitulos,
    );
  }

  Widget getContenido() {
    if (juzgado == "NO EXISTE") {
      return IconTitleDetalleWidget2(
        colorTexto: colorTexto,
        icon: AppSiipneMovilImages.iconIdentificacion,
        detalle: "SIN NOVEDAD",
        title: "NOVEDAD:",
      );
    }
    return Column(
      children: [
        IconTitleDetalleWidget2(
          colorTexto: colorTexto,
          icon: AppSiipneMovilImages.iconIdentificacion,
          detalle: documento,
          title: "DOCUMENTO:",
        ),
        IconTitleDetalleWidget2(
          colorTexto: colorTexto,
          icon: AppSiipneMovilImages.iconLey,
          detalle: juzgado,
          title: "JUZGADO:",
        ),
        IconTitleDetalleWidget2(
          colorTexto: colorTexto,
          icon: AppSiipneMovilImages.iconDocumento,
          detalle: oficio,
          title: "OFICIO:",
        ),
      ],
    );
  }
}
