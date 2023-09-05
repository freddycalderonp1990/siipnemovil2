part of '../operativo_polco_local_widgets.dart';
class DesingRestriccionVehiculoWg extends StatelessWidget {
  final RestriccionPj data;
  final Color colorTexto;
  final Color colorTitulos;

  const DesingRestriccionVehiculoWg({Key? key, required this.data, required this.colorTexto, required this.colorTitulos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
bool robado=data.robado;

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
            "RESTRICCIONES DEL VEHÍCULO",
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
                  child: Image.asset(robado? SiipneImages.iconAlerta:SiipneImages.icon_Dnpj

                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      child: Column(
                        children: [
                             IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg:SiipneImages.iconDocumento,
                              detalle: "",
                              title: robado?"ROBADO":"SIN NOVEDAD"),


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
