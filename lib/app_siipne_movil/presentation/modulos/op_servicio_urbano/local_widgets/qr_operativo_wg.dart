part of '../../pages.dart';

mixin QrOperativoViewMixin on OpServicioUrbanoPageBase {
  Future<void> mostrarQrOperativo() async {
    if (controller.peticionServerState.value) {
      return;
    }

    if (!controller.puedeFinalizarOperativo.value) {
      return;
    }

    final int idHdrEvento = controller.idHdrEventoActual.value;

    if (idHdrEvento <= 0) {
      DialogosAwesome.getWarning(
        title: "OPERATIVO NO DISPONIBLE",
        descripcion:
            "No existe un identificador válido para generar el código QR.",
      );

      return;
    }

    try {
      final String codigoQr = await OperativoQrUtil.encriptarIdOperativo(
        idHdrEvento,
      );

      final BuildContext? context = Get.context;

      if (context == null) {
        return;
      }

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(.65),
        builder: (dialogContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 24,
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 12, 7, 12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.qr_code_2_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),

                          const SizedBox(width: 9),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "QR DEL OPERATIVO",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                const SizedBox(height: 2),

                                Text(
                                  "OPERATIVO N° $idHdrEvento",
                                  style: const TextStyle(
                                    color: Color(0xDFFFFFFF),
                                    fontSize: 8.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(17),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFD6E2ED),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.07),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: QrImageView(
                              data: codigoQr,
                              version: QrVersions.auto,
                              size: 230,
                              backgroundColor: Colors.white,
                              errorCorrectionLevel: QrErrorCorrectLevel.M,
                            ),
                          ),

                          const SizedBox(height: 13),

                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_rounded,
                                color: Color(0xFF198754),
                                size: 15,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "IDENTIFICADOR CIFRADO",
                                style: TextStyle(
                                  color: Color(0xFF198754),
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 7),

                          const Text(
                            "Otro servidor policial puede escanear este código desde la opción ANEXARSE para vincularse al operativo.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF718294),
                              fontSize: 8.5,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 14),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              icon: const Icon(Icons.check_rounded, size: 17),
                              label: const Text(
                                "ENTENDIDO",
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(45),
                                backgroundColor: const Color(0xFF195BA6),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      DialogosAwesome.getError(
        title: "QR NO DISPONIBLE",
        descripcion: "No fue posible generar el código QR del operativo.",
      );
    }
  }
}
