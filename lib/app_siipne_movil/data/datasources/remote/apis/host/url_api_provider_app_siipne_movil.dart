part of '../../../datasource_impl_siipne_movil.dart';

class UrlApiProviderAppCenso {
  // ============================================================
  // OBTENER MENSAJE BACKEND
  // ============================================================

  static String _extraerMensajeBackend(String body, {String fallback = ''}) {
    if (body.trim().isEmpty) {
      return fallback;
    }

    try {
      final dynamic respuesta = jsonDecode(body);

      if (respuesta is Map) {
        // ======================================================
        // message principal
        // ======================================================

        final String message = respuesta['message']?.toString().trim() ?? '';

        if (message.isNotEmpty) {
          return message;
        }

        // ======================================================
        // error principal
        // ======================================================

        final dynamic error = respuesta['error'];

        if (error is String && error.trim().isNotEmpty) {
          return error.trim();
        }

        if (error is Map) {
          final String mensajeError = error['message']?.toString().trim() ?? '';

          if (mensajeError.isNotEmpty) {
            return mensajeError;
          }
        }

        // ======================================================
        // data.message
        // ======================================================

        final dynamic data = respuesta['data'];

        if (data is Map) {
          final String mensajeData = data['message']?.toString().trim() ?? '';

          if (mensajeData.isNotEmpty) {
            return mensajeData;
          }

          final String errorData = data['error']?.toString().trim() ?? '';

          if (errorData.isNotEmpty) {
            return errorData;
          }
        }
      }
    } catch (e) {
      debugPrint('NO FUE POSIBLE PARSEAR MENSAJE BACKEND: $e');
    }

    /*
     * Si no era JSON pero existe texto,
     * devolvemos el texto del servidor.
     */
    final String texto = body.trim();

    if (texto.isNotEmpty) {
      /*
       * Evitamos devolver páginas HTML completas.
       */
      if (!texto.toLowerCase().contains('<html') &&
          !texto.toLowerCase().contains('<!doctype')) {
        return texto;
      }
    }

    return fallback;
  }

  // ============================================================
  // MENSAJE DESDE EXCEPTION
  // ============================================================

  static String mensajeException(
    dynamic error, {
    String fallback = 'No fue posible completar la operación.',
  }) {
    if (error == null) {
      return fallback;
    }

    String mensaje = error.toString().trim();

    /*
     * Dart convierte:
     *
     * Exception("BadRequest...")
     *
     * en:
     *
     * Exception: BadRequest...
     *
     * Para la interfaz no queremos mostrar
     * "Exception:".
     */
    if (mensaje.startsWith('Exception: ')) {
      mensaje = mensaje.substring('Exception: '.length).trim();
    }

    if (mensaje.startsWith('Exception:')) {
      mensaje = mensaje.substring('Exception:'.length).trim();
    }

    if (mensaje.isEmpty) {
      return fallback;
    }

    return mensaje;
  }

  // ============================================================
  // EJECUTAR PETICIÓN HTTP
  // ============================================================

