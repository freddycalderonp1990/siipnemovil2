part of '../custom_app_widgets.dart';

class ComboBusqueda<T> extends StatefulWidget {
  final String title;
  final ValueChanged<T?>? complete;
  final List<T> datos;
  final String hint;
  final String searchHint;
  final T? selectValue;
  final IconData? icon;
  final String? imgUrl;
  final bool showClearButton;
  final GlobalKey? openDropDownProgKey;
  final String? textSeleccioneUndato;

  final String? Function(T?)? validator;

  /// Determina el texto que se mostrará para cada elemento.
  final String Function(T)? displayField;

  final void Function(T)? onChanged;

  const ComboBusqueda({
    Key? key,
    this.complete,
    required this.datos,
    this.title = '',
    this.hint = 'Seleccione...',
    required this.searchHint,
    this.selectValue,
    this.icon,
    this.showClearButton = true,
    this.openDropDownProgKey,
    this.textSeleccioneUndato,
    this.imgUrl,
    this.validator,
    this.displayField,
    this.onChanged,
  }) : super(key: key);

  @override
  State<ComboBusqueda<T>> createState() => _ComboBusquedaState<T>();
}

class _ComboBusquedaState<T> extends State<ComboBusqueda<T>> {
  bool showX = false;

  final TextEditingController _userEditTextController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    showX = _tieneSeleccion(widget.selectValue);
  }

  @override
  void didUpdateWidget(covariant ComboBusqueda<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    /*
     * Si desde el padre cambia el elemento seleccionado,
     * actualizamos la visualización de la X.
     */
    final nuevoEstado = _tieneSeleccion(widget.selectValue);

    if (showX != nuevoEstado) {
      showX = nuevoEstado;
    }
  }

  @override
  Widget build(BuildContext context) {
    /*
     * Solo mostramos el buscador cuando realmente aporta utilidad.
     *
     * 1 - 5 elementos  -> Sin buscador
     * 6 o más          -> Con buscador
     */
    final bool mostrarBuscador = widget.datos.length > 5;

    final Widget wgComboBusqueda = DropdownSearch<T>(
      key: widget.openDropDownProgKey,

      selectedItem: widget.selectValue,

      compareFn: (item, selectedItem) => item == selectedItem,

      /*
       * Validación
       */
      validator: widget.validator ??
              (value) {
            if (value == null) {
              return "EL ${widget.title} Es requerido";
            }

            return null;
          },

      /*
       * Botón para limpiar la selección.
       */
      suffixProps: DropdownSuffixProps(
        clearButtonProps: ClearButtonProps(
          isVisible: widget.showClearButton && showX,
          color: Colors.red,
        ),
      ),

      /*
       * Configuración del popup.
       */
      popupProps: PopupProps.dialog(
        showSelectedItems: true,
        disableFilter: false,

        fit: FlexFit.loose,

        // Solo se muestra si hay más de 5 opciones
        showSearchBox: mostrarBuscador,

        // Siempre se configura, aunque no se muestre
        searchFieldProps: getBusquedaPopup(),

        itemBuilder: (
            context,
            item,
            isDisabled,
            isSelected,
            ) {
          return _customDesingDataPopop(
            context,
            item,
            isDisabled,
            isSelected,
          );
        },

        dialogProps: DialogProps(
          backgroundColor: Colors.white,
          barrierDismissible: true,
          barrierLabel: 'Cerrar diálogo',

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),

          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
        ),
      ),

      /*
       * Convierte cada objeto T al texto que
       * utilizará DropdownSearch.
       */
      itemAsString: (item) {
        if (widget.displayField != null) {
          return widget.displayField!(item);
        }

        return item.toString();
      },

      /*
       * Diseño del valor seleccionado dentro
       * del combo.
       */
      dropdownBuilder: (
          context,
          selectedItem,
          ) {
        return _customDropDownExample(
          context,
          selectedItem,
        );
      },

      /*
       * Datos disponibles.
       */
      items: (
          filter,
          infiniteScrollProps,
          ) {
        return widget.datos;
      },

      /*
       * Cuando seleccionamos un elemento.
       */
      onSelected: (value) {
        /*
         * Limpiamos cualquier búsqueda anterior.
         */
        _userEditTextController.clear();

        /*
         * Actualizamos la X.
         */
        final nuevoEstado = _tieneSeleccion(value);

        if (showX != nuevoEstado && mounted) {
          setState(() {
            showX = nuevoEstado;
          });
        }

        /*
         * Callback principal.
         */
        widget.complete?.call(value);

        /*
         * Callback adicional si lo necesitas.
         */
        if (value != null) {
          widget.onChanged?.call(value);
        }
      },
    );

    /*
     * Diseño:
     *
     * Título | Combo
     */
    return Row(
      children: [
        Expanded(
          child: TituloTextWidget(
            title: widget.searchHint,
          ),
        ),

        const SizedBox(
          width: 5,
        ),

        Expanded(
          flex: 3,
          child: wgComboBusqueda,
        ),
      ],
    );
  }

  // =========================================================
  // BUSCADOR DEL POPUP
  // =========================================================

  TextFieldProps getBusquedaPopup() {
    return TextFieldProps(
      controller: _userEditTextController,

      decoration: InputDecoration(
        /*
         * X para cerrar el diálogo.
         */
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
          onPressed: () {
            _userEditTextController.clear();

            Navigator.of(context).pop();
          },
        ),

        border: const OutlineInputBorder(),

        contentPadding: const EdgeInsets.fromLTRB(
          12,
          12,
          8,
          0,
        ),

        labelText: widget.searchHint,
      ),
    );
  }

  // =========================================================
  // DISEÑO DEL COMBO CUANDO YA EXISTE UNA SELECCIÓN
  // =========================================================

  Widget _customDropDownExample(
      BuildContext context,
      T? item,
      ) {
    final responsive = ResponsiveUtil();

    /*
     * Mensaje cuando no existe selección.
     */
    final Widget msjSelectDato = Text(
      widget.textSeleccioneUndato ??
          "Seleccione un dato",
      style: TextStyle(
        color: Colors.red,
        fontSize: responsive.diagonalP(1),
      ),
    );

    if (item == null) {
      return msjSelectDato;
    }

    final String texto = _getDisplayText(item);

    if (texto.isEmpty) {
      return msjSelectDato;
    }

    return Text(
      texto,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: responsive.diagonalP(1.2),
      ),
    );
  }

  // =========================================================
  // DISEÑO DE LOS ELEMENTOS DEL POPUP
  // =========================================================

  Widget _customDesingDataPopop(
      BuildContext context,
      T? item,
      bool isDisabled,
      bool isSelected,
      ) {
    final responsive = ResponsiveUtil();

    /*
     * Mensaje cuando no existe información.
     */
    final Widget msjSelectDato = ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        widget.textSeleccioneUndato ??
            "Seleccione un dato",
        style: TextStyle(
          color: Colors.red,
          fontSize: responsive.diagonalP(1),
        ),
      ),
    );

    if (item == null) {
      return msjSelectDato;
    }

    final String texto = _getDisplayText(item);

    if (texto.isEmpty) {
      return msjSelectDato;
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
      ),

      decoration: isSelected
          ? BoxDecoration(
        color: AppColors.colorAzul,
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(5),
      )
          : null,

      child: getDesing(
        colorTexto:
        isSelected ? Colors.white : Colors.black,
        titulo: texto,
        icon: widget.icon,
        iconUrl: widget.imgUrl,
        isSelect: isSelected,
      ),
    );
  }

  // =========================================================
  // DISEÑO INTERNO DE CADA OPCIÓN
  // =========================================================

  Widget getOnlyDesing({
    required Widget icon,
    String titulo = '',
    Color colorTexto = Colors.black,
  }) {
    final responsive = ResponsiveUtil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          child: Row(
            children: [
              icon,

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: responsive.diagonalP(1.2),
                    color: colorTexto,
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          height: 1,
          color: Colors.black26,
        ),
      ],
    );
  }

  Widget getDesing({
    bool isSelect = false,
    IconData? icon,
    String titulo = '',
    bool selected = false,
    String? iconUrl,
    Color colorTexto = Colors.black,
  }) {
    final Widget iconWidget = getIcon(
      icon: icon,
      isSelecc: isSelect,
    );

    return getOnlyDesing(
      icon: iconWidget,
      titulo: titulo,
      colorTexto: colorTexto,
    );
  }

  // =========================================================
  // ICONO
  // =========================================================

  Widget getIcon({
    IconData? icon,
    bool isSelecc = false,
  }) {
    Widget wg;

    /*
     * Si está seleccionado mostramos CHECK.
     */
    if (isSelecc) {
      wg = const Icon(
        Icons.check_circle,
        color: Colors.white,
      );
    }

    /*
     * Si enviaron un icono personalizado.
     */
    else if (icon != null) {
      wg = Icon(
        icon,
        color: AppColors.colorBotones,
      );
    }

    /*
     * Icono por defecto.
     */
    else {
      wg = Icon(
        Icons.description,
        color: AppColors.colorBotones,
      );
    }

    return Container(
      padding: const EdgeInsets.all(5),
      child: wg,
    );
  }

  // =========================================================
  // UTILIDADES
  // =========================================================

  String _getDisplayText(T item) {
    if (widget.displayField != null) {
      return widget.displayField!(item);
    }

    return item.toString();
  }

  bool _tieneSeleccion(T? item) {
    if (item == null) {
      return false;
    }

    return _getDisplayText(item).trim().isNotEmpty;
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    _userEditTextController.dispose();
    super.dispose();
  }
}