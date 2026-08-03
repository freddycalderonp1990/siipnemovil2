part of '../operativo_polco_local_widgets.dart';

class DesingAntWg extends StatelessWidget {
  final DatosAntData data;
  final Color colorTexto;
  final Color colorTitulos;

  const DesingAntWg({
    Key? key,
    required this.data,
    this.colorTexto = Colors.black,
    this.colorTitulos = Colors.blueAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DesingShowDataTitleDetalle(
      title: "DATOS - ANT",
      imagen: Image.asset(
        AppSiipneMovilImages.icon_ANT,
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
            icon: AppSiipneMovilImages.iconIdentificacion,
            detalle: data.tipoSangre,
            title: "TIPO SANGRE"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: Icons.phone_android,
            detalle: data.celular + "  " + data.telefono,
            title: "TÉLEFONO:"),
        data.bloqueos.length > 0
            ? IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: AppSiipneMovilImages.iconAlerta,
            detalle: data.bloqueos,
            title: "BLOQUEOS:")
            : const SizedBox.shrink(),
        wgLicencias(),
        wgInfracciones(),
      ],
    );
  }

  Widget wgInfracciones() {
    final responsive = ResponsiveUtil();

    double valor = 0;
    int cantidad = 0;

    List<Widget> desing = [];
    if (data.infracciones != null) {
      valor = data.infracciones.valor;
      cantidad = data.infracciones.cantidad;

      data.infracciones.datos.forEach((element) {
        desing.add(Column(
          children: [
            lineaNegra(),
            IconTitleDetalleWidget2(
                colorTexto: colorTexto,
                icon: AppSiipneMovilImages.iconDocumento,
                detalle: element.empresa,
                title: "EMPRESA:"),
            IconTitleDetalleWidget2(
                colorTexto: colorTexto,
                icon: Icons.monetization_on,
                detalle: "\$" + element.valor.toString(),
                title: "VALOR:"),
            lineaNegra(),
          ],
        ));
      });
    }

    return Column(
      children: [
        TextSombrasWidget(
          colorTexto: colorTitulos,
          colorSombra: Colors.black26,
          title: "${cantidad} - INFRACCIONES - TOTAL: \$${valor}",
          size:    responsive.diagonalP(AppConfig.tamTexto - 0.3),
        ),
        Column(
          children: desing,
        ),
        linea(),
      ],
    );
  }

  Widget wgLicencias() {
    final responsive = ResponsiveUtil();

    List<Widget> desing = [];

    data.licencias.forEach((element) {
      desing.add(Column(
        children: [
          lineaNegra(),
          Row(
            children: [
              Flexible(
                child: IconTitleDetalleWidget2(
                    colorTexto: colorTexto,
                    icon: AppSiipneMovilImages.iconDocumento,
                    detalle: element.tipo,
                    title: "TIPO:"),
              ),
              Flexible(
                flex: 2,
                child: IconTitleDetalleWidget2(
                    colorTexto: colorTexto,
                    icon: AppSiipneMovilImages.iconCalendario,
                    detalle: element.fechaHasta,
                    title: "CAD:"),
              )
            ],
          ),
          lineaNegra(),
        ],
      ));
    });

    return Column(
      children: [
        linea(),
        TextSombrasWidget(
          colorTexto: colorTitulos,
          colorSombra: Colors.black26,
          title: "LICENCIAS - ${data.puntos} PUNTOS",
          size: responsive.diagonalP(AppConfig.tamTexto - 0.3),
        ),
        Column(
          children: desing,
        ),
        linea(),
      ],
    );
  }

  Widget linea() {
    return Container(height: 2, color: Colors.black12);
  }

  Widget lineaNegra() {
    return Container(height: 0.1, color: Colors.black);
  }
}
