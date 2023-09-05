part of   '../../../providers_impl_elecciones.dart';

class UrlApiProviderElecciones {
  static int _secondsTimeout = 8;

  static Future<String> getToken() async {
    String token=  await UrlApiProviderApp.getToken();
    return token;
  }

  static Future<String> post(
      {String segmento = '',
      Object? body,
      bool isLogin = false,
      bool onlyUrl = false}) async {
    try {
      String token = await getToken();

      UrlApiProviderApp _urlApiProviderApp =
          UrlApiProviderApp(secondsTimeout: _secondsTimeout, token: token);

      if (isLogin) {
        onlyUrl = true;
      }

      final String url = HostElecciones.gethost(onlyUrl: onlyUrl);

      return _urlApiProviderApp.post(
          url: url, segmento: segmento, body: body, isLogin: isLogin);

    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  static Future<String> patch(
      {String segmento = '',
        Object? body

        }) async {
    try {
      String token = await getToken();

      UrlApiProviderApp _urlApiProviderApp =
      UrlApiProviderApp(secondsTimeout: _secondsTimeout, token: token);
      final String url = HostElecciones.gethost();

      return _urlApiProviderApp.patch(
          url: url, segmento: segmento, body: body);

    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }


  static Future<String> postUploadFile(
      { required doc.File file,
        required String segmento,
        Map<String, String>? body}) async {
    try {
      String token = await getToken();

      UrlApiProviderApp _urlApiProviderApp =
      UrlApiProviderApp(secondsTimeout: _secondsTimeout, token: token);



      final String url = HostElecciones.gethost();

      return _urlApiProviderApp.postUploadFile(file: file, segmento: segmento, url: url,body: body);

    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  static Future<String> get(
      {required String segmento, bool onlyUrl = false}) async {
    try {
      String token = await getToken();
      UrlApiProviderApp _urlApiProviderApp =
      UrlApiProviderApp(secondsTimeout: _secondsTimeout, token: token);

      String url = HostElecciones.gethost(onlyUrl: onlyUrl);

      return _urlApiProviderApp.get(
          url: url, segmento: segmento,);
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }
}
