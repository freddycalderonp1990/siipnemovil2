part of '../../pages.dart';

mixin CabeceraMigracionViewMixin on OpMigracionPageBase {
  Widget cabeceraMigracion() {
    return Obx(() {
      final bool anexado = controller.esOperativoAnexado.value;
      final bool pendiente = controller.esOperativoPendiente.value;
      final String estado = anexado
          ? 'ANEXADO'
          : pendiente
              ? 'RETOMADO'
              : 'APERTURADO';

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(6, 4, 6, 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: _MigracionColors.borde),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: _MigracionColors.azul.withOpacity(.10),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(11, 10, 11, 11),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    _MigracionColors.azul,
                    _MigracionColors.azulOscuro,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.14),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: Colors.white.withOpacity(.18),
                          ),
                        ),
                        child: const Icon(
                          Icons.public_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 9),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'OPERATIVO MÓVIL MIGRACIÓN',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .25,
                              ),
                            ),
                            SizedBox(height: 3),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.security_rounded,
                                  color: Color(0xFFDCECFB),
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'CONSULTA MIGRATORIA AUDITADA',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(0xFFDCECFB),
                                      fontSize: 7,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.14),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          estado,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 6.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.13),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: Colors.white.withOpacity(.18)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.numbers_rounded,
                            color: _MigracionColors.azul,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'OPERATIVO N.° ${controller.idHdrEventoActual.value}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                controller.nombreOperativoActual.value
                                    .toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(.78),
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF70E7A5),
                          size: 21,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                height: 43,
                child: OutlinedButton.icon(
                  onPressed: controller.peticionServerState.value
                      ? null
                      : _confirmarSalidaMigracion,
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text(
                    'SALIR DEL MÓDULO',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF586D82),
                    side: const BorderSide(color: Color(0xFFD5DFE8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _confirmarSalidaMigracion() {
    final BuildContext? context = Get.context;
    if (context == null) return;

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'SALIR DEL MÓDULO',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          ),
          content: const Text(
            '¿Desea salir de Móvil Migración y regresar al menú operativo?',
            style: TextStyle(fontSize: 11),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('CANCELAR'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Get.back<void>();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _MigracionColors.azul,
                foregroundColor: Colors.white,
              ),
              child: const Text('SALIR'),
            ),
          ],
        );
      },
    );
  }
}
