part of '../pages.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.colorPrimary,
        statusBarIconBrightness: Brightness.light,
      ),
    );


    final responsive = ResponsiveUtil();
    return GetBuilder<SplashController>(
      builder:
          (_) => Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.transparent,
              child: Stack(
                children: [
                  Image.asset(
                    AppImages.splash,
                    fit:
                        BoxFit
                            .cover, // Esto asegura que la imagen ocupe toda la pantalla
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    bottom: responsive.altoP(15),
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Obx(
                          () => CargandoWidget(
                            mostrar: controller.peticionServerState.value,
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: responsive.diagonalP(40),
                      child: Image.asset(AppImages.imgLoginHeader, fit: BoxFit.fill),
                    ),
                  ),
                  Center(child:
                 Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [


                     SizedBox(
                       height: responsive.diagonalP(10),
                       width: responsive.ancho,
                       child: Padding(
                         padding: EdgeInsets.symmetric(horizontal: responsive.anchoP(5)),
                         child: Image.asset(AppImages.imgSiipneMovil),
                       ),
                     ),

                  SizedBox(
                    width: responsive.diagonalP(12),
                    child: Image.asset(AppImages.imgloginPoliciaEcuador),
                  )
                 ],)
            )

                ],
              ),
            ),
          ),
    );
  }
}
