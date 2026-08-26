part of 'custom_app_widgets.dart';

class WorkAreaPageWidget extends StatefulWidget {
  final RxBool peticionServer;
  final NamApps namApps;
  final Widget contenido;

  final ValueChanged<String>? onChangedBusqueda;
  final VoidCallback? onPressBtnAtras;

  final bool showGps;
  final String? title;

  final dynamic imgPerfil;
  final dynamic imgFondo;

  final bool mostrarVersion;
  final bool mostrarBtnHome;
  final bool mostrarBtnAtras;
  final VoidCallback? onPressedBtnHome;

  final bool showBtnNotificacione;

  /// Permite utilizar prácticamente toda la pantalla.
  /// Por defecto es false para no modificar el diseño
  /// de las pantallas existentes.
  final bool contenidoExpandido;

  const WorkAreaPageWidget({
    super.key,
    required this.peticionServer,
    required this.contenido,
    this.imgPerfil,
    this.imgFondo,
    this.mostrarVersion = false,
    this.title,
    this.mostrarBtnHome = false,
    this.onPressedBtnHome,
    this.mostrarBtnAtras = false,
    this.onChangedBusqueda,
    this.onPressBtnAtras,
    this.showGps = false,
    this.namApps = NamApps.Elecciones,
    this.showBtnNotificacione = false,
    this.contenidoExpandido = false,
  });

  @override
  State<WorkAreaPageWidget> createState() => _WorkAreaPageWidgetState();
}

class _WorkAreaPageWidgetState extends State<WorkAreaPageWidget> {
  bool _isSearching = false;

  String version = '';
  String namePhone = '';

  final NotificationService notificationService = Get.find();

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final String valorVersion = await DeviceInfoApp.getVersionCodeNameApp;

      if (!mounted) return;

      setState(() {
        version = valorVersion;
        namePhone = '';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        version = '';
        namePhone = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.colorPrimary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        return getDersingPage();
      },
    );
  }

  Widget getDesingImgProceso() {
    return const SizedBox.shrink();

    /*
    TODO: comentado
    final responsive=ResponsiveUtil();

    return Obx((){
      if(SiipneEleccionesImages.imgCabeceraProceso.value.length>10){
        var imgMemory=PhotoHelper.convertStringToUint8List(
          SiipneEleccionesImages.imgCabeceraProceso.value,
        );

        return imgMemory!=null
            ?Positioned(
                right:5,
                top:5,
                child:Container(
                  height:responsive.isHorizontal()
                      ?responsive.altoP(24)
                      :responsive.altoP(12),
                  width:responsive.isHorizontal()
                      ?responsive.anchoP(50)
                      :responsive.anchoP(48),
                  child:Center(
                    child:Image.memory(
                      imgMemory,
                      fit:BoxFit.contain,
                    ),
                  ),
                ),
              )
            :const SizedBox.shrink();
      }

      return const SizedBox.shrink();
    });
    */
  }

  Widget desingContenido() {
    final responsive = ResponsiveUtil();

    final Widget wgContenido = widget.showGps
        ? GpsAccessScreen(contenido: widget.contenido, namApps: widget.namApps)
        : widget.contenido;

    if (widget.title == null || widget.title!.trim().isEmpty) {
      return wgContenido;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextSombrasWidget(
          colorTexto: Colors.white,
          colorSombra: Colors.black,
          title: widget.title!,
          size: responsive.diagonalP(AppConfig.tamTextoTitulo + 0.2),
        ),

        SizedBox(
          height: widget.contenidoExpandido
              ? responsive.altoP(.5)
              : responsive.altoP(1),
        ),

        Expanded(child: wgContenido),
      ],
    );
  }

  Widget getDersingPage() {
    final responsive = ResponsiveUtil();

    return Scaffold(
      backgroundColor: AppColors.colorPrimary,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            getImgFondo(),

            getDesingImgProceso(),

            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: widget.contenidoExpandido
                        ? _contenidoPantallaExpandida(responsive)
                        : _contenidoPantallaNormal(responsive),
                  ),

                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),

            if (widget.mostrarBtnAtras)
              BtnAtrasWidget(pantallaIrAtras: widget.onPressBtnAtras),

            getBtnBuscar(),

            if (widget.mostrarBtnHome) getBtnHome(),

            getBtnNotificaciones(),

            Obx(() => CargandoWidget(mostrar: widget.peticionServer.value)),
          ],
        ),
      ),
    );
  }

  Widget _contenidoPantallaNormal(ResponsiveUtil responsive) {
    return Column(
      children: [
        SizedBox(height: responsive.altoP(8)),

        Expanded(
          child: Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: desingContenido(),
            ),
          ),
        ),

        SizedBox(height: responsive.altoP(4)),
      ],
    );
  }

  Widget _contenidoPantallaExpandida(ResponsiveUtil responsive) {
    return Column(
      children: [
        SizedBox(height: responsive.altoP(1)),

        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: desingContenido(),
          ),
        ),

        SizedBox(height: responsive.altoP(.5)),
      ],
    );
  }

  Widget getBtnBuscar() {
    if (widget.onChangedBusqueda == null) {
      return const SizedBox.shrink();
    }

    if (_isSearching) {
      return const SizedBox.shrink();
    }

    return BtnBuscar(
      onPressed: () {
        if (!mounted) return;

        setState(() {
          _isSearching = true;
        });
      },
    );
  }

  Widget getBtnHome() {
    final responsive = ResponsiveUtil();

    return Positioned(
      top: responsive.altoP(5),
      right: 10,
      child: BtnIconWidget(
        onPressed: widget.onPressedBtnHome,
        icon: Icons.menu,
        titulo: "Home",
      ),
    );
  }

  Widget getBtnNotificaciones() {
    if (!widget.showBtnNotificacione) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 0,
      right: 10,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.SHOW_NOTIFICATION);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.colorIcons,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              Obx(() {
                final int cantidad = notificationService.cantidadNoLeidas.value;

                if (cantidad <= 0) {
                  return const SizedBox.shrink();
                }

                return Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cantidad > 99 ? "99+" : cantidad.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget getImgFondo() {
    return Positioned.fill(
      child: Image.asset(
        widget.imgFondo == null ? AppImages.imgFondoDefault : widget.imgFondo,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) {
          return Container(color: AppColors.colorPrimary);
        },
      ),
    );
  }

  Widget getVersion() {
    if (!widget.mostrarVersion) {
      return const SizedBox.shrink();
    }

    if (version.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextSombrasWidget(
          size: 13,
          title: version,
          colorTexto: Colors.white,
          colorSombra: Colors.black,
        ),
      ],
    );
  }

  Widget getImgPerfil() {
    final responsive = ResponsiveUtil();

    if (widget.imgPerfil == null) {
      return const SizedBox.shrink();
    }

    return ImgPerfilRedonda(
      size: responsive.diagonalP(AppConfig.tamIcons),
      img: widget.imgPerfil,
    );
  }
}

