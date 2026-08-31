part of '../custom_app_widgets.dart';

class DialogosAwesome {
  static bool isDiaslogoShow = false;
  static Color colorWarning = const Color(0xFFF2B705);
  static Color colorInformacion = AppColors.colorAzul;
  static Color colorError = const Color(0xFFEA4236);
  static Color colorSucess = const Color(0xFF10C26E);

  static String imgDefault = AppImages.escudopolicia;

  // Ancho común para todos los diálogos: más amplio en teléfonos y
  // controlado en pantallas grandes para conservar una buena lectura.
  static double _anchoDialogo(BuildContext context) {
    return (MediaQuery.of(context).size.width - 12)
        .clamp(0.0, 720.0)
        .toDouble();
  }

  // Paleta institucional de alto contraste.
  static const Color _fondoTecnico = Color(0xFF071E35);
  static const Color _fondoCard = Color(0xFFF4F8FC);
  static const Color _textoPrincipal = Color(0xFF12263A);
  static const Color _textoSecundario = Color(0xFF52687D);
  static const Color _bordeTecnico = Color(0xFFC6D7E6);
  static const Color _azulNeon = Color(0xFF28B7F5);
  static const Color _azulInstitucional = Color(0xFF124E8C);
  static const Color _azulProfundo = Color(0xFF061C35);
  static const Color _azulPanel = Color(0xFF0A3158);
  static const Color _grisInstitucional = Color(0xFF64788B);

  static IconData _iconoEstado(Color color) {
    if (color == colorError) return Icons.report_gmailerrorred_rounded;
    if (color == colorWarning) return Icons.warning_amber_rounded;
    if (color == colorSucess) return Icons.task_alt_rounded;
    return Icons.info_outline_rounded;
  }

  static String _codigoEstado(Color color) {
    if (color == colorError) return 'ALERTA DEL SISTEMA';
    if (color == colorWarning) return 'ADVERTENCIA OPERATIVA';
    if (color == colorSucess) return 'OPERACIÓN COMPLETADA';
    return 'INFORMACIÓN INSTITUCIONAL';
  }

  static String _tituloDetalleEstado(Color color) {
    if (color == colorError) return 'DETALLE DEL INCIDENTE';
    if (color == colorWarning) return 'ACCIÓN QUE REQUIERE ATENCIÓN';
    if (color == colorSucess) return 'RESULTADO DE LA OPERACIÓN';
    return 'DETALLE DE LA INFORMACIÓN';
  }

