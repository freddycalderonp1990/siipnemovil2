part of '../../../providers_impl_app.dart';

class HostApp {
  //se utiliza el onlyUrl para no incluir el segmento
  // api/v1/siipne-movil/

  static gethost({bool onlyUrl = false}) {
    String url = '';
    switch (AppConfig.AmbienteUrl) {
      case Ambiente.desarrollo:
        url = "https://192.168.80.71:8002/"; //Desarrollo

        break;
      case Ambiente.prueba:
        url = "https://apides.policia.gob.ec/";  //Pruebas

        break;
      case Ambiente.produccion:
        url = "https://apides.policia.gob.ec/"; //Produccion

        break;
    }
    return url;
  }

  static getAmbiente() {
    String ambiente = '';
    switch (AppConfig.AmbienteUrl) {
      case Ambiente.desarrollo:
        ambiente = "Desc"; //Desarrollo

        break;
      case Ambiente.prueba:

        ambiente="Dest";
        break;
      case Ambiente.produccion:
        ambiente = "Prod"; //Produccion

        break;
    }
    return ambiente;
  }


}
