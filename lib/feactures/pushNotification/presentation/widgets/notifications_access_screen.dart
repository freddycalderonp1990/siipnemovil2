import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../app/domain/enums/enums.dart';
import '../../../../feactures/user/presentation/modules/controllers.dart';
import '../../services/bloc/notifications_bloc.dart';

class NotificationsAccessScreen extends StatefulWidget {
  final Widget contenido;
  final NamApps namApps;

  const NotificationsAccessScreen({
    super.key,
    required this.contenido,
    required this.namApps,
  });

  @override
  State<NotificationsAccessScreen> createState() =>
      _NotificationsAccessScreenState();
}

class _NotificationsAccessScreenState extends State<NotificationsAccessScreen>
    with WidgetsBindingObserver {
  NotificationsBloc? _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = context.read<NotificationsBloc>();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      _bloc?.refreshPermissionStatus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _permitir(NotificationsBloc bloc) async {
    if (bloc.solicitandoPermiso.value) return;
    // Detectar iOS y continuar sin permiso NO depende de LoginController.
    // El ID se necesita únicamente si luego se registra el token en el backend.
    final id = Get.isRegistered<LoginController>()
        ? Get.find<LoginController>().user.value.idGenUsuario
        : 0;
    await bloc.requestPermission(appName: widget.namApps, idGenUsuario: id);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NotificationsBloc>();
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) => Obx(() {
        final opcional = bloc.notificacionesOpcionales;
        final omitido = bloc.omitirEnEstaSesion.value;
        final inicializando = bloc.inicializandoPermiso.value;
        final ocupado = bloc.solicitandoPermiso.value;
        final ajustes = bloc.requiereConfiguracion.value;
        final error = bloc.errorPermiso.value;

        if ((opcional && omitido) ||
            state.status == NotificationPermissionStatus.authorized ||
            state.status == NotificationPermissionStatus.provisional) {
          return widget.contenido;
        }
        if (inicializando ||
            state.status == NotificationPermissionStatus.checking) {
          return const Center(child: CircularProgressIndicator());
        }
        return _TarjetaNotificaciones(
          opcional: opcional,
          ocupado: ocupado,
          ajustes: ajustes,
          error: error,
          onPermitir: () => _permitir(bloc),
          onNoPermitir: bloc.noPermitir,
          onConfiguracion: () => bloc.abrirConfiguracion(
            appName: widget.namApps,
            idGenUsuario: Get.isRegistered<LoginController>()
                ? Get.find<LoginController>().user.value.idGenUsuario
                : 0,
          ),
        );
      }),
    );
  }
}

class _TarjetaNotificaciones extends StatelessWidget {
  final bool opcional;
  final bool ocupado;
  final bool ajustes;
  final String error;
  final VoidCallback onPermitir;
  final VoidCallback onNoPermitir;
  final VoidCallback onConfiguracion;

  const _TarjetaNotificaciones({
    required this.opcional,
    required this.ocupado,
    required this.ajustes,
    required this.error,
    required this.onPermitir,
    required this.onNoPermitir,
    required this.onConfiguracion,
  });

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF104C92);
    return Material(
      color: Colors.transparent,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFD5E4F2)),
                boxShadow: [BoxShadow(
                  color: azul.withOpacity(.12), blurRadius: 22,
                  offset: const Offset(0, 8),
                )],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(23)),
                      gradient: LinearGradient(
                        colors: [Color(0xFF092D60), Color(0xFF176FC0)],
                      ),
                    ),
                    child: Column(children: [
                      const Icon(Icons.notifications_active_rounded,
                          size: 40, color: Colors.white),
                      const SizedBox(height: 10),
                      const Text('ACTIVA TUS ALERTAS',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 19,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.16),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(opcional ? 'iOS · ACTIVACIÓN OPCIONAL' : 'NOTIFICACIONES DEL DISPOSITIVO',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white,
                                fontSize: 10, fontWeight: FontWeight.w700)),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                          opcional
                              ? 'Tú decides si deseas recibir notificaciones. Puedes utilizar la aplicación sin activarlas.'
                              : 'Activa las notificaciones para recibir novedades y alertas de tus operativos.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13,
                              height: 1.45, color: Color(0xFF53667B))),
                      const SizedBox(height: 18),
                      _beneficio(Icons.campaign_outlined, 'Alertas institucionales'),
                      const SizedBox(height: 8),
                      _beneficio(Icons.local_police_outlined, 'Novedades de tus operativos'),
                      const SizedBox(height: 18),
                      if (ajustes) ...[
                        const Text(
                            'Para activarlas, abre Configuración y habilita las notificaciones de esta aplicación.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12,
                                height: 1.4, color: Color(0xFF53667B))),
                        const SizedBox(height: 14),
                      ],
                      Row(children: [
                        if (opcional) ...[
                          Expanded(child: OutlinedButton(
                              onPressed: ocupado ? null : onNoPermitir,
                              style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  foregroundColor: const Color(0xFF52677D),
                                  side: const BorderSide(color: Color(0xFFCBD8E5)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                              child: const FittedBox(child: Text('NO PERMITIR',
                                  style: TextStyle(fontWeight: FontWeight.w800))))),
                          const SizedBox(width: 10),
                        ],
                        Expanded(child: ElevatedButton(
                            onPressed: ocupado ? null : onPermitir,
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                backgroundColor: azul,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                            child: FittedBox(child: Text(
                                ajustes ? 'ABRIR CONFIGURACIÓN' : 'PERMITIR',
                                style: const TextStyle(fontWeight: FontWeight.w800))))),
                      ]),
                      if (ocupado) ...[
                        const SizedBox(height: 12),
                        const LinearProgressIndicator(),
                      ],
                      if (error.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(error, textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFFB3261E),
                                fontSize: 12, height: 1.4)),
                      ],
                      if (!ajustes)
                        TextButton.icon(
                            onPressed: ocupado ? null : onConfiguracion,
                            icon: const Icon(Icons.settings_outlined, size: 16),
                            label: const Text('Abrir configuración del móvil',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 11))),
                      const SizedBox(height: 8),
                      const Text('Puedes cambiar el permiso desde los ajustes del sistema.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Color(0xFF7A8DA1))),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _beneficio(IconData icono, String texto) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: const Color(0xFFF1F6FB),
        borderRadius: BorderRadius.circular(12)),
    child: Row(children: [
      Icon(icono, color: const Color(0xFF176FC0), size: 22),
      const SizedBox(width: 10),
      Expanded(child: Text(texto, style: const TextStyle(
          color: Color(0xFF30485F), fontWeight: FontWeight.w600, fontSize: 12))),
    ]),
  );
}
