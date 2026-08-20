part of '../controllers.dart';

class MenuSiipneMovilController extends GetxController{
  final LoginController loginController=Get.find<LoginController>();
  final SiipneMovilUseCase siipneMovilUseCase=Get.find();

  final RxList<DataModulo> listModulos=<DataModulo>[].obs;

  late UserEntities user;

  final RxBool peticionServerState=false.obs;

  /// Mientras sea false la Page NO debe mostrar el menú.
  final RxBool flujoInicialFinalizado=false.obs;

  /// Resultado de la comprobación.
  final Rxn<Pendiente> operativoPendiente=Rxn<Pendiente>();

  final ScrollController scrollController=ScrollController();
  final RxBool mostrarIndicador=false.obs;

  bool _inicializando=false;

  // ============================================================
  // HISTORIAL OPERATIVOS
  // ============================================================

  final RxList<DataOperativosUsuario> operativosUsuario=
      <DataOperativosUsuario>[].obs;

  final RxBool consultandoOperativos=false.obs;
  final RxBool descargandoPdf=false.obs;

  final RxnInt idOperativoDescargando=RxnInt();

  late final Rx<DateTime> fechaInicio;
  late final Rx<DateTime> fechaFin;

  String mensajeErrorOperativos='';
  String mensajeErrorPdf='';

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit(){
    super.onInit();

    user=loginController.user.value;

    final DateTime hoy=DateTime.now();

    fechaInicio=DateTime(
      hoy.year,
      hoy.month,
      1,
    ).obs;

    fechaFin=DateTime(
      hoy.year,
      hoy.month,
      hoy.day,
    ).obs;

    scrollController.addListener(_onScroll);

    _inicializarPantalla();
  }

  Future<void> _inicializarPantalla()async{
    if(_inicializando){
      return;
    }

    _inicializando=true;
    flujoInicialFinalizado.value=false;

    try{
      final Pendiente? pendiente=
      await verificarOperativoPendiente();

      if(
      pendiente!=null &&
          pendiente.idHdrEvento>0
      ){
        operativoPendiente.value=pendiente;
        listModulos.clear();
        return;
      }

      operativoPendiente.value=null;

      await getModulosPermitidos();
    }catch(e,stackTrace){
      debugPrint(
        'ERROR INICIALIZANDO MENU SIIPNE: $e',
      );
      debugPrint('$stackTrace');
    }finally{
      flujoInicialFinalizado.value=true;
      _inicializando=false;
    }
  }

  // ============================================================
  // OPERATIVO PENDIENTE
  // ============================================================

  Future<Pendiente?> verificarOperativoPendiente()async{
    try{
      peticionServerState.value=true;

      final Pendiente pendiente=
      await siipneMovilUseCase.consultaPendiente(
        request:GetOperativosPendientesRequest(
          idGenPersona:user.idGenPersona,
          idGenUsuario:user.idGenUsuario,
        ),
      );

      if(pendiente.idHdrEvento<=0){
        operativoPendiente.value=null;
        return null;
      }

      operativoPendiente.value=pendiente;

      return pendiente;
    }catch(e){
      debugPrint(
        'NO EXISTE OPERATIVO PENDIENTE O NO FUE POSIBLE CONSULTARLO: $e',
      );

      operativoPendiente.value=null;

      return null;
    }finally{
      peticionServerState.value=false;
    }
  }

  void continuarOperativoPendiente(){
    final Pendiente? pendiente=
        operativoPendiente.value;

    if(
    pendiente==null ||
        pendiente.idHdrEvento<=0
    ){
      return;
    }

    Get.offAllNamed(
      SiipneMovilRoutes.OPERATIVOS_SERVICIO_URBANO,
      arguments:{
        "tipoAcceso":"PENDIENTE",
        "pendiente":pendiente,
        "idHdrEvento":pendiente.idHdrEvento,
        "idGenGeoSenplades":pendiente.idGenGeoSenplades,
        "idOperativo":pendiente.idTipoOperativo,
      },
    );
  }

  // ============================================================
  // MÓDULOS
  // ============================================================

  Future<void> getModulosPermitidos()async{
    try{
      peticionServerState.value=true;

      final List<DataModulo> data=
      await siipneMovilUseCase.getModulos(
        request:GetPermisosModulosRequest(
          idGenUsuario:user.idGenUsuario,
          idGenPersona:user.idGenPersona,
        ),
      );

      listModulos.assignAll(data);

      _actualizarIndicador();
    }catch(e,stackTrace){
      listModulos.clear();

      debugPrint(
        'ERROR CONSULTANDO MÓDULOS: $e',
      );
      debugPrint('$stackTrace');
    }finally{
      peticionServerState.value=false;
    }
  }

  void goToNextPage(DataModulo modulo){
    if(peticionServerState.value){
      return;
    }

    Get.toNamed(
      SiipneMovilRoutes.TIPOS_OPERATIVOS,
      arguments:{
        "modulo":modulo,
      },
    );
  }

  // ============================================================
  // FECHAS
  // ============================================================

