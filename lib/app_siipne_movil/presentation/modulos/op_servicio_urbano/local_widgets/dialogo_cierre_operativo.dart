
part of '../../pages.dart';
class _DialogoCierreOperativo extends StatefulWidget {
  const _DialogoCierreOperativo({
    required this.operativo,
    required this.clave,
    required this.biometriaConfiguradaApp,
    required this.validarClave,
    required this.validarBiometria,
  });

  final String operativo;
  final TextEditingController clave;
  final bool biometriaConfiguradaApp;
  final Future<bool> Function() validarClave;
  final Future<bool> Function() validarBiometria;

  @override
  State<_DialogoCierreOperativo> createState() =>
      _DialogoCierreOperativoState();
}

class _DialogoCierreOperativoState extends State<_DialogoCierreOperativo>
    with WidgetsBindingObserver {
  static const Color _azul = Color(0xFF195BA6);
  static const Color _azulElectrico = Color(0xFF4EA8FF);
  static const Color _azulOscuro = Color(0x8ACD2727);
  static const Color _azulPanel = Color(0xFF9E1223);
  static const Color _tinta = Color(0xFF142D49);
  static const Color _rojo = Color(0xFFB42318);
  static const Color _rojoClaro = Color(0xFFFFE8E6);

  final LocalAuthentication _auth = LocalAuthentication();

  bool _biometriaSistemaDisponible = false;
  bool _consultandoBiometria = true;
  bool _ocupado = false;
  bool _ocultar = true;
  String? _error;
  int _revision = 0;

  bool get _mostrarBiometria =>
      widget.biometriaConfiguradaApp &&
          _biometriaSistemaDisponible &&
          !_consultandoBiometria;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _revisarBiometria();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;

    if (state == AppLifecycleState.resumed && !_ocupado) {
      _revisarBiometria();
    }

    if (state == AppLifecycleState.paused) {
      _revision++;
      setState(() {
        _biometriaSistemaDisponible = false;
        _consultandoBiometria = widget.biometriaConfiguradaApp;
      });
    }
  }

  Future<bool> _revisarBiometria() async {
    final int revision = ++_revision;

    // PRIMERA REGLA:
    // Si SIIPNE Móvil NO tiene activada la biometría,
    // ni siquiera consultamos LocalAuthentication.
    if (!widget.biometriaConfiguradaApp) {
      if (mounted) {
        setState(() {
          _biometriaSistemaDisponible = false;
          _consultandoBiometria = false;
        });
      }

      debugPrint(
        '[CIERRE BIOMETRIA] Configuración SIIPNE = DESACTIVADA',
      );

      return false;
    }

    if (mounted) {
      setState(() {
        _biometriaSistemaDisponible = false;
        _consultandoBiometria = true;
      });
    }

    try {
      final bool soportado = await _auth.isDeviceSupported();
      final bool puedeComprobar = await _auth.canCheckBiometrics;

      final List<BiometricType> disponibles =
      soportado && puedeComprobar
          ? await _auth.getAvailableBiometrics()
          : <BiometricType>[];

      final bool disponible =
          soportado &&
              puedeComprobar &&
              disponibles.isNotEmpty;

      debugPrint(
        '[CIERRE BIOMETRIA] '
            'configApp=${widget.biometriaConfiguradaApp} '
            'soportado=$soportado '
            'canCheck=$puedeComprobar '
            'disponibles=$disponibles '
            'visible=$disponible',
      );

      if (!mounted || revision != _revision) return false;

      setState(() {
        _biometriaSistemaDisponible = disponible;
        _consultandoBiometria = false;
      });

      return disponible;
    } catch (e) {
      debugPrint(
        '[CIERRE BIOMETRIA] Error verificando disponibilidad: $e',
      );

      if (mounted && revision == _revision) {
        setState(() {
          _biometriaSistemaDisponible = false;
          _consultandoBiometria = false;
        });
      }

      return false;
    }
  }

  Future<void> _validar({bool biometria = false}) async {
    if (_ocupado) return;

    FocusScope.of(context).unfocus();

    if (!biometria && widget.clave.text.trim().isEmpty) {
      setState(() {
        _error = 'Ingrese su clave institucional.';
      });
      return;
    }

    if (biometria) {
      // SEGUNDA BARRERA:
      // aunque por cualquier razón el botón llegara a ejecutarse,
      // nuevamente validamos la preferencia SIIPNE.
      if (!widget.biometriaConfiguradaApp) {
        setState(() {
          _error =
          'El acceso biométrico no está habilitado en las preferencias de SIIPNE Móvil.';
        });
        return;
      }

      final bool disponible = await _revisarBiometria();

      if (!disponible) {
        if (mounted) {
          setState(() {
            _error =
            'La biometría no está disponible actualmente. Utilice su clave institucional.';
          });
        }
        return;
      }
    }

    setState(() {
      _ocupado = true;
      _error = null;
    });

    try {
      final bool valido = biometria
          ? await widget.validarBiometria()
          : await widget.validarClave();

      if (!mounted) return;

      if (valido) {
        Navigator.of(context).pop(true);
        return;
      }

      setState(() {
        _error = biometria
            ? 'No se completó la validación biométrica. Puede reintentar o utilizar su clave.'
            : 'No se pudo validar la clave institucional.';
      });
    } catch (e) {
      debugPrint('[CIERRE OPERATIVO] Error de validación: $e');

      if (mounted) {
        setState(() {
          _error =
          'No fue posible completar la validación. Intente nuevamente.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _ocupado = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_ocupado,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.35),
                    blurRadius: 35,
                    spreadRadius: 2,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _cabecera(),
                    _contenido(),
                    _alertaFinalizacion(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _datoTecnico({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.065),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: Colors.white.withOpacity(.09),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icono,
            size: 17,
            color: const Color(0xFFAED4F5),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF7FA6C9),
                    fontSize: 8,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
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

  Widget _cabecera() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF650A13),
            Color(0xFF981B1E),
            Color(0xFFC62D2D),
            Color(0xFF7D1018),
          ],
          stops: [0, .38, .72, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -35,
            top: -55,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(.08),
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: -28,
            child: Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(.025),
                border: Border.all(
                  color: Colors.white.withOpacity(.07),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 11, 8, 13),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.10),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: Colors.white.withOpacity(.16),
                        ),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_outlined,
                        color: Colors.white,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 11),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SIIPNE MÓVIL  //  CONTROL OPERATIVO',
                            style: TextStyle(
                              color: Color(0xFFFFD6D6),
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'FINALIZAR OPERATIVO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Cerrar',
                      onPressed: _ocupado
                          ? null
                          : () => Navigator.of(context).pop(false),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _datoTecnico(
                        icono: Icons.tag_rounded,
                        titulo: 'OPERATIVO',
                        valor: widget.operativo,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: _datoTecnico(
                        icono: Icons.radio_button_checked_rounded,
                        titulo: 'ESTADO',
                        valor: 'ACTIVO',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenido() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 14, 17, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: _tinta,
                size: 18,
              ),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'CONFIRME SU IDENTIDAD',
                  style: TextStyle(
                    color: _tinta,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Ingrese su clave institucional o utilice el acceso biométrico configurado.',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 10.5,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 11),

          TextField(
            controller: widget.clave,
            enabled: !_ocupado,
            obscureText: _ocultar,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _validar(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              labelText: 'Clave institucional',
              hintText: 'Ingrese su clave',
              labelStyle: const TextStyle(fontSize: 11.5),
              hintStyle: const TextStyle(fontSize: 11.5),
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: _azul,
                size: 20,
              ),
              suffixIcon: IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: _ocultar ? 'Mostrar clave' : 'Ocultar clave',
                onPressed: _ocupado
                    ? null
                    : () => setState(() => _ocultar = !_ocultar),
                icon: Icon(
                  _ocultar
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 19,
                  color: const Color(0xFF64748B),
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFF5F8FC),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(
                  color: Color(0xFFD8E2EC),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(
                  color: _azul,
                  width: 1.4,
                ),
              ),
            ),
          ),

          if (_error != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4F3),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: const Color(0xFFF2C7C3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: _rojo,
                    size: 16,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          color: _rojo,
                          fontSize: 10.5,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 10),

          FilledButton.icon(
            onPressed: _ocupado ? null : () => _validar(),
            icon: _ocupado
                ? const SizedBox.shrink()
                : const Icon(
              Icons.verified_user_outlined,
              size: 19,
            ),
            label: _ocupado
                ? const SizedBox(
              width: 19,
              height: 19,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Text(
              'VALIDAR CREDENCIALES',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: .35,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: _azul,
              foregroundColor: Colors.white,
              disabledBackgroundColor: _azul.withOpacity(.55),
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),

          const SizedBox(height: 9),

          // BIOMETRÍA + VOLVER EN UNA SOLA LÍNEA
          Row(
            children: [
              if (_mostrarBiometria) ...[
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: OutlinedButton.icon(
                      onPressed: _ocupado
                          ? null
                          : () => _validar(biometria: true),
                      icon: const Icon(
                        Icons.fingerprint_rounded,
                        size: 21,
                      ),
                      label: const Text(
                        'BIOMÉTRICO',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .25,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _azul,
                        side: const BorderSide(
                          color: Color(0xFFB9D0E5),
                        ),
                        backgroundColor: const Color(0xFFF4F8FC),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: _ocupado
                        ? null
                        : () => Navigator.of(context).pop(false),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 18,
                    ),
                    label: const Text(
                      'VOLVER AL OPERATIVO',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .15,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF596B7F),
                      side: const BorderSide(
                        color: Color(0xFFD5DEE8),
                      ),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _alertaFinalizacion() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 9, 16, 10),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF3F2),
        border: Border(
          top: BorderSide(
            color: Color(0xFFF0CBC7),
          ),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: _rojo,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'ALERTA DE FINALIZACIÓN  ',
                    style: TextStyle(
                      color: _rojo,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .4,
                    ),
                  ),
                  TextSpan(
                    text:
                    'Al cerrar el operativo no podrán registrarse nuevas consultas.',
                    style: TextStyle(
                      color: Color(0xFF7A3C37),
                      fontSize: 9.5,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}