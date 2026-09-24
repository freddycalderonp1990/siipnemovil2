part of '../operativo_polco_local_widgets.dart';

Uint8List _decodificarImagenBase64(String valor) {
  String contenido = valor.trim();
  final int separador = contenido.indexOf(',');
  if (contenido.startsWith('data:') && separador >= 0) contenido = contenido.substring(separador + 1);
  contenido = contenido.replaceAll(RegExp(r'\s+'), '');
  if (contenido.isEmpty) throw const FormatException('La imagen Base64 está vacía.');
  if (contenido.length > 20 * 1024 * 1024) throw const FormatException('La imagen Base64 supera el tamaño permitido.');
  return base64Decode(contenido);
}

class DesingRegistroCivilWg extends StatefulWidget {
  final String title;
  final String dato1;
  final String dato2;
  final String dato3;
  final String stringImg;
  final double sizeImg;
  final String? imgBase64;

  const DesingRegistroCivilWg({
    super.key,
    required this.title,
    required this.dato1,
    required this.dato2,
    required this.dato3,
    required this.stringImg,
    this.sizeImg = 45,
    this.imgBase64,
  });

  @override
  State<DesingRegistroCivilWg> createState() => _DesingRegistroCivilWgState();
}

class _DesingRegistroCivilWgState extends State<DesingRegistroCivilWg> {
  Uint8List? _imgMemory;
  int _numeroPeticion = 0;

  @override
  void initState() {
    super.initState();
    _cargarImagen();
  }

  @override
  void didUpdateWidget(covariant DesingRegistroCivilWg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imgBase64 != widget.imgBase64) _cargarImagen();
  }

  Future<void> _cargarImagen() async {
    final int peticion = ++_numeroPeticion;
    final String contenido = widget.imgBase64?.trim() ?? '';
    if (contenido.isEmpty) {
      _imgMemory = null;
      return;
    }
    _imgMemory = null;
    try {
      final Uint8List bytes = !kIsWeb && contenido.length >= 100000
          ? await compute<String, Uint8List>(_decodificarImagenBase64, contenido, debugLabel: 'decodificar-foto-registro-civil')
          : _decodificarImagenBase64(contenido);
      if (!mounted || peticion != _numeroPeticion) return;
      setState(() => _imgMemory = bytes);
    } catch (e) {
      debugPrint('No fue posible decodificar la fotografía: $e');
      if (!mounted || peticion != _numeroPeticion) return;
      setState(() => _imgMemory = null);
    }
  }

  Widget _imagenPredeterminada() {
    return Image.asset(widget.stringImg, width: widget.sizeImg, height: widget.sizeImg, fit: BoxFit.contain);
  }

  Widget _foto(BuildContext context) {
    final Uint8List? bytes = _imgMemory;
    if (bytes == null) return _imagenPredeterminada();
    final int cacheSize = (widget.sizeImg * MediaQuery.devicePixelRatioOf(context)).round().clamp(1, 1024).toInt();
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => DialogosDesingWidget.getDialogoXImgMemory(title: 'FOTO', imgMemory: bytes),
          child: Image.memory(
            bytes,
            width: widget.sizeImg,
            height: widget.sizeImg,
            fit: BoxFit.cover,
            cacheWidth: cacheSize,
            filterQuality: FilterQuality.low,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => _imagenPredeterminada(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _numeroPeticion++;
    _imgMemory = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveUtil responsive = ResponsiveUtil();
    return Container(
      width: responsive.anchoP(95),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConfig.radioBordecajas),
        border: Border.all(color: Colors.black.withOpacity(.5), width: .5),
      ),
      child: Column(
        children: [
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blueAccent.withOpacity(.9), fontWeight: FontWeight.bold, fontSize: responsive.diagonalP(2.3)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: SizedBox.square(dimension: widget.sizeImg, child: _foto(context)),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text(
                      widget.dato1,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black.withOpacity(.9), fontSize: responsive.diagonalP(1.5)),
                    ),
                    Row(
                      children: [
                        Expanded(flex: 2, child: Text(widget.dato2)),
                        const SizedBox(width: 1),
                        Expanded(flex: 1, child: Text(widget.dato3, textAlign: TextAlign.end)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}