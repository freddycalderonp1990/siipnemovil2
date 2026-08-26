part of '../../pages.dart';

abstract final class _MigracionColors {
  static const Color azul = Color(0xFF195BA6);
  static const Color azulOscuro = Color(0xFF0A3D7E);
  static const Color texto = Color(0xFF203E5B);
  static const Color textoSuave = Color(0xFF718496);
  static const Color borde = Color(0xFFD5E1EC);
  static const Color fondo = Color(0xFFF5F9FD);
  static const Color verde = Color(0xFF198754);
  static const Color rojo = Color(0xFFB42318);
  static const Color naranja = Color(0xFFA97814);
}

class _MigracionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? borderColor;
  final Color color;

  const _MigracionCard({
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.margin = const EdgeInsets.fromLTRB(6, 4, 6, 6),
    this.borderColor,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: borderColor ?? _MigracionColors.borde),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: _MigracionColors.azul.withOpacity(.06),
            blurRadius: 11,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MigracionSectionHeader extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final String? badge;

  const _MigracionSectionHeader({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F2FC),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icono, color: _MigracionColors.azul, size: 21),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _MigracionColors.texto,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitulo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _MigracionColors.textoSuave,
                  fontSize: 8.2,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge!,
              style: const TextStyle(
                color: _MigracionColors.azul,
                fontSize: 7,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
      ],
    );
  }
}

class _MigracionDato extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData? icono;
  final Color? color;

  const _MigracionDato({
    required this.titulo,
    required this.valor,
    this.icono,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final String dato = valor.trim().isEmpty ? 'NO REGISTRA' : valor.trim();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: _MigracionColors.fondo,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDCE6EF)),
      ),
      child: Row(
        children: <Widget>[
          if (icono != null) ...<Widget>[
            Icon(icono, color: color ?? _MigracionColors.azul, size: 16),
            const SizedBox(width: 7),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF8A9AAA),
                    fontSize: 6.7,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .25,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  dato,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color ?? _MigracionColors.texto,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MigracionVacio extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _MigracionVacio({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FB),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFE1E8EE)),
      ),
      child: Row(
        children: <Widget>[
          Icon(icono, color: const Color(0xFF93A1AE), size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                color: Color(0xFF718090),
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MigracionCargando extends StatelessWidget {
  final String texto;

  const _MigracionCargando(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: _MigracionColors.azul,
            ),
          ),
          const SizedBox(width: 9),
          Flexible(
            child: Text(
              texto,
              style: const TextStyle(
                color: _MigracionColors.textoSuave,
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
