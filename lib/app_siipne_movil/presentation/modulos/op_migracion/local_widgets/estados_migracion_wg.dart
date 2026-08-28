part of '../../pages.dart';

mixin EstadosMigracionViewMixin on OpMigracionPageBase {
  Widget estadoInicialMigracion() {
    return _MigracionCard(
      color: const Color(0xFFF7FAFD),
      child: Column(
        children: <Widget>[
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              color: Color(0xFFE7F1FB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.travel_explore_rounded,
              color: _MigracionColors.azul,
              size: 32,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'CONSULTA MIGRATORIA',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _MigracionColors.texto,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'La información biográfica, documentos, movimientos y visas se mostrará en cards independientes.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _MigracionColors.textoSuave,
              fontSize: 8.5,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget operativoMigracionInvalido() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE9BBB7)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: _MigracionColors.rojo.withOpacity(.08),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFECE9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.block_rounded,
                  color: _MigracionColors.rojo,
                  size: 35,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'MÓDULO NO DISPONIBLE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _MigracionColors.texto,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                controller.mensajeDatosOperativo.isEmpty
                    ? 'Esta pantalla solo puede mostrarse para el tipo Móvil Migración.'
                    : controller.mensajeDatosOperativo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _MigracionColors.textoSuave,
                  fontSize: 9.5,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () => Get.back<void>(),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text(
                    'REGRESAR',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _MigracionColors.azul,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
