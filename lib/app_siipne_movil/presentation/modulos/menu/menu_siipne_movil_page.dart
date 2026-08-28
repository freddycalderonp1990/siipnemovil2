part of '../pages.dart';

class MenuSiipneMovilPage extends StatefulWidget {
  const MenuSiipneMovilPage({Key? key}) : super(key: key);

  @override
  State<MenuSiipneMovilPage> createState() => _MenuSiipneMovilPageState();
}

class _MenuSiipneMovilPageState extends State<MenuSiipneMovilPage> {
  final MenuSiipneMovilController controller =
  Get.find<MenuSiipneMovilController>();

  bool _dialogoPendienteMostrado = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      context.read<NotificationsBloc>().requestPermission(
        appName: NamApps.SiipneMovil,
        idGenUsuario: controller.user.idGenUsuario,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.flujoInicialFinalizado.value) {
        return _pantallaVerificando();
      }

      final Pendiente? pendiente = controller.operativoPendiente.value;

      if (pendiente != null && pendiente.idHdrEvento > 0) {
        if (!_dialogoPendienteMostrado) {
          _dialogoPendienteMostrado = true;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            final Pendiente? pendienteActual =
                controller.operativoPendiente.value;

            if (pendienteActual == null || pendienteActual.idHdrEvento <= 0) {
              _dialogoPendienteMostrado = false;
              return;
            }

            _mostrarOperativoPendiente(pendienteActual);
          });
        }

        return _pantallaFondoPendiente();
      }

      _dialogoPendienteMostrado = false;

      return WorkAreaPageSiipneMovilWidget(
        showGps: true,
        mostrarBtnAtras: false,
        contenidoExpandido: true,
        title: "PERMISOS DE APLICACIONES",
        contenido: _getContenido(),
        imgPerfil: true,
        peticionServer: controller.peticionServerState,
      );
    });
  }

  // ============================================================
  // CARGANDO
  // ============================================================

  Widget _pantallaVerificando() {
    return WorkAreaPageSiipneMovilWidget(
      showGps: false,
      mostrarBtnAtras: false,
      contenidoExpandido: true,
      title: null,
      imgPerfil: false,
      peticionServer: controller.peticionServerState,
      contenido: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 34,
              height: 34,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.colorAzul,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "VERIFICANDO INFORMACIÓN...",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.colorAzul,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: .4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pantallaFondoPendiente() {
    return WorkAreaPageSiipneMovilWidget(
      showGps: false,
      mostrarBtnAtras: false,
      contenidoExpandido: true,
      title: null,
      imgPerfil: false,
      peticionServer: controller.peticionServerState,
      contenido: const SizedBox.expand(),
    );
  }

  // ============================================================
  // CONTENIDO
  // ============================================================

  Widget _getContenido() {
    final ResponsiveUtil responsive = ResponsiveUtil();

    return SizedBox.expand(
      child: Stack(
        children: [
          Column(
            children: [
              _cardUsuario(responsive),

              SizedBox(height: responsive.altoP(.7)),

              Expanded(child: _getMenu()),

              _accionesMenu(),

              SizedBox(height: responsive.altoP(.4)),
            ],
          ),

          Obx(() {
            if (!controller.mostrarIndicador.value) {
              return const SizedBox.shrink();
            }

            return Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: IndicadorScroll(),
            );
          }),
        ],
      ),
    );
  }

  // ============================================================
  // DATOS USUARIO
  // ============================================================

  Widget _cardUsuario(ResponsiveUtil responsive) {
    final user = controller.user;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        responsive.anchoP(1.5),
        responsive.altoP(.6),
        responsive.anchoP(1.5),
        responsive.altoP(.4),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD7E2EE)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D4C9C).withOpacity(.08),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: responsive.anchoP(3),
                vertical: responsive.altoP(.75),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF0D4C9C), Color(0xFF173E6B)],
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.security_rounded,
                    color: Colors.white,
                    size: 17,
                  ),

                  const SizedBox(width: 7),

                  const Expanded(
                    child: Text(
                      "DATOS SERVIDOR POLICIAL AUTENTICADO",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .5,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF8BF0B5),
                          size: 13,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "ACTIVO",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.anchoP(3),
                vertical: responsive.altoP(1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0D4C9C),
                        width: 2,
                      ),
                    ),
                    child: ImgPerfilRedonda(
                      size: responsive.diagonalP(2),
                      img: user.foto,
                    ),
                  ),

                  SizedBox(width: responsive.anchoP(2.5)),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.nombres.trim().isEmpty
                              ? "SERVIDOR POLICIAL"
                              : user.nombres.trim(),
                          style: const TextStyle(
                            color: Color(0xFF1F2937),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Wrap(
                          spacing: 6,
                          runSpacing: 5,
                          children: [
                            _miniDato(
                              icon: Icons.credit_card_rounded,
                              texto: user.documento,
                            ),
                            _miniDato(
                              icon: Icons.person_outline_rounded,
                              texto: user.nombreUsuario,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: responsive.anchoP(3)),
              height: 2,
              color: const Color(0xFFE8EDF3),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                responsive.anchoP(3),
                responsive.altoP(.7),
                responsive.anchoP(3),
                responsive.altoP(.9),
              ),
              child: Column(
                children: [
                  /*  _datoHorizontal(
                    icon: Icons.apartment_rounded,
                    titulo: "UNIDAD",
                    valor: user.unidad,
                  ),*/
                  const SizedBox(height: 2),
                  _datoHorizontal(
                    icon: Icons.work_outline_rounded,
                    titulo: "FUNCIÓN",
                    valor: user.funcion,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniDato({required IconData icon, required String texto}) {
    final String valor = texto.trim().isEmpty ? "NO REGISTRADO" : texto.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6FC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDCE7F3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF0D4C9C)),
          const SizedBox(width: 4),
          Text(
            valor,
            style: const TextStyle(
              color: Color(0xFF40536A),
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _datoHorizontal({
    required IconData icon,
    required String titulo,
    required String valor,
  }) {
    final String dato = valor.trim().isEmpty ? "NO REGISTRADO" : valor.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF0D4C9C), size: 15),
        ),

        const SizedBox(width: 8),

        SizedBox(
          width: 52,
          child: Text(
            titulo,
            style: const TextStyle(
              color: Color(0xFF8793A3),
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(width: 4),

        Expanded(
          child: Text(
            dato,
            style: const TextStyle(
              color: Color(0xFF263548),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MENÚ MÓDULOS
  // ============================================================

  Widget _getMenu() {
    return Obx(() {
      final modulos = controller.listModulos;

      if (modulos.isEmpty) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.apps_outlined, color: Colors.grey, size: 42),
              SizedBox(height: 10),
              Text(
                "No existen módulos disponibles",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          const double separacion = 10;
          const double margenHorizontal = 5;

          final double anchoDisponible =
              constraints.maxWidth - (margenHorizontal * 2);

          final double anchoItem = (anchoDisponible - separacion) / 2;

          final bool impar = modulos.length.isOdd;

          final int limite = impar ? modulos.length - 1 : modulos.length;

          return ListView(
            controller: controller.scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              margenHorizontal,
              4,
              margenHorizontal,
              15,
            ),
            children: [
              Wrap(
                spacing: separacion,
                runSpacing: separacion,
                children: [
                  for (int i = 0; i < limite; i++)
                    SizedBox(
                      width: anchoItem,
                      height: 150,
                      child: _itemModulo(modulos[i]),
                    ),
                ],
              ),

              if (impar) ...[
                const SizedBox(height: 10),

                Center(
                  child: SizedBox(
                    width: anchoItem,
                    height: 150,
                    child: _itemModulo(modulos.last),
                  ),
                ),
              ],
            ],
          );
        },
      );
    });
  }

  Widget _itemModulo(DataModulo modulo) {
    return BtnMenuSiipneMovilWidget(
      cuadrado: true,
      horizontal: false,
      colorFondo: Colors.white,
      img: AppSiipneMovilImages.ic_operativos_su,
      title: modulo.descripcion,
      descripcion: modulo.detalle,
      onTap: () => controller.goToNextPage(modulo),
    );
  }

  // ============================================================
  // ACCIONES INFERIORES
  // ============================================================

  Widget _accionesMenu() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
      child: Row(
        children: [
          Expanded(
            child: _botonAccion(
              icon: Icons.picture_as_pdf_rounded,
              titulo: "MIS OPERATIVOS",
              subtitulo: "REPORTES PDF",
              color: const Color(0xFF195BA6),
              onTap: _mostrarDialogoOperativos,
            ),
          ),

          const SizedBox(width: 7),

          Expanded(
            child: _botonAccion(
              icon: Icons.logout_rounded,
              titulo: "CERRAR SESIÓN",
              subtitulo: "SALIR DEL SISTEMA",
              color: const Color(0xFFB42318),
              onTap: _confirmarCerrarSesion,
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonAccion({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(.30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: color.withOpacity(.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: color,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF7A8998),
                        fontSize: 6.7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DIÁLOGO HISTÓRICO OPERATIVOS
  // ============================================================

  Future<void> _mostrarDialogoOperativos() async {
    controller.limpiarConsultaOperativos();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.65),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 18,
          ),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(dialogContext).size.height * .88,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _cabeceraDialogoOperativos(dialogContext),

                _filtrosOperativos(),

                Expanded(child: _resultadoOperativos()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cabeceraDialogoOperativos(BuildContext dialogContext) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 9, 5, 9),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.history_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 8),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MIS OPERATIVOS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "Consulta y visualización de reportes",
                  style: TextStyle(
                    color: Color(0xFFDCEBFA),
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _filtrosOperativos() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F9FC),
        border: Border(bottom: BorderSide(color: Color(0xFFDCE5ED))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _selectorFecha(
                  titulo: "DESDE",
                  icon: Icons.calendar_today_rounded,
                  fecha: controller.fechaInicio,
                  onTap: () => _seleccionarFecha(inicio: true),
                ),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: _selectorFecha(
                  titulo: "HASTA",
                  icon: Icons.event_available_rounded,
                  fecha: controller.fechaFin,
                  onTap: () => _seleccionarFecha(inicio: false),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 43,
            child: Obx(() {
              final bool cargando = controller.consultandoOperativos.value;

              return ElevatedButton.icon(
                onPressed: cargando ? null : _buscarOperativos,
                icon: cargando
                    ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.search_rounded, size: 19),
                label: Text(
                  cargando ? "BUSCANDO..." : "BUSCAR OPERATIVOS",
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF195BA6),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF86A8C7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  elevation: 0,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _selectorFecha({
    required String titulo,
    required IconData icon,
    required Rx<DateTime> fecha,
    required VoidCallback onTap,
  }) {
    return Obx(
          () => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: const Color(0xFFD4E0EB)),
            ),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF195BA6), size: 17),

                const SizedBox(width: 6),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          color: Color(0xFF8292A3),
                          fontSize: 6.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        controller.fechaVisual(fecha.value),
                        style: const TextStyle(
                          color: Color(0xFF2A4057),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF8A9AAA),
                  size: 17,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _seleccionarFecha({required bool inicio}) async {
    final DateTime actual = inicio
        ? controller.fechaInicio.value
        : controller.fechaFin.value;

    final DateTime? seleccionada = await showDatePicker(
      context: context,
      initialDate: actual,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime.now(),
      helpText: inicio ? "SELECCIONE FECHA DESDE" : "SELECCIONE FECHA HASTA",
      cancelText: "CANCELAR",
      confirmText: "ACEPTAR",
    );

    if (seleccionada == null) {
      return;
    }

    if (inicio) {
      controller.cambiarFechaInicio(seleccionada);
    } else {
      controller.cambiarFechaFin(seleccionada);
    }
  }

  Future<void> _buscarOperativos() async {
    final bool resultado = await controller.consultarOperativosUsuario();

    if (!resultado) {
      DialogosAwesome.getError(
        title: "CONSULTA NO REALIZADA",
        descripcion: controller.mensajeErrorOperativos.isEmpty
            ? "No fue posible consultar los operativos."
            : controller.mensajeErrorOperativos,
      );
    }
  }

  // ============================================================
  // RESULTADOS
  // ============================================================

  Widget _resultadoOperativos() {
    return Obx(() {
      if (controller.consultandoOperativos.value) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                strokeWidth: 2.8,
                color: Color(0xFF195BA6),
              ),
              SizedBox(height: 10),
              Text(
                "CONSULTANDO OPERATIVOS...",
                style: TextStyle(
                  color: Color(0xFF60778D),
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        );
      }

      final List<DataOperativosUsuario> datos = controller.operativosUsuario;

      if (datos.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.manage_search_rounded,
                  color: Color(0xFF9AA9B7),
                  size: 42,
                ),
                SizedBox(height: 8),
                Text(
                  "SELECCIONE EL RANGO DE FECHAS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF52687C),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Los operativos en los que participó aparecerán en esta sección.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8A99A8),
                    fontSize: 8,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            color: const Color(0xFFF2F6FA),
            child: Row(
              children: [
                const Icon(
                  Icons.assignment_turned_in_outlined,
                  color: Color(0xFF195BA6),
                  size: 15,
                ),
                const SizedBox(width: 5),
                Text(
                  "${datos.length} OPERATIVO${datos.length == 1 ? '' : 'S'} ENCONTRADO${datos.length == 1 ? '' : 'S'}",
                  style: const TextStyle(
                    color: Color(0xFF52687C),
                    fontSize: 7.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 7,
                mainAxisSpacing: 7,
                childAspectRatio: .83,
              ),
              itemCount: datos.length,
              itemBuilder: (context, index) {
                return _cardOperativo(datos[index]);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _cardOperativo(DataOperativosUsuario data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD7E2EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF195BA6), Color(0xFF0D4A85)],
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_police_outlined,
                  color: Colors.white,
                  size: 16,
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: Text(
                    "#${data.idHdrEvento}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                const Icon(
                  Icons.verified_rounded,
                  color: Color(0xFF9CE7B8),
                  size: 14,
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.tipoOperativo.trim().isEmpty
                        ? "OPERATIVO"
                        : data.tipoOperativo.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF27445F),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 6),

                  _datoGrid(Icons.calendar_month_outlined, data.fechaEvento),

                  _datoGrid(Icons.location_city_outlined, data.distrito),

                  _datoGrid(Icons.route_outlined, data.circuito),

                  _datoGrid(Icons.location_on_outlined, data.subcircuito),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: Obx(() {
                      final bool cargando =
                          controller.descargandoPdf.value &&
                              controller.idOperativoDescargando.value ==
                                  data.idHdrEvento;

                      return ElevatedButton.icon(
                        onPressed: controller.descargandoPdf.value
                            ? null
                            : () => _abrirPdf(data),
                        icon: cargando
                            ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Icon(
                          Icons.picture_as_pdf_rounded,
                          size: 16,
                        ),
                        label: Text(
                          cargando ? "CARGANDO" : "VER PDF",
                          style: const TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB42318),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFCC8C87),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _datoGrid(IconData icon, String valor) {
    final String texto = valor.trim().isEmpty ? "NO REGISTRADO" : valor.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF7890A5), size: 11),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              texto,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF63778A),
                fontSize: 6.7,
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _abrirPdf(DataOperativosUsuario operativo) async {
    final String? path = await controller.descargarPdfOperativo(operativo);

    if (path == null || path.trim().isEmpty) {
      DialogosAwesome.getError(
        title: "REPORTE NO DISPONIBLE",
        descripcion: controller.mensajeErrorPdf.isEmpty
            ? "No fue posible obtener el reporte."
            : controller.mensajeErrorPdf,
      );
      return;
    }

    debugPrint('==========================================');
    debugPrint('VISUALIZANDO PDF DENTRO DE LA APP');
    debugPrint('OPERATIVO: ${operativo.idHdrEvento}');
    debugPrint('PATH: $path');
    debugPrint('==========================================');

    if (!mounted) return;

    await _mostrarPdfInterno(path: path, operativo: operativo);
  }

  Future<void> _mostrarPdfInterno({
    required String path,
    required DataOperativosUsuario operativo,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.80),
      builder: (BuildContext dialogContext) {
        int paginaActual = 0;
        int totalPaginas = 0;
        bool cargando = true;
        String mensajeError = '';

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.fromLTRB(7, 12, 7, 12),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .94,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(18),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // ==================================================
                    // CABECERA
                    // ==================================================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(12, 9, 5, 9),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.14),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.picture_as_pdf_rounded,
                              color: Colors.white,
                              size: 21,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "REPORTE DEL OPERATIVO",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),

                                const SizedBox(height: 1),

                                Text(
                                  "#${operativo.idHdrEvento} · ${operativo.tipoOperativo}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFFDCEBFA),
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            tooltip: "Cerrar",
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ==================================================
                    // INFORMACIÓN
                    // ==================================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFD6DFE8)),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Color(0xFF195BA6),
                            size: 14,
                          ),

                          const SizedBox(width: 5),

                          Expanded(
                            child: Text(
                              operativo.fechaEvento,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF53687B),
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          if (totalPaginas > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF2FC),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${paginaActual + 1} / $totalPaginas",
                                style: const TextStyle(
                                  color: Color(0xFF195BA6),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // ==================================================
                    // PDF
                    // ==================================================
                    Expanded(
                      child: Stack(
                        children: [
                          if (mensajeError.isEmpty)
                            PDFView(
                              filePath: path,

                              enableSwipe: true,

                              swipeHorizontal: false,

                              autoSpacing: true,

                              pageFling: true,

                              pageSnap: true,

                              fitPolicy: FitPolicy.BOTH,

                              preventLinkNavigation: false,

                              onRender: (int? paginas) {
                                if (!dialogContext.mounted) {
                                  return;
                                }

                                setStateDialog(() {
                                  totalPaginas = paginas ?? 0;
                                  cargando = false;
                                });

                                debugPrint(
                                  'PDF RENDERIZADO -> '
                                      '${paginas ?? 0} páginas',
                                );
                              },

                              onPageChanged: (int? pagina, int? total) {
                                if (!dialogContext.mounted) {
                                  return;
                                }

                                setStateDialog(() {
                                  paginaActual = pagina ?? 0;

                                  if (total != null) {
                                    totalPaginas = total;
                                  }
                                });
                              },

                              onError: (dynamic error) {
                                debugPrint('ERROR VISOR PDF: $error');

                                if (!dialogContext.mounted) {
                                  return;
                                }

                                setStateDialog(() {
                                  cargando = false;
                                  mensajeError =
                                  'No fue posible visualizar el documento PDF.';
                                });
                              },

                              onPageError: (int? pagina, dynamic error) {
                                debugPrint(
                                  'ERROR PÁGINA PDF '
                                      '$pagina: $error',
                                );
                              },
                            ),

                          if (cargando)
                            Container(
                              color: const Color(0xFFF2F4F7),
                              child: const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.7,
                                        color: Color(0xFF195BA6),
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    Text(
                                      "PREPARANDO REPORTE...",
                                      style: TextStyle(
                                        color: Color(0xFF60778D),
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          if (mensajeError.isNotEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 58,
                                      height: 58,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFECEA),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.picture_as_pdf_outlined,
                                        color: Color(0xFFB42318),
                                        size: 31,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    const Text(
                                      "NO SE PUDO MOSTRAR EL PDF",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF34495E),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      mensajeError,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF788A9C),
                                        fontSize: 9,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // ==================================================
                    // PIE
                    // ==================================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(9, 7, 9, 7),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Color(0xFFD6DFE8)),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.zoom_in_map_rounded,
                                  color: Color(0xFF73869A),
                                  size: 14,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    "Use dos dedos para ampliar el documento",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(0xFF73869A),
                                      fontSize: 7,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 7),

                          SizedBox(
                            height: 34,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              icon: const Icon(Icons.close_rounded, size: 15),
                              label: const Text(
                                "CERRAR",
                                style: TextStyle(
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF195BA6),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // CERRAR SESIÓN
  // ============================================================

  void _confirmarCerrarSesion() {
    FocusManager.instance.primaryFocus?.unfocus();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xD9061C35),
      useSafeArea: true,
      builder: (BuildContext dialogContext) {
        final MediaQueryData mediaQuery = MediaQuery.of(dialogContext);
        final double altoDisponible =
            mediaQuery.size.height -
                mediaQuery.viewInsets.bottom -
                mediaQuery.padding.vertical -
                32;
        final double altoMaximo = altoDisponible
            .clamp(260.0, mediaQuery.size.height)
            .toDouble();

        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: altoMaximo),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(1.2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFF7E93A6),
                    Color(0xFF294A68),
                    Color(0xFF38BDF8),
                  ],
                ),
                borderRadius: BorderRadius.circular(23),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x66061C35),
                    blurRadius: 28,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Material(
                  color: const Color(0xFFF0F4F7),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Color(0xFF061C35),
                                Color(0xFF163B5B),
                                Color(0xFF455F76),
                              ],
                            ),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                right: 34,
                                top: -20,
                                child: Icon(
                                  Icons.power_settings_new_rounded,
                                  color: Colors.white.withOpacity(.045),
                                  size: 96,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.11),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(.20),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.logout_rounded,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 11),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "SIIPNE MÓVIL // SESIÓN SEGURA",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Color(0xFFB8DDF4),
                                            fontSize: 7.4,
                                            letterSpacing: .55,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "CERRAR SESIÓN",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            height: 1.1,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Finalización controlada del acceso actual",
                                          style: TextStyle(
                                            color: Color(0xFFD3E2EC),
                                            fontSize: 8,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: "Cancelar",
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
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
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 13),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FBFC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFC8D5DF),
                                  ),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                      color: Color(0x14061C35),
                                      blurRadius: 13,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 3,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF536C82),
                                          borderRadius:
                                          BorderRadius.circular(4),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF536C82)
                                              .withOpacity(.10),
                                          borderRadius:
                                          BorderRadius.circular(11),
                                          border: Border.all(
                                            color: const Color(0xFF536C82)
                                                .withOpacity(.20),
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.person_off_outlined,
                                          color: Color(0xFF536C82),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "FINALIZAR ACCESO ACTUAL",
                                              style: TextStyle(
                                                color: Color(0xFF455F76),
                                                fontSize: 8,
                                                letterSpacing: .40,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              "¿Está seguro de cerrar la sesión actual y salir del módulo SIIPNE Móvil?",
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                color: Color(0xFF293D51),
                                                fontSize: 11.5,
                                                height: 1.42,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 11),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                      Color(0xFFE5EDF3),
                                      Color(0xFFF4F7F9),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFC1D0DC),
                                  ),
                                ),
                                child: const Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Color(0x14536C82),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.lock_outline_rounded,
                                          color: Color(0xFF536C82),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 9),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "SEGURIDAD DE LA CUENTA",
                                            style: TextStyle(
                                              color: Color(0xFF455F76),
                                              fontSize: 7.8,
                                              letterSpacing: .35,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            "Para volver a ingresar deberá autenticarse nuevamente con sus credenciales institucionales.",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              color: Color(0xFF617487),
                                              fontSize: 9.3,
                                              height: 1.38,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                      },
                                      icon: const Icon(
                                        Icons.keyboard_return_rounded,
                                        size: 17,
                                      ),
                                      label: const Text(
                                        "CANCELAR",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        minimumSize:
                                        const Size.fromHeight(50),
                                        foregroundColor:
                                        const Color(0xFF617487),
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                          color: Color(0xFFB8C8D6),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(13),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                        controller.cerrarSesion();
                                      },
                                      icon: const Icon(
                                        Icons.logout_rounded,
                                        size: 17,
                                      ),
                                      label: const FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "CERRAR SESIÓN",
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 8.8,
                                            letterSpacing: .15,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize:
                                        const Size.fromHeight(50),
                                        backgroundColor:
                                        const Color(0xFF294A68),
                                        foregroundColor: Colors.white,
                                        elevation: 4,
                                        shadowColor:
                                        const Color(0x66294A68),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(13),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.verified_user_outlined,
                                    color: Color(0xFF718294),
                                    size: 11,
                                  ),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      "SALIDA SEGURA  ·  SIIPNE MÓVIL",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFF718294),
                                        fontSize: 7,
                                        letterSpacing: .32,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // OPERATIVO PENDIENTE
  // ============================================================

  Future<void> _mostrarOperativoPendiente(Pendiente pendiente) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.15),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4D8),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.assignment_late_rounded,
                    color: Color(0xFFD98A00),
                    size: 35,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "OPERATIVO PENDIENTE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF24364B),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Se ha identificado un operativo que aún se encuentra pendiente de finalizar.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8FC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFDCE5EF)),
                  ),
                  child: Column(
                    children: [
                      _datoPendiente(
                        icon: Icons.badge_outlined,
                        titulo: "OPERATIVO",
                        valor: "#${pendiente.idHdrEvento}",
                      ),

                      if (pendiente.descripcion.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),

                        _datoPendiente(
                          icon: Icons.description_outlined,
                          titulo: "DESCRIPCIÓN",
                          valor: pendiente.descripcion,
                        ),
                      ],

                      if (pendiente.fechaEvento.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),

                        _datoPendiente(
                          icon: Icons.calendar_month_rounded,
                          titulo: "FECHA",
                          valor: pendiente.fechaEvento,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Debe continuar con este operativo antes de iniciar uno nuevo.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF40536A),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();

                      controller.continuarOperativoPendiente();
                    },
                    icon: const Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 21,
                    ),
                    label: const Text(
                      "CONTINUAR OPERATIVO",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorAzul,
                      minimumSize: const Size.fromHeight(50),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _datoPendiente({
    required IconData icon,
    required String titulo,
    required String valor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FC),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: const Color(0xFF0D4C9C), size: 18),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: Color(0xFF8A98A9),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                valor.trim(),
                style: const TextStyle(
                  color: Color(0xFF293A4F),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}