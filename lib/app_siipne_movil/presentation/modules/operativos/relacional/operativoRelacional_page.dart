part of '../../pages.dart';

class OperativoRelacionalPage extends GetView<OperativoRelacionalController> {
  OperativoRelacionalPage({Key? key}) : super(key: key);

  final _keyCedula_conductor = GlobalKey<FormState>();
  final _keyCedula_acompanante1 = GlobalKey<FormState>();
  final _keyCedula_acompanante2 = GlobalKey<FormState>();
  final _keyCedula_acompanante3 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          controller.tempAnimationController,
        ]),
        builder: (context, _) {
          return Obx(() => WorkAreaPageWidget2(
                btnAtras: true,
                title: controller.dataVehiculoANT.length > 0
                    ? controller.dataVehiculoANT[0].placaActual
                    : "",
                peticionServer: controller.peticionServerState.value,
                contenido: [getCabecera(), getDesingCar()],
              ));
        });
  }

  getCabecera() {
    final responsive = ResponsiveUtil();

    //ANT

    String descripcionVehiculo = "";
    String cilindrajeVehiculo = "";
    String anioVehiculo = "";

    String propietario = "";
    String matricula = "";
    String servicio = "";

    DataVehiculoAnt dataVehiculoAnt;
    if (controller.dataVehiculo.value.length > 0) {
      dataVehiculoAnt = controller.dataVehiculoANT.value[0];

      descripcionVehiculo = "Placa:" +
          dataVehiculoAnt.placaActual +
          "/Marca:" +
          dataVehiculoAnt.marcaDesc +
          "\nModelo:" +
          dataVehiculoAnt.modeloDesc +
          "/color:" +
          dataVehiculoAnt.color +
          "\nMotor:" +
          dataVehiculoAnt.motor +
          "\nChasis:" +
          dataVehiculoAnt.chasis;

      cilindrajeVehiculo = "Cilindraje:" + dataVehiculoAnt.cilindraje;
      anioVehiculo = "Año:" + dataVehiculoAnt.anio.toString();

      propietario = "Propietario:" + dataVehiculoAnt.propietario;
      matricula = "Matricula caduca:" + dataVehiculoAnt.fechaCaducidad;
      servicio = "Servicio:" + dataVehiculoAnt.claseServicio;
    }

    Widget wg = DesingDatosWg(
      title: "DATOS DEL VEHÍCULO",
      stringImg: SiipneImages.icon_ANT,
      dato1: descripcionVehiculo,
      dato2: cilindrajeVehiculo,
      dato3: anioVehiculo,
    );

    return Container(
        padding: EdgeInsets.all(5),
        width: responsive.anchoP(95),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(1),
          borderRadius: BorderRadius.circular(SiipneConfig.radioBordecajas),
          border: Border.all(color: AppColors.colorBordecajas, width: 0.5),
        ),
        child: wg);
  }

  getDesingCar() {
    final responsive = ResponsiveUtil();
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      color: Colors.transparent,
      height: responsive.altoP(67),
      child: LayoutBuilder(builder: (context, constrains) {
        return Stack(
          children: [
            Positioned(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: constrains.maxHeight * 0.1),
                child: Center(
                  child: SvgPicture.asset(SiipneImages.svg_car),
                ),
              ),
            ),
            GridView.builder(
              itemCount: 4,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: constrains.maxWidth / constrains.maxHeight,
              ),
              itemBuilder: (context, int index) => getIntegrantesDesing(index),
            )
          ],
        );
      }),
    );
  }

  // Paso 1 -Primer Pantalla
  getIntegrantesDesing(int index) {
    Widget wg = Container();

    switch (index) {
      case 0:
        wg = setControllerIntegrantes(
            title: "CONDUCTOR",
            controllerText: controller.controllerCedula_Conductor,
            dataPersona: controller.dataPersona_conductor,

            myKey: _keyCedula_conductor);

        break;
      case 1:
        wg = setControllerIntegrantes(
            title: "ACOMPAÑANTE",
            controllerText: controller.controllerCedula_Acompanante1,
            dataPersona: controller.dataPersona_acompanante1,
            complete: (d) {},
            myKey: _keyCedula_acompanante1);
        break;

      case 2:
        wg = setControllerIntegrantes(
            title: "ACOMPAÑANTE",
            controllerText: controller.controllerCedula_Acompanante2,
            dataPersona: controller.dataPersona_acompanante2,
            myKey: _keyCedula_acompanante2);
        break;

      case 3:
        wg = setControllerIntegrantes(
            title: "ACOMPAÑANTE",
            controllerText: controller.controllerCedula_Acompanante3,
            dataPersona: controller.dataPersona_acompanante3,
            myKey: _keyCedula_acompanante3);
        break;
      default:
        wg = Container();
        break;
    }

    return wg;
  }

  setControllerIntegrantes(
      {String title = "",
      required TextEditingController controllerText,
      required RxList<PersonaModelData> dataPersona,
      ValueChanged<PersonaModelData>? complete,
      required GlobalKey<FormState> myKey}) {
    Widget wg = setDatosIntegrantes(
        title: title,
        onTap: () async {
          PersonaModelData? d=   await controller.consultarPersonaPorCedula(
            condutorAcompanante: title,
              key: myKey, cedula: controllerText.text);
          if(d!=null) {
            dataPersona.value.add( d);

            complete!(d);
          }
        },
        myKey: myKey,
        controllerText: controllerText,
        dataPersona: dataPersona);

    return wg;
  }

  setDatosIntegrantes(
      {required String title,
      required GestureTapCallback? onTap,
      required GlobalKey<FormState> myKey,
      required TextEditingController controllerText,
      required RxList<PersonaModelData> dataPersona}) {
    final responsive = ResponsiveUtil();

    String nombres = "", cedula = "", sexo = "", licencia = "";

    bool boletas = false;

    if (dataPersona.value.length > 0) {
      if (dataPersona.value[0].dataSiipne.success) {
        nombres = dataPersona.value[0].dataSiipne.data.apenom;
        cedula = dataPersona.value[0].dataSiipne.data.documento;
        sexo = dataPersona.value[0].dataSiipne.data.sexo;
      } else if (dataPersona.value[0].dataDinardap.success) {
        nombres = dataPersona.value[0].dataDinardap.data.nombre;
        cedula = dataPersona.value[0].dataDinardap.data.cedula;
        sexo = dataPersona.value[0].dataDinardap.data.genero;
      }

      //********************** ANT *****************************

      DatosAnt? _datosAnt = dataPersona.value[0].datosAnt;
      String contactos = "";

      String licencias = "", direccion = "", puntos = "";

      if (_datosAnt.success) {
        direccion = _datosAnt.data.direccion;
        puntos = _datosAnt.data.puntos.toString();


          contactos = _datosAnt.data.telefono;

        _datosAnt.data.licencias.forEach((element) {
          licencias = licencias + "Tipo:" + element.tipo;
          licencias = licencias + "->Cad." + element.fechaHasta + "\n";
        });
      } else {
        direccion = _datosAnt.message;
      }
      licencia = licencias;

      //********************** PJ ORDEN DE CAPTURA *****************************

      if (dataPersona.value[0].ordenCaptura.success) {
        boletas = true;
      }
    }

    return DesingDatosRelacionalWg(
      boletas: boletas,
      nombres: nombres,
      cedula: cedula,
      sexo: sexo,
      licencia: licencia,
      title: title,
      onTap: () {
        DialogosDesingWidget.getDialogoX(
            title: title,
            contenido: Obx(() => Container(
                  height: responsive.altoP(50),
                  child: Stack(
                    children: [
                      dataPersona.value.length == 0
                          ? getBtnBusquedaPersona(
                              onTap: onTap,
                              myKey: myKey,
                              controllerText: controllerText)
                          : getMuestraDatosPersona(dataPersona),
                      CargandoWidget(
                        mostrar: controller.peticionServerState.value,
                      )
                    ],
                  ),
                )));
      },
    );
  }

  getBtnBusquedaPersona(
      {required GlobalKey<FormState> myKey,
      required TextEditingController controllerText,
      required GestureTapCallback? onTap}) {
    return BusquedaTipoOperativoWg(
      anchoPorcentaje: 95,
      myKey: myKey,
      controller: controllerText,
      maxLength: 10,
      icono: Icon(
        Icons.person_sharp,
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      title: "Cédula",
      msjError: "Erro Cédula",
      onTap: onTap,
    );
  }

  getMuestraDatosPersona(RxList<PersonaModelData> dataPersona1) {

     return DesingBusquedaPorCedulaWidget(
       dataPersona: dataPersona1.value,
     );

  }

  getDesingCarAnimated() {
    final responsive = ResponsiveUtil();
    return Container(
      color: Colors.white,
      height: responsive.altoP(80),
      child: LayoutBuilder(builder: (context, constrains) {
        return Stack(
          children: [
            Positioned(
              left:
                  constrains.maxWidth / 2 * controller.animationCarShift.value,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: constrains.maxHeight * 0.1),
                child: Container(
                  child: SvgPicture.asset(SiipneImages.svg_car),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
