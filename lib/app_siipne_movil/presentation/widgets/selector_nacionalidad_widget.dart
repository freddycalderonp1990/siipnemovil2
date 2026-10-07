import 'package:country_utils/country_utils.dart';
import 'package:flutter/material.dart';

class SelectorNacionalidadWidget extends StatelessWidget {
  const SelectorNacionalidadWidget({
    super.key,
    required this.paisSeleccionado,
    required this.onChanged,
    this.enabled = true,
    this.excluirEcuador = false,
    this.errorText,
  });

  final Country? paisSeleccionado;
  final ValueChanged<Country> onChanged;
  final bool enabled;
  final bool excluirEcuador;
  final String? errorText;

  Future<void> _abrirSelector(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final paises =
        CountryService.getCountries()
            .where((pais) => !excluirEcuador || pais.isoCodeAlpha3 != 'ECU')
            .toList()
          ..sort(
            (a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()),
          );

    final seleccionado = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .70),
      builder: (_) => _SelectorPaisSheet(
        paises: paises,
        codigoSeleccionado: paisSeleccionado?.isoCodeAlpha3,
      ),
    );

    if (!context.mounted || seleccionado == null) return;
    onChanged(seleccionado);
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Semantics(
        button: true,
        enabled: enabled,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? () => _abrirSelector(context) : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 58),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: enabled
                    ? const Color(0xFFF8FAFC)
                    : const Color(0xFFF0F3F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: errorText == null
                      ? _NacionalidadColors.borde
                      : _NacionalidadColors.rojo,
                  width: errorText == null ? 1 : 1.3,
                ),
              ),
              child: Row(
                children: [
                  _BanderaPais(pais: paisSeleccionado),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NACIONALIDAD',
                          style: TextStyle(
                            color: _NacionalidadColors.textoSuave,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .25,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          paisSeleccionado?.name ?? 'Seleccione un país',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: paisSeleccionado == null
                                ? _NacionalidadColors.textoSuave
                                : _NacionalidadColors.texto,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (paisSeleccionado != null) ...[
                    const SizedBox(width: 7),
                    _CodigoPais(codigo: paisSeleccionado!.isoCodeAlpha3),
                    const SizedBox(width: 7),
                  ],
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: enabled
                        ? _NacionalidadColors.azul
                        : _NacionalidadColors.textoSuave.withValues(alpha: .40),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      if (errorText != null) ...[
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            errorText!,
            style: const TextStyle(
              color: _NacionalidadColors.rojo,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ],
  );
}

class _SelectorPaisSheet extends StatefulWidget {
  const _SelectorPaisSheet({required this.paises, this.codigoSeleccionado});

  final List<Country> paises;
  final String? codigoSeleccionado;

  @override
  State<_SelectorPaisSheet> createState() => _SelectorPaisSheetState();
}

class _SelectorPaisSheetState extends State<_SelectorPaisSheet> {
  final _controllerBusqueda = TextEditingController();
  late List<Country> _paisesFiltrados;

  @override
  void initState() {
    super.initState();
    _paisesFiltrados = widget.paises;
  }

  void _buscarPais(String value) {
    final criterio = value.trim().toUpperCase();
    setState(() {
      _paisesFiltrados = widget.paises.where((pais) {
        return pais.name.toUpperCase().contains(criterio) ||
            pais.isoCodeAlpha2.toUpperCase().contains(criterio) ||
            pais.isoCodeAlpha3.toUpperCase().contains(criterio);
      }).toList();
    });
  }

  @override
  void dispose() {
    _controllerBusqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedPadding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    duration: const Duration(milliseconds: 150),
    child: Container(
      height: MediaQuery.sizeOf(context).height * .82,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Color(0xFFF6F9FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 10, 8, 14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _NacionalidadColors.azul,
                    _NacionalidadColors.azulOscuro,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 45,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.public_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SELECCIONAR NACIONALIDAD',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'Busque por nombre o código ISO.',
                              style: TextStyle(
                                color: Color(0xFFDCEAF7),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Cerrar selector',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controllerBusqueda,
                autofocus: true,
                onChanged: _buscarPais,
                decoration: InputDecoration(
                  hintText: 'Buscar país, VEN, COL, PER...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _controllerBusqueda.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Limpiar búsqueda',
                          onPressed: () {
                            _controllerBusqueda.clear();
                            _buscarPais('');
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(
                      color: _NacionalidadColors.borde,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(
                      color: _NacionalidadColors.borde,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _paisesFiltrados.isEmpty
                  ? const Center(
                      child: Text(
                        'No se encontraron países.',
                        style: TextStyle(
                          color: _NacionalidadColors.textoSuave,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                      itemCount: _paisesFiltrados.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (_, index) {
                        final pais = _paisesFiltrados[index];
                        final seleccionado =
                            pais.isoCodeAlpha3 == widget.codigoSeleccionado;
                        return Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(pais),
                            borderRadius: BorderRadius.circular(13),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: seleccionado
                                      ? _NacionalidadColors.azul
                                      : const Color(0xFFDCE5ED),
                                ),
                              ),
                              child: Row(
                                children: [
                                  _BanderaPais(pais: pais),
                                  const SizedBox(width: 11),
                                  Expanded(
                                    child: Text(
                                      pais.name,
                                      style: const TextStyle(
                                        color: _NacionalidadColors.texto,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _CodigoPais(codigo: pais.isoCodeAlpha3),
                                  const SizedBox(width: 5),
                                  Icon(
                                    seleccionado
                                        ? Icons.check_circle_rounded
                                        : Icons.chevron_right_rounded,
                                    color: _NacionalidadColors.azul,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _BanderaPais extends StatelessWidget {
  const _BanderaPais({required this.pais});

  final Country? pais;

  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 32,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: const Color(0xFFE8F2FC),
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: const Color(0xFFC6D8E8)),
    ),
    child: pais == null
        ? const Icon(
            Icons.public_rounded,
            color: _NacionalidadColors.azul,
            size: 21,
          )
        : RTMCountryFlag(
            countryCode: pais!.isoCodeAlpha3,
            width: 44,
            height: 32,
            fit: BoxFit.cover,
          ),
  );
}

class _CodigoPais extends StatelessWidget {
  const _CodigoPais({required this.codigo});

  final String codigo;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFE8F2FC),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      codigo,
      style: const TextStyle(
        color: _NacionalidadColors.azul,
        fontSize: 12,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

abstract final class _NacionalidadColors {
  static const azul = Color(0xFF195BA6);
  static const azulOscuro = Color(0xFF0A3D7E);
  static const texto = Color(0xFF203E5B);
  static const textoSuave = Color(0xFF718496);
  static const borde = Color(0xFFD5E1EC);
  static const rojo = Color(0xFFB42318);
}
