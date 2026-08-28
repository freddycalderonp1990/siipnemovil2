part of '../../pages.dart';

mixin AccionesOperativoMigracionViewMixin on OpMigracionPageBase {
  Widget accionesOperativoMigracion() {
    return Obx(() {
      final bool bloqueado = controller.peticionServerState.value;
      final bool puedeFinalizar = controller.puedeFinalizarOperativo.value;

      return _MigracionCard(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(3, 1, 3, 7),
              child: Text(
                'GESTIÓN DEL OPERATIVO',
                style: TextStyle(
                  color: _MigracionColors.textoSuave,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .4,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: _botonGestionMigracion(
                    titulo: 'PERSONAL',
                    icono: Icons.groups_2_rounded,
                    color: _MigracionColors.verde,
                    fondo: const Color(0xFFEAF7F0),
                    borde: const Color(0xFFB8DFC9),
                    onTap: bloqueado ? null : mostrarPersonalOperativo,
                  ),
                ),
                if (puedeFinalizar) ...<Widget>[
                  const SizedBox(width: 6),
                  Expanded(
                    child: _botonGestionMigracion(
                      titulo: 'QR',
                      icono: Icons.qr_code_2_rounded,
                      color: _MigracionColors.azul,
                      fondo: const Color(0xFFEAF3FC),
                      borde: const Color(0xFFB6CFE5),
                      onTap: bloqueado ? null : mostrarQrOperativo,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _botonGestionMigracion(
                      titulo: 'FINALIZAR',
                      icono: Icons.edgesensor_low_sharp,
                      color: _MigracionColors.rojo,
                      fondo: const Color(0xFFFFECE9),
                      borde: const Color(0xFFE9BBB7),
                      onTap: bloqueado ? null : mostrarFinalizarOperativo,
                    ),
                  ),
                ],
                const SizedBox(width: 6),
                Expanded(
                  child: _botonGestionMigracion(
                    titulo: 'SALIR',
                    icono: Icons.logout_rounded,
                    color: const Color(0xFF586D82),
                    fondo: const Color(0xFFF3F6F9),
                    borde: const Color(0xFFD5DFE8),
                    onTap: bloqueado ? null : confirmarCerrarSesion,
                  ),
                ),
              ],
            ),
            if (controller.esOperativoAnexado.value) ...<Widget>[
              const SizedBox(height: 7),
              const Row(
                children: <Widget>[
                  Icon(
                    Icons.info_outline_rounded,
                    size: 13,
                    color: _MigracionColors.textoSuave,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Como servidor anexado puede consultar personal y salir; solo el responsable puede generar QR o finalizar.',
                      style: TextStyle(
                        color: _MigracionColors.textoSuave,
                        fontSize: 7.2,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _botonGestionMigracion({
    required String titulo,
    required IconData icono,
    required Color color,
    required Color fondo,
    required Color borde,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: fondo,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height:55,
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borde),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icono, color: onTap == null ? color.withOpacity(.4) : color, size: 22),
              const SizedBox(height: 4),
              Text(
                titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: onTap == null ? color.withOpacity(.4) : color,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void confirmarCerrarSesion() {
    final BuildContext? context = Get.context;
    if (context == null || controller.peticionServerState.value) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.68),
      builder: (BuildContext dialogContext) => _MigracionDialog(
        icono: Icons.logout_rounded,
        titulo: 'CERRAR SESIÓN',
        subtitulo: 'El operativo permanecerá activo y podrá retomarse.',
        colorInicio: const Color(0xFF52687C),
        colorFin: const Color(0xFF273E52),
        maxHeightFactor: .52,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD5DFE8)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.shield_outlined, color: Color(0xFF52687C)),
                    SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        '¿Está seguro de cerrar la sesión actual? No se finalizará el operativo ni se perderán las consultas registradas.',
                        style: TextStyle(
                          color: _MigracionColors.texto,
                          fontSize: 10,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('CANCELAR'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        controller.cerrarSesionOperativo();
                      },
                      icon: const Icon(Icons.logout_rounded, size: 17),
                      label: const Text('SALIR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF52687C),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
