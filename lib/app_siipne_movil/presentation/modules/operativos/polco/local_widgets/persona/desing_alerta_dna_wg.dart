part of '../operativo_polco_local_widgets.dart';
class DesingAlertaDnaWg extends StatelessWidget {
final   AlertaDnaData data;
final Color colorTexto;
final Color colorTitulos;


  const DesingAlertaDnaWg({Key? key, required this.data,
    this.colorTexto = Colors.black,
    this.colorTitulos = Colors.blueAccent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

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
            "ALERTA DNA",
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
                    SiipneImages.icon_Dna,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      child: Column(
                        children: [

                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconDocumento,
                              detalle: data.descripcion,
                              title: "DETALLE:"),
                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconCalendario,
                              detalle: data.fechaParte,
                              title: "FECHA PARTE:"),

                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconLey,
                              detalle: data.numCasoJef,
                              title: "NUM CASO:"),





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
}


