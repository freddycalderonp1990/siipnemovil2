part of 'utils.dart';


class UtilidadesUtil {
  static double redondearDecimales(double valor) {
    return redondearDecimalesN(valor, 2);
  }


  static double redondearDecimalesN(double valor, int numDecimales) {
    return double.parse((valor).toStringAsFixed(numDecimales));
  }

  static Future<GaleryCameraModel> getImageGallery(String title) async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    return getImagenResourse(title:title,imageFile:imageFile);

  }

  static Future<GaleryCameraModel> getImageCamera(String title) async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    return getImagenResourse(title:title,imageFile:imageFile);

  }
  static Future<String> getVersionCodeApp() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;

    String result= versionName+' - '+versionCode;

    return result;
  }



  static pantallasAbrirNuevaCerrarTodas({BuildContext context, String pantalla}){
    Navigator.of(context).pushNamedAndRemoveUntil(pantalla, (Route<dynamic> route) => false);
  }

  static Future<GaleryCameraModel> getImagenResourse ({String title,imageFile}) async{
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int tamImg=900;


    if(imageFile!=null) {
      int rand = new math.Random().nextInt(100000);

      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());

      // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
      //Img Image thumbnail = copyResize(image, 120);

      print('Alto: ${image.height}, Ancho ${image.width}');

      int altoImg=image.height;
      int anchoImg=image.width;

      if(altoImg>anchoImg){
        //Img Vertical
        altoImg=tamImg;
        print('En columna IMG alto ${altoImg}, ancho ${anchoImg}');
      }
      else{
        //Img Horizontal
        anchoImg=tamImg;
        print('En row IMG alto ${anchoImg}, ancho ${anchoImg}');
      }

      Img.Image smallerImg = Img.copyResize(image, height: altoImg,width: anchoImg);


      String nameImg = "image_" + title + "_" + rand.toString() + ".jpg";
      var compressImg = new File("$path/$nameImg")
        ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 100));
      return GaleryCameraModel(nombreImg:nameImg,image: compressImg);
    }


  }


  static Future<String> getIp() async {
    String ipAddress = "0";
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      ipAddress = await GetIp.ipAddress;
    } on PlatformException {
      ipAddress = '0';
    }
    String plataforma = getPlataforma();
    return plataforma + " IP: " + ipAddress;
  }

  static getTheme() {
    return SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  static String getPlataforma() {
    bool isAndroid = Platform.isAndroid;
    bool isOs = Platform.isIOS;
    String result = Platform.operatingSystem;
    if (isAndroid) {
      result = "ANDROID";
    } else if (isOs) {
      result = "IOS";
    } else {
      result = Platform.operatingSystem.toUpperCase();
    }
    return "PLATAFORMA " + result;
  }

  static Future<String> get getLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static   setStringBool (bool valor) {

    return valor?'S':'N';
  }




}
