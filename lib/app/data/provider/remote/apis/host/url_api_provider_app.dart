

part of '../../../providers_impl_app.dart';


class UrlApiProviderApp {
  final int secondsTimeout;
  final String? token;

  UrlApiProviderApp({this.secondsTimeout = 18, this.token});

  Map<String, String> getheaders({required String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<String> getToken() async {
    LocalStorageRepository _localStorageRepository =
    Get.find<LocalStorageRepository>();
    Rx<User> user = User.empty().obs;

    user.value = await _localStorageRepository.getUserModel();

    String token = user.value.token.request;

    return token;
  }

  Future<String> post(
      {String segmento = '',
      Object? body,
      required String url,
      bool isLogin = false}) async {
    try {
      http.Client client = http.Client();

      var uri = Uri.parse(url);
      if (segmento != '') {
        uri = Uri.parse(url + segmento);
      }

      final response = await client
          .post(uri,
              body: jsonEncode(body), headers: getheaders(token: this.token))
          .timeout(Duration(seconds: this.secondsTimeout));

      print("post-uri: ${uri.toString()}");
      print("post-body: ${body.toString()}");
      print("post-statusCode: ${response.statusCode}");
      log("METHOD post JSON: ${response.body.toString()}");

      if (response.statusCode == 200) {
        if (!isLogin) {

        }
        return response.body.toString();
      } else if (response.statusCode == 401 && isLogin) {
        throw ServerException(cause: "El Usuario - la clave es incorrecta");
      } else if (response.statusCode == 423 && isLogin) {
        String json = response.body.toString();
        CabeceraJsonModel data = CabeceraJsonModel.fromJson(json);
        throw ServerException(cause: data.message);
      } else {
        throw ServerException.StatusCode(statusCode: response.statusCode);
      }
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  Future<String> get({
    required String segmento,
    required String url,
  }) async {
    try {
      http.Client client = http.Client();

      var uri = Uri.parse(url);
      if (segmento != '') {
        url = url + segmento;
        uri = Uri.parse(url);
      }

      final response =
          await client.get(uri, headers: getheaders(token: this.token)).timeout(
                Duration(seconds: this.secondsTimeout),
              );

      print("post-uri: ${uri.toString()}");
      print("post-body: no existe");
      print("post-statusCode: ${response.statusCode}");
      log("METHOD GET JSON: ${response.body.toString()}");

      if (response.statusCode == 200) {
        return response.body.toString();
      } else {
        throw ServerException.StatusCode(statusCode: response.statusCode);
      }
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  Future<String> delete(
      {required String segmento, Object? body, required String url}) async {
    try {
      http.Client client = http.Client();

      var uri = Uri.parse(url);
      if (segmento != '') {
        url = url + segmento;
        uri = Uri.parse(url);
      }

      print("la url: $url");

      final response = await client
          .delete(uri,
              headers: getheaders(token: this.token), body: jsonEncode(body))
          .timeout(
            Duration(seconds: this.secondsTimeout),
          );

      print("post-uri: ${uri.toString()}");
      print("post-body: ${body.toString()}");
      print("post-statusCode: ${response.statusCode}");
      log("METHOD delete JSON: ${response.body.toString()}");

      if (response.statusCode == 200) {
        return response.body.toString();
      } else {
        throw ServerException.StatusCode(statusCode: response.statusCode);
      }
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  //Modifica toda la data
  Future<String> put(
      {String segmento = '', Object? body, required String url}) async {
    try {
      http.Client client = http.Client();

      var uri = Uri.parse(url);
      if (segmento != '') {
        uri = Uri.parse(url + segmento);
      }

      final response = await client
          .put(uri,
              body: jsonEncode(body), headers: getheaders(token: this.token))
          .timeout(Duration(seconds: this.secondsTimeout));

      print("post-uri: ${uri.toString()}");
      print("post-body: ${body.toString()}");
      print("post-statusCode: ${response.statusCode}");
      log("METHOD put JSON: ${response.body.toString()}");

      if (response.statusCode == 200) {
        return response.body.toString();
      } else {
        throw ServerException.StatusCode(statusCode: response.statusCode);
      }
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }


  //Modifica Parte de la data

  Future<String> patch(
      {String segmento = '', Object? body, required String url}) async {
    try {
      http.Client client = http.Client();

      var uri = Uri.parse(url);
      if (segmento != '') {
        uri = Uri.parse(url + segmento);
      }

      final response = await client
          .patch(uri,
          body: jsonEncode(body), headers: getheaders(token: this.token))
          .timeout(Duration(seconds: this.secondsTimeout));

      print("post-uri: ${uri.toString()}");
      print("post-body: ${body.toString()}");
      print("post-statusCode: ${response.statusCode}");
      log("METHOD put JSON: ${response.body.toString()}");

      if (response.statusCode == 200) {
        return response.body.toString();
      } else {
        throw ServerException.StatusCode(statusCode: response.statusCode);
      }
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  Future<String> postUploadFile(
      {required doc.File file,
      required String segmento,
      required String url, Map<String, String>? body}) async {
    try {
      String? parsed = null;

      var uri = Uri.parse(url);
      if (segmento != '') {
        url = url + segmento;
        uri = Uri.parse(url);
      }



      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();


      var request = new http.MultipartRequest("POST", uri);

      var multipartFile = new http.MultipartFile("file", stream, length,
          filename: basename(file.path),
          contentType: MediaType("text", "plain"));

      request.files.add(multipartFile);

      request.headers.addAll(getheaders(token: this.token));



      if(body!=null) {
        request.fields.addAll(body);
      }


      http.StreamedResponse response = await request.send();

      parsed = await response.stream.transform(utf8.decoder).first;

      print("postUploadFile-uri: ${uri.toString()}");
      print("postUploadFile-body: ${body.toString()}");
      print("postUploadFile-statusCode: ${response.statusCode}");

      log("METHOD postUploadFile JSON: ${parsed}");





      if (response.statusCode == 200) {
        return parsed.toString();
      } else {
        throw ServerException.StatusCode(statusCode: response.statusCode);
      }
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }
}
