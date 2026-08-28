part of '../../pages.dart';

class _FotoVisaElectronica extends StatelessWidget {
  final String fotoBase64;
  final double width;
  final double height;

  const _FotoVisaElectronica({
    required this.fotoBase64,
    this.width = 92,
    this.height = 112,
  });

  @override
  Widget build(BuildContext context) {
    final String contenido = _limpiar(fotoBase64);
    if (contenido.isEmpty) return _sinFoto();

    try {
      final bytes = base64Decode(base64.normalize(contenido));
      if (bytes.isEmpty) return _sinFoto();

      return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFABC9E3), width: 1.4),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: _MigracionColors.azul.withOpacity(.10),
              blurRadius: 9,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            filterQuality: FilterQuality.medium,
            errorBuilder: (_, __, ___) => _contenidoSinFoto(),
          ),
        ),
      );
    } catch (_) {
      return _sinFoto();
    }
  }

  String _limpiar(String value) {
    String contenido = value.trim();
    final int separador = contenido.indexOf(',');
    if (contenido.startsWith('data:') && separador >= 0) {
      contenido = contenido.substring(separador + 1);
    }
    return contenido.replaceAll(RegExp(r'\s+'), '');
  }

  Widget _sinFoto() {
    return SizedBox(width: width, height: height, child: _contenidoSinFoto());
  }

  Widget _contenidoSinFoto() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FC),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFC4D7E8)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.no_photography_outlined,
            color: _MigracionColors.textoSuave,
            size: 27,
          ),
          SizedBox(height: 4),
          Text(
            'SIN FOTO',
            style: TextStyle(
              color: _MigracionColors.textoSuave,
              fontSize: 6.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
