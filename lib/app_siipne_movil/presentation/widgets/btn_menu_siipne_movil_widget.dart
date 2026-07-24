part of 'custom_siipne_movil_widgets.dart';


class BtnMenuSiipneMovilWidget extends StatefulWidget {
  final String? img;
  final String title;
  final String? descripcion;
  final GestureTapCallback? onTap;
  final bool horizontal;
  final Color colorTexto;
  final Color colorFondo;


  const BtnMenuSiipneMovilWidget({
    this.img,
    this.title = '',
    this.descripcion,
    this.onTap,
    this.horizontal = false,
    this.colorTexto = Colors.black,
    this.colorFondo = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  State<BtnMenuSiipneMovilWidget> createState() => _BtnMenuSiipneMovilWidgetState();
}

class _BtnMenuSiipneMovilWidgetState extends State<BtnMenuSiipneMovilWidget>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
    final fontSize = responsive.diagonalP(AppConfig.tamTexto - 0.1);

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: responsive.anchoP(70),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
            gradient: LinearGradient(
              colors: [
                widget.colorFondo == Colors.white
                    ? const Color(0xFFE9EDF3)
                    : widget.colorFondo,
                widget.colorFondo == Colors.white
                    ? const Color(0xFFFFFFFF)
                    : widget.colorFondo.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
            child: widget.horizontal
                ? _buildHorizontal(fontSize, responsive)
                : _buildVertical(fontSize, responsive),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontal(double fontSize, ResponsiveUtil responsive) {
    return Row(
      children: [
        _buildImage(responsive.anchoP(15)),
        SizedBox(width: responsive.anchoP(3)),

        /// Texto
        Expanded(
          child: Text(
            widget.title.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.colorTexto,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: fontSize,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),

        /// Espacio entre texto e icono
        const SizedBox(width: 8),

        /// Icono fijo a la derecha
        if ((widget.descripcion ?? "").isNotEmpty)
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
    );
  }

  void _mostrarDescripcion() {

    DialogosAwesome.getInformation(
      title: widget.title,
        descripcion:     widget.descripcion ?? '',titleBtn: "Entendido");
    return;


  }

  Widget _buildVertical(double fontSize, ResponsiveUtil responsive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildImage(responsive.anchoP(14)),
        SizedBox(height: responsive.altoP(1)),
        Text(
          widget.title.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.colorTexto,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
            fontSize: fontSize,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: ClipOval(
        child: widget.img != null
            ? Image.asset(widget.img!, fit: BoxFit.contain)
            : Image.asset(AppImages.iconNoImg, fit: BoxFit.contain),
      ),
    );
  }
}
