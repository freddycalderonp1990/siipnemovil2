part of 'custom_siipne_movil_widgets.dart';

class BtnMenuSiipneMovilWidget extends StatefulWidget {
  final String? img;
  final String title;
  final String? descripcion;
  final GestureTapCallback? onTap;
  final bool horizontal;
  final bool cuadrado;
  final Color colorTexto;
  final Color colorFondo;

  const BtnMenuSiipneMovilWidget({
    super.key,
    this.img,
    this.title = '',
    this.descripcion,
    this.onTap,
    this.horizontal = false,
    this.cuadrado = false,
    this.colorTexto = Colors.black,
    this.colorFondo = Colors.white,
  });

  @override
  State<BtnMenuSiipneMovilWidget> createState() =>
      _BtnMenuSiipneMovilWidgetState();
}

class _BtnMenuSiipneMovilWidgetState extends State<BtnMenuSiipneMovilWidget> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
    final double fontSize = responsive.diagonalP(AppConfig.tamTexto - .25);

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => _cambiarEscala(.96),
      onPointerUp: (_) => _cambiarEscala(1),
      onPointerCancel: (_) => _cambiarEscala(1),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.cuadrado
            ? _buildCuadrado(fontSize, responsive)
            : _buildNormal(fontSize, responsive),
      ),
    );
  }

  void _cambiarEscala(double valor) {
    if (!mounted) return;
    if (_scale == valor) return;

    setState(() {
      _scale = valor;
    });
  }

  // ============================================================
  // VALIDACIÓN TEMPORAL DE IMÁGENES SEGÚN NOMBRE DEL MÓDULO
  // ============================================================

  String _getImagenModulo() {
    final String titulo = _normalizarTexto(widget.title);

    if (titulo.contains('MOVILES OPERATIVOS PREVENTIVOS') ||
        titulo.contains('MOVIL OPERATIVO PREVENTIVO')) {
      return AppSiipneMovilImages.img_modulos_dgo;
    }

    if (titulo.contains('MOVILES TRANSITO') ||
        titulo.contains('MOVIL TRANSITO')) {
      return AppSiipneMovilImages.img_modulos_transito;
    }

    if (titulo.contains('MOVILES METRO') || titulo.contains('MOVIL METRO')) {
      return AppSiipneMovilImages.img_modulos_metro;
    }

    final String? imagen = widget.img;

    if (imagen != null && imagen.trim().isNotEmpty) {
      return imagen.trim();
    }

    return AppSiipneMovilImages.img_modulos_transito;
  }

  String _normalizarTexto(String texto) {
    return texto
        .trim()
        .toUpperCase()
        .replaceAll('Á', 'A')
        .replaceAll('É', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll('Ü', 'U')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  // ============================================================
  // BOTÓN CUADRADO
  // ============================================================

  Widget _buildCuadrado(double fontSize, ResponsiveUtil responsive) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDCE5EF), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D4C9C).withOpacity(.08),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: widget.onTap,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(7, 7, 7, 2),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Column(
                          children: [
                            Expanded(child: _imagenModuloCuadrada()),

                            const SizedBox(height: 5),

                            Text(
                              widget.title.toUpperCase(),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                color: const Color(0xFF23364A),
                                fontSize: fontSize,
                                fontWeight: FontWeight.w800,
                                height: 1.08,
                                letterSpacing: .2,
                              ),
                            ),

                            const SizedBox(height: 3),
                          ],
                        ),
                      ),

                      if ((widget.descripcion ?? '').trim().isNotEmpty)
                        Positioned(
                          top: 1,
                          right: 1,
                          child: _botonInformacion(),
                        ),
                    ],
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F7FB),
                  border: Border(top: BorderSide(color: Color(0xFFE3EAF2))),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "INGRESAR",
                      style: TextStyle(
                        color: Color(0xFF195BA6),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .6,
                      ),
                    ),

                    SizedBox(width: 5),

                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFF195BA6),
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // IMAGEN GRANDE DEL BOTÓN CUADRADO
  // ============================================================

  Widget _imagenModuloCuadrada() {
    final double escala = _getEscalaImagenModulo();

    return Center(
      child: Container(
        width: 110,
        height: 82,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFF2F6FB)],
          ),
          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D4C9C).withOpacity(.10),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Transform.scale(
              scale: escala,
              child: Image.asset(
                _getImagenModulo(),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      AppImages.iconNoImg,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getEscalaImagenModulo() {
    final String titulo = _normalizarTexto(widget.title);

    if (titulo.contains('MOVILES OPERATIVOS PREVENTIVOS') ||
        titulo.contains('MOVIL OPERATIVO PREVENTIVO')) {
      return 1.10;
    }

    if (titulo.contains('MOVILES TRANSITO') ||
        titulo.contains('MOVIL TRANSITO')) {
      return 1.08;
    }

    if (titulo.contains('MOVILES METRO') || titulo.contains('MOVIL METRO')) {
      return 1.12;
    }

    return 1.0;
  }

  Widget _botonInformacion() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _mostrarDescripcion,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 27,
          height: 27,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.95),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: const Color(0xFFD5E2EF)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF195BA6),
            size: 17,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DISEÑO NORMAL
  // ============================================================

  Widget _buildNormal(double fontSize, ResponsiveUtil responsive) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        width: responsive.anchoP(70),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.colorFondo == Colors.white
                  ? const Color(0xFFE9EDF3)
                  : widget.colorFondo,

              widget.colorFondo == Colors.white
                  ? Colors.white
                  : widget.colorFondo.withOpacity(.9),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            child: widget.horizontal
                ? _buildHorizontal(fontSize, responsive)
                : _buildVertical(fontSize, responsive),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DISEÑO HORIZONTAL
  // ============================================================

  Widget _buildHorizontal(double fontSize, ResponsiveUtil responsive) {
    return Row(
      children: [
        _buildImage(responsive.anchoP(15)),
        Expanded(
          child: Text(
            widget.title.toUpperCase(),
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              color: widget.colorTexto,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: fontSize,
            ),
          ),
        ),

        if ((widget.descripcion ?? '').trim().isNotEmpty) ...[
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: _mostrarDescripcion,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF164987).withOpacity(.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF164987),
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ============================================================
  // DISEÑO VERTICAL
  // ============================================================

  Widget _buildVertical(double fontSize, ResponsiveUtil responsive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildImage(responsive.anchoP(14)),

        SizedBox(height: responsive.altoP(1)),

        Text(
          widget.title.toUpperCase(),
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
            color: widget.colorTexto,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // IMAGEN PARA DISEÑOS NORMALES
  // ============================================================

  Widget _buildImage(double size) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          _getImagenModulo(),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(AppImages.iconNoImg, fit: BoxFit.contain);
          },
        ),
      ),
    );
  }

  // ============================================================
  // INFORMACIÓN
  // ============================================================

  void _mostrarDescripcion() {
    if ((widget.descripcion ?? '').trim().isEmpty) return;

    DialogosAwesome.getInformation(
      title: widget.title,
      descripcion: widget.descripcion ?? '',
      titleBtn: "Entendido",
    );
  }
}
