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
    final responsive = ResponsiveUtil();

    String descripcion =
        "Nombres: " + data.nombreCompleto + "\nTipo Sangre: " + data.tipoSangre;

    return Container(
      padding: EdgeInsets.all(5),
      width: responsive.anchoP(95),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SiipneConfig.radioBordecajas),
        border: Border.all(color: Colors.black.withOpacity(0.5), width: 0.5),
      ),
      child: Column(
        children: [
          Text(
            "DATOS - ANT",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: colorTitulos,
                fontWeight: FontWeight.bold,
                fontSize: responsive.diagonalP(2.3)),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    SiipneImages.icon_ANT,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      child: Column(
                        children: [
                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconIdentificacion,
                              detalle: descripcion,
                              title: ""),
                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: AppImages.iconTelefono,
                              detalle: data.celular + "  " + data.telefono,
                              title: "TÉLEFONO:"),
                          data.bloqueos.length > 0
                              ? IconTitleDetalleWidget(
                                  colorTexto: colorTexto,
                                  nameStringImg: SiipneImages.iconAlerta,
                                  detalle: data.bloqueos,
                                  title: "BLOQUEOS:")
                              : Container(),
                          wgLicencias(),
                          wgInfracciones(),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
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
            IconTitleDetalleWidget(
                colorTexto: colorTexto,
                nameStringImg: SiipneImages.iconDocumento,
                detalle: element.empresa,
                title: "EMPRESA:"),
            IconTitleDetalleWidget(
                colorTexto: colorTexto,
                nameStringImg: AppImages.iconDollar,
                detalle: "\$" + element.valor.toString(),
                title: "VALOR:"),
            lineaNegra(),
          ],
        ));
      });
    }

    return Column(
      children: [
        Text(
          "${cantidad} - INFRACCIONES - TOTAL: \$${valor}",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: colorTitulos,
              fontWeight: FontWeight.bold,
              fontSize: responsive.diagonalP(1.5)),
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
                child: IconTitleDetalleWidget(
                    colorTexto: colorTexto,
                    nameStringImg: SiipneImages.iconDocumento,
                    detalle: element.tipo,
                    title: "TIPO:"),
              ),
              Flexible(
                flex: 2,
                child: IconTitleDetalleWidget(
                    colorTexto: colorTexto,
                    nameStringImg: SiipneImages.iconCalendario,
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
        Text(
          "LICENCIAS - ${data.puntos} PUNTOS",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: colorTitulos,
              fontWeight: FontWeight.bold,
              fontSize: responsive.diagonalP(1.5)),
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
