part of '../../pages.dart';

mixin SelectorNacionalidadMigracionViewMixin on OpMigracionPageBase {
  Widget selectorNacionalidadMigracion({required bool bloqueado}) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller.controllerNacionalidad,
      builder: (context, nacionalidadValue, child) {
        final codigo = nacionalidadValue.text.trim().toUpperCase();
        final paisSeleccionado = codigo.length == 3
            ? CountryService.getCountryByCode(codigo)
            : null;

        return FormField<String>(
          initialValue: codigo.isEmpty ? null : codigo,
          validator: (_) {
            final nacionalidad = controller.controllerNacionalidad.text
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
          builder: (fieldState) => SelectorNacionalidadWidget(
            paisSeleccionado: paisSeleccionado,
            enabled: !bloqueado,
            errorText: fieldState.errorText,
            onChanged: (pais) {
              if (controller.peticionServerState.value ||
                  controller.hayResultado) {
                return;
              }
              controller.seleccionarNacionalidad(
                nombre: pais.name,
                codigoAlpha3: pais.isoCodeAlpha3,
              );
              fieldState.didChange(pais.isoCodeAlpha3);
              fieldState.validate();
            },
          ),
        );
      },
    );
  }
}
