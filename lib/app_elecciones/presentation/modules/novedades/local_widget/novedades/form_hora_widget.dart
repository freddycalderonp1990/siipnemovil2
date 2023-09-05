part of '../forms_novedades.dart';

class FormHora extends StatelessWidget {
  final formKey;
  final TextEditingController controllerHora;
  final TextEditingController controllerMinuto;
  final ValueChanged<String> completeHora;
  final ValueChanged<String> completeMinuto;

  const FormHora(
      {Key? key,
      required this.formKey,
      required this.controllerHora,
      required this.controllerMinuto,
      required this.completeHora,
      required this.completeMinuto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return wgTxtHora();
  }

  Widget wgTxtHora() {
    final responsive = ResponsiveUtil();
    return Form(
      key: formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: getComboHora(responsive),
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(child: getComboMinuto(responsive))
        ],
      ),
    );
  }

  Widget getComboHora(ResponsiveUtil responsive) {
    List<ModelDataCombo> datos = [];

    for (int i = 0; i < 24; i++) {
      if (i < 10) {
        datos.add(ModelDataCombo(id: i, titulo: "0" + i.toString()));
      } else {
        datos.add(ModelDataCombo(id: i, titulo: i.toString()));
      }
    }

    return Container(
        child: ComboConBusqueda(
      selectValue: ModelDataCombo(id: 0, titulo: controllerHora.text).obs,
      title: "Hora",
      titleSelecioneEl: 'Hora',
      data: datos,
      complete: (dato) {
        completeHora(dato.titulo);
      },
    ));
  }

  Widget getComboMinuto(ResponsiveUtil responsive) {
    List<ModelDataCombo> datos = [];

    for (int i = 0; i < 60; i++) {
      if (i < 10) {
        datos.add(ModelDataCombo(id: i, titulo: "0" + i.toString()));
      } else {
        datos.add(ModelDataCombo(id: i, titulo: i.toString()));
      }
    }

    return Container(
        child: ComboConBusqueda(
      selectValue: ModelDataCombo(id: 0, titulo: controllerMinuto.text).obs,
      title: "Minuto",
      titleSelecioneEl: 'Minuto',
      data: datos,
      complete: (dato) {
        completeMinuto(dato.titulo);
      },
    ));
  }
}
