part of '../../pages.dart';

mixin SelectorNacionalidadMigracionViewMixin on OpMigracionPageBase {
  Widget selectorNacionalidadMigracion({required bool bloqueado}) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller.controllerNacionalidad,
      builder: (
          BuildContext context,
          TextEditingValue nacionalidadValue,
          Widget? child,
          ) {
        final String codigo =
        nacionalidadValue.text.trim().toUpperCase();

        final Country? paisSeleccionado = codigo.length == 3
            ? CountryService.getCountryByCode(codigo)
            : null;

        return FormField<String>(
          initialValue: codigo.isEmpty ? null : codigo,
          validator: (_) {
            final String nacionalidad = controller
                .controllerNacionalidad.text
                .trim()
                .toUpperCase();

            if (nacionalidad.length != 3) {
              return 'Seleccione una nacionalidad válida.';
            }

            if (CountryService.getCountryByCode(nacionalidad) == null) {
              return 'El código de nacionalidad no es válido.';
            }

            return null;
          },
          builder: (FormFieldState<String> fieldState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: bloqueado
                        ? null
                        : () => _abrirSelectorNacionalidad(fieldState),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 58),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: bloqueado
                            ? const Color(0xFFF0F3F6)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: fieldState.hasError
                              ? _MigracionColors.rojo
                              : _MigracionColors.borde,
                          width: fieldState.hasError ? 1.3 : 1,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 44,
                            height: 32,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F2FC),
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: const Color(0xFFC6D8E8),
                              ),
                            ),
                            child: paisSeleccionado == null
                                ? const Icon(
                              Icons.public_rounded,
                              color: _MigracionColors.azul,
                              size: 21,
                            )
                                : RTMCountryFlag(
                              countryCode:
                              paisSeleccionado.isoCodeAlpha3,
                              width: 44,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  'NACIONALIDAD',
                                  style: TextStyle(
                                    color: _MigracionColors.textoSuave,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: .25,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  paisSeleccionado?.name ??
                                      'Seleccione un país',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: paisSeleccionado == null
                                        ? _MigracionColors.textoSuave
                                        : _MigracionColors.texto,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (paisSeleccionado != null) ...<Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 7),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F2FC),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                paisSeleccionado.isoCodeAlpha3,
                                style: const TextStyle(
                                  color: _MigracionColors.azul,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: bloqueado
                                ? _MigracionColors.textoSuave.withOpacity(.40)
                                : _MigracionColors.azul,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (fieldState.hasError) ...<Widget>[
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      fieldState.errorText!,
                      style: const TextStyle(
                        color: _MigracionColors.rojo,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _abrirSelectorNacionalidad(
      FormFieldState<String> fieldState,
      ) async {
    if (controller.peticionServerState.value) return;

    FocusManager.instance.primaryFocus?.unfocus();

    final BuildContext? context = Get.context;
    if (context == null) return;

    final List<Country> paises = CountryService.getCountries().toList()
      ..sort(
            (Country a, Country b) =>
            a.name.toUpperCase().compareTo(b.name.toUpperCase()),
      );

    final Country? seleccionado = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(.70),
      builder: (_) => _SelectorPaisMigracionSheet(paises: paises),
    );

    if (seleccionado == null) return;

    controller.seleccionarNacionalidad(
      nombre: seleccionado.name,
      codigoAlpha3: seleccionado.isoCodeAlpha3,
    );

    fieldState.didChange(seleccionado.isoCodeAlpha3);
    fieldState.validate();
  }
}

class _SelectorPaisMigracionSheet extends StatefulWidget {
  final List<Country> paises;

  const _SelectorPaisMigracionSheet({
    required this.paises,
  });

  @override
  State<_SelectorPaisMigracionSheet> createState() =>
      _SelectorPaisMigracionSheetState();
}

class _SelectorPaisMigracionSheetState
    extends State<_SelectorPaisMigracionSheet> {
  final TextEditingController _controllerBusqueda =
  TextEditingController();

  late List<Country> _paisesFiltrados;

  @override
  void initState() {
    super.initState();
    _paisesFiltrados = widget.paises;
  }

  void _buscarPais(String value) {
    final String criterio = value.trim().toUpperCase();

    setState(() {
      if (criterio.isEmpty) {
        _paisesFiltrados = widget.paises;
        return;
      }

      _paisesFiltrados = widget.paises.where((Country pais) {
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
  Widget build(BuildContext context) {
    final double altura = MediaQuery.sizeOf(context).height;

    return Container(
      height: altura * .82,
      decoration: const BoxDecoration(
        color: Color(0xFFF6F9FC),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 10, 8, 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  _MigracionColors.azul,
                  _MigracionColors.azulOscuro,
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.14),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.public_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                    color: _MigracionColors.borde,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    color: _MigracionColors.borde,
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
                  color: _MigracionColors.textoSuave,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
                : ListView.separated(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
              itemCount: _paisesFiltrados.length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 6),
              itemBuilder: (_, int index) {
                final Country pais = _paisesFiltrados[index];

                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  child: InkWell(
                    onTap: () =>
                        Navigator.of(context).pop(pais),
                    borderRadius: BorderRadius.circular(13),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: const Color(0xFFDCE5ED),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 45,
                            height: 32,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(7),
                              border: Border.all(
                                color: const Color(0xFFD1DCE6),
                              ),
                            ),
                            child: RTMCountryFlag(
                              countryCode: pais.isoCodeAlpha3,
                              width: 45,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              pais.name,
                              style: const TextStyle(
                                color: _MigracionColors.texto,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F2FC),
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              pais.isoCodeAlpha3,
                              style: const TextStyle(
                                color: _MigracionColors.azul,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: _MigracionColors.azul,
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
    );
  }
}