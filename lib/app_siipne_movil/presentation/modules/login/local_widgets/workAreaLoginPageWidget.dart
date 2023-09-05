import 'package:get/get.dart';
import '../../../../../../app/data/provider/providers_impl_app.dart';

import '../../../../../../app_siipne_movil/core/siipne_config.dart';
import '../../../../../../app/core/utils/responsiveUtil.dart';
import '../../../../../../app/core/utils/utilidadesUtil.dart';
import '../../../../../../app_siipne_movil/core/values/siipne_images.dart';
import '../../../../../../app_siipne_movil/data/providers/providers_impl.dart';
import '../../../../../../app_siipne_movil/presentation/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../app/presentation/widgets/custom_app_widgets.dart';

class WorkAreaLoginPageWidget extends StatefulWidget {
  final RxBool peticionServer;
  final String title;
  final List<Widget> contenido;
  final bool btnAtras;
  final VoidCallback? pantallaIrAtras;
  final Widget? widgetBtnFinal;
  final EdgeInsetsGeometry? paddin;
  final FloatingActionButtonLocation ubicacionBtnFinal;
  final imgPerfil;
  final imgFondo;
  final double sizeTittle;
  final bool mostrarVersion;
  final bool eliminarSpaceTop;

  const WorkAreaLoginPageWidget({
    required this.peticionServer,
    this.title = '',
    required this.contenido,
    this.btnAtras = false,
    this.widgetBtnFinal,
    this.paddin,
    this.ubicacionBtnFinal = FloatingActionButtonLocation.centerFloat,
    this.imgPerfil = null,
    this.imgFondo,
    this.sizeTittle = 0,
    this.mostrarVersion = false,
    this.pantallaIrAtras,
    this.eliminarSpaceTop = false,
  });

  @override
  _WorkAreaLoginPageWidgetState createState() =>
      _WorkAreaLoginPageWidgetState();
}

class _WorkAreaLoginPageWidgetState extends State<WorkAreaLoginPageWidget> {
  String version = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadVersion();
  }

  _loadVersion() async {
    String _version = await UtilidadesUtil.getVersionCodeNameApp();
    setState(() {
      version = _version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

    Widget wgImgFondo = Container(
      height: responsive.alto,
      width: responsive.ancho,
      child: Image.asset(
        widget.imgFondo == null
            ? SiipneImages.imgFondoDefault
            : widget.imgFondo,
        fit: BoxFit.cover,
      ),
    );

    Widget wgImgPerfil = Container(
      margin: EdgeInsets.only(
        top: responsive.altoP(2.0),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SiipneConfig.radioBordecajas),
          boxShadow: [
            BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 45)
          ]),
      child: Center(
        child: Column(
          children: <Widget>[
            imgPerfilRedonda(
              size: 22,
              img: widget.imgPerfil,
            ),
            widget.title != ''
                ? Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.sizeTittle == 0
                            ? responsive.anchoP(5)
                            : responsive.anchoP(widget.sizeTittle)),
                  )
                : Container(),
            widget.mostrarVersion
                ? Text(
                    'Versión 2: Build-' + version + ' ' + HostApp.getAmbiente(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.5)),
                  )
                : Container()
          ],
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Color(0xFF003595),
        floatingActionButtonLocation: widget.ubicacionBtnFinal,
        floatingActionButton: widget.widgetBtnFinal,
        body: SafeArea(
          child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Stack(
                children: [
                  wgImgFondo,
                  Center(
                    child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 35),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            wgImgPerfil,
                            Column(
                              children: widget.contenido != null
                                  ? widget.contenido
                                  : [Container()],
                            ),
                            SizedBox(
                              height: responsive.altoP(5),
                            ),
                          ],
                        )),
                  ),
                  Obx(
                    () => CargandoWidget(
                      mostrar: widget.peticionServer.value,
                    ),
                  )
                ],
              )),
        ));

    Widget wgBtnAtras = Container(
      width: responsive.ancho,
      height: responsive.isVertical()
          ? responsive.altoP(8.5)
          : responsive.altoP(20),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: responsive.anchoP(38),
              height: responsive.anchoP(38),
            ),
          ),
          widget.btnAtras
              ? BtnAtrasWidget(
                  pantallaIrAtras: widget.pantallaIrAtras,
                )
              : Container(),
        ],
      ),
    );

    return Scaffold(
        floatingActionButtonLocation: widget.ubicacionBtnFinal,
        floatingActionButton: widget.widgetBtnFinal,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: [
                wgImgFondo,
                SafeArea(
                  child: Column(
                    children: [
                      wgBtnAtras,
                      Expanded(
                        child: SingleChildScrollView(
                            padding: widget.paddin,
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  wgImgPerfil,
                                  Column(
                                    children: widget.contenido != null
                                        ? widget.contenido
                                        : [Container()],
                                  )
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Obx(() => CargandoWidget(
                      mostrar: widget.peticionServer.value,
                    ))
              ],
            )));
  }
}
