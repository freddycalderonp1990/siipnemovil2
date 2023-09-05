part of '../operativo_polco_local_widgets.dart';
class DesingDesaparecidoDinasedWg extends StatelessWidget {
  final DesaparecidoDinasedData desaparecidoDinasedData;
  final Color colorTexto;
  final Color colorTitulos;



  const DesingDesaparecidoDinasedWg({Key? key,required this.desaparecidoDinasedData, this.colorTexto = Colors.black,
    this.colorTitulos = Colors.blueAccent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

    String  descripcion = "Documento: " +
        desaparecidoDinasedData.documento+
        "\nNombres: " +
        desaparecidoDinasedData.nombres +
        "\nEdad: " +
        desaparecidoDinasedData.edad ;

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
            "ALERTA DESAPARECIDOS",
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
                    SiipneImages.icon_Dinased,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      child: Column(
                        children: [
                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconCalendario,
                              detalle: desaparecidoDinasedData.fechaAlerta,
                              title: "FECHA ALERTA:"),
                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconIdentificacion,
                              detalle: descripcion,
                              title: "DATOS:"),


                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconDocumento,
                              detalle: desaparecidoDinasedData.descripcion,
                              title: "DESCRIPCIÓN:"),

                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconDireccion,
                              detalle: desaparecidoDinasedData.lugarDesaparicion,
                              title: "LUGAR DESAPARECIÓN:"),




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


