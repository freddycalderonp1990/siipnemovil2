import 'package:country_utils/country_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app/core/values/app_colors.dart';
import '../../../../../app/presentation/widgets/custom_app_widgets.dart';
import '../../../widgets/selector_nacionalidad_widget.dart';

class DialogoConsultaOperativa extends StatefulWidget {
  const DialogoConsultaOperativa({
    super.key,
    required this.titulo,
    required this.esPersona,
    required this.formKey,
    required this.documentoController,
    required this.onConsultar,
    required this.obtenerError,
    this.esConsultaRepetida,
  });

  final String titulo;
  final bool esPersona;
  final GlobalKey<FormState> formKey;
  final TextEditingController documentoController;
  final Future<bool> Function(String nacionalidad) onConsultar;
  final String Function() obtenerError;
  final bool Function()? esConsultaRepetida;

  @override
  State<DialogoConsultaOperativa> createState() =>
      _DialogoConsultaOperativaState();
}

class _DialogoConsultaOperativaState extends State<DialogoConsultaOperativa> {
  bool _extranjero = false;
  bool _confirmando = false;
  bool _consultando = false;
  Country? _pais;
  String _error = '';
  bool _consultaRepetida = false;

  bool get _ocupado => _confirmando || _consultando;
  String get _nacionalidad =>
      _extranjero ? _pais?.isoCodeAlpha3.toUpperCase() ?? '' : 'ECU';
  bool get _puedeConsultar =>
      !_ocupado &&
      !_consultaRepetida &&
      _validarDocumento(widget.documentoController.text) == null &&
      (!widget.esPersona || !_extranjero || _pais != null);

  @override
  void initState() {
    super.initState();
    widget.documentoController.addListener(_actualizarDocumento);
  }

  void _actualizarDocumento() {
    setState(() {
      _error = '';
      _consultaRepetida = false;
    });
  }

  String? _validarDocumento(String? value) {
    final documento = value?.trim() ?? '';
    if (documento.isEmpty) {
      return widget.esPersona
          ? 'Ingrese un documento.'
          : 'Ingrese una placa válida.';
    }
    if (!widget.esPersona &&
        !RegExp(r'^[A-Za-z0-9]{6,7}$').hasMatch(documento)) {
      return 'La placa debe tener mínimo 6 caracteres.';
    }
    if (widget.esPersona &&
        !_extranjero &&
        !RegExp(r'^\d{10}$').hasMatch(documento)) {
      return 'La cédula debe tener 10 dígitos.';
    }
    if (widget.esPersona && _extranjero && documento.length < 4) {
      return 'Documento no válido.';
    }
    return null;
  }

  @override
  void dispose() {
    widget.documentoController.removeListener(_actualizarDocumento);
    super.dispose();
  }

  void _cerrar(bool resultado) {
    FocusManager.instance.primaryFocus?.unfocus();
    final route = ModalRoute.of<bool>(context);
    if (route == null) return;
    final navigator = Navigator.of(context);
    if (route.isCurrent) {
      navigator.pop<bool>(resultado);
    } else {
      // Una alerta puede abrirse encima mientras termina la consulta.
      navigator.removeRoute<bool>(route, resultado);
    }
  }

