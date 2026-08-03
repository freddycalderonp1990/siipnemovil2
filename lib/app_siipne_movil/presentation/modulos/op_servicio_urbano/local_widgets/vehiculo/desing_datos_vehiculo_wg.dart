part of '../operativo_polco_local_widgets.dart';

class DesingDatosVehiculoWg extends StatelessWidget {
  final DataVehiculo data;
  final Color colorTexto;
  final Color colorTitulos;
  final bool onlyDataCar;
     final VoidCallback? onPressedOcupantes;
  final VoidCallback? onPressedNewConsulta;

  const DesingDatosVehiculoWg(
      {Key? key,
      required this.data,
      this.colorTexto = Colors.blueAccent,
      this.onlyDataCar = false,
      this.colorTitulos = Colors.blueAccent, this.onPressedOcupantes, this.onPressedNewConsulta})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool vehiculoRobado = false;
    if (data.restriccionPj.robado) {
      vehiculoRobado = true;
    }

    Color colorTexto = vehiculoRobado
        ? ColorsLocal.colorTextoOrdenCaptura
        : ColorsLocal.colorTextoNormal;
    Color colorTitulos = vehiculoRobado
        ? ColorsLocal.colorTitulosOrdenCaptura
        : ColorsLocal.colorTitulosNormal;
    Color colorFondo = vehiculoRobado
        ? ColorsLocal.colorFondoOrdenCaptura
        : ColorsLocal.colorFondoNormal;

