part of '../pages.dart';

class MenuSiipneMovilPage extends GetView<MenuSiipneMovilController> {
  const MenuSiipneMovilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //aqui obtenemos el token
    // context.read<NotificationsBloc>().requestPermission(appName: NamApps.Censo, idGenUsuario: controller.user.idGenUsuario);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsBloc>().requestPermission(
        appName: NamApps.SiipneMovil,
        idGenUsuario: controller.user.idGenUsuario,
      );
    });

    return WorkAreaPageSiipneMovilWidget(
      showGps: true,
      mostrarBtnAtras: false,
      title: "PERMISOS DE APLICACIONES",
      contenido: getContenido(),
      peticionServer: controller.peticionServerState,
    );
  }

  getContenido() {
    return Stack(
      children: [
        Column(
          children: [
            DesingFotoNameWidget(
              img: controller.user.foto,
              sexo: controller.user.sexo,
              nombres: controller.user.nombres,
            ),
            Expanded(child: _getMenu()),
          ],
        ),

        Obx(
          () => controller.mostrarIndicador.value
              ? Positioned(
                  bottom: 18,
                  left: 0,
                  right: 0,
                  child: _IndicadorScroll(),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  _getMenu() {
    final responsive = ResponsiveUtil();
    Widget wg = Obx(
      () => ListView.builder(
        padding: EdgeInsets.zero,
        controller: controller.scrollController,
        itemCount: controller.listModulos.length,
        itemBuilder: (_, index) {
          final modulo = controller.listModulos[index];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: BtnMenuSiipneMovilWidget(
              horizontal: true,
              colorFondo: Colors.white,
              img: AppSiipneMovilImages.ic_operativos_su,
              title: modulo.descripcion,
              descripcion: modulo.detalle,
              onTap: () {},
            ),
          );
        },
      ),
    );

    return wg;
  }
}

class _IndicadorScroll extends StatefulWidget {
  @override
  State<_IndicadorScroll> createState() => _IndicadorScrollState();
}

class _IndicadorScrollState extends State<_IndicadorScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _controller.value * 10),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.keyboard_double_arrow_down_rounded,
            size: 42,
            color: Color(0xFF164987),
          ),

          Text(
            "Desliza",
            style: TextStyle(
              color: Color(0xFF164987),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