  void cambiarFechaInicio(DateTime fecha){
    fechaInicio.value=DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
    );
  }

  void cambiarFechaFin(DateTime fecha){
    fechaFin.value=DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
    );
  }

  String fechaFormato(DateTime fecha){
    final String mes=
    fecha.month.toString().padLeft(2,'0');

    final String dia=
    fecha.day.toString().padLeft(2,'0');

    return '${fecha.year}-$mes-$dia';
  }

  String fechaVisual(DateTime fecha){
    final String mes=
    fecha.month.toString().padLeft(2,'0');

    final String dia=
    fecha.day.toString().padLeft(2,'0');

    return '$dia/$mes/${fecha.year}';
  }

  bool validarFechas(){
    mensajeErrorOperativos='';

    if(fechaInicio.value.isAfter(fechaFin.value)){
      mensajeErrorOperativos=
      'La fecha inicial no puede ser mayor a la fecha final.';

      return false;
    }

    return true;
  }

  // ============================================================
  // CONSULTAR OPERATIVOS DEL USUARIO
  // ============================================================

  Future<bool> consultarOperativosUsuario()async{
    if(
    consultandoOperativos.value ||
        descargandoPdf.value
    ){
      return false;
    }

    mensajeErrorOperativos='';

    if(!validarFechas()){
      return false;
    }

    consultandoOperativos.value=true;

    try{
      final GetDatosOperativoUsuarioRequest request=
      GetDatosOperativoUsuarioRequest(
        idGenUsuario:user.idGenUsuario,
        fechaInicio:fechaFormato(fechaInicio.value),
        fechaFin:fechaFormato(fechaFin.value),
      );

      debugPrint('==========================================');
      debugPrint('CONSULTA OPERATIVOS USUARIO');
      debugPrint('USUARIO: ${user.idGenUsuario}');
      debugPrint(
        'DESDE: ${request.fechaInicio}',
      );
      debugPrint(
        'HASTA: ${request.fechaFin}',
      );
      debugPrint('==========================================');

      final List<DataOperativosUsuario> resultado=
      await siipneMovilUseCase.consultarOperativosUsuario(
        request:request,
      );

      /*
       * Por seguridad volvemos a ordenar desde el móvil.
       * El más reciente queda primero.
       */
      resultado.sort(
            (
            DataOperativosUsuario a,
            DataOperativosUsuario b,
            ){
          final DateTime? fa=
          DateTime.tryParse(a.fechaEvento);

          final DateTime? fb=
          DateTime.tryParse(b.fechaEvento);

          if(fa==null || fb==null){
            return b.idHdrEvento.compareTo(
              a.idHdrEvento,
            );
          }

          return fb.compareTo(fa);
        },
      );

      operativosUsuario.assignAll(resultado);

      return true;
    }catch(e,stackTrace){
      operativosUsuario.clear();

      mensajeErrorOperativos=
      'No fue posible consultar los operativos del período seleccionado.';

      debugPrint(
        'ERROR CONSULTANDO OPERATIVOS USUARIO: $e',
      );
      debugPrint('$stackTrace');

      return false;
    }finally{
      consultandoOperativos.value=false;
    }
  }

  void limpiarConsultaOperativos(){
    operativosUsuario.clear();
    mensajeErrorOperativos='';

    final DateTime hoy=DateTime.now();

    fechaInicio.value=DateTime(
      hoy.year,
      hoy.month,
      1,
    );

    fechaFin.value=DateTime(
      hoy.year,
      hoy.month,
      hoy.day,
    );
  }

  // ============================================================
  // PDF
  // ============================================================
  Future<String?> descargarPdfOperativo(
      DataOperativosUsuario operativo,
      )async{
    if(
    descargandoPdf.value ||
        consultandoOperativos.value
    ){
      return null;
    }

    if(operativo.idHdrEvento<=0){
      mensajeErrorPdf=
      'El número del operativo no es válido.';

      return null;
    }

    if(user.idGenUsuario<=0){
      mensajeErrorPdf=
      'No se pudo identificar al usuario autenticado.';

      return null;
    }

    mensajeErrorPdf='';

    descargandoPdf.value=true;

    idOperativoDescargando.value=
        operativo.idHdrEvento;

    try{
      debugPrint('==========================================');
      debugPrint('DESCARGANDO REPORTE OPERATIVO');
      debugPrint(
        'ID USUARIO: ${user.idGenUsuario}',
      );
      debugPrint(
        'ID HDR EVENTO: ${operativo.idHdrEvento}',
      );
      debugPrint('==========================================');

      final String filePath=
      await siipneMovilUseCase.downloadPdfOperativo(
        idGenUsuario:user.idGenUsuario,
        idHdrEvento:operativo.idHdrEvento,
      );

      if(filePath.trim().isEmpty){
        mensajeErrorPdf=
        'No fue posible obtener el archivo PDF.';

        return null;
      }

      return filePath;
    }catch(e,stackTrace){
      mensajeErrorPdf=
      'No fue posible descargar el reporte del operativo.';

      debugPrint(
        'ERROR DESCARGANDO PDF: $e',
      );
      debugPrint('$stackTrace');

      return null;
    }finally{
      descargandoPdf.value=false;
      idOperativoDescargando.value=null;
    }
  }

  // ============================================================
  // CERRAR SESIÓN
  // ============================================================

  void cerrarSesion(){
    if(
    peticionServerState.value ||
        consultandoOperativos.value ||
        descargandoPdf.value
    ){
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    debugPrint('==========================================');
    debugPrint('CERRANDO SESIÓN SIIPNE MÓVIL');
    debugPrint(
      'ID USUARIO: ${user.idGenUsuario}',
    );
    debugPrint('==========================================');

    Get.offAllNamed(
      AppRoutes.SPLASH_APP,
    );
  }

  // ============================================================
  // SCROLL
  // ============================================================

  void _onScroll(){
    _actualizarIndicador();
  }

  void _actualizarIndicador(){
    if(!scrollController.hasClients){
      mostrarIndicador.value=false;
      return;
    }

    mostrarIndicador.value=
        scrollController.position.maxScrollExtent>0 &&
            scrollController.position.pixels<
                scrollController.position.maxScrollExtent-15;
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  void onClose(){
    scrollController.removeListener(_onScroll);
    scrollController.dispose();

    super.onClose();
  }
}