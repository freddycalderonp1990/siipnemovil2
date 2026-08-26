part of 'operativo_polco_local_widgets.dart';

class BusquedaTipoOperativoWg extends StatelessWidget {
  final String tipo;
  final GestureTapCallback? onTap;
  final String title;
  final String msjError;
  final GlobalKey<FormState> myKey;
  final int maxLength;
  final TextInputType keyboardType;
  final Icon? icono;
  final double anchoPorcentaje;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const BusquedaTipoOperativoWg({
    this.onTap,
    required this.title,
    required this.msjError,
    required this.myKey,
    this.maxLength = 11,
    this.keyboardType = TextInputType.text,
    this.icono,
    this.anchoPorcentaje = 100,
    required this.controller,
    this.tipo = 'N',
    required ValueKey<String> key,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ResponsiveUtil responsive = ResponsiveUtil();

    return Container(
      width: responsive.anchoP(anchoPorcentaje),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD7E3EE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Form(
              key: myKey,
              child: ImputTextWidget(
                controller: controller,
                focusNode: focusNode,
                keyboardType: keyboardType,
                maxLength: maxLength,
                icono: icono,
                activar: true,
                label: title,
                fonSize: responsive.diagonalP(2),
                validar: (value) {
                  if (value == null || value.toString().trim().isEmpty) {
                    return msjError;
                  }

                  return null;
                },
              ),
            ),
          ),

          const SizedBox(width: 6),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 9),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                      size: 19,
                    ),

                    if (tipo == 'N') ...[
                      const SizedBox(width: 4),

                      const Text(
                        "BUSCAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
