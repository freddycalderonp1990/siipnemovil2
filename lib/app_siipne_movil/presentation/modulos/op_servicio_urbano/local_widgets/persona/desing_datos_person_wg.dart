part of '../operativo_polco_local_widgets.dart';

class DesingDatosPersonaWg extends StatelessWidget {
  final LocalPersonSuModel data;
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
    String title="ECUATORIANO";
    if(data.pais!=null){
      if(data.pais?.length!=0 && data.pais!="ECUADOR"){
        title="EXTRANJERO";
      }

    }
    return DesingShowDataTitleDetalle(
      title: title,
      imagen: getImagen(),
      datos: getContenido(),
      colorTitulos: colorTitulos,
    );
  }

  Widget getImagen() {
    var imgMemory = null;
    if (data.foto != null && data.foto!.length > 5) {
      imgMemory = PhotoHelper.convertStringToUint8List(data.foto);
    }
    return Container(
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
                        fit: BoxFit.fill),
                  ),
                ),
              ),
            )
          :data.pais?.length==0?Image.asset(
     AppSiipneMovilImages.icon_RegistroCivil,
      ): Image.asset(
             data.pais=="ECUADOR"? AppSiipneMovilImages.icon_RegistroCivil:AppSiipneMovilImages.icon_Extranjero,
            ),
    );
  }

  Widget getContenido() {
    return Column(
      children: [
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: AppSiipneMovilImages.iconDocumento,
            detalle: data.documento,
            title: "DOCUMENTO:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: AppSiipneMovilImages.iconDocumento,
            detalle: data.nombres,
            title: "NOMBRES:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: AppSiipneMovilImages.iconDireccion,
            detalle: data.domicilio,
            title: "DOMICILIO:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: AppSiipneMovilImages.iconDocumento,
            detalle: data.estadoCivil,
            title: "ESTADO CIVIL:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: AppSiipneMovilImages.iconCalendario,
            detalle: data.fechaNcaimiento,
            title: "F. NACIMIENTO:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: AppSiipneMovilImages.iconDocumento,
            detalle: data.edad,
            title: "EDAD:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: Icons.data_exploration_outlined,
            detalle: data.sexo,
            title: "SEXO/GÉNERO:"),

        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
            icon: Icons.data_exploration_outlined,
            detalle: data.pais,
             title: "PAÍS:"),

      ],
    );
  }
}