  static Future<String> _request({
    required String metodo,
    String segmento = '',
    Object? body,
  }) async {
    final UrlApiProviderApp urlApiProviderApp = UrlApiProviderApp();

    final http.Client client = http.Client();

    try {
      final String url = HostAppSiipneMovil.gethost();

      Uri uri = Uri.parse(url);

      if (segmento.trim().isNotEmpty) {
        uri = Uri.parse(url + segmento);
      }

      final Map<String, String> headers = await urlApiProviderApp.getheaders();

      final String metodoHttp = metodo.trim().toUpperCase();

      debugPrint('==========================================');
      debugPrint('$metodoHttp -> REQUEST');
      debugPrint('URL: $uri');

      /*
       * IMPORTANTE:
       * No imprimir Authorization.
       */
      if (body != null) {
        debugPrint('BODY: $body');
      }

      debugPrint('==========================================');

      late http.Response response;

      switch (metodoHttp) {
        case 'POST':
          response = await client
              .post(uri, headers: headers, body: jsonEncode(body))
              .timeout(Duration(seconds: ApiConfig.secondsTimeout));
          break;

        case 'PUT':
          response = await client
              .put(uri, headers: headers, body: jsonEncode(body))
              .timeout(Duration(seconds: ApiConfig.secondsTimeout));
          break;

        case 'PATCH':
          response = await client
              .patch(uri, headers: headers, body: jsonEncode(body))
              .timeout(Duration(seconds: ApiConfig.secondsTimeout));
          break;

        case 'DELETE':
          response = await client
              .delete(uri, headers: headers, body: jsonEncode(body))
              .timeout(Duration(seconds: ApiConfig.secondsTimeout));
          break;

        case 'GET':
          response = await client
              .get(uri, headers: headers)
              .timeout(Duration(seconds: ApiConfig.secondsTimeout));
          break;

        default:
          throw Exception('Método HTTP no soportado: $metodoHttp');
      }

      final String responseBody = utf8.decode(
        response.bodyBytes,
        allowMalformed: true,
      );

      debugPrint('==========================================');
      debugPrint('$metodoHttp -> RESPONSE');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: $responseBody');
      debugPrint('==========================================');

      // ========================================================
      // RESPUESTA EXITOSA
      // ========================================================

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      }

      // ========================================================
      // RESPUESTA ERROR BACKEND
      // ========================================================

      final String mensajeBackend = _extraerMensajeBackend(
        responseBody,
        fallback: 'Error HTTP ${response.statusCode}',
      );

      debugPrint('==========================================');
      debugPrint('ERROR BACKEND');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('MENSAJE: $mensajeBackend');
      debugPrint('==========================================');

      /*
       * MUY IMPORTANTE:
       *
       * Aquí conservamos EXACTAMENTE el message
       * que envía la API.
       */
      throw Exception(mensajeBackend);
    } on TimeoutException {
      throw Exception(
        'Tiempo de espera agotado. Verifique su conexión e intente nuevamente.',
      );
    } on SocketException {
      throw Exception(
        'No fue posible conectarse con el servidor. Verifique su conexión a internet.',
      );
    } catch (e) {
      /*
       * Si ya viene nuestro BadRequest:
       *
       * Exception:
       * BadRequest: Operativo cerrado
       *
       * NO lo reemplazamos.
       */
      rethrow;
    } finally {
      client.close();
    }
  }

  // ============================================================
  // POST
  // ============================================================

  static Future<String> post({
    String segmento = '',
    Object? body,
    bool isLogin = false,
    bool onlyUrl = false,
  }) async {
    /*
     * Mantengo LOGIN con el provider original
     * para no alterar el flujo de autenticación.
     */
    if (isLogin) {
      final UrlApiProviderApp provider = UrlApiProviderApp();

      final String url = HostAppSiipneMovil.gethost();

      return provider.post(
        url: url,
        segmento: segmento,
        body: body,
        isLogin: true,
      );
    }

    return _request(metodo: 'POST', segmento: segmento, body: body);
  }

  // ============================================================
  // GET
  // ============================================================

  static Future<String> get({
    required String segmento,
    bool onlyUrl = false,
  }) async {
    return _request(metodo: 'GET', segmento: segmento);
  }

  // ============================================================
  // PATCH
  // ============================================================

  static Future<String> patch({String segmento = '', Object? body}) async {
    return _request(metodo: 'PATCH', segmento: segmento, body: body);
  }

  // ============================================================
  // PUT
  // ============================================================

  static Future<String> put({String segmento = '', Object? body}) async {
    return _request(metodo: 'PUT', segmento: segmento, body: body);
  }

  // ============================================================
  // DELETE
  // ============================================================

  static Future<String> delete({String segmento = '', Object? body}) async {
    return _request(metodo: 'DELETE', segmento: segmento, body: body);
  }

  // ============================================================
  // A PARTIR DE AQUÍ DEJA TU downloadPdfOperativo()
  // EXACTAMENTE COMO YA LO TIENES.
  // ============================================================

  static Future<String> downloadPdfOperativo({
    required int idGenUsuario,
    required int idHdrEvento,
  }) async {
    final http.Client client = http.Client();

    try {
      final Uri apiUri = Uri.parse(HostAppSiipneMovil.gethost());

      final String hostRaiz = '${apiUri.scheme}://${apiUri.authority}';

      const String pathReporte =
          '/operaciones/modulos/justificarAlertasMovil/imprimeMovil.php';

      final Uri uri = Uri.parse('$hostRaiz$pathReporte').replace(
        queryParameters: {
          'idGenUsuario': idGenUsuario.toString(),
          'idHdrEvento': idHdrEvento.toString(),
        },
      );

      debugPrint('==========================================');
      debugPrint('PDF OPERATIVO -> REQUEST');
      debugPrint('ID GEN USUARIO: $idGenUsuario');
      debugPrint('ID HDR EVENTO: $idHdrEvento');
      debugPrint('HOST RAÍZ: $hostRaiz');
      debugPrint('URL: $uri');
      debugPrint('==========================================');

      final UrlApiProviderApp urlApiProviderApp = UrlApiProviderApp();

      final Map<String, String> headers = await urlApiProviderApp.getheaders();

      final http.Response response = await client
          .get(uri, headers: headers)
          .timeout(Duration(seconds: ApiConfig.secondsTimeout));

      debugPrint('==========================================');
      debugPrint('PDF OPERATIVO -> RESPONSE');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BYTES: ${response.bodyBytes.length}');
      debugPrint('CONTENT-TYPE: ${response.headers['content-type']}');
      debugPrint('==========================================');

      if (response.statusCode != 200) {
        final String respuesta = utf8.decode(
          response.bodyBytes,
          allowMalformed: true,
        );

        final String mensaje = _extraerMensajeBackend(
          respuesta,
          fallback: 'Error al obtener el reporte PDF.',
        );

        throw Exception(mensaje);
      }

      if (response.bodyBytes.isEmpty) {
        throw Exception('El servidor devolvió un archivo vacío.');
      }

      final String contentType =
          response.headers['content-type']?.toLowerCase() ?? '';

      if (contentType.contains('text/html')) {
        final String contenido = utf8.decode(
          response.bodyBytes,
          allowMalformed: true,
        );

        final String mensaje = _extraerMensajeBackend(
          contenido,
          fallback: 'El servidor no devolvió un archivo PDF válido.',
        );

        throw Exception(mensaje);
      }

      final Directory tempDir = Directory.systemTemp;

      final Directory directorioPdf = Directory(
        '${tempDir.path}/siipne_movil_pdf',
      );

      if (!await directorioPdf.exists()) {
        await directorioPdf.create(recursive: true);
      }

      final String filePath =
          '${directorioPdf.path}/operativo_$idHdrEvento.pdf';

      final File file = File(filePath);

      await file.writeAsBytes(response.bodyBytes, flush: true);

      if (!await file.exists()) {
        throw Exception('No fue posible guardar el archivo PDF.');
      }

      final int tamanio = await file.length();

      if (tamanio <= 0) {
        throw Exception('El archivo PDF descargado está vacío.');
      }

      debugPrint('==========================================');
      debugPrint('PDF OPERATIVO DESCARGADO CORRECTAMENTE');
      debugPrint('ARCHIVO: $filePath');
      debugPrint('TAMAÑO: $tamanio bytes');
      debugPrint('==========================================');

      return filePath;
    } catch (e) {
      debugPrint('==========================================');
      debugPrint('ERROR PDF OPERATIVO');
      debugPrint(e.toString());
      debugPrint('==========================================');

      rethrow;
    } finally {
      client.close();
    }
  }
}
