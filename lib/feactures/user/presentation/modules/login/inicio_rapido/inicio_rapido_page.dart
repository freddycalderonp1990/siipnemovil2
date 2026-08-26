part of '../../pages.dart';

class InicioRapidoPage extends GetView<InicioRapidoController> {
  const InicioRapidoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xFF0D315A),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppImages.imgFondoLogin,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xB30A2A4A),
                      Color(0x990D315A),
                      Color(0xE60A2542),
                    ],
                    stops: [0, .48, 1],
                  ),
                ),
              ),
            ),

            WorkAreaPageLoginWidget(
              imgFondo: null,
              imgPerfil: _getFotoPerfil(),
              nombresServidor: controller.user.value.nombres,
              gradoServidor: '',
              mostrarBtnHome: controller.mostrarBtnHome.value,
              onPressedBtnHome: () {},
              peticionServer: controller.peticionServerState,
              contenido: getContenido(responsive),
            ),
          ],
        ),
      ),
    );
  }

  dynamic _getFotoPerfil() {
    final foto = controller.user.value.foto;

    if (foto == null) return null;
    if (foto is String && foto.trim().isEmpty) return null;

    return foto;
  }

  Widget getContenido(ResponsiveUtil responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.anchoP(5)),
      child: Column(
        children: [
          _tituloAcceso(responsive),

          SizedBox(height: responsive.altoP(1)),

          _gridAccesos(responsive),

          SizedBox(height: responsive.altoP(1)),
        ],
      ),
    );
  }

  Widget _tituloAcceso(ResponsiveUtil responsive) {
    return Text(
      "Seleccione el método de autenticación",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey.shade600,
        fontSize: responsive.diagonalP(1),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _gridAccesos(ResponsiveUtil responsive) {
    final List<Widget> botones = [
      DesignBtnLoginRapidoWidget(
        icon: Icons.fingerprint_rounded,
        titulo: "Huella / Face ID",
        descripcion: "Acceso biométrico seguro",
        onTap: () => controller.loginConBiometrico(),
      ),

      DesignBtnLoginRapidoWidget(
        icon: Icons.lock_person_rounded,
        titulo: "Usuario y contraseña",
        descripcion: "Acceso con credenciales",
        onTap: () => controller.ingresoConOtroUsuario(),
      ),
    ];

    return _gridBotones(responsive: responsive, botones: botones);
  }

  Widget _gridBotones({
    required ResponsiveUtil responsive,
    required List<Widget> botones,
  }) {
    final List<Widget> filas = [];

    for (int i = 0; i < botones.length; i += 2) {
      if (i + 1 < botones.length) {
        filas.add(
          Row(
            children: [
              Expanded(child: botones[i]),
              SizedBox(width: responsive.anchoP(3)),
              Expanded(child: botones[i + 1]),
            ],
          ),
        );
      } else {
        filas.add(
          Row(
            children: [
              const Spacer(),
              Expanded(flex: 2, child: botones[i]),
              const Spacer(),
            ],
          ),
        );
      }

      if (i + 2 < botones.length) {
        filas.add(SizedBox(height: responsive.altoP(1.5)));
      }
    }

    return Column(children: filas);
  }
}
