import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../app_siipne_movil/core/siipne_config.dart';
import '../../../../../../app/core/utils/responsiveUtil.dart';

import 'title_detalle_wg.dart';

class DesingDatosRelacionalWg extends StatelessWidget {
  final String title;
  final String nombres;
  final String cedula;
  final String licencia;
  final String sexo;
  final bool boletas;
  final GestureTapCallback? onTap;

  const DesingDatosRelacionalWg(
      {Key? key,
      this.title = "",
      this.nombres = "",
      this.cedula = "",
      this.licencia = "",
      this.sexo = "",
      this.boletas = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

    return GestureDetector(
        onTap: onTap,
        child:Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.diagonalP(1.8)),
              ),
              Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Divider(),
                      nombres != ""
                          ? TitleDetalleWg(
                        title: "",
                        descripcion: nombres,
                      )
                          : Container(),
                      SizedBox(
                        height: responsive.anchoP(1),
                      ),
                      cedula != ""
                          ? TitleDetalleWg(
                        title: "Cédula",
                        descripcion: cedula,
                      )
                          : Container(),
                      SizedBox(
                        height: responsive.anchoP(1),
                      ),
                      licencia != ""
                          ? TitleDetalleWg(
                        title: "Licencia:",
                        descripcion: "TIPO B CADUCA 26-01-2025 PUNTOS: 30",
                      )
                          : Container(),
                      SizedBox(
                        height: responsive.anchoP(1),
                      ),
                      sexo != ""
                          ? TitleDetalleWg(
                        title: "SEXO:",
                        descripcion: "HOMBRE",
                      )
                          : Container(),
                      SizedBox(
                        height: responsive.anchoP(1),
                      ),
                      nombres != ""
                          ? TitleDetalleWg(
                        title: "Boletas de Captura:",
                        descripcion: boletas ? "SI" : "NO",
                      )
                          : Container(),
                      SizedBox(
                        height: responsive.anchoP(1),
                      ),
                    ],
                  )),
            ],
          ),
          decoration: BoxDecoration(
              color: boletas
                  ? Colors.red.withOpacity(0.8)
                  : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(SiipneConfig.radioBordecajas),
              border: Border.all(color: Colors.white)),
        ));

  }
}
