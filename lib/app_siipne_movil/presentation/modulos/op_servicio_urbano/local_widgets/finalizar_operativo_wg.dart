part of '../../pages.dart';

mixin FinalizarOperativoViewMixin on OpServicioUrbanoPageBase {
  void mostrarFinalizarOperativo() {
    controller.limpiarClaveFinalizar();

    final BuildContext? context = Get.context;

    if (context == null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      barrierColor: Colors.black.withOpacity(.68),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 20,
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(23),
            clipBehavior: Clip.antiAlias,
            elevation: 20,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  headerFinalizar(dialogContext),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 14, 15, 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7F1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF0D3BF)),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFFB76832),
                                size: 19,
                              ),

                              SizedBox(width: 7),

                              Expanded(
                                child: Text(
                                  "Al finalizar el operativo se cerrará el registro de nuevas consultas. Esta acción requiere validar su identidad.",
                                  style: TextStyle(
                                    color: Color(0xFF7A4A2A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 13),

                        opcionFinalizarClave(dialogContext),

                        const SizedBox(height: 10),

                        const Row(
                          children: [
                            Expanded(child: Divider()),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "O",
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),

                            Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 10),

                        opcionFinalizarBiometria(dialogContext),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed: () {
                              controller.limpiarClaveFinalizar();

                              Navigator.of(dialogContext).pop();
                            },
                            icon: const Icon(Icons.close_rounded, size: 17),
                            label: const Text(
                              "CANCELAR",
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF64748B),
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
  }

  Widget headerFinalizar(BuildContext dialogContext) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 7, 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFB42318), Color(0xFF78170F)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.power_settings_new_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "FINALIZAR OPERATIVO",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  "OPERATIVO N° ${controller.idHdrEventoActual.value}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.80),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              controller.limpiarClaveFinalizar();

              Navigator.of(dialogContext).pop();
            },
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget opcionFinalizarClave(BuildContext dialogContext) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD9E3ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFE6EFF8),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFF195BA6),
                  size: 17,
                ),
              ),

              SizedBox(width: 7),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "VALIDAR CON CLAVE",
                      style: TextStyle(
                        color: Color(0xFF314A61),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    Text(
                      "Ingrese su clave institucional",
                      style: TextStyle(color: Color(0xFF82909D), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          TextFormField(
            controller: controller.controllerClaveFinalizar,
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Clave institucional",
              prefixIcon: const Icon(
                Icons.password_rounded,
                color: Color(0xFF195BA6),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: Color(0xFFD5DFE8)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: Color(0xFFD5DFE8)),
              ),
            ),
          ),

          const SizedBox(height: 9),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();

                if (controller.controllerClaveFinalizar.text.trim().isEmpty) {
                  DialogosAwesome.getWarning(
                    title: "CLAVE REQUERIDA",
                    descripcion:
                        "Ingrese su clave institucional para continuar.",
                  );

                  return;
                }

                final bool valida = await controller.validarClaveFinalizar();

                if (!valida) {
                  DialogosAwesome.getError(
                    title: "CLAVE INCORRECTA",
                    descripcion: "La clave ingresada no pudo ser validada.",
                  );

                  return;
                }

                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }

                await Future.delayed(const Duration(milliseconds: 120));

                confirmarFinalizacionDefinitiva();
              },
              icon: const Icon(Icons.verified_user_rounded, size: 18),
              label: const Text(
                "VALIDAR CLAVE",
                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(43),
                backgroundColor: const Color(0xFF195BA6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget opcionFinalizarBiometria(BuildContext dialogContext) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          FocusManager.instance.primaryFocus?.unfocus();

          final bool autenticado = await controller
              .autenticarBiometriaFinalizar();

          if (!autenticado) {
            DialogosAwesome.getError(
              title: "AUTENTICACIÓN NO VALIDADA",
              descripcion:
                  "No fue posible validar su identidad mediante huella o biometría.",
            );

            return;
          }

          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }

          await Future.delayed(const Duration(milliseconds: 120));

          confirmarFinalizacionDefinitiva();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFEAF3FC), Color(0xFFF4F8FC)],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFACC9E3)),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: Color(0xFFDCEBFA),
                child: Icon(
                  Icons.fingerprint_rounded,
                  color: Color(0xFF195BA6),
                  size: 31,
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HUELLA / BIOMETRÍA",
                      style: TextStyle(
                        color: Color(0xFF195BA6),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      "Toque aquí para validar su identidad rápidamente.",
                      style: TextStyle(
                        color: Color(0xFF6F8294),
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF195BA6),
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void confirmarFinalizacionDefinitiva() {
    DialogosAwesome.getWarningSiNo(
      title: "CONFIRMAR FINALIZACIÓN",
      descripcion:
          "¿Está seguro de finalizar el operativo N° ${controller.idHdrEventoActual.value}?\n\n"
          "Una vez finalizado no se podrán registrar nuevas consultas.",
      btnOkOnPress: () async {
        final bool resultado = await controller.finalizarOperativo();

        if (!resultado) {
          DialogosAwesome.getError(
            title: "NO SE PUDO FINALIZAR",
            descripcion: controller.mensajeErrorFinalizar.isEmpty
                ? "No fue posible finalizar el operativo."
                : controller.mensajeErrorFinalizar,
          );

          return;
        }

        DialogosAwesome.getSucess(
          title: "OPERATIVO FINALIZADO",
          descripcion:
              "El operativo N° ${controller.idHdrEventoActual.value} fue finalizado correctamente.",
          btnOkOnPress: () {
            controller.volverMenu();
          },
        );
      },
      btnCancelOnPress: () {},
    );
  }
}