    return contenido(colorTexto: colorTexto, colorTitulos: colorTitulos);
  }

  Widget wgDataVehiculoAnt(
      {required Color colorTexto, required Color colorTitulos}) {
    return DesingShowDataTitleDetalle(
      title: "DATOS DEL VEHÍCULO - ANT",
      imagen: Image.asset(
        AppSiipneMovilImages.icon_consult_vehiculo,
      ),
      datos: getContenidoVehiculoAnt(),
      colorTitulos: colorTitulos,
    );
  }

  Widget getContenidoVehiculoAnt() {
    final responsive = ResponsiveUtil();

    DataVehiculoAnt dataVehiculo = data.datosVehiculoAnt.dataVehiculoAnt;

    return Column(
      children: [
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
           icon:Icons.perm_contact_calendar_outlined,
            
            detalle: dataVehiculo.propietario,
            title: "DUEÑO:", ),
        Row(
          children: [
            Flexible(
              child: IconTitleDetalleWidget2(
                  colorTexto: colorTexto,
                 icon:AppSiipneMovilImages.iconCalendario,
                  detalle: dataVehiculo.fechaMatricula,
                  title: "MATRICULA:"),
            ),
            Flexible(
              child: IconTitleDetalleWidget2(
                  colorTexto: colorTexto,
                 icon:AppSiipneMovilImages.iconCalendario,
                  detalle: dataVehiculo.fechaCaducidad,
                  title: "CAD:"),
            )
          ],
        ),
        Row(
          children: [
            Flexible(
              child: IconTitleDetalleWidget2(
                  colorTexto: colorTexto,
                 icon:Icons.summarize,
                  detalle: dataVehiculo.placaActual,
                  title: "PLACA:"),
            ),
            Flexible(
              child: IconTitleDetalleWidget2(
                  colorTexto: colorTexto,
                 icon:AppSiipneMovilImages.iconCalendario,
                  detalle: dataVehiculo.anio.toString(),
                  title: "AÑO:"),
            )
          ],
        ),
        Row(
          children: [
            Flexible(
              child: IconTitleDetalleWidget2(
                  colorTexto: colorTexto,
                 icon:Icons.note_alt,
                  detalle: dataVehiculo.marcaDesc,
                  title: "MARCA:"),
            ),
            Flexible(
              child: IconTitleDetalleWidget2(
                  colorTexto: colorTexto,
                 icon:Icons.palette,
                  detalle:
                      "1. ${dataVehiculo.color} - 2. ${dataVehiculo.color2}",
                  title: "COLOR:"),
            )
          ],
        ),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
           icon:Icons.fact_check,
            detalle: dataVehiculo.modeloDesc,
            title: "MODELO:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
           icon:Icons.swap_vert_circle,
            detalle: dataVehiculo.cilindraje,
            title: "CILINDRAJE:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
           icon:Icons.car_repair_outlined,
            detalle: dataVehiculo.motor,
            title: "MOTOR:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
           icon:Icons.car_rental,
            detalle: dataVehiculo.chasis,
            title: "CHASIS:"),
      ],
    );
  }

  Widget getContenidoVehiculo() {
    if (data.datosVehiculoSiipne.success) {
      return getContenidoVehiculoSiipne();
    } else if (data.datosVehiculoAnt.success) {
      return getContenidoVehiculoAnt();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget wgDataVehiculo(
      {required Color colorTexto, required Color colorTitulos}) {
    return DesingShowDataTitleDetalle(
      title: "DATOS DEL VEHÍCULO",
      imagen: Image.asset(
        AppSiipneMovilImages.icon_consult_vehiculo,
      ),
      datos: getContenidoVehiculo(),
      colorTitulos: colorTitulos,
    );
  }

  Widget getContenidoVehiculoSiipne() {
    DataVehiculoSiipne dataVehiculo =
        data.datosVehiculoSiipne.dataVehiculoSiipne;

    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: IconTitleDetalleWidget2(
                  colorTexto: colorTexto,
                 icon:Icons.summarize,
                  detalle: dataVehiculo.placa,
                  title: "PLACA:"),
            ),
            Flexible(
              child: IconTitleDetalleWidget2(
                  colorTexto: colorTexto,
                 icon:AppSiipneMovilImages.iconCalendario,
                  detalle: dataVehiculo.anoFabricacion.toString(),
                  title: "AÑO:"),
            )
          ],
        ),
        Row(
          children: [
            Flexible(
              child: IconTitleDetalleWidget2(
                  colorTexto: colorTexto,
                 icon:Icons.note_alt,
                  detalle: dataVehiculo.marca,
                  title: "MARCA:"),
            ),
            Flexible(
              child: IconTitleDetalleWidget2(
                  colorTexto: colorTexto,
                 icon:Icons.palette,
                  detalle: "1. ${dataVehiculo.color} ",
                  title: "COLOR:"),
            )
          ],
        ),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
           icon:Icons.fact_check,
            detalle: dataVehiculo.modelo,
            title: "MODELO:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
           icon:Icons.swap_vert_circle,
            detalle: dataVehiculo.cilindraje,
            title: "CILINDRAJE:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
           icon:Icons.car_repair_outlined,
            detalle: dataVehiculo.motor,
            title: "MOTOR:"),
        IconTitleDetalleWidget2(
            colorTexto: colorTexto,
           icon:Icons.car_rental,
            detalle: dataVehiculo.chasis,
            title: "CHASIS:"),
      ],
    );
  }

  Widget contenido({required Color colorTexto, required Color colorTitulos}) {
    if (onlyDataCar) {
      return wgDataVehiculo(colorTexto: colorTexto, colorTitulos: colorTitulos);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: BtnIconOperativoWidget(
                  colorTxt: Colors.white,
                  select: true,
                 icon:Icons.newspaper_outlined,

                  titulo: "Nueva Consulta",
                  onPressed: onPressedNewConsulta,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: BtnIconOperativoWidget(
                  colorTxt: Colors.white,
                  select: true,
                 icon:Icons.add_circle,

                  titulo: "Ocupantes",
                  onPressed: onPressedOcupantes,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          wgDataVehiculo(colorTexto: colorTexto, colorTitulos: colorTitulos),
          DesingRestriccionVehiculoWg(
              data: data.restriccionPj,
              colorTexto: colorTexto,
              colorTitulos: colorTitulos)
        ],
      ),
    );
  }
}