class BtnBuscar extends StatelessWidget {
  final VoidCallback? onPressed;

  const BtnBuscar({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

    return Positioned(
      right: responsive.isVertical()
          ? responsive.altoP(1)
          : responsive.anchoP(1),
      top: responsive.isVertical() ? responsive.altoP(1) : responsive.anchoP(2),
      child: SafeArea(
        child: CupertinoButton(
          minSize: responsive.isVertical()
              ? responsive.altoP(5)
              : responsive.anchoP(5),
          padding: const EdgeInsets.all(3),
          borderRadius: BorderRadius.circular(30),
          color: Colors.black26,
          onPressed: onPressed,
          child: Icon(
            Icons.search,
            color: Colors.white,
            size: responsive.isVertical()
                ? responsive.altoP(3)
                : responsive.anchoP(3),
          ),
        ),
      ),
    );
  }
}

class SearchWidget extends StatefulWidget {
  final ValueChanged<String>? onChangedBusqueda;
  final ValueChanged<bool> onChangedisSearching;
  final String? title;
  final bool isSearching;

  const SearchWidget({
    super.key,
    this.onChangedBusqueda,
    this.title,
    required this.isSearching,
    required this.onChangedisSearching,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchQueryController = TextEditingController();

  @override
  void dispose() {
    _searchQueryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onChangedBusqueda == null) {
      return getTitle();
    }

    return Container(
      padding: const EdgeInsets.only(right: 10, left: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.isSearching
              ? Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: _searchQueryController,
                    onChanged: (value) {
                      widget.onChangedBusqueda?.call(value);
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: "Buscar...",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.colorPrimary),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.colorPrimary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                )
              : Expanded(child: getTitle()),

          if (widget.isSearching)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                _searchQueryController.clear();

                widget.onChangedBusqueda?.call('');

                widget.onChangedisSearching(false);
              },
            ),
        ],
      ),
    );
  }

  Widget getTitle() {
    final responsive = ResponsiveUtil();

    if (widget.title == null || widget.title!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return TextSombrasWidget(
      colorTexto: AppColors.colorAmarilloTitle,
      colorSombra: Colors.black87,
      title: widget.title!,
      size: responsive.diagonalP(AppConfig.tamTextoTitulo + 0.6),
    );
  }
}
