import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siipnemovil_v2/app_siipne_movil/presentation/modulos/op_servicio_urbano/operativo_push_identity.dart';

void main() {
  test('dos envíos con el mismo alertaId deben generar dos notificaciones', () {
    const data = <String, dynamic>{'alertaId': '10', 'tipo': 'BOLETA'};
    expect(
      operativoPushIdentity(const RemoteMessage(messageId: 'envio1', data: data)),
      isNot(operativoPushIdentity(const RemoteMessage(messageId: 'envio2', data: data))),
    );
  });

  test('una entrega repetida del mismo mensaje se deduplica', () {
    const message = RemoteMessage(messageId: 'envio1');
    expect(operativoPushIdentity(message), operativoPushIdentity(message));
  });

  test('sin messageId diferencia envíos por fecha aunque repitan alertaId', () {
    final first = RemoteMessage(data: const {'alertaId': '10'}, sentTime: DateTime(2026));
    final second = RemoteMessage(data: const {'alertaId': '10'}, sentTime: DateTime(2026, 1, 1, 0, 0, 1));
    expect(operativoPushIdentity(first), isNot(operativoPushIdentity(second)));
  });

  test('sin identificadores conserva el payload y su orden no cambia la identidad', () {
    const first = RemoteMessage(data: {'tipo': 'BOLETA', 'cedula': '123'});
    const second = RemoteMessage(data: {'cedula': '123', 'tipo': 'BOLETA'});
    expect(operativoPushIdentity(first), operativoPushIdentity(second));
    expect(operativoPushIdentity(first), isNotEmpty);
  });
}
