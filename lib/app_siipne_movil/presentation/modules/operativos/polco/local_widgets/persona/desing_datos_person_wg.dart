part of '../operativo_polco_local_widgets.dart';
class DesingDatosPersonaWg extends StatelessWidget {
  final LocalPersonModel data;
  final Color colorTexto;
  final Color colorTitulos;

  const DesingDatosPersonaWg(
      {Key? key,
      required this.data,
      this.colorTexto = Colors.black,
      this.colorTitulos = Colors.blueAccent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
    var imgMemory = null;
    if (data.foto != null && data.foto!.length > 5) {
      imgMemory = PhotoHelper.convertStringToUint8List(data.foto);
    }


    String  descripcion = "Estado Civil: " +
        data.estadoCivil.toString() +
        "\nFecha Nacicmiento: " +
        data.fechaNcaimiento +
        "\nEdad: " +
        data.edad +
        "\nSexo/Género:" +
        data.sexo ;

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
            "DATOS",
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
                  child: Container(
                    height: 120,
                    child: imgMemory != null
                        ? Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                DialogosDesingWidget.getDialogoXImgMemory(
                                    title: 'FOTO', imgMemory: imgMemory);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: Image.memory(imgMemory).image,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          )
                        : Image.asset(
                            SiipneImages.icon_RegistroCivil,
                          ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Column(
                        children: [
                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconDocumento,
                              detalle: data.nombres,
                              title: "NOMBRES:"),


                          data.domicilio != null
                              ? IconTitleDetalleWidget(
                                  colorTexto: colorTexto,
                                  nameStringImg: SiipneImages.iconDireccion,
                                  detalle: data.domicilio!,
                                  title: "DOMICILIO:")
                              : Container(),
                         /* data.conyugue != null
                              ? IconTitleDetalleWidget(
                                  colorTexto: colorTexto,
                                  nameStringImg: SiipneImages.iconConyuge,
                                  detalle: data.conyugue!,
                                  title: "CONYUGE:")
                              : Container(),
                          data.madre != null
                              ? IconTitleDetalleWidget(
                                  colorTexto: colorTexto,
                                  nameStringImg: SiipneImages.iconMama,
                                  detalle: data.madre!,
                                  title: "MADRE:")
                              : Container(),
                          data.padre != null
                              ? IconTitleDetalleWidget(
                                  colorTexto: colorTexto,
                                  nameStringImg: SiipneImages.iconPapa,
                                  detalle: data.padre!,
                                  title: "PADRE:")
                              : Container(),*/
                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconDocumento,
                              detalle:descripcion,
                              title: ""),

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
