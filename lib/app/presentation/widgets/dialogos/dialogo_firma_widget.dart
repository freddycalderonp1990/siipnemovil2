part of '../custom_app_widgets.dart';

class DialogoFirmaWidget extends StatefulWidget {
  final String titulo;
  final String descripcion;

  const DialogoFirmaWidget({
    Key? key,
    this.titulo = 'FIRMA DE ACEPTACIÓN',
    this.descripcion = 'Por favor, dibuje su firma en el recuadro para continuar.',
  }) : super(key: key);

  static Future<Uint8List?> mostrar() async {
    return await Get.dialog<Uint8List?>(
      const DialogoFirmaWidget(),
      barrierDismissible: false,
    );
  }

  @override
  State<DialogoFirmaWidget> createState() => _DialogoFirmaWidgetState();
}

class _DialogoFirmaWidgetState extends State<DialogoFirmaWidget> {
  final List<Offset?> _points = <Offset?>[];
  bool _estaDibujando = false;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ============================================================
            // HEADER
            // ============================================================
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF0D4C9C), Color(0xFF123A69)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.draw_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.titulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .4,
                          ),
                        ),
                        Text(
                          "RESPALDO DE ACEPTACIÓN",
                          style: TextStyle(
                            color: Colors.white.withOpacity(.75),
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    widget.descripcion,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 11,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ============================================================
                  // ÁREA DE DIBUJO
                  // ============================================================
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            _estaDibujando = true;
                            _points.add(details.localPosition);
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            _points.add(details.localPosition);
                          });
                        },
                        onPanEnd: (details) {
                          setState(() {
                            _points.add(null);
                          });
                        },
                        child: CustomPaint(
                          painter: SignaturePainter(_points),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ============================================================
                  // ACCIONES
                  // ============================================================
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _points.clear();
                              _estaDibujando = false;
                            });
                          },
                          icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                          label: const Text(
                            "LIMPIAR",
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF64748B),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _points.isEmpty ? null : _guardarFirma,
                          icon: const Icon(Icons.check_circle_rounded, size: 18),
                          label: const Text(
                            "GUARDAR FIRMA",
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D4C9C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardarFirma() async {
    final Uint8List? signature = await _exportSignature();
    if (signature != null) {
      Get.back(result: signature);
    }
  }

  Future<Uint8List?> _exportSignature() async {
    if (_points.isEmpty) return null;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 500, 250));

    // Fondo blanco
    final paintBg = Paint()..color = Colors.white;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 500, 250), paintBg);

    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < _points.length - 1; i++) {
      if (_points[i] != null && _points[i + 1] != null) {
        canvas.drawLine(_points[i]!, _points[i + 1]!, paint);
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(500, 250);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}
