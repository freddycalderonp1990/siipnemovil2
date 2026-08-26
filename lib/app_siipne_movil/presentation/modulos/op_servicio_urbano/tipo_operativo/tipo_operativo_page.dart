part of '../../pages.dart';

class TipoOperativoPage extends GetView<TipoOperativoController> {
  const TipoOperativoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TipoOperativoController>(
      builder: (controller) {
        return WorkAreaPageSiipneMovilWidget(
          showGps: true,
          mostrarBtnAtras: true,
          contenidoExpandido: false,
          title: null,
          peticionServer: controller.peticionServerState,
          contenido: _contenidoPrincipal(context),
        );
      },
    );
  }

  Widget _contenidoPrincipal(BuildContext context) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _cardModulo(),
            const SizedBox(height: 12),
            _cardSeguridad(),
            const SizedBox(height: 16),
            _btnIniciarOperativo(context),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CABECERA DEL MÓDULO
  // ============================================================

  Widget _cardModulo() {
    final String nombre = controller.dataModuloResponse.descripcion.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD7E2EE)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D4C9C).withOpacity(.10),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 112,
            height: 82,
            padding: const EdgeInsets.all(3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                _getImagenModulo(),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Image.asset(AppImages.iconNoImg, fit: BoxFit.contain),
              ),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "MÓDULO OPERATIVO",
                  style: TextStyle(
                    color: Color(0xFF7E8DA0),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .8,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  nombre.isEmpty ? "CARGANDO MÓDULO..." : nombre.toUpperCase(),
                  softWrap: true,
                  style: const TextStyle(
                    color: Color(0xFF193550),
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    height: 1.18,
                  ),
                ),

                const SizedBox(height: 7),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3FC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD2E3F3)),
                  ),
                  child: const Text(
                    "SERVICIO POLICIAL",
                    style: TextStyle(
                      color: Color(0xFF195BA6),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ALERTA SEGURIDAD
  // ============================================================

  Widget _cardSeguridad() {
    ResponsiveUtil responsiveUtil = ResponsiveUtil();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF7F8), Color(0xFFFFFBFB)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB9092D), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB9092D).withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9ED),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFB9092D),
                  size: 25,
                ),
              ),

              const SizedBox(width: 3),

              const Expanded(
                child: Text(
                  "ALERTA DE SEGURIDAD",
                  style: TextStyle(
                    color: Color(0xFFB9092D),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          const Text(
            "Usted accederá a información personal y sensible, incluyendo datos personales, antecedentes, información vehicular, boletas judiciales y reportes de vehículos robados.\n\n"
            "TODA CONSULTA ES AUDITADA y registrada. El uso indebido, consultas sin justificación o la divulgación de esta información puede acarrear sanciones administrativas, civiles y penales.\n\n"
            "Utilice estos datos exclusivamente para fines institucionales y con estricto apego a la normativa vigente.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Color(0xFF173E64),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.38,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTÓN PRINCIPAL
  // ============================================================

  Widget _btnIniciarOperativo(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: () => _dialogoInicioOperativo(context),
        child: Ink(
          width: double.infinity,
          height: 68,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF195BA6), Color(0xFF0B3F79)],
            ),
            borderRadius: BorderRadius.circular(19),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0D4C9C).withOpacity(.30),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.14),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.white.withOpacity(.18)),
                  ),
                  child: Image.asset(
                    _getImagenModulo(),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "INICIAR OPERATIVO",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Seleccione cómo desea iniciar el servicio",
                        style: TextStyle(
                          color: Color(0xDFFFFFFF),
                          fontSize: 9.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.13),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DIÁLOGO INICIAR OPERATIVO
  // ============================================================

  void _dialogoInicioOperativo(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      barrierColor: Colors.black.withOpacity(.58),
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 24,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.22),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ============================================================
                  // CABECERA
                  // ============================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF195BA6), Color(0xFF0B3F79)],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.14),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(.18),
                            ),
                          ),
                          child: const Icon(
                            Icons.local_police_rounded,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),

                        const SizedBox(width: 10),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "INICIAR OPERATIVO",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: .2,
                                ),
                              ),

                              SizedBox(height: 2),

                              Text(
                                "Seleccione la modalidad de ingreso",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xDFFFFFFF),
                                  fontSize: 8.8,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ============================================================
                  // CONTENIDO
                  // ============================================================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ==================================================
                            // ANEXARSE
                            // ==================================================

                            Expanded(
                              child: _btnModalidadOperativo(
                                titulo: "ANEXARSE",
                                subtitulo: "Unirse a un operativo existente",
                                imagen: AppSiipneMovilImages.img_anexarse,
                                principal: false,
                                onTap: () {
                                  Navigator.of(dialogContext).pop();

                                  Future.delayed(
                                    const Duration(milliseconds: 150),
                                    () {
                                      if (context.mounted) {
                                        _dialogoAnexarse(context);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 10),

                            // ==================================================
                            // ABRIR OPERATIVO
                            // ==================================================
                            Expanded(
                              child: _btnModalidadOperativo(
                                titulo: "ABRIR OPERATIVO",
                                subtitulo: "Crear un nuevo operativo",
                                imagen:
                                    AppSiipneMovilImages.img_crear_operativo,
                                principal: true,
                                onTap: () {
                                  Navigator.of(dialogContext).pop();

                                  controller.limpiarTipoOperativo();

                                  Future.delayed(
                                    const Duration(milliseconds: 150),
                                    () {
                                      if (context.mounted) {
                                        _dialogoAbrirOperativo(context);
                                      }
                                    },
                                  );
                                },
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
          ),
        );
      },
    );
  }

  Widget _btnModalidadOperativo({
    required String titulo,
    required String subtitulo,
    required String imagen,
    required bool principal,
    required VoidCallback onTap,
  }) {
    final Color colorPrincipal = principal
        ? const Color(0xFF195BA6)
        : const Color(0xFF198754);

    return SizedBox(
      width: double.infinity,
      height: 205,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(17),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: principal
                    ? const Color(0xFFB9CEE2)
                    : const Color(0xFFB9D8C7),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorPrincipal.withOpacity(.07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 9),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // ============================================================
                  // IMAGEN
                  // ============================================================

                  Container(
                    width: double.infinity,
                    height: 105,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F9FC),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: const Color(0xFFE2E8EF)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        imagen,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              principal
                                  ? Icons.add_task_rounded
                                  : Icons.group_add_rounded,
                              color: colorPrincipal,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 2),

                  // ============================================================
                  // TÍTULO
                  // ============================================================
                  SizedBox(
                    height: 16,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          titulo,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            color: colorPrincipal,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ============================================================
                  // DESCRIPCIÓN
                  // ============================================================
                  Expanded(
                    child: Center(
                      child: Text(
                        subtitulo,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF7B8B99),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 2),

                  // ============================================================
                  // ACCIÓN
                  // ============================================================
                  Container(
                    width: double.infinity,
                    height: 29,
                    decoration: BoxDecoration(
                      color: colorPrincipal.withOpacity(.08),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          principal
                              ? Icons.add_circle_outline_rounded
                              : Icons.group_add_rounded,
                          color: colorPrincipal,
                          size: 16,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          principal ? "CREAR" : "INGRESAR",
                          style: TextStyle(
                            color: colorPrincipal,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(width: 3),

                        Icon(
                          Icons.arrow_forward_rounded,
                          color: colorPrincipal,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ANEXARSE
  // ============================================================

  void _dialogoAnexarse(BuildContext context) {
    controller.numeroOperativoController.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.55),
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.20),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF195BA6), Color(0xFF0B3F79)],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 58,
                          height: 48,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Image.asset(
                            _getImagenModulo(),
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(width: 11),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ANEXARSE A OPERATIVO",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Vinculación a servicio operativo",
                                style: TextStyle(
                                  color: Color(0xDFFFFFFF),
                                  fontSize: 9.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () => Navigator.pop(dialogContext),
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
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F6FB),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFDCE6F0)),
                          ),
                          child: const Text(
                            "Ingrese el número del operativo proporcionado por el servidor policial que realizó la apertura.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF55697E),
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: controller.numeroOperativoController,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(12),
                          ],
                          style: const TextStyle(
                            color: Color(0xFF173E65),
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                          decoration: InputDecoration(
                            hintText: "000000",
                            labelText: "NÚMERO DE OPERATIVO",
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            hintStyle: const TextStyle(
                              color: Color(0xFFB7C1CB),
                            ),
                            labelStyle: const TextStyle(
                              color: Color(0xFF195BA6),
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFD),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 17,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Color(0xFFD4E0EC),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Color(0xFF195BA6),
                                width: 1.7,
                              ),
                            ),
                          ),
                          onSubmitted: (_) {
                            _aceptarAnexarse(context, dialogContext);
                          },
                        ),
                        const SizedBox(height: 12),

                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();

                              Navigator.pop(dialogContext);

                              Future.delayed(
                                const Duration(milliseconds: 120),
                                () {
                                  if (context.mounted) {
                                    _dialogoEscanearQrOperativo(context);
                                  }
                                },
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF3FC),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFAFCBE4),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.qr_code_scanner_rounded,
                                    color: Color(0xFF195BA6),
                                    size: 21,
                                  ),

                                  SizedBox(width: 7),

                                  Text(
                                    "ESCANEAR CÓDIGO QR",
                                    style: TextStyle(
                                      color: Color(0xFF195BA6),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 9),
                        const SizedBox(height: 17),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(0, 49),
                                  side: const BorderSide(
                                    color: Color(0xFFCFDAE5),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  "CANCELAR",
                                  style: TextStyle(
                                    color: Color(0xFF66798D),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10.5,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _aceptarAnexarse(context, dialogContext);
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 49),
                                  elevation: 2,
                                  backgroundColor: const Color(0xFF195BA6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  "ANEXARSE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
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
          ),
        );
      },
    );
  }

  void _dialogoEscanearQrOperativo(BuildContext context) {
    bool codigoProcesado = false;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.70),
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 22,
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * .75,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(23),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Column(
                children: [
                  // ====================================================
                  // HEADER
                  // ====================================================

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
                          width: 41,
                          height: 41,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.qr_code_scanner_rounded,
                            color: Colors.white,
                            size: 23,
                          ),
                        ),

                        const SizedBox(width: 9),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ESCANEAR OPERATIVO",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),

                              SizedBox(height: 2),

                              Text(
                                "Apunte la cámara hacia el código QR",
                                style: TextStyle(
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

                            Future.delayed(
                              const Duration(milliseconds: 120),
                              () {
                                if (context.mounted) {
                                  _dialogoAnexarse(context);
                                }
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ====================================================
                  // ESCÁNER
                  // ====================================================
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        MobileScanner(
                          onDetect: (BarcodeCapture capture) async {
                            if (codigoProcesado) {
                              return;
                            }

                            if (capture.barcodes.isEmpty) {
                              return;
                            }

                            final String? codigo =
                                capture.barcodes.first.rawValue;

                            if (codigo == null || codigo.trim().isEmpty) {
                              return;
                            }

                            codigoProcesado = true;

                            try {
                              final int idHdrEvento =
                                  await OperativoQrUtil.desencriptarIdOperativo(
                                    codigo,
                                  );

                              if (Navigator.of(dialogContext).canPop()) {
                                Navigator.of(dialogContext).pop();
                              }

                              controller.numeroOperativoController.text =
                                  idHdrEvento.toString();

                              await Future.delayed(
                                const Duration(milliseconds: 150),
                              );

                              if (context.mounted) {
                                /*
                               * Reutilizamos la lógica actual:
                               * consulta backend, loading general,
                               * error cerrado/no existe y confirmación.
                               */
                                _consultarOperativoQr(context, idHdrEvento);
                              }
                            } catch (e) {
                              codigoProcesado = false;

                              DialogosAwesome.getError(
                                title: "QR NO VÁLIDO",
                                descripcion:
                                    "El código escaneado no corresponde a un operativo SIIPNE válido.",
                              );
                            }
                          },
                        ),

                        // ==================================================
                        // MARCO VISUAL
                        // ==================================================
                        Center(
                          child: IgnorePointer(
                            child: Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(11),
                    color: Colors.white,
                    child: const Row(
                      children: [
                        Icon(
                          Icons.security_rounded,
                          color: Color(0xFF198754),
                          size: 16,
                        ),

                        SizedBox(width: 6),

                        Expanded(
                          child: Text(
                            "El código contiene el identificador cifrado del operativo.",
                            style: TextStyle(
                              color: Color(0xFF607487),
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
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

  Future<void> _consultarOperativoQr(
    BuildContext context,
    int numeroOperativo,
  ) async {
    if (numeroOperativo <= 0) {
      return;
    }

    /*
   * El controller ya muestra el loading GENERAL
   * mediante peticionServerState.
   */
    final Anexarse? data = await controller.consultarOperativoAnexarse(
      numeroOperativo,
    );

    if (!context.mounted) {
      return;
    }

    if (data == null) {
      final String mensaje = controller.mensajeErrorAnexarse.trim();

      _dialogoErrorAnexarse(
        context,
        mensaje.isEmpty ? "No fue posible verificar el operativo." : mensaje,
      );

      return;
    }

    _dialogoConfirmarAnexarse(context, data);
  }

  Future<void> _aceptarAnexarse(
    BuildContext context,
    BuildContext dialogContext,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final String numero = controller.numeroOperativoController.text.trim();

    if (numero.isEmpty) {
      DialogosAwesome.getInformation(
        title: "Número requerido",
        descripcion: "Ingrese el número del operativo al que desea anexarse.",
        titleBtn: "Entendido",
      );
      return;
    }

    final int numeroOperativo = int.tryParse(numero) ?? 0;

    if (numeroOperativo <= 0) {
      DialogosAwesome.getInformation(
        title: "Número inválido",
        descripcion: "Ingrese un número de operativo válido.",
        titleBtn: "Entendido",
      );
      return;
    }

    // ============================================================
    // CERRAMOS EL DIÁLOGO PARA QUE SE VEA EL LOADING GENERAL
    // ============================================================

    if (dialogContext.mounted) {
      Navigator.pop(dialogContext);
    }

    /*
   * Únicamente permitimos que Flutter pinte nuevamente
   * la pantalla principal antes de iniciar la consulta.
   *
   * NO es un loading nuevo.
   */
    await Future.delayed(const Duration(milliseconds: 100));

    // ============================================================
    // CONSULTAR OPERATIVO
    //
    // Este método ya maneja:
    //
    // peticionServerState(true)
    // peticionServerState(false)
    //
    // por lo tanto aparecerá CargandoWidget general.
    // ============================================================

    final Anexarse? data = await controller.consultarOperativoAnexarse(
      numeroOperativo,
    );

    if (!context.mounted) {
      return;
    }

    // ============================================================
    // ERROR
    // ============================================================

    if (data == null) {
      final String mensaje = controller.mensajeErrorAnexarse.trim();

      _dialogoErrorAnexarse(
        context,
        mensaje.isEmpty ? "No fue posible verificar el operativo." : mensaje,
      );

      return;
    }

    // ============================================================
    // OPERATIVO CORRECTO
    // ============================================================

    _dialogoConfirmarAnexarse(context, data);
  }
  // ============================================================
  // DIÁLOGO CONFIRMAR ANEXARSE
  // ============================================================

  void _dialogoConfirmarAnexarse(BuildContext context, Anexarse data) {
    final String descripcion = data.descripcion.trim().isEmpty
        ? "OPERATIVO"
        : data.descripcion.trim().toUpperCase();

    final String policia = data.policia.trim().isEmpty
        ? "SERVIDOR NO REGISTRADO"
        : data.policia.trim();

    final String estado = data.estadoOperativo.trim().isEmpty
        ? "ACTIVO"
        : data.estadoOperativo.trim().toUpperCase();

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.62),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 20,
          ),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * .82,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(23),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.22),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ==================================================
                  // CABECERA
                  // ==================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(15, 12, 8, 12),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.group_add_rounded,
                            color: Colors.white,
                            size: 23,
                          ),
                        ),

                        const SizedBox(width: 10),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ANEXARSE AL OPERATIVO",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: .2,
                                ),
                              ),

                              SizedBox(height: 2),

                              Text(
                                "Verifique la información antes de continuar",
                                style: TextStyle(
                                  color: Color(0xDFFFFFFF),
                                  fontSize: 8.8,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 21,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ==================================================
                  // CONTENIDO
                  // ==================================================
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ==========================================
                          // OPERATIVO PRINCIPAL
                          // ==========================================

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFF0F6FC), Colors.white],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFD3E1EF),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF195BA6),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.local_police_rounded,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),

                                const SizedBox(width: 11),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "NÚMERO DE OPERATIVO",
                                        style: TextStyle(
                                          color: Color(0xFF8493A3),
                                          fontSize: 7.8,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: .5,
                                        ),
                                      ),

                                      const SizedBox(height: 1),

                                      Text(
                                        "#${data.idHdrEvento}",
                                        style: const TextStyle(
                                          color: Color(0xFF173E65),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: .5,
                                        ),
                                      ),

                                      const SizedBox(height: 2),

                                      Text(
                                        descripcion,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFF586C80),
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE5F6ED),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFB9E1CA),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Color(0xFF198754),
                                        size: 13,
                                      ),

                                      const SizedBox(width: 4),

                                      Text(
                                        estado,
                                        style: const TextStyle(
                                          color: Color(0xFF198754),
                                          fontSize: 7.5,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ==========================================
                          // SERVIDOR
                          // ==========================================
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFD),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: const Color(0xFFE1E8F0),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF2FC),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.badge_outlined,
                                    color: Color(0xFF195BA6),
                                    size: 18,
                                  ),
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "SERVIDOR QUE APERTURÓ",
                                        style: TextStyle(
                                          color: Color(0xFF8794A2),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),

                                      const SizedBox(height: 2),

                                      Text(
                                        policia,
                                        style: const TextStyle(
                                          color: Color(0xFF31475C),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ==========================================
                          // FECHA
                          // ==========================================
                          _filaAnexarseCompacta(
                            icono: Icons.calendar_month_rounded,
                            titulo: "FECHA DE APERTURA",
                            valor: data.fechaEvento,
                          ),
                          const SizedBox(height: 6),
                          // ==========================================
                          // UBICACIÓN
                          // ==========================================
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFD),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: const Color(0xFFE1E8F0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Color(0xFF195BA6),
                                      size: 16,
                                    ),

                                    SizedBox(width: 5),

                                    Text(
                                      "UBICACIÓN OPERATIVA",
                                      style: TextStyle(
                                        color: Color(0xFF40566B),
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 7),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _miniDatoAnexarse(
                                        titulo: "ZONA",
                                        valor: data.zona,
                                      ),
                                    ),

                                    const SizedBox(width: 6),

                                    Expanded(
                                      child: _miniDatoAnexarse(
                                        titulo: "SUBZONA",
                                        valor: data.subzona,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                _miniDatoAnexarse(
                                  titulo: "DISTRITO",
                                  valor: data.distrito,
                                ),

                                const SizedBox(height: 6),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _miniDatoAnexarse(
                                        titulo: "CIRCUITO",
                                        valor: data.circuito,
                                      ),
                                    ),

                                    const SizedBox(width: 6),

                                    Expanded(
                                      child: _miniDatoAnexarse(
                                        titulo: "SUBCIRCUITO",
                                        valor: data.subcircuito,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ==========================================
                          // MENSAJE
                          // ==========================================
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF7F0),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  color: Color(0xFF198754),
                                  size: 18,
                                ),

                                SizedBox(width: 7),

                                Expanded(
                                  child: Text(
                                    "Operativo verificado y disponible para anexarse.",
                                    style: TextStyle(
                                      color: Color(0xFF397256),
                                      fontSize: 8.8,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ==========================================
                          // BOTONES
                          // ==========================================
                          Row(
                            children: [
                              // ==========================================================
                              // VOLVER
                              // ==========================================================

                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);

                                    Future.delayed(
                                      const Duration(milliseconds: 120),
                                      () {
                                        if (context.mounted) {
                                          _dialogoAnexarse(context);
                                        }
                                      },
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(0, 48),
                                    foregroundColor: const Color(0xFF65788B),
                                    side: const BorderSide(
                                      color: Color(0xFFCDD8E3),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                  ),
                                  child: const Text(
                                    "VOLVER",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              // ==========================================================
                              // ANEXARSE Y CONTINUAR
                              // ==========================================================
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _confirmarAnexarseConLoading(
                                      dialogContext,
                                      data,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.group_add_rounded,
                                    size: 17,
                                  ),
                                  label: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "ANEXARSE Y CONTINUAR",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 9.3,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(0, 48),
                                    backgroundColor: const Color(0xFF198754),
                                    foregroundColor: Colors.white,
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Future<void> _confirmarAnexarseConLoading(
    BuildContext dialogContext,
    Anexarse data,
  ) async {
    /*
   * Evitamos doble toque.
   */
    if (controller.peticionServerState.value) {
      return;
    }

    if (dialogContext.mounted) {
      Navigator.pop(dialogContext);
    }
    controller.peticionServerState(true);

    await Future.delayed(const Duration(milliseconds: 120));

    // ============================================================
    // CONTINUAR
    // ============================================================

    controller.anexarseOperativo(data);
  }
  // ============================================================
  // DIÁLOGO ERROR ANEXARSE
  // ============================================================

  void _dialogoErrorAnexarse(BuildContext context, String mensaje) {
    final String texto = mensaje.trim().isEmpty
        ? "No fue posible verificar el operativo."
        : mensaje.trim();

    final String textoUpper = texto.toUpperCase();

    final bool cerrado = textoUpper.contains('CERRADO');
    final bool noExiste = textoUpper.contains('NO EXISTE');

    final String titulo = cerrado
        ? "OPERATIVO CERRADO"
        : noExiste
        ? "OPERATIVO NO ENCONTRADO"
        : "OPERATIVO NO DISPONIBLE";

    final IconData icono = cerrado
        ? Icons.lock_outline_rounded
        : noExiste
        ? Icons.search_off_rounded
        : Icons.warning_amber_rounded;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.60),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 26,
            vertical: 24,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.20),
                  blurRadius: 26,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEA),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icono, color: const Color(0xFFB42318), size: 31),
                ),

                const SizedBox(height: 12),

                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF293D52),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .2,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  texto,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF68798A),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: const Color(0xFFE2E8EF)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF718295),
                        size: 17,
                      ),

                      const SizedBox(width: 7),

                      Expanded(
                        child: Text(
                          cerrado
                              ? "Este operativo ya fue cerrado y no permite anexar nuevos servidores policiales."
                              : noExiste
                              ? "Verifique que el número del operativo sea correcto e intente nuevamente."
                              : "El operativo no se encuentra disponible para anexarse en este momento.",
                          style: const TextStyle(
                            color: Color(0xFF657789),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text(
                      "INTENTAR NUEVAMENTE",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      backgroundColor: const Color(0xFF195BA6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filaAnexarseCompacta({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    final String dato = valor.trim().isEmpty ? "NO REGISTRADO" : valor.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E8F0)),
      ),
      child: Row(
        children: [
          Icon(icono, color: const Color(0xFF195BA6), size: 17),

          const SizedBox(width: 7),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF8794A2),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  dato,
                  style: const TextStyle(
                    color: Color(0xFF31475C),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniDatoAnexarse({required String titulo, required String valor}) {
    final String dato = valor.trim().isEmpty ? "NO REGISTRADO" : valor.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E9EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: Color(0xFF929EAA),
              fontSize: 6.8,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 1),

          Text(
            dato,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF40566B),
              fontSize: 8.6,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
  // ============================================================
  // DATO DEL OPERATIVO
  // ============================================================

  Widget _datoAnexarseDialogo({
    required String titulo,
    required String valor,
    required IconData icono,
  }) {
    final String dato = valor.trim().isEmpty ? "NO REGISTRADO" : valor.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E7EF)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FB),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icono, size: 17, color: const Color(0xFF195BA6)),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: Color(0xFF8593A0),
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    dato,
                    style: const TextStyle(
                      color: Color(0xFF32495E),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ABRIR OPERATIVO
  // ============================================================

  void _dialogoAbrirOperativo(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.55),
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 22,
          ),
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * .82,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.22),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(15, 13, 9, 13),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF195BA6), Color(0xFF0B3F79)],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            padding: const EdgeInsets.all(4),

                            child: Image.asset(
                              _getImagenModulo(),
                              fit: BoxFit.fill,
                            ),
                          ),

                          const SizedBox(width: 10),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ABRIR OPERATIVO",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Configuración del servicio policial",
                                  style: TextStyle(
                                    color: Color(0xDFFFFFFF),
                                    fontSize: 9.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Flexible(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F6FB),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFD9E5F0),
                                ),
                              ),
                              child: const Text(
                                "Configure progresivamente el tipo de servicio. Las opciones siguientes aparecerán automáticamente según su selección.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF53677C),
                                  fontSize: 10.5,
                                  height: 1.35,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            getCombosTipoOperativos(),

                            const SizedBox(height: 14),

                            Obx(() {
                              if (!controller.showContinuar.value) {
                                return const SizedBox.shrink();
                              }

                              return Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () {
                                    Navigator.pop(dialogContext);

                                    Future.delayed(
                                      const Duration(milliseconds: 150),
                                      () => _dialogoConfirmarCreacion(context),
                                    );
                                  },
                                  child: Ink(
                                    width: double.infinity,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF195BA6),
                                          Color(0xFF0B3F79),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "CONFIRMAR Y ABRIR OPERATIVO",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: .4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // COMBOS
  // ============================================================

  Widget getCombosTipoOperativos() {
    return Obx(() {
      controller.rutaSeleccionada.length;
      controller.listTipoOperativos.length;

      if (controller.listTipoOperativos.isEmpty) {
        return const SizedBox.shrink();
      }

      /*
     * Debe existir el NIVEL 1 automático.
     */
      if (controller.rutaSeleccionada.isEmpty) {
        return const SizedBox.shrink();
      }

      final List<Widget> combos = [];

      /*
     * rutaSeleccionada ya contiene inicialmente:
     *
     * [0] = PADRE AUTOMÁTICO
     */
      int cantidadNiveles = controller.rutaSeleccionada.length;

      final DataTipoOperativo ultimo = controller.rutaSeleccionada.last;

      /*
     * Si el último tiene hijos, mostramos
     * un combo adicional para seleccionar el siguiente nivel.
     */
      if (controller.tieneHijos(ultimo.idGenTipoTipificacion)) {
        cantidadNiveles++;
      }

      /*
     * MUY IMPORTANTE:
     *
     * Comenzamos desde 1.
     *
     * nivel 0 → automático → oculto.
     * nivel 1 → NIVEL 2.
     * nivel 2 → NIVEL 3.
     */
      for (int nivel = 1; nivel < cantidadNiveles; nivel++) {
        final List<DataTipoOperativo> datos = controller.getDatosNivel(nivel);

        if (datos.isEmpty) {
          continue;
        }

        combos.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: ComboBusqueda<DataTipoOperativo>(
              key: ValueKey('tipo_operativo_nivel_$nivel'),

              icon: Icons.shield_outlined,

              datos: datos,

              selectValue: controller.getSeleccionNivel(nivel),

              showClearButton: true,

              /*
             * nivel interno 1 = NIVEL 2 visible.
             */
              searchHint: (nivel == 1 ? "TIPO DE OPERATIVO" : "OPERATIVO"),

              textSeleccioneUndato: "Seleccione una opción",

              displayField: (item) => item.descripcion,

              complete: (item) {
                if (item == null) {
                  controller.limpiarDesdeNivel(nivel);
                  return;
                }

                controller.seleccionarTipoOperativo(nivel, item);
              },
            ),
          ),
        );
      }

      if (combos.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(mainAxisSize: MainAxisSize.min, children: combos);
    });
  }
  // ============================================================
  // IMAGEN DEL MÓDULO
  // ============================================================

  String _getImagenModulo() {

    final String titulo = _normalizarTexto(
      controller.dataModuloResponse.descripcion,
    );
    print("titolooooo---"+titulo);
    if (titulo.contains('MOVILES OPERATIVOS PREVENTIVOS')) {
      return AppSiipneMovilImages.img_modulos_dgo;
    }

    if (titulo.contains('MOVILES TRANSITO')) {
      return AppSiipneMovilImages.img_modulos_transito;
    }

    if (titulo.contains('MOVIL METRO')) {
      return AppSiipneMovilImages.img_modulos_metro;
    }

    if (titulo.contains('MOVIL MIGRACION')) {
      return AppSiipneMovilImages.icon_Migracion;
    }
    return AppImages.iconNoImg;
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

  void _dialogoConfirmarCreacion(BuildContext context) {
    final DataTipoOperativo operativo = controller.selectTipoOperativo.value;

    final String descripcion = operativo.descripcion.trim().isNotEmpty
        ? operativo.descripcion.trim().toUpperCase()
        : "OPERATIVO SELECCIONADO";

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.60),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ==================================================
                  // CABECERA
                  // ==================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(17, 16, 12, 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            _getImagenModulo(),
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Image.asset(
                              AppImages.iconNoImg,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(width: 11),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CONFIRMAR OPERATIVO",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: .3,
                                ),
                              ),

                              SizedBox(height: 3),

                              Text(
                                "Verifique la información antes de continuar",
                                style: TextStyle(
                                  color: Color(0xDFFFFFFF),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ==================================================
                  // CONTENIDO
                  // ==================================================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(17, 18, 17, 17),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF3FC),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: const Color(0xFFD4E4F3)),
                          ),
                          child: const Icon(
                            Icons.help_outline_rounded,
                            color: Color(0xFF195BA6),
                            size: 37,
                          ),
                        ),

                        const SizedBox(height: 13),

                        const Text(
                          "¿ESTÁ SEGURO?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF20394F),
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .4,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "Se creará un nuevo operativo con la siguiente configuración:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF718194),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ==============================================
                        // OPERATIVO SELECCIONADO
                        // ==============================================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFF2F7FC), Color(0xFFFFFFFF)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFCBDCEB)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 43,
                                height: 43,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF195BA6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.local_police_rounded,
                                  color: Colors.white,
                                  size: 23,
                                ),
                              ),

                              const SizedBox(width: 11),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "TIPO DE OPERATIVO",
                                      style: TextStyle(
                                        color: Color(0xFF7D8D9E),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: .6,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      descripcion,
                                      softWrap: true,
                                      style: const TextStyle(
                                        color: Color(0xFF193B5B),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        height: 1.18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 7),

                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE1F4EB),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Color(0xFF15955B),
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ==============================================
                        // MENSAJE IMPORTANTE
                        // ==============================================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E8),
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: const Color(0xFFF2D899)),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFFB57900),
                                size: 19,
                              ),

                              SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  "Una vez confirmado, se registrará la apertura del operativo y se iniciará el servicio.",
                                  style: TextStyle(
                                    color: Color(0xFF755A18),
                                    fontSize: 9.8,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 17),

                        // ==============================================
                        // BOTONES
                        // ==============================================
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(0, 52),
                                  foregroundColor: const Color(0xFF63768A),
                                  side: const BorderSide(
                                    color: Color(0xFFCAD6E2),
                                    width: 1.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  "CANCELAR",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: .3,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 9),

                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () {
                                    Navigator.pop(dialogContext);

                                    Future.delayed(
                                      const Duration(milliseconds: 100),
                                      () {
                                        controller.crearOperativo();
                                      },
                                    );
                                  },
                                  child: Ink(
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF195BA6),
                                          Color(0xFF0A3D7E),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF195BA6,
                                          ).withOpacity(.22),
                                          blurRadius: 9,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),

                                        SizedBox(width: 5),

                                        Flexible(
                                          child: Text(
                                            "SÍ, CREAR OPERATIVO",
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: .2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
          ),
        );
      },
    );
  }
}
