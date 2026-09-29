part of '../pages.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});
  static const Color _azulOscuro = Color(0xFFCDCDCD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: _azulOscuro,
      body: Stack(
        children: [
          _fondo(),
          _capaFondo(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final double height = constraints.maxHeight;

                final bool telefonoPequeno = width < 380 || height < 700;
                final bool tablet = width >= 600;
                final bool pantallaGrande = width >= 900;

                final double horizontalPadding = pantallaGrande
                    ? 32
                    : tablet
                    ? 28
                    : telefonoPequeno
                    ? 14
                    : 20;

                return Column(
                  children: [
                    _barraSuperior(
                      context,
                      telefonoPequeno: telefonoPequeno,
                      tablet: tablet,
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          telefonoPequeno ? 4 : 10,
                          horizontalPadding,
                          telefonoPequeno ? 8 : 16,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: telefonoPequeno
                                ? 0
                                : constraints.maxHeight -
                                (pantallaGrande ? 145 : 125),
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: pantallaGrande
                                    ? 620
                                    : tablet
                                    ? 560
                                    : 500,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: telefonoPequeno
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.center,
                                children: [
                                  _encabezado(
                                    tablet: tablet,
                                    pantallaGrande: pantallaGrande,
                                    pantallaBaja: telefonoPequeno,
                                  ),

                                  SizedBox(
                                    height: telefonoPequeno
                                        ? 10
                                        : pantallaGrande
                                        ? 20
                                        : 18,
                                  ),

                                  _formulario(
                                    tablet: tablet,
                                    pantallaGrande: pantallaGrande,
                                    pantallaBaja: telefonoPequeno,
                                  ),

                                  SizedBox(
                                    height: telefonoPequeno ? 10 : 16,
                                  ),

                                  _piePagina(
                                    tablet: tablet,
                                    pantallaBaja: telefonoPequeno,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    _versionApp(context),
                  ],
                );
              },
            ),
          ),

          Obx(
                () => CargandoWidget(
              mostrar: controller.peticionServerState.value,
              titulo: 'VERIFICANDO CREDENCIALES',
              mensaje: 'Preparando los servicios institucionales...',
            ),
          ),
        ],
      ),
    );
  }
  Widget _fondo() {
    return Positioned.fill(
      child: Image.asset(
        AppImages.imgFondoLogin,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) =>
            Container(color: _azulOscuro),
      ),
    );
  }

  Widget _capaFondo() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xB3BBBCBD), Color(0x990D315A), Color(0xFF101A30)],
            stops: [0, .48, 1],
          ),
        ),
      ),
    );
  }

  Widget _barraSuperior(
      BuildContext context, {
        required bool telefonoPequeno,
        required bool tablet,
      }) {
    final double alturaLogo = tablet
        ? 60
        : telefonoPequeno
        ? 46
        : 54;

    final double tamBoton = telefonoPequeno ? 38 : 42;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        telefonoPequeno ? 10 : 16,
        telefonoPequeno ? 2 : 4,
        telefonoPequeno ? 10 : 12,
        0,
      ),
      child: SizedBox(
        height: tablet
            ? 66
            : telefonoPequeno
            ? 50
            : 58,
        child: Row(
          children: [
            SizedBox(width: tamBoton),
            Expanded(
              child: Center(
                child: Image.asset(
                  AppImages.imgSiipneMovil,
                  height: alturaLogo,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Obx(
                  () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: controller.mostrarBtnHome.value
                    ? Material(
                  key: const ValueKey('btnHome'),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(13),
                    onTap: () => controller.setAppPageSelect(
                      PageAppsSelect.Bienvenida,
                    ),
                    child: Container(
                      width: tamBoton,
                      height: tamBoton,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.12),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: Colors.white.withOpacity(.18),
                        ),
                      ),
                      child: Icon(
                        Icons.home_rounded,
                        color: Colors.white,
                        size: telefonoPequeno ? 20 : 22,
                      ),
                    ),
                  ),
                )
                    : SizedBox(
                  key: const ValueKey('sinBtnHome'),
                  width: tamBoton,
                  height: tamBoton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _encabezado({
    required bool tablet,
    required bool pantallaGrande,
    required bool pantallaBaja,
  }) {
    final double escudo = pantallaBaja
        ? 62
        : pantallaGrande
        ? 100
        : tablet
        ? 90
        : 82;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: tablet ? 500 : 430,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppImages.escudopoliciaPlomo,
            width: escudo,
            height: escudo,
            fit: BoxFit.contain,
          ),

          SizedBox(height: pantallaBaja ? 5 : 12),

          Text(
            'INICIO DE SESIÓN',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: pantallaBaja
                  ? 19
                  : tablet
                  ? 24
                  : 22,
              fontWeight: FontWeight.w800,
              letterSpacing: .5,
              height: 1.1,
            ),
          ),

          SizedBox(height: pantallaBaja ? 4 : 7),

          Text(
            'Ingrese sus credenciales institucionales para continuar',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(.82),
              fontSize: pantallaBaja
                  ? 11.5
                  : tablet
                  ? 14
                  : 13,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
  Widget _formulario({
    required bool tablet,
    required bool pantallaGrande,
    required bool pantallaBaja,
  }) {
    final double anchoFormulario = pantallaGrande
        ? 580
        : tablet
        ? 520
        : 430;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: anchoFormulario,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: pantallaBaja
              ? 14
              : tablet
              ? 30
              : 18,
          vertical: pantallaBaja
              ? 12
              : pantallaGrande
              ? 24
              : 18,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.96),
          borderRadius: BorderRadius.circular(
            tablet ? 24 : 20,
          ),
          border: Border.all(
            color: Colors.white.withOpacity(.80),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.18),
              blurRadius: pantallaBaja ? 18 : 28,
              spreadRadius: 1,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: WgLogin(
          onPressed: () => controller.login(),
          controllerPass: controller.controllerPass,
          controllerUser: controller.controllerUser,
          formKey: controller.formKey,
        ),
      ),
    );
  }
  Widget _piePagina({
    required bool tablet,
    required bool pantallaBaja,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppImages.imgloginPoliciaEcuador,
          height: pantallaBaja
              ? 30
              : tablet
              ? 42
              : 38,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Widget _versionApp(BuildContext context) {
    final bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    if (keyboardVisible) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<String>(
      future: DeviceInfoApp.getVersionCodeNameApp,
      builder: (context, snapshot) {
        final String version = snapshot.data ?? '';

        if (version.isEmpty) {
          return const SizedBox(height: 20);
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(.25),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(.22)),
                    ),
                    child: Icon(
                      Icons.gpp_good_outlined,
                      size: 21,
                      color: Colors.white.withOpacity(.85),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(.25),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(.18)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      version,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(.88),
                        fontWeight: FontWeight.w600,
                        letterSpacing: .4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
