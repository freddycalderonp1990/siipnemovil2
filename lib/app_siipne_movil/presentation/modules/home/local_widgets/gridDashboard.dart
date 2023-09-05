import 'package:flutter/material.dart';

import '../../../../../../app/core/values/app_images.dart';
import '../../../../../../app_siipne_movil/core/values/siipne_colors.dart';

import '../../../../../app_siipne_movil/core/siipne_config.dart';
import '../../../../../app/core/utils/responsiveUtil.dart';
import '../../../../../app_siipne_movil/data/models/models.dart';
import '../../../../../app_siipne_movil/presentation/modules/controllers.dart';
import '../../../../../app_siipne_movil/presentation/widgets/customWidgets.dart';
import '../../../../core/values/siipne_images.dart';

class GridDashboard extends StatelessWidget {
  final HomeController homeController;

  final GestureTapCallback? onTap;

  final List<Modulo> modulos;

  GridDashboard(
      {this.onTap, required this.modulos, required this.homeController});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

    if (modulos.length == 1) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SiipneConfig.radioBordecajas),
            boxShadow: [
              BoxShadow(
                  color: SiipneColors.colorBordecajas,
                  blurRadius: SiipneConfig.sobraBordecajas)
            ]),
        child: Material(
          color: Colors.white.withOpacity(1),
          borderRadius: BorderRadius.circular(20),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              homeController.verificarGps(modulos[0]);
            },
            // handle your onTap here
            child: Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              margin: EdgeInsets.only(left: 5.0, right: 5.0),
              width: responsive.anchoP(90),
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: responsive.altoP(1),
                      ),
                      Container(
                        width: responsive.anchoP(15),
                        height: responsive.anchoP(15),
                        child: Image.asset(
                          AppImages.iconNoImg,
                        ),
                      ),
                      Text(
                        modulos[0].descripcion,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive
                                .anchoP(SiipneConfig.tamTextoTitulo)),
                      ),
                      Text(
                        modulos[0].detalle,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Color(0xff545454),
                            fontSize:
                            responsive.anchoP(SiipneConfig.tamTexto)),
                      ),
                      SizedBox(
                        height: responsive.altoP(1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
          padding: EdgeInsets.all(10),
          height: responsive.altoP(60),
          child: ListView.builder(
              itemCount: modulos.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    BtnMenuWidget2(
                      titlte: modulos[index].descripcion,
                      descripcion: modulos[index].detalle,
                      onTap: () {
                        homeController.verificarGps(
                            modulos[index]);
                      },
                      img: SiipneImages.icon_Polco,
                    ),
                    SizedBox(
                      height: 2,
                    )
                  ],
                );
              }));
    }
  }

  getGriw() {
    final responsive = ResponsiveUtil();
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 2 / 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemCount: modulos.length,
        itemBuilder: (BuildContext ctx, index) {
          return Container(
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(SiipneConfig.radioBordecajas),
                boxShadow: [
                  BoxShadow(
                      color: SiipneColors.colorBordecajas,
                      blurRadius: SiipneConfig.sobraBordecajas)
                ]),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  homeController
                      .verificarGps(modulos[index]);
                },
                // handle your onTap here
                child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  margin: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: responsive.altoP(1),
                          ),
                          Container(
                            width: responsive.anchoP(15),
                            height: responsive.anchoP(15),
                            child: Image.asset(
                              AppImages.iconNoImg,
                            ),
                          ),
                          Text(
                            modulos[index].descripcion,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.anchoP(
                                    SiipneConfig.tamTextoTitulo - 0.3)),
                          ),
                          Text(
                            modulos[index].detalle,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Color(0xff545454),
                                fontSize: responsive
                                    .anchoP(SiipneConfig.tamTexto - 0.5)),
                          ),
                          SizedBox(
                            height: responsive.altoP(1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
