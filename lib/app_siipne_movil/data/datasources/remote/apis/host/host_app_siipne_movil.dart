part of  '../../../datasource_impl_siipne_movil.dart';

class HostAppSiipneMovil{
  //se utiliza el onlyUrl para no incluir el segmento
  // api/v1/siipne-movil/

  static gethost() {
    String segmento = dotenv.env['SEGMENTO_APP_SIIPNE_MOVIL'] ?? '';
    String url = HostApp.gethost( segmento: segmento);
    return url;
  }

}



class HeadAppSiipneMovilRequest {
  final String? modulo;
  final String uri;
  final Map<String, dynamic> bodyRequest;

  HeadAppSiipneMovilRequest({
    this.modulo,
    required this.uri,
    required this.bodyRequest,
  });

  /// Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> body = {
      "modulo": modulo ?? SiipneMovilApiConstantes.MODULO, // Usa ?? en lugar de operador ternario
      "uri": uri,
      ...bodyRequest, // Agrega los valores del bodyRequest al mapa usando spread operator
    };

    return body;
  }
}

