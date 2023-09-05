part of '../operativo_polco_local_widgets.dart';

class DesingDatosVehiculoWg extends StatelessWidget {
  final DataVehiculo data;
  final Color colorTexto;
  final Color colorTitulos;

  const DesingDatosVehiculoWg(
      {Key? key,
      required this.data,
      this.colorTexto = Colors.black,
      this.colorTitulos = Colors.blueAccent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool vehiculoRobado=false;
    if (data.restriccionPj.robado) {
      vehiculoRobado=true;
    }

    Color colorTexto =
    vehiculoRobado ? Colors.white : Colors.black;
    Color colorTitulos =
    vehiculoRobado ? Colors.yellow : Colors.blueAccent;
    Color colorFondo=vehiculoRobado
        ? SiipneColors.colorOrdenCaptura
        : Colors.white.withOpacity(0.8);



    return contenido(colorTexto: colorTexto,colorTitulos: colorTitulos);
  }

  Widget wgDataVehiculoAnt({required Color colorTexto, required Color colorTitulos}){
         final responsive = ResponsiveUtil();


         if(!data.datosVehiculoAnt.success){
           return wgDataVehiculoSiipne(colorTexto: colorTexto,colorTitulos: colorTitulos);
         }

         DataVehiculoAnt dataVehiculo=data.datosVehiculoAnt.dataVehiculoAnt;
    String descripcionVehiculo = "Placa: " +
        dataVehiculo.placaActual +
        "| Año: " +
        dataVehiculo.anio.toString() +
        "\nMarca: " +
        dataVehiculo.marcaDesc +
        " | Color: " +
        dataVehiculo.color +
        "\nModelo: " +
        dataVehiculo.modeloDesc +
        "\nMotor: " +
        dataVehiculo.motor +
        "\nChasis: " +
        dataVehiculo.chasis +
        "\nCilindraje: " +
        dataVehiculo.cilindraje;
    String matricula = "Matriculado: " +
        dataVehiculo.fechaMatricula +
        "\nCaduca: " +
        dataVehiculo.fechaCaducidad ;


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
            "DATOS DEL VEHÍCULO - ANT",
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
                    SiipneImages.icon_consult_vehiculo,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      child: Column(
                        children: [
                          /* TituloDetalleTextDoubleColumn(
                              colorTexto: colorTexto,
                              title1: "Placa:",
                              title2: "Año:",
                              detalle1: data.placaActual,
                              detalle2: data.anio.toString(),
                              icon1: SiipneImages.iconDocumento,
                              icon2: SiipneImages.iconDocumento),*/

                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconIdentificacion,
                              detalle: dataVehiculo.propietario,
                              title: "Propietario:"),
                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconIdentificacion,
                              detalle: matricula,
                              title: ""),
                          Container(height: 0.5,color: Colors.black12,),
                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconIdentificacion,
                              detalle: descripcionVehiculo,
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

  Widget wgDataVehiculoSiipne({required Color colorTexto, required Color colorTitulos}){
    final responsive = ResponsiveUtil();


    if(!data.datosVehiculoSiipne.success){
      return Container();
    }

    DataVehiculoSiipne dataVehiculo=data.datosVehiculoSiipne.dataVehiculoSiipne;
    String descripcionVehiculo = "Placa: " +
        dataVehiculo.placa +
        "| Año: " +
        dataVehiculo.anoFabricacion.toString() +
        "\nMarca: " +
        dataVehiculo.marca +
        "dataVehiculo" +
        dataVehiculo.color +
        "\nModelo: " +
        dataVehiculo.modelo +
        "\nMotor: " +
        dataVehiculo.motor +
        "\nChasis: " +
        dataVehiculo.chasis +
        "\nCilindraje: " +
        dataVehiculo.cilindraje;



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
            "DATOS DEL VEHÍCULO - SIIPNE",
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
                    SiipneImages.icon_consult_vehiculo,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      child: Column(
                        children: [

                          Container(height: 0.5,color: Colors.black12,),
                          IconTitleDetalleWidget(
                              colorTexto: colorTexto,
                              nameStringImg: SiipneImages.iconIdentificacion,
                              detalle: descripcionVehiculo,
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


  Widget contenido({required Color colorTexto, required Color colorTitulos}){
    return SingleChildScrollView(
      child: Column(
        children: [
          BtnIconWidget(
            select: true,
            stringImg: SiipneImages.icon_Grafo,
            titulo: "Agregar Ocupantes",
            onPressed: () {
              Get.toNamed(
                  SiipneRoutes.OPERATIVOS_POLCO_RELACIONAL,
                  arguments: data);
            },
          ),
          wgDataVehiculoAnt(colorTexto: colorTexto,colorTitulos: colorTitulos),
          DesingRestriccionVehiculoWg(data:data.restriccionPj ,colorTexto: colorTexto,colorTitulos: colorTitulos)


        ],
      ),
    );
  }


}