  static Widget _textoMensaje(String descripcion) {
    return Text(
      descripcion.trim(),
      textAlign: TextAlign.justify,
      style: const TextStyle(
        color: _textoPrincipal,
        fontSize: 12.2,
        height: 1.48,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static Widget _botonAccionTecnico({
    required String titulo,
    required IconData icono,
    required Color color,
    required VoidCallback onPressed,
    String? subtitulo,
    bool secundario = false,
  }) {
    final bool usarTextoOscuro = !secundario && color.computeLuminance() > .45;
    final Color texto = secundario
        ? color
        : usarTextoOscuro
        ? _azulProfundo
        : Colors.white;
    final Color colorFinal = Color.lerp(color, _azulProfundo, .30)!;

    return Semantics(
      button: true,
      label: titulo,
      child: Container(
        height: subtitulo == null ? 54 : 60,
        decoration: BoxDecoration(
          color: secundario ? Colors.white : null,
          gradient: secundario
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[color, colorFinal],
                ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: secundario ? color.withOpacity(.38) : color.withOpacity(.90),
            width: secundario ? 1.1 : 1,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: secundario
                  ? _azulProfundo.withOpacity(.06)
                  : color.withOpacity(.28),
              blurRadius: secundario ? 8 : 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: secundario
                          ? color.withOpacity(.09)
                          : Colors.white.withOpacity(.14),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: secundario
                            ? color.withOpacity(.16)
                            : Colors.white.withOpacity(.20),
                      ),
                    ),
                    child: Icon(icono, color: texto, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            titulo.toUpperCase(),
                            maxLines: 1,
                            style: TextStyle(
                              color: texto,
                              fontSize: 9.8,
                              letterSpacing: .30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (subtitulo != null) ...<Widget>[
                          const SizedBox(height: 2),
                          Text(
                            subtitulo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: secundario
                                  ? _textoSecundario
                                  : Colors.white.withOpacity(.76),
                              fontSize: 7.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    secundario
                        ? Icons.keyboard_return_rounded
                        : Icons.arrow_forward_rounded,
                    color: texto.withOpacity(.78),
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _cabeceraTecnica({
    required Color color,
    String imgString = AppImages.escudopolicia,
    IconData icono = Icons.shield_outlined,
  }) {
    return SizedBox(
      width: 58,
      height: 58,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: 54,
            height: 54,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.96),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(.65)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(.16),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Image.asset(imgString, fit: BoxFit.contain),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: _azulProfundo, width: 2),
                boxShadow: <BoxShadow>[
                  BoxShadow(color: color.withOpacity(.45), blurRadius: 8),
                ],
              ),
              child: Icon(icono, color: Colors.white, size: 12),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _encabezadoDialogo({
    required String title,
    required Color color,
    String codigo = 'SIIPNE // CONTROL OPERATIVO',
    String imgString = AppImages.escudopolicia,
    IconData? iconoEstado,
  }) {
    final bool esTemaRojo = color == colorError;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 13, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: esTemaRojo
              ? const <Color>[
                  Color(0xFF35070C),
                  Color(0xFF78111C),
                  Color(0xFFB51F2E),
                ]
              : <Color>[
                  Color.lerp(_azulProfundo, color, .18)!,
                  _azulPanel,
                  Color.lerp(_azulPanel, color, .42)!,
                ],
        ),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: esTemaRojo
              ? const Color(0xFFFF98A2).withOpacity(.68)
              : _azulNeon.withOpacity(.32),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: esTemaRojo
                ? colorError.withOpacity(.34)
                : _azulProfundo.withOpacity(.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -8,
            top: -13,
            child: Icon(
              Icons.radar_rounded,
              color: Colors.white.withOpacity(.045),
              size: 92,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _cabeceraTecnica(
                color: color,
                imgString: imgString,
                icono: iconoEstado ?? _iconoEstado(color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'POLICÍA NACIONAL  //  SIIPNE',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF9EDFFF),
                        fontSize: 7.8,
                        letterSpacing: .85,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.5,
                        height: 1.10,
                        letterSpacing: -.15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withOpacity(.58)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: color, blurRadius: 6),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              codigo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 7.3,
                                letterSpacing: .38,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  static Widget _cardInformativa({
    required Widget child,
    required Color color,
    IconData icono = Icons.data_object_rounded,
    String? etiqueta,
    EdgeInsetsGeometry padding = const EdgeInsets.all(12),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: _fondoCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _bordeTecnico.withOpacity(.82)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: _azulProfundo.withOpacity(.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                boxShadow: <BoxShadow>[
                  BoxShadow(color: color.withOpacity(.38), blurRadius: 7),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(.10),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: color.withOpacity(.22)),
              ),
              child: Icon(icono, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    etiqueta ?? _tituloDetalleEstado(color),
                    style: TextStyle(
                      color: Color.lerp(color, _azulProfundo, .16),
                      fontSize: 8.2,
                      letterSpacing: .55,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DefaultTextStyle.merge(
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: _textoPrincipal,
                      fontSize: 12,
                      height: 1.46,
                      fontWeight: FontWeight.w600,
                    ),
                    child: child,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _fondoDialogo({required Widget child, Color? color}) {
    final Color tono = color ?? colorInformacion;
    final bool esTemaRojo = tono == colorError;
    final Color fondoInicio = esTemaRojo
        ? const Color(0xFF29070B)
        : Color.lerp(_fondoTecnico, tono, .10)!;
    final Color fondoFin = esTemaRojo
        ? const Color(0xFF510C14)
        : Color.lerp(_azulProfundo, tono, .20)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(1.2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: esTemaRojo
              ? <Color>[
                  colorError,
                  const Color(0xFF7E101B),
                  const Color(0xFFFF7C88),
                ]
              : <Color>[tono, tono.withOpacity(.45), _azulNeon],
        ),
        borderRadius: BorderRadius.circular(23),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: esTemaRojo
                ? colorError.withOpacity(.30)
                : _azulProfundo.withOpacity(.24),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 13, 15, 11),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[fondoInicio, fondoFin],
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            child,
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.lock_outline_rounded,
                  color: esTemaRojo
                      ? const Color(0xFFFFCDD2)
                      : const Color(0xFFAFC8DC),
                  size: 11,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    'CANAL SEGURO  ·  REGISTRO AUDITABLE',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: esTemaRojo
                          ? const Color(0xFFFFCDD2)
                          : const Color(0xFFAFC8DC),
                      fontSize: 7,
                      letterSpacing: .38,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static showIconPolicia({
    bool mostrarSegungoBtn = true,
    Color colorBtnSi = AppColors.colorBotones,
    Color colorTitle = AppColors.colorAzul,
    Color colorCircleImg = AppColors.colorAzul,
    String imgString = AppImages.escudopolicia,
    required String title,
    IconData iconBtnSi = Icons.check_circle_outline,
    IconData iconBtnNo = Icons.cancel_outlined,
    String titleBtnSi = 'Aceptar',
    String titleBtnNo = 'Cancelar',
    required String descripcion,
    required Function() btnOkOnPress,
    Function()? btnCancelOnPress,
  }) {
    return _getIconPolicia(
      mostrarSegungoBtn: mostrarSegungoBtn,
      colorBtnSi: colorBtnSi,
      colorTitle: colorTitle,
      colorCircleImg: colorCircleImg,
      imgString: imgString,
      title: title,
      iconBtnSi: iconBtnSi,
      iconBtnNo: iconBtnNo,
      titleBtnSi: titleBtnSi,
      titleBtnNo: titleBtnNo,
      descripcion: descripcion,
      btnOkOnPress: btnOkOnPress,
      btnCancelOnPress: btnCancelOnPress,
    );
  }

  static _getIconPolicia({
    bool mostrarSegungoBtn = true,
    Color colorBtnSi = AppColors.colorBotones,
    Color colorTitle = AppColors.colorAzul,
    Color colorCircleImg = AppColors.colorAzul,
    String imgString = AppImages.escudopolicia,
    required String title,
    IconData iconBtnSi = Icons.check_circle_outline,
    IconData iconBtnNo = Icons.cancel_outlined,
    String titleBtnSi = 'Aceptar',
    String titleBtnNo = 'Cancelar',
    required String descripcion,
    required Function() btnOkOnPress,
    Function()? btnCancelOnPress,
    String? codigoEstado,
    String? etiquetaDetalle,
    IconData? iconoEstado,
  }) {
    if (isDiaslogoShow) return;

    isDiaslogoShow = true;

    _DialogoAmplio(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      context: Get.context!,
      width: _anchoDialogo(Get.context!),
      dialogType: DialogType.noHeader,
      headerAnimationLoop: false,
      animType: AnimType.scale,
      dialogBackgroundColor: Colors.transparent,
      barrierColor: _azulProfundo.withOpacity(.82),
      body: SingleChildScrollView(
        child: _fondoDialogo(
          color: colorCircleImg,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _encabezadoDialogo(
                title: title,
                color: colorTitle,
                codigo: codigoEstado ?? _codigoEstado(colorCircleImg),
                imgString: imgString,
                iconoEstado: iconoEstado,
              ),
              const SizedBox(height: 12),
              _cardInformativa(
                color: colorCircleImg,
                icono: iconoEstado ?? _iconoEstado(colorCircleImg),
                etiqueta: etiquetaDetalle,
                child: _textoMensaje(descripcion),
              ),
              const SizedBox(height: 15),
              if (!mostrarSegungoBtn)
                _botonAccionTecnico(
                  titulo: titleBtnSi,
                  icono: iconBtnSi,
                  color: colorBtnSi,
                  onPressed: () {
                    isDiaslogoShow = false;
                    Get.back();
                    Future.delayed(
                      const Duration(milliseconds: 100),
                      btnOkOnPress,
                    );
                  },
                )
              else
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _botonAccionTecnico(
                        titulo: titleBtnNo,
                        icono: iconBtnNo,
                        color: _grisInstitucional,
                        secundario: true,
                        onPressed: () {
                          isDiaslogoShow = false;
                          Get.back();

                          if (btnCancelOnPress != null) {
                            Future.delayed(
                              const Duration(milliseconds: 100),
                              btnCancelOnPress,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _botonAccionTecnico(
                        titulo: titleBtnSi,
                        icono: iconBtnSi,
                        color: colorBtnSi,
                        onPressed: () {
                          isDiaslogoShow = false;
                          Get.back();
                          Future.delayed(
                            const Duration(milliseconds: 100),
                            btnOkOnPress,
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    ).show();
  }

  // ============================================================
  // WARNING
  // ============================================================

  static getWarning({
    String title = 'ADVERTENCIA',
    String titleBtnOk = 'Ok',
    required String descripcion,
    Function()? btnOkOnPress,
  }) {
    return _getIconPolicia(
      colorBtnSi: colorWarning,
      colorCircleImg: colorWarning,
      colorTitle: colorWarning,
      title: title,
      descripcion: descripcion,
      btnOkOnPress: btnOkOnPress ?? () {},
      titleBtnSi: titleBtnOk,
      mostrarSegungoBtn: false,
      codigoEstado: 'SIIPNE // ADVERTENCIA OPERATIVA',
      etiquetaDetalle: 'INFORMACIÓN QUE REQUIERE ATENCIÓN',
      iconoEstado: Icons.warning_amber_rounded,
    );
  }

  static getWarningSiNo({
    String title = 'CONFIRMACIÓN',
    required String descripcion,
    Function()? btnOkOnPress,
    Function()? btnCancelOnPress,
    Color? colorAccion,
    IconData? iconoAccion,
    String? codigoEstado,
    String? etiquetaDetalle,
  }) {
    final Color colorConfirmacion = colorAccion ?? _azulInstitucional;

    return _getIconPolicia(
      colorBtnSi: colorConfirmacion,
      colorCircleImg: colorConfirmacion,
      colorTitle: colorConfirmacion,
      title: title,
      descripcion: descripcion,
      btnOkOnPress: btnOkOnPress ?? () {},
      titleBtnSi: "SÍ",
      mostrarSegungoBtn: true,
      titleBtnNo: "NO",
      btnCancelOnPress: btnCancelOnPress ?? () {},
      codigoEstado: codigoEstado ?? 'SIIPNE MÓVIL // CONFIRMACIÓN',
      etiquetaDetalle: etiquetaDetalle ?? 'DECISIÓN DE CONTINUIDAD',
      iconoEstado: iconoAccion ?? Icons.help_outline_rounded,
    );
  }

  // ============================================================
  // WARNING CON CONTADOR
  // ============================================================

  static getWarningSiNoContador({
    String title = 'CONFIRMACIÓN CONTROLADA',
    required String descripcion,
    Function()? btnOkOnPress,
    Function()? btnCancelOnPress,
  }) {
    int segundos = 5;
    bool botonesHabilitados = false;
    Timer? timer;

    late _DialogoAmplio dialog;

    dialog = _DialogoAmplio(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      context: Get.context!,
      width: _anchoDialogo(Get.context!),
      dialogType: DialogType.noHeader,
      headerAnimationLoop: false,
      animType: AnimType.scale,
      dialogBackgroundColor: Colors.transparent,
      barrierColor: _azulProfundo.withOpacity(.82),
      body: StatefulBuilder(
        builder: (context, setState) {
          timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
            if (segundos > 1) {
              setState(() => segundos--);
            } else {
              setState(() {
                segundos = 0;
                botonesHabilitados = true;
              });
              t.cancel();
            }
          });

          return _fondoDialogo(
            color: _grisInstitucional,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _encabezadoDialogo(
                  title: title,
                  color: _grisInstitucional,
                  codigo: 'SIIPNE MÓVIL // VALIDACIÓN TEMPORIZADA',
                  iconoEstado: Icons.timer_outlined,
                ),
                const SizedBox(height: 12),
                _cardInformativa(
                  color: _grisInstitucional,
                  icono: Icons.hourglass_top_rounded,
                  etiqueta: 'TIEMPO DE VERIFICACIÓN ACTIVO',
                  child: _textoMensaje(descripcion),
                ),
                const SizedBox(height: 13),
                if (!botonesHabilitados)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color.lerp(_azulProfundo, _grisInstitucional, .22)!,
                          Color.lerp(_azulPanel, _grisInstitucional, .42)!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _grisInstitucional.withOpacity(.72),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: _azulProfundo.withOpacity(.18),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 27,
                          height: 27,
                          child: CircularProgressIndicator(
                            value: (5 - segundos) / 5,
                            strokeWidth: 3,
                            backgroundColor: Colors.white.withOpacity(.18),
                            color: _azulNeon,
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'PROTOCOLO DE SEGURIDAD ACTIVO',
                                style: TextStyle(
                                  color: Color(0xFFD9E4EC),
                                  fontSize: 8.2,
                                  letterSpacing: .55,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Habilitando acciones en $segundos segundos...',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (botonesHabilitados)
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _botonAccionTecnico(
                          titulo: 'NO',
                          icono: Icons.close_rounded,
                          color: _grisInstitucional,
                          secundario: true,
                          onPressed: () {
                            timer?.cancel();
                            dialog.dismiss();

                            Future.delayed(
                              const Duration(milliseconds: 100),
                              () => btnCancelOnPress?.call(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: _botonAccionTecnico(
                          titulo: 'SÍ, CONTINUAR',
                          icono: Icons.verified_rounded,
                          color: _azulInstitucional,
                          onPressed: () {
                            timer?.cancel();
                            dialog.dismiss();

                            Future.delayed(
                              const Duration(milliseconds: 100),
                              () => btnOkOnPress?.call(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );

    dialog.show();
  }

  // ============================================================
  // ERROR
  // ============================================================

  static getError({
    String title = 'ERROR',
    required String descripcion,
    Function()? btnOkOnPress,
  }) {
    return _getIconPolicia(
      colorBtnSi: colorError,
      colorCircleImg: colorError,
      colorTitle: colorError,
      title: title,
      descripcion: descripcion,
      btnOkOnPress: btnOkOnPress ?? () {},
      titleBtnSi: "ACEPTAR",
      mostrarSegungoBtn: false,
      codigoEstado: 'SIIPNE // ALERTA DEL SISTEMA',
      etiquetaDetalle: 'DETALLE DE LA ALERTA',
      iconoEstado: Icons.gpp_bad_rounded,
    );
  }

  // ============================================================
  // SUCCESS
  // ============================================================

  static getSucess({
    String title = 'ÉXITO',
    required String descripcion,
    Function()? btnOkOnPress,
  }) {
    return _getIconPolicia(
      colorBtnSi: colorSucess,
      colorCircleImg: colorSucess,
      colorTitle: colorSucess,
      title: title,
      descripcion: descripcion,
      btnOkOnPress: btnOkOnPress ?? () {},
      titleBtnSi: "ACEPTAR",
      mostrarSegungoBtn: false,
      codigoEstado: 'SIIPNE // OPERACIÓN COMPLETADA',
      etiquetaDetalle: 'RESULTADO REGISTRADO CORRECTAMENTE',
      iconoEstado: Icons.task_alt_rounded,
    );
  }

  // ============================================================
  // INFORMATION
  // ============================================================

  static getInformation({
    String title = 'INFORMACIÓN',
    String titleBtn = 'Ok',
    required String descripcion,
    Function()? btnOkOnPress,
  }) {
    return _getIconPolicia(
      colorBtnSi: colorInformacion,
      colorCircleImg: colorInformacion,
      colorTitle: colorInformacion,
      title: title,
      descripcion: descripcion,
      btnOkOnPress: btnOkOnPress ?? () {},
      titleBtnSi: titleBtn,
      mostrarSegungoBtn: false,
      codigoEstado: 'SIIPNE // INFORMACIÓN INSTITUCIONAL',
      etiquetaDetalle: 'DETALLE DE LA INFORMACIÓN',
      iconoEstado: Icons.info_outline_rounded,
    );
  }

  static getInformationSiNo({
    String title = 'CONFIRMACIÓN',
    required String descripcion,
    Function()? btnOkOnPress,
    Function()? btnCancelOnPress,
  }) {
    return _getIconPolicia(
      colorBtnSi: colorSucess,
      colorCircleImg: colorSucess,
      colorTitle: colorSucess,
      title: title,
      descripcion: descripcion,
      btnOkOnPress: btnOkOnPress ?? () {},
      titleBtnNo: "NO",
      titleBtnSi: "SÍ",
      mostrarSegungoBtn: true,
      btnCancelOnPress: btnCancelOnPress ?? () {},
      codigoEstado: 'SIIPNE // CONFIRMACIÓN DE INFORMACIÓN',
      etiquetaDetalle: 'CONFIRMACIÓN REQUERIDA',
      iconoEstado: Icons.fact_check_rounded,
    );
  }

  // ============================================================
  // CLAVE + BIOMETRÍA
  //
  // Mantiene el comportamiento existente:
  // loginController.validarPass(pass)
  //
  // y permite opcionalmente biometría.
  // ============================================================

  static getDesingChangePass({
    required GlobalKey<FormState> formKey,
    required TextEditingController controllerPass,
    VoidCallback? onPressed,
    String title = 'INFO',
    required int idDgoCreaOpReci,
    String? descripcion,
    bool mostrarBiometria = false,
    Future<bool> Function()? onBiometria,
    String textoConfirmacion = '¿Está seguro de continuar?',
  }) {
    final ResponsiveUtil responsive = ResponsiveUtil();
    final double sizeTxt = responsive.diagonalP(AppConfig.tamTextoTitulo);

    descripcion ??=
        "Para abandonar el código $idDgoCreaOpReci, ingrese su clave de seguridad";

    void abrirDialogo() {
      late _DialogoAmplio dialog;

      void confirmar() {
        Future.delayed(const Duration(milliseconds: 150), () {
          DialogosAwesome.getWarningSiNo(
            title: "CONFIRMACIÓN",
            descripcion: textoConfirmacion,
            btnOkOnPress: () {
              onPressed?.call();
            },
          );
        });
      }

      dialog = _DialogoAmplio(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        width: _anchoDialogo(Get.context!),
        dialogType: DialogType.noHeader,
        headerAnimationLoop: false,
        animType: AnimType.topSlide,
        dialogBackgroundColor: Colors.transparent,
        barrierColor: _azulProfundo.withOpacity(.82),
        context: Get.context!,
        showCloseIcon: true,
        closeIcon: const Icon(
          Icons.close_rounded,
          color: Colors.white,
          size: 22,
        ),
        keyboardAware: true,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: _fondoDialogo(
              color: colorInformacion,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _encabezadoDialogo(
                    title: title,
                    color: colorInformacion,
                    codigo: 'SIIPNE // AUTENTICACIÓN DE USUARIO',
                  ),
                  const SizedBox(height: 12),
                  _cardInformativa(
                    color: colorInformacion,
                    icono: Icons.security_rounded,
                    etiqueta: 'VALIDACIÓN DE IDENTIDAD',
                    child: Text(
                      descripcion!,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: _textoPrincipal,
                        fontSize: 10.5,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: _bordeTecnico),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x100B3558),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ImputTextWidget(
                      imgString: AppImages.icon_clave,
                      elevation: 0,
                      isSegura: true,
                      controller: controllerPass,
                      hitText: "Ingrese la clave",
                      label: "Clave institucional",
                      fonSize: sizeTxt,
                      validar: (text) {
                        if (text != null && text.length >= 8) {
                          return null;
                        }

                        return "Clave no válida";
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  _botonAccionTecnico(
                    titulo: "VALIDAR CLAVE",
                    icono: Icons.lock_open_rounded,
                    color: colorInformacion,
                    onPressed: () async {
                      final bool isValid =
                          formKey.currentState?.validate() ?? false;

                      if (!isValid) return;

                      final LoginController loginController =
                          Get.find<LoginController>();

                      final String pass = controllerPass.text;

                      final bool result = await loginController.validarPass(
                        pass,
                      );

                      controllerPass.clear();

                      if (!result) {
                        dialog.dismiss();

                        Future.delayed(const Duration(milliseconds: 150), () {
                          DialogosAwesome.getError(
                            descripcion: "La clave ingresada no es la correcta",
                            btnOkOnPress: () {
                              abrirDialogo();
                            },
                          );
                        });

                        return;
                      }

                      dialog.dismiss();
                      confirmar();
                    },
                  ),

                  if (mostrarBiometria && onBiometria != null) ...[
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "O",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 10),

                    _botonAccionTecnico(
                      titulo: "HUELLA / BIOMETRÍA",
                      icono: Icons.fingerprint_rounded,
                      color: _azulNeon,
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();

                        final bool autenticado = await onBiometria();

                        if (!autenticado) {
                          dialog.dismiss();

                          Future.delayed(const Duration(milliseconds: 150), () {
                            DialogosAwesome.getError(
                              title: "AUTENTICACIÓN",
                              descripcion:
                                  "No fue posible validar su identidad mediante biometría.",
                              btnOkOnPress: () {
                                abrirDialogo();
                              },
                            );
                          });

                          return;
                        }

                        controllerPass.clear();

                        dialog.dismiss();
                        confirmar();
                      },
                    ),
                  ],

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      );

      dialog.show();
    }

    abrirDialogo();
  }

  // ============================================================
  // PERSONALIZADO
  // ============================================================

  static getPersonalizado({
    String title = 'Información',
    required String descripcion,
  }) {
    _DialogoAmplio(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      context: Get.context!,
      width: _anchoDialogo(Get.context!),
      dialogType: DialogType.noHeader,
      headerAnimationLoop: false,
      animType: AnimType.scale,
      dialogBackgroundColor: Colors.transparent,
      barrierColor: _azulProfundo.withOpacity(.82),
      body: _fondoDialogo(
        color: colorInformacion,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _encabezadoDialogo(
              title: title,
              color: colorInformacion,
              codigo: 'SIIPNE // MENSAJE DEL SISTEMA',
            ),
            const SizedBox(height: 12),
            _cardInformativa(
              color: colorInformacion,
              icono: Icons.info_outline_rounded,
              etiqueta: 'COMUNICADO DEL SISTEMA',
              child: Text(
                descripcion,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: _textoPrincipal,
                  fontSize: 11,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _botonAccionTecnico(
              titulo: 'CERRAR MENSAJE',
              icono: Icons.keyboard_return_rounded,
              color: colorInformacion,
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    ).show();
  }

  static getSelectItem<T>({
    String title = 'SELECCIONE',
    required String descripcion,
    required List<T> items,
    required String Function(T item) itemText,
    required Function(T item) onSelected,
    Function()? onCancel,
    String hintText = 'Seleccione una opción',
  }) {
    if (items.isEmpty) {
      DialogosAwesome.getWarning(
        descripcion: "No existen opciones disponibles.",
      );
      return;
    }

    T? seleccionado;

    late _DialogoAmplio dialog;

    dialog = _DialogoAmplio(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      context: Get.context!,
      width: _anchoDialogo(Get.context!),
      dialogType: DialogType.noHeader,
      headerAnimationLoop: false,
      animType: AnimType.scale,
      dialogBackgroundColor: Colors.transparent,
      barrierColor: _azulProfundo.withOpacity(.82),
      body: StatefulBuilder(
        builder: (context, setState) {
          return _fondoDialogo(
            color: colorInformacion,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _encabezadoDialogo(
                  title: title,
                  color: colorInformacion,
                  codigo: 'SIIPNE // CLASIFICACIÓN DE RESULTADO',
                ),
                const SizedBox(height: 12),
                _cardInformativa(
                  color: colorInformacion,
                  icono: Icons.rule_folder_outlined,
                  etiqueta: 'SELECCIÓN DE VARIABLE',
                  child: Text(
                    descripcion,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: _textoSecundario,
                      fontSize: 10.5,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                DropdownButtonFormField<T>(
                  value: seleccionado,
                  isExpanded: true,
                  menuMaxHeight: 320,
                  hint: Text(hintText, style: const TextStyle(fontSize: 10)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'VARIABLE DE RESULTADO',
                    labelStyle: TextStyle(
                      color: colorInformacion,
                      fontSize: 9,
                      letterSpacing: .3,
                      fontWeight: FontWeight.w900,
                    ),
                    prefixIcon: const Icon(
                      Icons.fact_check_outlined,
                      color: AppColors.colorAzul,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: _bordeTecnico),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: _bordeTecnico),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: _azulNeon,
                        width: 1.5,
                      ),
                    ),
                  ),
                  items: items
                      .map(
                        (T item) => DropdownMenuItem<T>(
                          value: item,
                          child: Text(
                            itemText(item),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF334155),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (T? value) {
                    setState(() {
                      seleccionado = value;
                    });
                  },
                ),

                const SizedBox(height: 15),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: _botonAccionTecnico(
                        titulo: 'CANCELAR',
                        icono: Icons.close_rounded,
                        color: _grisInstitucional,
                        secundario: true,
                        onPressed: () {
                          dialog.dismiss();

                          Future.delayed(
                            const Duration(milliseconds: 120),
                            () => onCancel?.call(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _botonAccionTecnico(
                        titulo: 'CONTINUAR',
                        icono: Icons.fact_check_rounded,
                        color: AppColors.colorBotones,
                        onPressed: () {
                          if (seleccionado == null) {
                            return;
                          }

                          final T item = seleccionado as T;

                          dialog.dismiss();

                          Future.delayed(
                            const Duration(milliseconds: 150),
                            () => onSelected(item),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
              ],
            ),
          );
        },
      ),
    );

    dialog.show();
  }

  static getFinalizarOperativo({
    required GlobalKey<FormState> formKey,
    required TextEditingController controllerPass,
    required int numeroOperativo,
    required Future<bool> Function() onBiometria,
    required Future<void> Function() onFinalizar,
  }) {
    late _DialogoAmplio dialog;

    final ResponsiveUtil responsive = ResponsiveUtil();

    final double sizeTxt = responsive.diagonalP(AppConfig.tamTextoTitulo);

    void abrirConfirmacion() {
      Future.delayed(const Duration(milliseconds: 150), () {
        DialogosAwesome.getWarningSiNo(
          title: "CONFIRMAR FINALIZACIÓN",
          colorAccion: colorError,
          iconoAccion: Icons.gpp_bad_rounded,
          codigoEstado: 'SIIPNE MÓVIL // CIERRE DEFINITIVO',
          etiquetaDetalle: 'CONFIRMACIÓN DE ACCIÓN IRREVERSIBLE',
          descripcion:
              "¿Está seguro de finalizar el operativo N° $numeroOperativo?\n\n"
              "Esta acción cerrará el operativo y no permitirá registrar nuevas consultas.",
          btnOkOnPress: () async {
            await onFinalizar();
          },
        );
      });
    }

    void abrirDialogo() {
      dialog = _DialogoAmplio(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        context: Get.context!,
        width: _anchoDialogo(Get.context!),
        dialogType: DialogType.noHeader,
        headerAnimationLoop: false,
        animType: AnimType.scale,
        dialogBackgroundColor: Colors.transparent,
        barrierColor: const Color(0xFF210408).withOpacity(.88),
        keyboardAware: true,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: _fondoDialogo(
              color: colorError,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _encabezadoDialogo(
                    title: 'FINALIZAR OPERATIVO',
                    color: colorError,
                    codigo: 'SIIPNE // CIERRE SEGURO DE OPERACIÓN',
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Color(0xFF3A080D),
                          Color(0xFF81121E),
                          Color(0xFFB62030),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x55B62030),
                          blurRadius: 14,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.12),
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                              color: Colors.white.withOpacity(.20),
                            ),
                          ),
                          child: const Icon(
                            Icons.radar_rounded,
                            color: Colors.white,
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'IDENTIFICADOR OPERATIVO',
                                style: TextStyle(
                                  color: Color(0xFFFFCDD2),
                                  fontSize: 7.5,
                                  letterSpacing: .6,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "N° $numeroOperativo",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.verified_user_outlined,
                          color: Color(0xFFFFC5CB),
                          size: 23,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 11),
                  _cardInformativa(
                    color: colorError,
                    icono: Icons.gpp_bad_rounded,
                    etiqueta: 'AUTORIZACIÓN PARA CIERRE DEFINITIVO',
                    child: const Text(
                      "Para proteger el cierre del operativo debe validar su identidad mediante su clave institucional o biometría.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: _textoSecundario,
                        fontSize: 10,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFF0B8BE)),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x24B62030),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ImputTextWidget(
                      imgString: AppImages.icon_clave,
                      elevation: 0,
                      isSegura: true,
                      controller: controllerPass,
                      hitText: "Ingrese la clave",
                      label: "Clave institucional",
                      fonSize: sizeTxt,
                      validar: (text) {
                        if (text != null && text.trim().length >= 8) {
                          return null;
                        }

                        return "Clave no válida";
                      },
                    ),
                  ),

                  const SizedBox(height: 11),

                  SizedBox(
                    width: double.infinity,
                    child: _botonAccionTecnico(
                      titulo: "VALIDAR CON CLAVE",
                      icono: Icons.lock_open_rounded,
                      color: colorError,
                      onPressed: () async {
                        final bool valido =
                            formKey.currentState?.validate() ?? false;

                        if (!valido) return;

                        final LoginController loginController =
                            Get.find<LoginController>();

                        final String pass = controllerPass.text;

                        final bool resultado = await loginController
                            .validarPass(pass);

                        controllerPass.clear();

                        if (!resultado) {
                          dialog.dismiss();

                          Future.delayed(const Duration(milliseconds: 150), () {
                            DialogosAwesome.getError(
                              title: "CLAVE INCORRECTA",
                              descripcion:
                                  "La clave institucional ingresada no es correcta.",
                              btnOkOnPress: () {
                                abrirDialogo();
                              },
                            );
                          });

                          return;
                        }

                        dialog.dismiss();
                        abrirConfirmacion();
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "O VALIDE CON",
                          style: TextStyle(
                            color: Color(0xFF8A97A6),
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();

                        final bool autenticado = await onBiometria();

                        if (!autenticado) {
                          dialog.dismiss();

                          Future.delayed(const Duration(milliseconds: 150), () {
                            DialogosAwesome.getError(
                              title: "BIOMETRÍA NO VALIDADA",
                              descripcion:
                                  "No fue posible validar su identidad mediante huella o biometría.",
                              btnOkOnPress: () {
                                abrirDialogo();
                              },
                            );
                          });

                          return;
                        }

                        controllerPass.clear();

                        dialog.dismiss();

                        abrirConfirmacion();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Color(0xFF3A080D),
                              Color(0xFF86131F),
                              Color(0xFFC6283A),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFFFF9FA9)),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x55B62030),
                              blurRadius: 15,
                              offset: Offset(0, 7),
                            ),
                          ],
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.14),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(.25),
                                ),
                              ),
                              child: const Icon(
                                Icons.fingerprint_rounded,
                                color: Colors.white,
                                size: 27,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "HUELLA / BIOMETRÍA",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      letterSpacing: .35,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    "Validación biométrica de alta seguridad",
                                    style: TextStyle(
                                      color: Color(0xFFFFD4D8),
                                      fontSize: 7.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFFFFD1D6),
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 9),

                  _botonAccionTecnico(
                    titulo: 'CANCELAR OPERACIÓN',
                    icono: Icons.keyboard_return_rounded,
                    color: _grisInstitucional,
                    secundario: true,
                    onPressed: () {
                      controllerPass.clear();
                      dialog.dismiss();
                    },
                  ),

                  const SizedBox(height: 3),
                ],
              ),
            ),
          ),
        ),
      );

      dialog.show();
    }

    abrirDialogo();
  }
}

/// Contenedor modal sin los 40 dp laterales que impone [Dialog].
/// Conserva la misma interfaz utilizada por AwesomeDialog para no modificar
/// los flujos, callbacks ni la forma en que se abren y cierran los diálogos.
class _DialogoAmplio {
  final BuildContext context;
  final Widget body;
  final double width;
  final bool dismissOnTouchOutside;
  final bool dismissOnBackKeyPress;
  final Color dialogBackgroundColor;
  final Color barrierColor;
  final bool keyboardAware;
  final bool showCloseIcon;
  final Widget? closeIcon;
  final AnimType animType;
  final bool useRootNavigator;

  bool _visible = false;

  _DialogoAmplio({
    required this.context,
    required this.body,
    required this.width,
    required this.animType,
    this.dismissOnTouchOutside = true,
    this.dismissOnBackKeyPress = true,
    this.dialogBackgroundColor = Colors.transparent,
    this.barrierColor = Colors.black54,
    this.keyboardAware = true,
    this.showCloseIcon = false,
    this.closeIcon,
    this.useRootNavigator = false,
    DialogType? dialogType,
    bool headerAnimationLoop = false,
  });

  Future<void> show() async {
    if (_visible) return;
    _visible = true;

    await showGeneralDialog<void>(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierDismissible: dismissOnTouchOutside,
      barrierLabel: dismissOnTouchOutside ? 'Cerrar diálogo' : null,
      barrierColor: barrierColor,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (dialogContext, animation, _, __) {
        final Animation<double> curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        Widget contenido = Material(
          color: dialogBackgroundColor,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              body,
              if (showCloseIcon)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: dismiss,
                      borderRadius: BorderRadius.circular(22),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child:
                            closeIcon ??
                            const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );

        contenido = ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width),
          child: contenido,
        );

        contenido = AnimatedPadding(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          padding: EdgeInsets.fromLTRB(
            6,
            12,
            6,
            keyboardAware
                ? MediaQuery.of(dialogContext).viewInsets.bottom + 12
                : 12,
          ),
          child: SafeArea(child: Center(child: contenido)),
        );

        final Widget transicion = animType == AnimType.topSlide
            ? SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -.08),
                  end: Offset.zero,
                ).animate(curved),
                child: FadeTransition(opacity: curved, child: contenido),
              )
            : ScaleTransition(
                scale: Tween<double>(begin: .94, end: 1).animate(curved),
                child: FadeTransition(opacity: curved, child: contenido),
              );

        return WillPopScope(
          onWillPop: () async => dismissOnBackKeyPress,
          child: transicion,
        );
      },
    );

    _visible = false;
  }

  void dismiss() {
    if (!_visible) return;
    Navigator.of(context, rootNavigator: useRootNavigator).pop();
  }
}
