part of 'user_custom_widgets.dart';

class WorkAreaPageLoginWidget extends StatefulWidget {
  final RxBool peticionServer;

  final Widget contenido;

  final String title;
  final imgPerfil;
  final imgFondo;

  final bool mostrarVersion;
  final bool mostrarBtnHome;
  final VoidCallback? onPressedBtnHome;

  const WorkAreaPageLoginWidget({
    required this.peticionServer,
    required this.contenido,
    this.imgPerfil = null,
    this.imgFondo,
    this.mostrarVersion = false,
    this.title = '',
    this.mostrarBtnHome = false,
    this.onPressedBtnHome,
  });

  @override
  _WorkAreaPageLoginWidgetState createState() =>
      _WorkAreaPageLoginWidgetState();
}

class _WorkAreaPageLoginWidgetState extends State<WorkAreaPageLoginWidget> {
  String version = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final String _version = await DeviceInfoApp.getVersionCodeNameApp;

    if (!mounted) return;

    setState(() {
      version = _version;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.colorPrimary, // color sólido
        statusBarIconBrightness: Brightness.light, // íconos claros
      ),
    );
    return OrientationBuilder(
      builder: (context, orientation) {
        print("orientation ${orientation}");

        //orientation == Orientation.portrait
        return getDersingPage();
      },
    );
  }

  Widget getDersingPage(){
    final responsive = ResponsiveUtil();
    return Scaffold(

      body: Material(
        color: Colors.white,
        child:  Stack(children: [
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: responsive.diagonalP(10),
              child: Image.asset(
                AppImages.imgLoginHeader,
                fit: BoxFit.fill,
              ),
            ),
          ),
        // Contenido
        Positioned(
          top: responsive.diagonalP(10),
          left: 0,
          right: 0,
          bottom: 60, // espacio para el footer
          child:
            SingleChildScrollView(
             // keyboardDismissBehavior:
            //  ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(

                constraints: BoxConstraints(

                  minHeight: responsive.altoP(80),
                ),
                child: Column(
                  children: [
                    // Header


                    // Logo
                    SizedBox(
                      height: responsive.diagonalP(8),
                      width: responsive.ancho,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.anchoP(5),
                        ),
                        child: Image.asset(AppImages.imgSiipneMovil),
                      ),
                    ),

                    SizedBox(height: responsive.altoP(4)),

                    SizedBox(
                      height: responsive.diagonalP(12),
                      width: responsive.diagonalP(12),
                      child: Image.asset(AppImages.escudopolicia),
                    ),

                    SizedBox(
                      width: responsive.diagonalP(12),
                      child: Image.asset(AppImages.imgloginPoliciaEcuador),
                    ),

                    /// FORMULARIO
                    widget.contenido,

                    const SizedBox(height: 20),


                    SizedBox(height: responsive.altoP(4)),



                  ],
                ),
              ),
            ),
        ),
          // Footer
          Positioned(
            left: 0,
            right: 0,
            bottom: 0+MediaQuery.of(context).padding.bottom,
            child: getVersion(),
          ),
          Obx(() => CargandoWidget(mostrar: widget.peticionServer.value)),
          ],),
        ),

    );
  }



  Widget getBtnHome() {
    final responsive = ResponsiveUtil();


    Widget wg= Positioned(
      top: responsive.altoP(5),
      right: 10,
      child: BtnIconWidget(
        colorIcon: AppColors.colorIcons,
        colorTxt: AppColors.colorIcons,
        colorLineas: AppColors.colorIcons,
        colorBtn: Colors.white,
        onPressed: widget.onPressedBtnHome,
        icon: Icons.menu,
        titulo: "Home",
      ),
    );

   return widget.mostrarBtnHome ? wg : Container();
  }

  Widget getImgFondo() {
    final responsive = ResponsiveUtil();
    return Container(
      height: responsive.alto,
      width: responsive.ancho,
      child: Image.asset(
        widget.imgFondo == null ? AppImages.imgFondoDefault : widget.imgFondo,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget getTitle() {
    final responsive = ResponsiveUtil();

    return widget.title != ''
        ? TextSombrasWidget(
            colorTexto: Colors.white,
            colorSombra: Colors.black,
            title: widget.title,
            size: responsive.diagonalP(AppConfig.tamTextoTitulo + 1),
          )
        : Container();
  }

  Widget getVersion() {
    if (!widget.mostrarVersion) {
      return const SizedBox.shrink();
    }

    if (!widget.mostrarVersion) return const SizedBox.shrink();

    final bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    if (keyboardVisible) {
      return const SizedBox.shrink();
    }


    final responsive = ResponsiveUtil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: responsive.anchoP(10),
          ),
          height: 1,
          color: AppColors.colorPlomo_40,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 18,
              color: Color(0xFF8E8E93),
            ),
            const SizedBox(width: 6),
            Text(
              version,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF8E8E93),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getImgPerfil() {
    final responsive = ResponsiveUtil();

    return widget.imgPerfil == null
        ? Container()
        : ImgPerfilRedonda(
            size: responsive.diagonalP(AppConfig.tamIcons),
            img: widget.imgPerfil,
          );
  }
}
