part of '../../pages.dart';

class TipoOperativoPage extends GetView<TipoOperativoController> {
  const TipoOperativoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WorkAreaPageSiipneMovilWidget(
      showGps: true,
      mostrarBtnAtras: true,
      title: "TIPOS DE OPERATIVOS",
      contenido: getContenido(),
      peticionServer: controller.peticionServerState,
    );
  }

  Widget getContenido() {
    return  Column(
      children: [
        DesingFotoNameWidget(
          img: controller.user.foto,
          sexo: controller.user.sexo,
          nombres: controller.user.nombres,
        ),
        Expanded(child: SingleChildScrollView(child: Column(children: [

          getBtnContinuar(),
          SizedBox(height: 10,),
          // Combos dinámicos
          getCombosTipoOperativos(),


        ],),)),


      ],
    );
  }


  Widget getBtnContinuar(){

    return Obx(()=>controller.showContinuar.value?BtnIconWidget(
      icon: Icons.exit_to_app,
      titulo: "CONTINUAR",
      onPressed: () =>controller.gotToNextPage(),
    ):Container());
  }

  // ============================================================
  // COMBOS DINÁMICOS
  // ============================================================

  Widget getCombosTipoOperativos() {
    return Obx(() {
      // Para que Obx escuche los cambios
      controller.rutaSeleccionada.length;
      controller.listTipoOperativos.length;

      if (controller.listTipoOperativos.isEmpty) {
        return const SizedBox();
      }

      final List<Widget> combos = [];

      /*
       * Siempre mostramos nivel 0.
       *
       * Luego mostramos un combo adicional por cada selección
       * que tenga hijos.
       */

      int cantidadNiveles = 1;

      if (controller.rutaSeleccionada.isNotEmpty) {
        final ultimo = controller.rutaSeleccionada.last;

        cantidadNiveles =
            controller.rutaSeleccionada.length;

        // Si el último seleccionado tiene hijos,
        // necesitamos mostrar el siguiente combo.
        if (controller.tieneHijos(
          ultimo.idGenTipoTipificacion,
        )) {
          cantidadNiveles++;
        }
      }

      for (int nivel = 0;
      nivel < cantidadNiveles;
      nivel++) {

        final datos =
        controller.getDatosNivel(nivel);

        if (datos.isEmpty) {
          continue;
        }

        combos.add(
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 5,
            ),
            child: ComboBusqueda(
              icon: Icons.local_police_outlined  ,
              datos: datos,

              selectValue:
              controller.getSeleccionNivel(nivel),

              showClearButton: true,

              searchHint:
              nivel == 0
                  ? 'Tipo Operativo'
                  : 'Seleccione',

              textSeleccioneUndato:
              'Seleccione una opción',

              displayField: (item) =>
              item.descripcion,

              complete: (item) {

                // Limpió el combo
                if (item == null) {
                  controller.limpiarDesdeNivel(nivel);
                  return;
                }

                // Seleccionó algo
                controller.seleccionarTipoOperativo(
                  nivel,
                  item,
                );
              },
            ),
          ),
        );
      }

      return Column(
        children: combos,
      );
    });
  }
}