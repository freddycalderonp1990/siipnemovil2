part of 'custom_siipne_movil_widgets.dart';

class WorkAreaPageSiipneMovilWidget extends StatelessWidget {
  final RxBool peticionServer;
  final Widget contenido;

  final VoidCallback? onPressBtnAtras;

  final bool showGps;
  final String? title;

  final dynamic imgPerfil;
  final dynamic imgFondo;

  final bool mostrarBtnAtras;
  final bool showBtnNotificacione;

  /// Permite que el contenido utilice prácticamente
  /// toda el área disponible del WorkAreaPageWidget.
  final bool contenidoExpandido;

  const WorkAreaPageSiipneMovilWidget({
    super.key,
    required this.peticionServer,
    required this.contenido,
    this.imgPerfil,
    this.imgFondo,
    this.title,
    this.mostrarBtnAtras = false,
    this.onPressBtnAtras,
    this.showGps = false,
    this.showBtnNotificacione = false,
    this.contenidoExpandido = false,
  });

  @override
  Widget build(BuildContext context) {
    return WorkAreaPageWidget(
      namApps: NamApps.SiipneMovil,
      peticionServer: peticionServer,
      contenido: contenido,
      imgPerfil: imgPerfil,
      imgFondo: imgFondo,
      title: title,
      mostrarBtnAtras: mostrarBtnAtras,
      onPressBtnAtras: onPressBtnAtras,
      showGps: showGps,
      showBtnNotificacione: showBtnNotificacione,
      contenidoExpandido: contenidoExpandido,
    );
  }
}
