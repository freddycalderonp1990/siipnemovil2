part of '../operativo_polco_local_widgets.dart';

class DesingDesaparecidoDinasedWg extends StatelessWidget {
  final DesaparecidoDinasedData desaparecidoDinasedData;
  final Color colorTexto;
  final Color colorTitulos;

  const DesingDesaparecidoDinasedWg(
      {Key? key,
      required this.desaparecidoDinasedData,
      this.colorTexto = Colors.black,
      this.colorTitulos = Colors.blueAccent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DesingShowDataTitleDetalle(
      title: "ALERTA DESAPARECIDOS",
      imagen: Image.asset(
        AppSiipneMovilImages.icon_Dinased,
      ),
      datos: getContenido(),
      colorTitulos: colorTitulos,
    );
  }

  Widget getContenido() {
    String descripcion = "Documento: " +
        desaparecidoDinasedData.documento +
        "\nNombres: " +
        desaparecidoDinasedData.nombres +
        "\nEdad: " +
        desaparecidoDinasedData.edad;
    return Column(
      children: [
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: AppSiipneMovilImages.iconCalendario,
            detalle: desaparecidoDinasedData.fechaAlerta,
            title: "FECHA ALERTA:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: AppSiipneMovilImages.iconIdentificacion,
            detalle: descripcion,
            title: "DATOS:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: AppSiipneMovilImages.iconDocumento,
            detalle: desaparecidoDinasedData.descripcion,
            title: "DESCRIPCIÓN:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: AppSiipneMovilImages.iconDireccion,
            detalle: desaparecidoDinasedData.lugarDesaparicion,
            title: "LUGAR DESAPARECIÓN:"),
      ],
    );
  }
}
