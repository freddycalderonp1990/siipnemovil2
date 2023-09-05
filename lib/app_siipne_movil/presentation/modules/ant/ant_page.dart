part of '../pages.dart';

class AntPage extends GetView<AntController> {
  final _formKey = GlobalKey<FormState>();
  final List<Widget> wgs2 = <Widget>[].obs;
  TestAntModel? _testAntModel = null;

  int lenDatos = 0;

  void consultar({bool validarForm = true}) async {
    var isValid = true;

    if (validarForm) {
      isValid = _formKey.currentState!.validate();
    }

    if (isValid) {
      await controller.decodeDatos();
    }
  }

  void consultar2() async {
    var isValid = true;

    isValid = _formKey.currentState!.validate();

    if (isValid) {
      _testAntModel = await controller.getDatos();
      if (_testAntModel != null) {
        getWgDatos();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
    return GetBuilder<AntController>(
        builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text('Placas'),
              backgroundColor: Colors.blue,
            ),
            body: Obx(() => SafeArea(
                    child: Stack(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: responsive.anchoP(5), vertical: 10),
                        child: Column(
                          children: [
                            _TxtPlaca(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  child: Text('Consultar1'),
                                  onPressed: consultar2,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                TextButton(
                                  child: Text('Consultar2'),
                                  onPressed: consultar,
                                ),
                              ],
                            ),
                            Container(
                              width: responsive.anchoP(90),
                              child: Text(controller.textError.value),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: responsive.anchoP(90),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text("CONSULTA 1"),
                                          Column(children: wgs2),
                                          Text("CONSULTA 2"),
                                          Container(
                                              margin: EdgeInsets.all(5.0),
                                              padding: EdgeInsets.all(5.0),
                                              alignment: Alignment.topCenter,
                                              decoration: BoxDecoration(
                                                color: Colors.blue
                                                    .withOpacity(0.1),
                                                border: Border.all(),
                                              ),
                                              child: Column(
                                                  children: controller.wgs))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                    CargandoWidget(
                      mostrar: controller.peticionServerState.value,
                    )
                  ],
                )))));
  }

  Future<List<Widget>> getWgDatos() async {
    wgs2.clear();
    Widget wg = Column(
      children: [
        Container(
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.all(5.0),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            border: Border.all(),
          ),
          child: Column(
            children: [
              Text("${_testAntModel!.modelo}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              Text(
                  "(${_testAntModel!.marca}) - (${_testAntModel!.placa}) - (AÑO ${_testAntModel!.anio})",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              getWgModelo(
                  titulo: 'MATRICULADO',
                  Descripcion: _testAntModel!.fechaMatricula),
              getWgModelo(
                  titulo: 'CILINDRAJE', Descripcion: _testAntModel!.cilindraje),
              getWgModelo(
                  titulo: 'COLOR',
                  Descripcion:
                      "1: ${_testAntModel!.color}, 2: ${_testAntModel!.color2}"),
              getWgModelo(
                  titulo: 'COMBUSTIBLE',
                  Descripcion: _testAntModel!.combustible),
              getWgModelo(
                  titulo: 'AVALUO',
                  Descripcion: _testAntModel!.avaluoComercial),
              SizedBox(
                height: 15,
              ),
              getWgModelo(titulo: 'PROPIETARIOS', Descripcion: ''),
              getWgModelo(
                  titulo: 'CED-${_testAntModel!.docPropietario}',
                  Descripcion: _testAntModel!.propietario),
              getWgModelo(
                  titulo: 'Telefono', Descripcion: _testAntModel!.telefono),
              getWgModelo(
                  titulo: 'ANTERIOR ${_testAntModel!.cedulaPropAnterior}',
                  Descripcion: _testAntModel!.nombrePropAnterior),
              getWgModelo(
                  titulo: 'CASA COMERCIAL',
                  Descripcion: _testAntModel!.casaComercial),
              getWgModelo(titulo: 'CHASIS', Descripcion: _testAntModel!.chasis),
              getWgModelo(titulo: 'MOTOR', Descripcion: _testAntModel!.motor),
            ],
          ),
        ),
      ],
    );

    wgs2.add(wg);

    return wgs2;
  }

  Widget getWgModelo({String? titulo = '', String? Descripcion = ''}) {
    final responsive = ResponsiveUtil();
    Widget wg = Column(
      children: [
        Row(
          children: [
            Container(
              width: responsive.anchoP(33),
              child: Text(titulo != null ? titulo : '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
            ),
            Text(
              '=>',
              style: TextStyle(color: Colors.black),
            ),
            Expanded(
                child: Text(
              Descripcion != null ? Descripcion : '',
              style: TextStyle(color: Colors.black),
            )),
          ],
        ),
        Container(
          height: 1,
          color: Colors.white,
        ),
        SizedBox(
          height: responsive.altoP(0.2),
        ),
      ],
    );

    return wg;
  }

  Widget _TxtPlaca() {
    final responsive = ResponsiveUtil();
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white, //PARA PROBAR CONTAINER
                borderRadius: new BorderRadius.circular(30.0),
              ),
              child: Expanded(
                child: ImputTextWidget(
                  imgString: AppImages.icon_usuario,
                  controller: controller.controllerPlaca,
                  elevation: 1,
                  label: "Placa",
                  fonSize: 10,
                  hitText: "Ingrese la Placa",
                  validar: (text) {
                    if (text!.length >= 1) {
                      return null;
                    }
                    return "Ingrese la Placa";
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
