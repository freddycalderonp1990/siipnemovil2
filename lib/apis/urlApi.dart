
part of  'apis.dart';


class UrlApi {

  static String ambiente=Host.hostDesarrollo;
  static String host = Host.gethost(ambiente); //Pruebas

  static const _pathUrl = "appmovil/siipneMovil/index.php"; //ruta del arhivo index
//obtener polilyne
  //http://router.project-osrm.org/route/v1/driving/-78.501620,-0.217045;-78.500491,-0.216096

  static const String tag = "UrlApi";
  static const int timeEspera = 8;

  static Future getUrl(BuildContext context, Map<String, String> parametros,
      {File file = null, String modulo=ConstApi.moduloSiipneMovil}) async {
    try {
      //SE AGREGA EL VALOR DEL MODULO POR DEFECTO
      parametros.addAll({ConstApi.varModulo: modulo});
      Uri url = Uri.https(host, _pathUrl, parametros);
      var data = null;
      if (file != null) {
        //var host1="des.policia.gob.ec";
        url = Uri.https(host, _pathUrl, parametros);
        data = await getUrlUploadFile(url, context, file: file);
      } else {
        data = await getUrlCertificate(url, context);
      }

      log("urlLista= " + url.toString());
      print("mostrando la data");
      log(data);
      return data;
    } catch (e) {


      String msj = tag + " error en getUrl= ${e.message}";
      msj='No es posible conectar con el servidor.'
          '\nPor favor revise su conexión a internet y vuelve a ejecutar la acción. '
          '\nSi el problema persiste contacte con el administrador.  ' ;

      throw new Exception(msj);

    }
  }

  static Future getUrlNoCertificate(Uri url, BuildContext context) async {
    try {
      HttpClient client = new HttpClient();
      client.connectionTimeout = const Duration(seconds: timeEspera);
      HttpClientRequest request = await client.postUrl(url);

      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();

      String reply = await response.transform(utf8.decoder).join();

      return reply;
    } catch (e) {

      throw new Exception('[getUrlNoCertificate-${e.message}]');


    }
  }

  static Future getUrlCertificate(Uri url, BuildContext context) async {
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      client.connectionTimeout = const Duration(seconds: timeEspera);

      HttpClientRequest request = await client.postUrl(url);

      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();

      String reply = await response.transform(utf8.decoder).join();

      return reply;
    } catch (e) {
      throw new Exception('[getUrlCertificate-${e.message}]');

    }
  }


  static Future getUrlUploadFile(Uri url, BuildContext context,
      {File file}) async {
    try {
      String parsed = null;

      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();

      var request = new http.MultipartRequest("POST", url);

      var multipartFile = new http.MultipartFile("file", stream, length,
          filename: basename(file.path));

      request.files.add(multipartFile);

      http.StreamedResponse response = await request.send();

       parsed = await response.stream.transform(utf8.decoder).first;

      return parsed;
    } catch (e) {
      throw new Exception('[getUrlUploadFile-${e.message}]');

    }
  }
}
