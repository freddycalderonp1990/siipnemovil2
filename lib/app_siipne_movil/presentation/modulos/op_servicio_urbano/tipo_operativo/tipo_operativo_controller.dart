part of '../../controllers.dart';

class TipoOperativoController extends GetxController {
  final loginController = Get.find<LoginController>();
  final SiipneMovilUseCase siipneMovilUseCase = Get.find();

  late UserEntities user;

  RxBool peticionServerState = false.obs;

  DataModulo dataModuloResponse = DataModulo.empty();

  /// Todos los registros recibidos desde el servidor
  RxList<DataTipoOperativo> listTipoOperativos =
      <DataTipoOperativo>[].obs;

  /// Último elemento seleccionado.
  /// Si no tiene hijos, este será el operativo final.
  Rx<DataTipoOperativo> selectTipoOperativo =
      DataTipoOperativo.empty().obs;

  /// Ruta que el usuario va seleccionando.
  ///
  /// Ejemplo:
  /// [
  ///   OPERATIVO SERVICIO URBANO,
  ///   EXTRAORDINARIOS,
  ///   INSTITUCIONAL,
  ///   INSTITUCIONAL
  /// ]
  RxList<DataTipoOperativo> rutaSeleccionada =
      <DataTipoOperativo>[].obs;

  RxBool showContinuar=false.obs;

  @override
  void onInit() {
    user = loginController.user.value;
    super.onInit();
  }

  @override
  void onReady() async {
    await getDataToPage();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getDataToPage() async {
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments.containsKey('modulo')) {
      try {
        dataModuloResponse = arguments['modulo'] as DataModulo;

        await getTipoOperativos();
      } catch (e) {
        print('Error getDataToPage: $e');
      }
    }
  }

  Future<void> getTipoOperativos() async {
    peticionServerState(true);

    await ExceptionDialogos.manejarErroresShowDialogo(
      showMsjNodata: false,
          () async {
        GetTipoOperativosRequest request =
        GetTipoOperativosRequest(
          idGenModulo: dataModuloResponse.idGenModulo,
        );

        listTipoOperativos.value =
        await siipneMovilUseCase.getTipoOperativos(
          request: request,
        );

        // Limpiamos cualquier selección anterior
        rutaSeleccionada.clear();
        selectTipoOperativo.value =
            DataTipoOperativo.empty();

        if (listTipoOperativos.isEmpty) {
          print("Sin permisos cerrar");
        }
      },
    );

    peticionServerState(false);
  }

  // =========================================================
  // OBTENER RAÍCES
  // =========================================================

  /// Obtiene los elementos que no tienen padre.
  ///
  /// En tu modelo:
  /// idPadre = 0 significa que es raíz.
  List<DataTipoOperativo> get hijosRaiz {
    final Map<int, DataTipoOperativo> unicos = {};

    for (final item in listTipoOperativos) {
      if (item.idPadre == 0) {
        unicos[item.idGenTipoTipificacion] = item;
      }
    }

    return unicos.values.toList();
  }

  // =========================================================
  // OBTENER HIJOS
  // =========================================================

  /// Obtiene los hijos directos de cualquier elemento.
  List<DataTipoOperativo> getHijos(int idPadre) {
    final Map<int, DataTipoOperativo> unicos = {};

    for (final item in listTipoOperativos) {
      if (item.idPadre == idPadre) {
        unicos[item.idGenTipoTipificacion] = item;
      }
    }

    return unicos.values.toList();
  }

  // =========================================================
  // SABER SI TIENE HIJOS
  // =========================================================

  bool tieneHijos(int idGenTipoTipificacion) {
    return listTipoOperativos.any(
          (item) =>
      item.idPadre == idGenTipoTipificacion,
    );
  }

  // =========================================================
  // OBTENER DATOS PARA UN NIVEL
  // =========================================================