  Future<void> _consultar() async {
    if (!_puedeConsultar ||
        !(widget.formKey.currentState?.validate() ?? false)) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _confirmando = true;
      _error = '';
      _consultaRepetida = false;
    });

    try {
      final documento = widget.documentoController.text.trim().toUpperCase();
      final confirmado = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierColor: DialogoInstitucional.barrera,
        builder: (dialogContext) => DialogoInstitucional(
          titulo: 'Confirmar consulta',
          codigo: widget.esPersona
              ? 'CONSULTA DE PERSONA'
              : 'CONSULTA VEHICULAR',
          icono: widget.esPersona
              ? Icons.person_search_rounded
              : Icons.directions_car_rounded,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TarjetaDialogoInstitucional(
                etiqueta: widget.esPersona
                    ? 'DOCUMENTO A CONSULTAR'
                    : 'PLACA A CONSULTAR',
                icono: widget.esPersona
                    ? Icons.badge_outlined
                    : Icons.directions_car_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      documento,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.colorAzul,
                      ),
                    ),
                    if (widget.esPersona) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Nacionalidad: ${_extranjero ? _pais!.name : 'Ecuador'} ($_nacionalidad)',
                      ),
                    ],
                    const SizedBox(height: 8),
                    const Text('Verifique el dato antes de continuar.'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const TarjetaDialogoInstitucional(
                etiqueta: 'REGISTRO DE LA CONSULTA',
                icono: Icons.security_rounded,
                child: Text(
                  'La consulta será registrada con su usuario, ubicación, fecha y hora.',
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: BotonDialogoInstitucional(
                      titulo: 'VOLVER',
                      icono: Icons.arrow_back_rounded,
                      secundario: true,
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: BotonDialogoInstitucional(
                      titulo: 'SÍ, CONSULTAR',
                      icono: Icons.search_rounded,
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      if (!mounted || confirmado != true) return;

      setState(() {
        _confirmando = false;
        _consultando = true;
      });
      final resultado = await widget.onConsultar(_nacionalidad);
      if (!mounted) return;
      if (resultado) {
        _cerrar(true);
      } else {
        setState(() {
          _consultaRepetida = widget.esConsultaRepetida?.call() ?? false;
          final mensaje = widget.obtenerError().trim();
          _error = _consultaRepetida
              ? ''
              : mensaje.isEmpty
              ? 'No fue posible realizar la consulta. Intente nuevamente.'
              : mensaje;
        });
      }
    } catch (error, stackTrace) {
      debugPrint('Error en consulta operativa: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted)
        setState(
          () => _error =
              'No fue posible realizar la consulta. Intente nuevamente.',
        );
    } finally {
      if (mounted) {
        setState(() {
          _confirmando = false;
          _consultando = false;
        });
      }
    }
  }

  Widget _avisoConsultaRepetida() {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F1FA),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFAAC8E5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.fact_check_outlined, color: AppColors.colorAzul),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'PERSONA YA CONSULTADA',
                    style: TextStyle(
                      color: AppColors.colorAzul,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.documentoController.text.trim().toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF203E5B),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Esta persona ya tiene una consulta registrada en este operativo. '
              'Ingrese otro documento o pulse SALIR para elegir un tipo de consulta.',
              style: TextStyle(
                color: Color(0xFF52687D),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opcionNacionalidad({
    required bool extranjero,
    required String titulo,
    required String detalle,
    required IconData icono,
  }) {
    final seleccionado = _extranjero == extranjero;
    return Expanded(
      child: Semantics(
        button: true,
        selected: seleccionado,
        enabled: !_ocupado,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _ocupado
                ? null
                : () {
                    if (seleccionado) return;
                    setState(() {
                      _extranjero = extranjero;
                      _pais = null;
                      widget.documentoController.clear();
                      _error = '';
                    });
                    widget.formKey.currentState?.reset();
                  },
            borderRadius: BorderRadius.circular(13),
            child: Ink(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: seleccionado
                      ? const [AppColors.colorAzul, AppColors.colorAzulSecond]
                      : const [Color(0xFFFAFCFE), Color(0xFFF1F5F9)],
                ),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: seleccionado
                      ? AppColors.colorAzul
                      : const Color(0xFFC6D7E6),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        icono,
                        color: seleccionado
                            ? Colors.white
                            : AppColors.colorAzul,
                        size: 23,
                      ),
                      Icon(
                        seleccionado
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: seleccionado
                            ? Colors.white
                            : const Color(0xFF64788B),
                        size: 17,
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    titulo,
                    style: TextStyle(
                      color: seleccionado ? Colors.white : AppColors.colorAzul,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    detalle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: seleccionado
                          ? Colors.white70
                          : const Color(0xFF52687D),
                      fontSize: 10,
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_ocupado,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DialogoInstitucional(
            titulo: widget.titulo,
            codigo: 'CONSULTA OPERATIVA',
            icono: widget.esPersona
                ? Icons.person_search_rounded
                : Icons.directions_car_rounded,
            mostrarCerrar: true,
            onCerrar: _ocupado ? null : () => _cerrar(false),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F8FC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFC6D7E6)),
              ),
              child: Form(
                key: widget.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.esPersona) ...[
                      const Text(
                        'TIPO DE DOCUMENTO',
                        style: TextStyle(
                          color: AppColors.colorAzul,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .5,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          _opcionNacionalidad(
                            extranjero: false,
                            titulo: 'Nacional',
                            detalle: 'Cédula ecuatoriana',
                            icono: Icons.badge_outlined,
                          ),
                          const SizedBox(width: 8),
                          _opcionNacionalidad(
                            extranjero: true,
                            titulo: 'Extranjero',
                            detalle: 'Documento y país',
                            icono: Icons.public_rounded,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                    ],
                    TextFormField(
                      key: ValueKey('${widget.esPersona}_$_extranjero'),
                      controller: widget.documentoController,
                      enabled: !_ocupado,
                      autofocus: true,
                      maxLength: widget.esPersona
                          ? (_extranjero ? null : 10)
                          : 7,
                      keyboardType: widget.esPersona && !_extranjero
                          ? TextInputType.number
                          : TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.search,
                      inputFormatters: widget.esPersona && !_extranjero
                          ? [FilteringTextInputFormatter.digitsOnly]
                          : [
                              if (!widget.esPersona)
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9]'),
                                ),
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) => newValue.copyWith(
                                  text: newValue.text.toUpperCase(),
                                ),
                              ),
                            ],
                      onFieldSubmitted: (_) => _consultar(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _validarDocumento,
                      decoration: InputDecoration(
                        labelText: widget.esPersona
                            ? (_extranjero
                                  ? 'Documento extranjero'
                                  : 'Número de cédula')
                            : 'Placa',
                        hintText: widget.esPersona
                            ? (_extranjero
                                  ? 'Pasaporte o identificación'
                                  : 'Ingrese los 10 dígitos')
                            : 'Ej. ABC1234',
                        prefixIcon: Icon(
                          widget.esPersona
                              ? Icons.badge_outlined
                              : Icons.directions_car_outlined,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: const TextStyle(
                          color: AppColors.colorAzul,
                          fontSize: 13,
                        ),
                        hintStyle: const TextStyle(
                          color: Color(0xFF64788B),
                          fontSize: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFC6D7E6),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.colorAzul,
                            width: 1.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        counterText: '',
                      ),
                    ),
                    if (widget.esPersona && _extranjero) ...[
                      const SizedBox(height: 16),
                      FormField<Country>(
                        key: const ValueKey('nacionalidad'),
                        validator: (_) => _pais == null
                            ? 'Seleccione la nacionalidad.'
                            : null,
                        builder: (field) => SelectorNacionalidadWidget(
                          paisSeleccionado: _pais,
                          enabled: !_ocupado,
                          excluirEcuador: true,
                          errorText: field.errorText,
                          onChanged: (pais) {
                            if (_ocupado) return;
                            setState(() {
                              _pais = pais;
                              _error = '';
                              _consultaRepetida = false;
                            });
                            field.didChange(pais);
                            field.validate();
                          },
                        ),
                      ),
                    ],
                    if (widget.esPersona && _extranjero) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Seleccione el país de nacionalidad para habilitar la consulta.',
                        style: TextStyle(
                          color: Color(0xFF52687D),
                          fontSize: 11,
                          height: 1.35,
                        ),
                      ),
                    ],
                    if (_consultaRepetida) ...[
                      const SizedBox(height: 14),
                      _avisoConsultaRepetida(),
                    ] else if (_error.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        _error,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: BotonDialogoInstitucional(
                            onPressed: _ocupado ? null : () => _cerrar(false),
                            icono: Icons.exit_to_app_rounded,
                            titulo: 'SALIR',
                            secundario: true,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: BotonDialogoInstitucional(
                            onPressed: _puedeConsultar ? _consultar : null,
                            icono: Icons.search_rounded,
                            titulo: _consultando
                                ? 'CONSULTANDO...'
                                : 'CONSULTAR',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_consultando)
            CargandoWidget(
              mostrar: true,
              titulo: widget.esPersona
                  ? 'CONSULTANDO PERSONA'
                  : 'CONSULTANDO VEHÍCULO',
              mensaje: 'Espere mientras se obtiene la información.',
            ),
        ],
      ),
    );
  }
}
