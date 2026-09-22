import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../app/core/utils/responsiveUtil.dart';
import '../../../../app/domain/enums/enums.dart';
import '../../../../feactures/user/presentation/modules/controllers.dart';
import '../../services/bloc/notifications_bloc.dart';

class NotificationsAccessScreen extends StatelessWidget {
  final Widget contenido;
  final NamApps namApps;

  const NotificationsAccessScreen({
    super.key,
    required this.contenido,
    required this.namApps,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state.status == NotificationPermissionStatus.authorized) {
          return contenido;
        }

        return _MensajePermisoNotificaciones(
          namApps: namApps,
          onPressed: () {
            final loginController = Get.find<LoginController>();
            context.read<NotificationsBloc>().requestPermission(
                  appName: namApps,
                  idGenUsuario: loginController.user.value.idGenUsuario,
                );
          },
        );
      },
    );
  }
}

class _MensajePermisoNotificaciones extends StatelessWidget {
  final VoidCallback onPressed;
  final NamApps namApps;

  const _MensajePermisoNotificaciones({
    required this.onPressed,
    required this.namApps,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 460),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.97),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFD8E3EE)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0D4C9C).withOpacity(.10),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _cabeceraPermiso(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        "Necesitamos su autorización para enviar notificaciones de novedades y alertas relacionadas con los operativos móviles.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: responsive.diagonalP(1.35),
                          color: const Color(0xFF6F7F90),
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _itemsInformativos(),
                      const SizedBox(height: 20),
                      _btnContinuar(onPressed),
                      const SizedBox(height: 18),
                      _cardPrivacidad(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cabeceraPermiso() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(.18)),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "PERMISO DE NOTIFICACIONES",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.13),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemsInformativos() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _itemPermiso(
          numero: "1",
          titulo: "Alertas institucionales",
          detalle: "Reciba mensajes oficiales de la Policía Nacional.",
        ),
        const SizedBox(height: 7),
        _itemPermiso(
          numero: "2",
          titulo: "Novedades de operativos",
          detalle: "Información relevante sobre el estado de sus operativos.",
        ),
        const SizedBox(height: 7),
        _itemPermiso(
          numero: "3",
          titulo: "Seguridad de la cuenta",
          detalle: "Notificaciones sobre inicios de sesión y seguridad.",
        ),
      ],
    );
  }

  Widget _itemPermiso({
    required String numero,
    required String titulo,
    required String detalle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE0E7EF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F0FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                numero,
                style: const TextStyle(
                  color: Color(0xFF195BA6),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF30485F),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detalle,
                  style: const TextStyle(
                    color: Color(0xFF748395),
                    fontSize: 9.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _btnContinuar(VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Ink(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF195BA6), Color(0xFF0A3D7E)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF195BA6).withOpacity(.24),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline_rounded,
                  color: Colors.white, size: 19),
              SizedBox(width: 8),
              Text(
                "ACTIVAR NOTIFICACIONES",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .7,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardPrivacidad() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD9E5F0)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.privacy_tip_outlined, color: Color(0xFF195BA6), size: 20),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              "Puede gestionar sus preferencias de notificaciones en cualquier momento desde los ajustes del sistema.",
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF5C7186),
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
