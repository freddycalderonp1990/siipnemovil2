part of '../../pages.dart';

class OperativoPolcoPage extends GetView<OperativoPolcoController> {
  OperativoPolcoPage({Key? key}) : super(key: key);

  final _keyPlaca = GlobalKey<FormState>();
  final _keyCedula = GlobalKey<FormState>();

  final _formKey = GlobalKey<FormState>();

  final _openDropDownProgKey = GlobalKey<DropdownSearchState<String>>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => WorkAreaPageAppWidget(
        btnAtras:true,
          title: "OPERATIVO N°" + controller.idHdrEvento.value.toString(),
          peticionServer: controller.peticionServerState,
          contenido: Stack(
            children: [
              Column(
                children: [
                  getTipoDeConsulta(),
                  Obx(() => getBusquedaTipoOperativo()),
                  //  getOpcionesAgregarConsulta(),
                  SizedBox(
                    height: 5,
                  ),
                  controller.selectPerson.value
                      ? Expanded(child: getMuestraDatosPersona())
                      : Container(),
                  controller.selectVehiculo.value
                      ? Expanded(child: getMuestraDatosVehiculo())
                      : Container(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
              menu()
            ],
          ),
        ));
  }

  Widget menu() {
    return Positioned(
        right: 0,
        bottom: 0,
        child: SpeedDial(
          direction: SpeedDialDirection.up,
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: SiipneColors.colorBordecajas,
          overlayColor: SiipneColors.colorBordecajas,
          overlayOpacity: 0.4,
          children: [
            wgFinalizarOperativo(),
            SpeedDialChild(
                label: "Tipo Consulta",
                onTap: () {
                  getDialogoTipoConsulta();
                },
                labelStyle: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
                child: Icon(
                  Icons.find_in_page,
                  color: Colors.blueAccent,
                )),
            SpeedDialChild(
              onTap: () async{



      controller.getResumenConsulta();





              },
                label: "Verificar Consultas",
                labelStyle: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
                child: Icon(
                  Icons.file_copy,
                  color: Colors.blueAccent,
                ))
          ],
        ));
  }

  SpeedDialChild wgFinalizarOperativo() {
    return SpeedDialChild(
        onTap: () {
          controller.controllerPass.text = "";
          DialogosDesingWidget.getDialogoX(
              title: "Finalizar Operativo",
              contenido: formPass(),
              botones: BtnIconWidget(
                select: true,
                stringImg: AppImages.iconMenu,
                titulo: "Finalizar",
                onPressed: () {
                  controller.finalizarOperativo();
                },
              ));
        },
        label: "Finalizar Operativo",
        labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        child: Icon(
          Icons.cancel,
          color: Colors.red,
        ));
  }

  Widget formPass() {
    final responsive = ResponsiveUtil();
    final sizeTxt = responsive.anchoP(SiipneConfig.tamTexto + 2.0);
    return Form(
        key: controller.formKeyPass,
        child: ImputTextWidget(
          imgString: AppImages.icon_clave,
          elevation: 1,
          isSegura: true,
          controller: controller.controllerPass,
          hitText: SiipneStrings.ingreseClave,
          label: SiipneStrings.Clave,
          fonSize: sizeTxt,
          validar: (text) {
            if (text.toString().length >= 1) {
              return null;
            }
            return SiipneStrings.claveNoValida;
          },
        ));
  }

  getTipoDeConsulta() {
    final responsive = ResponsiveUtil();
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: BtnIconWidget(
                  select: controller.selectPerson.value,
                  stringImg: SiipneImages.icon_consult_person,
                  titulo: "Personas",
                  onPressed: () {
                    controller.selectPerson.value = true;
                    controller.selectVehiculo.value = false;
                  },
                ),
              ),
              SizedBox(
                width: responsive.diagonalP(0.5),
              ),
              Expanded(
                  child: BtnIconWidget(
                select: controller.selectVehiculo.value,
                stringImg: SiipneImages.icon_consult_vehiculo,
                titulo: "Vehículo",
                onPressed: () {
                  controller.selectPerson.value = false;
                  controller.selectVehiculo.value = true;
                },
              )),
            ],
          ),
        ));
  }

  getBusquedaTipoOperativo() {
    Widget wg = Container();

    //Vehiculos
    wg = BusquedaTipoOperativoWg(
        controller: controller.controllerPlaca,
        myKey: _keyPlaca,
        anchoPorcentaje: 95,
        title: "Placa",
        msjError: "Ingrese una placa valida",
        icono: Icon(
          Icons.directions_car,
          color: Colors.black,
        ),
        maxLength: 7,
        keyboardType: TextInputType.text,
        onTap: () {
          controller.consultarVehiculoPorPlaca(key: _keyPlaca);
        });

    //Personas
    if (controller.selectPerson.value) {
      wg = BusquedaTipoOperativoWg(
        anchoPorcentaje: 95,
        myKey: _keyCedula,
        controller: controller.controllerCedula,
        maxLength: 10,
        icono: Icon(
          Icons.person_outline_outlined,
          color: Colors.blueAccent,
        ),
        keyboardType: TextInputType.number,
        title: "Cédula",
        msjError: "Ingrese una cédula valida",
        onTap: () {
          controller.consultarPersonaPorCedula(key: _keyCedula);
        },
      );
    }

    return wg;
  }

  getMuestraDatosPersona() {
    return DesingBusquedaPorCedulaWidget(
      dataPersona: controller.dataPersona.value,
    );
  }

  getMuestraDatosVehiculo() {
    final responsive = ResponsiveUtil();

    Color colorTexto =
        controller.vehiculoRobado.value ? Colors.white : Colors.black;
    Color colorTitulos =
        controller.vehiculoRobado.value ? Colors.yellow : Colors.blueAccent;
    Color colorFondo = controller.vehiculoRobado.value
        ? SiipneColors.colorOrdenCaptura
        : Colors.white.withOpacity(0.8);

    Widget wg = controller.dataVehiculo.value.length > 0
        ? Container(
            padding: EdgeInsets.all(5),
            width: responsive.anchoP(95),
            height: responsive.altoP(55),
            decoration: BoxDecoration(
              color: controller.vehiculoRobado.value
                  ? Colors.red.withOpacity(0.8)
                  : Colors.white.withOpacity(1),
              borderRadius: BorderRadius.circular(SiipneConfig.radioBordecajas),
              border: Border.all(color: AppColors.colorBordecajas, width: 0.5),
            ),
            child:
                DesingDatosVehiculoWg(data: controller.dataVehiculo.value[0]))
        : Container();

    return wg;
  }

  getOpcionesAgregarConsulta() {
    List<String> datosString = [
      "Personas en cautiverio y delinquir es las carneles, del pais del ecuador por el trafico de sustancias sujetas a ",
      "Motos",
      "Detenidos",
      "Otros",
      "Conjunto",
    ];

    return ContenedorDesingWidget(
        anchoPorce: 95,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: ComboConBusqueda(
                  data: [],
                ))));
  }

  getDialogoTipoConsulta() async {
    String titulo = "";
    await controller.consultarCatalogo();
    List<DataCatalogoTipoConsulta> catalogoTipoConsulta = [];

    if (controller.selectPerson.value) {
      titulo = "Catalogo Personas";
      catalogoTipoConsulta = SiipneConfig.catalogoTipoConsultaPersonas;
    } else if (controller.selectVehiculo.value) {
      titulo = "Catalogo Vehículo";
      catalogoTipoConsulta = SiipneConfig.catalogoTipoConsultaVehiculos;
    }
    if (catalogoTipoConsulta.length == 0) {
      return;
    }

    List<ModelDataCombo> data = [];
    for (int i = 0; i < catalogoTipoConsulta.length; i++) {
      data.add(ModelDataCombo(
          id: catalogoTipoConsulta[i].idHdrTipoResum,
          titulo: catalogoTipoConsulta[i].desHdrTipoResum));
    }

    DialogosDesingWidget.getDialogoX(
        title: titulo,
        contenido: Column(
          children: [
            TituloTextWidget(
              title: "Tipo Consulta",
            ),
            DetalleTextWidget(
                detalle:
                    "Para modificar el tipo de consulta, seleccione una opción de la lista del catálogo luego de click sobre el boton en guardar.\nCaso contrario la consulta se registra con la opcion por defecto",
                todoElAncho: true),
            SizedBox(
              height: 5,
            ),
            ComboConBusqueda(
                data: data,
                complete: (data) {
                  controller.idHdrTipoResum = data.id;
                }),
            BtnIconWidget(
              onPressed: () {
                controller.updateResumenConsulta(
                    idHdrTipoResum: controller.idHdrTipoResum);
              },
              titulo: "Guardar",
              stringImg: AppImages.iconGuardar,
              select: true,
            )
          ],
        ));
  }
}
