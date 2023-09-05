part of '../../pages.dart';

class InicioRapidoPage extends GetView<InicioRapidoController> {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
    // TODO: verifique
/*

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateTieneFoto(context);
    });*/
    print('buildd');

    Widget wg = WorkAreaLoginPageWidget(
      title: SiipneStrings.POLICIANACIONAL,
      imgPerfil:controller.loginController.user.value.foto.fotoBase64,
      mostrarVersion: true,
      imgFondo: SiipneImages.imgFondoLogin,
      peticionServer: controller.peticionServerState,
      sizeTittle: 7,
      contenido: <Widget>[getContenido(responsive)],
    );

    return GetBuilder<LoginController>(
      builder: (_c) => wg,
    );
  }

  Widget getContenido(ResponsiveUtil responsive) {
    return Column(
      children: [
       Obx(()=> Text(
         controller.user.value.apenom,
         textAlign: TextAlign.center,
         style: TextStyle(
             color: Colors.white,
             fontWeight: FontWeight.bold,
             fontSize: responsive.anchoP(5)),
       )),
        SizedBox(
          height: responsive.altoP(2),
        ),
        wgHuella(),
        SizedBox(
          height: responsive.altoP(1),
        ),

        wgOtroUsuario(responsive)
      ],
    );
  }

  Widget wgHuella() {
    Widget wg = DesingBtn(

        title: "HUELLA",
        img: AppImages.icon_huella,

        onTap: () => controller.loginConBiometrico());

    return  wg;
  }

  Widget wgOtroUsuario(ResponsiveUtil responsive) {
    Widget wg = DesingBtn(
        title: "¿NO ERES TÚ?",
        img: AppImages.icon_usuario,
        onTap: () async {
          DialogosAwesome.getWarningSiNo(
              descripcion:
              "Por su seguridad el acceso rapido sera desactivado."
                  "\n¿Desea Continuar?",
              btnOkOnPress: (){
                controller.ingresoConOtroUsuario();
              });
        });

    return wg;
  }

  Widget wgClaveDigital(ResponsiveUtil responsive) {
    Widget wg = DesingBtn(
        title: "Clave Digital",
        img: AppImages.icon_llave,
        onTap: () async {
          DialogosDesingWidget.getDialogoXClaveTemporal(
              title: "Clave Temporal",
              contenido: Obx(() => Column(
                children: [
                  Center(
                    child: Text(
                      controller.codigo.value,
                      style: TextStyle(fontSize: responsive.diagonalP(5)),
                    ),
                  ),
                  _buildRadialImageAnnotation(),
                ],
              )),
              onPressedX: () {
                // controller.stopTimer();
                Get.back();
              });
        });

    return wg;
  }



  Widget wgPinCode() {
    Widget wg = DesingBtn(
        title: "INGRESAR CON PIN CODE",
        img: AppImages.icon_llave,
        onTap: () => controller.PinCode());

    return wg;
  }

  SfRadialGauge _buildRadialImageAnnotation() {
    controller.startTimer();
    String ceros = controller.seconds.value < 9 ? "00:0" : "00:";

    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            interval: 5,
            radiusFactor: 0.80,
            startAngle: 0,
            endAngle: 360,
            showTicks: false,
            showLabels: false,
            axisLineStyle: const AxisLineStyle(thickness: 20),
            pointers: <GaugePointer>[
              RangePointer(
                  value: controller.valueRadio.value,
                  width: 20,
                  color: Color(0xFFFFCD60),
                  enableAnimation: true,
                  gradient: SweepGradient(
                      colors: <Color>[Color(0xFFF38181), Color(0xFFFCE38A)],
                      stops: <double>[0.25, 0.75]),
                  cornerStyle: CornerStyle.bothCurve)
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Added image widget as an annotation
                      Container(
                          width: 35.00,
                          height: 35.00,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: ExactAssetImage(AppImages.icon_timer),
                              fit: BoxFit.fill,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Text(ceros + controller.seconds.value.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 25)),
                      ),
                    ],
                  ),
                  angle: 270,
                  positionFactor: 0.1)
            ])
      ],
    );
  }

  /// Returns the gauge clock
  SfRadialGauge _buildClockExample() {
    double _change_key_every = 30;

    controller.startTimer();
    return SfRadialGauge(
      axes: <RadialAxis>[
        /// Renders inner axis and positioned it using CenterX and
        /// CenterY properties and reduce the radius using radiusFactor

        // Renders outer axis
        RadialAxis(
            startAngle: 270,
            endAngle: 270,
            minimum: 0,
            maximum: _change_key_every,
            showFirstLabel: false,
            interval: 1,
            radiusFactor: 1,
            labelOffset: 0.1,
            offsetUnit: GaugeSizeUnit.factor,
            minorTicksPerInterval: 4,
            tickOffset: 0.03,
            minorTickStyle: const MinorTickStyle(
                length: 0.01, lengthUnit: GaugeSizeUnit.factor, thickness: 1),
            majorTickStyle: const MajorTickStyle(
                length: 0.1, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
            axisLabelStyle: GaugeTextStyle(fontSize: 12),
            axisLineStyle: const AxisLineStyle(
                thickness: 0.01, thicknessUnit: GaugeSizeUnit.factor),
            pointers: <GaugePointer>[
              NeedlePointer(
                  needleLength: 0.85,
                  lengthUnit: GaugeSizeUnit.factor,
                  needleStartWidth: 0,
                  needleEndWidth: 0,
                  value: 2,
                  knobStyle: const KnobStyle(
                      color: Colors.red,
                      sizeUnit: GaugeSizeUnit.factor,
                      knobRadius: 0.05),
                  needleColor: Colors.yellow),
              NeedlePointer(
                  needleLength: 0.9,
                  lengthUnit: GaugeSizeUnit.factor,
                  enableAnimation: false,
                  animationType: AnimationType.bounceOut,
                  needleStartWidth: 0,
                  needleEndWidth: 0.8,
                  value: double.parse(controller.seconds2.value.toString()),
                  needleColor: Colors.red,
                  tailStyle: const TailStyle(
                      width: 1,
                      length: 0.2,
                      lengthUnit: GaugeSizeUnit.factor,
                      color: Colors.red),
                  knobStyle: const KnobStyle(
                      knobRadius: 0.03,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: Colors.white)),
            ]),
      ],
    );
  }

  /// Returns the default axis gauge
  SfRadialGauge _buildWidgetPointerExample() {
    double tiempo = 30;

    //
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          startAngle: 0,
          endAngle: 360,
          showTicks: true,
          interval: 2,
          labelOffset: 0.1,
          tickOffset: 0.125,
          minorTicksPerInterval: 0,
          labelsPosition: ElementsPosition.outside,
          offsetUnit: GaugeSizeUnit.factor,
          showAxisLine: false,
          radiusFactor: 0.8,
          showLabels: true,
          minimum: 0,
          maximum: tiempo,
          pointers: <GaugePointer>[
            WidgetPointer(
                offset: 5.5,
                value: 20,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          offset: Offset.zero,
                          blurRadius: 4.0,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        style: BorderStyle.solid,
                        width: 1.0,
                      )),
                  height: 37,
                  width: 35,
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                        Center(
                          child: Text(
                            '50',
                            style: TextStyle(
                              color: const Color.fromRGBO(126, 126, 126, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ))
          ],
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue:10,
              color: Colors.green.withOpacity(0.5),
            ),
            GaugeRange(
              startValue: 10,
              endValue: 20,
              color: Colors.yellow.withOpacity(0.7),
            ),
            GaugeRange(
              startValue: 20,
              endValue: 30,
              color: Colors.red.withOpacity(0.7),
            )
          ],
        )
      ],
    );
  }
}