  /// Devuelve las opciones que debe mostrar cada combo.
  ///
  /// nivel 0 = raíces
  /// nivel 1 = hijos de la raíz seleccionada
  /// nivel 2 = hijos del elemento seleccionado en nivel 1
  /// etc.
  List<DataTipoOperativo> getDatosNivel(int nivel) {
    if (nivel == 0) {
      return hijosRaiz;
    }

    // Para obtener los datos del nivel actual
    // necesitamos que exista una selección anterior.
    if (rutaSeleccionada.length < nivel) {
      return [];
    }

    final padre = rutaSeleccionada[nivel - 1];

    return getHijos(
      padre.idGenTipoTipificacion,
    );
  }

  // =========================================================
  // SELECCIONAR
  // =========================================================

  void seleccionarTipoOperativo(
      int nivel,
      DataTipoOperativo item,
      ) {
    /*
     * Si el usuario regresa y cambia una selección anterior,
     * debemos eliminar todas las selecciones posteriores.
     *
     * Ejemplo:
     *
     * SERVICIO URBANO
     *    EXTRAORDINARIOS
     *       INSTITUCIONAL
     *
     * Si cambia EXTRAORDINARIOS,
     * eliminamos INSTITUCIONAL.
     */

    if (rutaSeleccionada.length > nivel) {
      rutaSeleccionada.removeRange(
        nivel,
        rutaSeleccionada.length,
      );
    }

    // Guardamos la nueva selección
    rutaSeleccionada.add(item);

    // Siempre guardamos el último seleccionado
    selectTipoOperativo.value = item;

    print('-------------------------------');
    print('Nivel seleccionado: $nivel');
    print('Descripción: ${item.descripcion}');
    print(
      'idGenTipoTipificacion: '
          '${item.idGenTipoTipificacion}',
    );
    print('idPadre: ${item.idPadre}');

    // Comprobamos si debemos continuar
    if (tieneHijos(item.idGenTipoTipificacion)) {
      print('Tiene hijos -> mostrar otro combo');
      showContinuar.value=false;
    } else {
      print('No tiene hijos -> selección final');
      print('idOperativo final: ${item.idOperativo}');
      
      print("select idOperativo  ${ selectTipoOperativo.value.idOperativo}");
      showContinuar.value=true;

    }

    print('-------------------------------');

    // Forzar actualización del RxList
    rutaSeleccionada.refresh();
  }

  // =========================================================
  // OBTENER SELECCIÓN DE UN NIVEL
  // =========================================================

  DataTipoOperativo? getSeleccionNivel(int nivel) {
    if (nivel < rutaSeleccionada.length) {
      return rutaSeleccionada[nivel];
    }

    return null;
  }

  // =========================================================
  // SABER SI TERMINÓ
  // =========================================================

  bool get seleccionFinalizada {
    if (rutaSeleccionada.isEmpty) {
      return false;
    }

    final ultimo = rutaSeleccionada.last;

    return !tieneHijos(
      ultimo.idGenTipoTipificacion,
    );
  }

  // =========================================================
  // OPERATIVO FINAL
  // =========================================================

  DataTipoOperativo? get operativoFinal {
    if (!seleccionFinalizada) {
      return null;
    }

    return rutaSeleccionada.last;
  }

  // =========================================================
  // LIMPIAR
  // =========================================================

  void limpiarTipoOperativo() {
    rutaSeleccionada.clear();

    selectTipoOperativo.value =
        DataTipoOperativo.empty();
  }

  void limpiarDesdeNivel(int nivel) {
    showContinuar.value=false;
    if (rutaSeleccionada.length > nivel) {
      rutaSeleccionada.removeRange(
        nivel,
        rutaSeleccionada.length,
      );
    }

    // Actualizamos el último seleccionado
    if (rutaSeleccionada.isNotEmpty) {
      selectTipoOperativo.value = rutaSeleccionada.last;
    } else {

      selectTipoOperativo.value = DataTipoOperativo.empty();
    }

    rutaSeleccionada.refresh();
  }

  gotToNextPage(){
    Get.toNamed(SiipneMovilRoutes.OPERATIVOS_SERVICIO_URBANO,arguments:{"tipoOperativo": selectTipoOperativo}  );
  }
}