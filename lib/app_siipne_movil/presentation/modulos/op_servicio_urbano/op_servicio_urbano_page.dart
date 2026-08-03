part of '../pages.dart';

class OpServicioUrbanoPage extends GetView<OpServicioUrbanoController> {
   OpServicioUrbanoPage({Key? key}) : super(key: key);

  final _keyPlaca = GlobalKey<FormState>();
  final _keyCedula = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {



    return WorkAreaPageSiipneMovilWidget(
      showGps: true,
      mostrarBtnAtras: true,
      title: "OPERATIVO N°123123122321312342324234234" ,
      contenido: getContenido(),
      peticionServer: controller.peticionServerState,
    );
  }

  getContenido() {
    return   Column(
      children: [
        SizedBox(height: 30,),
        getTipoDeConsulta(),
        SizedBox(height: 10,),
        Obx(() => getBusquedaTipoOperativo()),
        //  getOpcionesAgregarConsulta(),
        SizedBox(
          height: 5,
        ),
        controller.selectPerson.value
            ? Expanded(child: getMuestraDatosPersona())
            : const SizedBox.shrink(),
        controller.selectVehiculo.value
            ? Expanded(child: getMuestraDatosVehiculo())
            : const SizedBox.shrink(),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }


  getTipoDeConsulta() {
    final responsive = ResponsiveUtil();
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child:  BtnIconOperativoWidget(
              colorTxt:controller.selectPerson.value? Colors.white:AppColors.colorIcons,
              colorIcon:controller.selectPerson.value? Colors.white:AppColors.colorIcons,
              icon: Icons.perm_contact_calendar_outlined,
              select: controller.selectPerson.value,
              //stringImg: SiipneImages.icon_consult_person,
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
              child: BtnIconOperativoWidget(
               colorTxt: controller.selectVehiculo.value ? Colors.white:AppColors.colorIcons,
               // colorTxt: Colors.white,
                icon: Icons.car_crash,
                colorIcon:controller.selectVehiculo.value? Colors.white:AppColors.colorIcons,
               // colorIcon:Colors.white,
                select: controller.selectVehiculo.value,
                //stringImg: SiipneImages.icon_consult_vehiculo,
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
    Widget wg = const SizedBox.shrink();

    //Personas
    if (controller.selectPerson.value) {
      wg = BusquedaTipoOperativoWg(
        anchoPorcentaje: 95,
        myKey: _keyCedula,
        controller: controller.controllerCedula,
        maxLength: 20,
        icono: Icon(
          Icons.person_outline_outlined,
          color: AppColors.colorIcons,
        ),
        keyboardType: TextInputType.number,
        title: "Nro. Documento",
        msjError: "documento vacio",
        onTap: () {
          //controller.consultarPersonaPorCedula(key: _keyCedula);
        },
      );

      return Obx(()=>controller.ocultarBtnBuscarPersona.value?const SizedBox.shrink():wg);
    }
    else{
      //Vehiculos
      wg = BusquedaTipoOperativoWg(
          controller: controller.controllerPlaca,
          myKey: _keyPlaca,
          anchoPorcentaje: 95,
          title: "Placa",
          msjError: "Ingrese una placa valida",
          icono: Icon(
            Icons.directions_car,
            color: AppColors.colorIcons,

          ),
          maxLength: 7,
          keyboardType: TextInputType.text,
          onTap: () {
            //controller.consultarVehiculoPorPlaca(key: _keyPlaca);
          });

      return Obx(()=>controller.ocultarBtnBuscarVehiculo.value?const SizedBox.shrink():wg);
    }



  }

  getMuestraDatosPersona() {
    return DesingBusquedaPorCedulaWidget(

      onPressedAceptar: (){
        controller.controllerCedula.clear();
        controller. dataPersona.clear();
        controller.ocultarBtnBuscarPersona(false);
      },
      dataPersona: controller.dataPersona.value,
    );
  }


  getMuestraDatosVehiculo() {
    final responsive = ResponsiveUtil();
    Color colorTexto =
    controller.vehiculoRobado.value ? ColorsLocal.colorTextoOrdenCaptura : ColorsLocal.colorTextoNormal;
    Color colorTitulos =
    controller.vehiculoRobado.value ? ColorsLocal.colorTitulosOrdenCaptura: ColorsLocal.colorTitulosNormal;
    Color colorFondo=controller.vehiculoRobado.value
        ? ColorsLocal.colorFondoOrdenCaptura
        : ColorsLocal.colorFondoNormal;

    Widget wg = controller.dataVehiculo.length > 0
        ? Container(
        padding: EdgeInsets.all(5),
        width: responsive.anchoP(95),
        height: responsive.altoP(55),
        decoration: BoxDecoration(
          color: colorFondo,
          borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
          border: Border.all(color: AppColors.colorBordecajas, width: 0.5),
        ),
        child:
        DesingDatosVehiculoWg(
            onPressedNewConsulta: (){
              controller.dataVehiculo.clear();
              controller.controllerPlaca.clear();
              controller.ocultarBtnBuscarVehiculo(false);
            },

            onPressedOcupantes: (){

              //controller.goToAddOcupantes();
            },
            colorTitulos: colorTitulos,
            colorTexto: colorTexto,

            data: controller.dataVehiculo[0]))
        : const SizedBox.shrink();

    return wg;
  }

}
