part of   '../../../providers_impl_elecciones.dart';



class HostElecciones {
  //se utiliza el onlyUrl para no incluir el segmento
  // api/v1/siipne-movil/

  static gethost({bool onlyUrl = false}) {
    String url = HostApp.gethost(onlyUrl: onlyUrl);
    url=_setSegmento(url,onlyUrl);
    return url;
  }

  static  _setSegmento(String url, onlyUrl) {
    if (onlyUrl) {
      return url;
    }

    String segmento = 'api/v1/operativos-elecciones/';

    return url + segmento;
  }
}
