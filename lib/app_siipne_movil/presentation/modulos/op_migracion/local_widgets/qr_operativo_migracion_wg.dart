part of '../../pages.dart';

mixin QrOperativoMigracionViewMixin on OpMigracionPageBase {
  Future<void> mostrarQrOperativo() async {
    if (controller.peticionServerState.value ||
        !controller.puedeFinalizarOperativo.value) {
      return;
    }

    final int idEvento = controller.idHdrEventoActual.value;
    if (idEvento <= 0) {
      DialogosAwesome.getWarning(
        title: 'OPERATIVO NO DISPONIBLE',
        descripcion: 'No existe un identificador válido para generar el QR.',
      );
      return;
    }

    controller.peticionServerState.value = true;
    try {
      final String codigo =
          await OperativoQrUtil.encriptarIdOperativo(idEvento);
      final BuildContext? context = Get.context;
      if (context == null) return;

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(.68),
        builder: (BuildContext dialogContext) => _MigracionDialog(
          icono: Icons.qr_code_2_rounded,
          titulo: 'QR DEL OPERATIVO',
          subtitulo: 'OPERATIVO N.° $idEvento · IDENTIFICADOR CIFRADO',
          maxHeightFactor: .78,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFD6E2ED)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(.07),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: codigo,
                    version: QrVersions.auto,
                    size: 225,
                    backgroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F8F4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFB8DCC8)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.lock_rounded,
                        color: _MigracionColors.verde,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'Otro servidor policial puede escanear este código desde ANEXARSE para vincularse al operativo.',
                          style: TextStyle(
                            color: Color(0xFF267149),
                            fontSize: 9,
                            height: 1.35,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const _MigracionDialogCloseButton(texto: 'ENTENDIDO'),
              ],
            ),
          ),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR QR MIGRACIÓN: $e');
      debugPrint('$stackTrace');
      DialogosAwesome.getError(
        title: 'QR NO DISPONIBLE',
        descripcion: 'No fue posible generar el código QR del operativo.',
      );
    } finally {
      controller.peticionServerState.value = false;
    }
  }
}
