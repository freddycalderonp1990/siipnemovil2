part of '../controllers.dart';

class AntController extends GetxController {
  final List<Widget> wgs = <Widget>[].obs;


  var peticionServerState = false.obs;
  RxString textError = ''.obs;

  final TestAntRepository _testAntRepository = Get.find<TestAntRepository>();

  var controllerPlaca = new TextEditingController();

  @override
  void onInit() {
    // TODO: el contolloler se ha creado pero la vista no se ha renderizado
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: Donde la vista ya se presento
    _init();
  }

  _init() async {}

  Future<String> getDatosString() async {
    try {
      final placa = controllerPlaca.text;
      peticionServerState(true);
      final datos = await _testAntRepository.getDataString(placa);
      peticionServerState(false);
      return datos;

    } on ServerException  catch (e){
      peticionServerState(false);
      DialogosAwesome.getError(descripcion: e.cause);
      return '';
    }
 catch (e) {
   peticionServerState(false);
      DialogosAwesome.getError(descripcion: e.toString());
      return '';
    }



  }

  Future<TestAntModel?> getDatos() async {
    try {
      final placa = controllerPlaca.text;
      peticionServerState(true);
      final datos = await _testAntRepository.getData(placa);
      peticionServerState(false);
      return datos;

    } on ServerException  catch (e){
            peticionServerState(false);
      DialogosAwesome.getError(descripcion: e.cause);
      return null;

    } catch (e) {
            peticionServerState(false);
      DialogosAwesome.getError(descripcion: e.toString());
      return null;
    }
  }

  Future<List<Widget>> decodeDatos() async {
    final responsive = ResponsiveUtil();
    String datos = await getDatosString();
    Map<String, dynamic> jsonD = json.decode(datos);
    int lenDatos = jsonD.length;
wgs.clear();
    jsonD.forEach((key, value) {
      Widget wg = Column(
        children: [
          Row(
            children: [
              Container(
                width: responsive.anchoP(33),
                child: Text(key.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
              ),
              SizedBox(
                width: responsive.anchoP(1),
              ),
              Expanded(
                child: Text(": " + value.toString(),style: TextStyle(color: Colors.black),),
              )
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
      print(key);

      wgs.add(wg);
    });


    return wgs;
  }
}
