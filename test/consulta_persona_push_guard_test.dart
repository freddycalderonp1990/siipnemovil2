import 'package:flutter_test/flutter_test.dart';
import 'package:siipnemovil_v2/app_siipne_movil/presentation/modulos/op_servicio_urbano/consulta_persona_push_guard.dart';

void main() {
  late ConsultaPersonaPushGuard guard;
  setUp(() => guard = ConsultaPersonaPushGuard());

  Map<String, dynamic> alerta({
    String documento = '1712345678',
    String operativo = '20',
    String registro = '30',
    String tipo = 'BOLETA',
  }) => {
    'tipo': tipo,
    'idHdrEvento': operativo,
    'idHdrEventoResum': registro,
    'cedula': documento,
  };

  test(
    'espera la respuesta y descarta el push que llegó antes del duplicado',
    () async {
      final consulta = guard.iniciar(idOperativo: 20, documento: '1712345678');
      var resuelta = false;
      final permitir = guard.permitirAlerta(alerta()).then((value) {
        resuelta = true;
        return value;
      });
      await Future<void>.value();
      expect(resuelta, isFalse);
      guard.finalizar(consulta, consultaRepetida: true, idHdrEventoResum: 30);
      expect(await permitir, isFalse);
      expect(await guard.permitirAlerta(alerta()), isFalse);
    },
  );

  test('la primera consulta conserva su alerta aunque llegue antes de la respuesta', () async {
    final consulta = guard.iniciar(idOperativo: 20, documento: '1712345678');
    final permitir = guard.permitirAlerta(alerta());
    guard.finalizar(consulta, consultaRepetida: false, idHdrEventoResum: 30);
    expect(await permitir, isTrue);
    expect(await guard.permitirAlerta(alerta()), isTrue);
  });

  test(
    'no bloquea alertas de otras personas, operativos, registros o vehículos',
    () async {
      final consulta = guard.iniciar(idOperativo: 20, documento: '1712345678');
      expect(
        await guard.permitirAlerta(alerta(documento: '1712345679')),
        isTrue,
      );
      expect(await guard.permitirAlerta(alerta(operativo: '21')), isTrue);
      expect(
        await guard.permitirAlerta(alerta(tipo: 'VEHICULO_ROBADO')),
        isTrue,
      );
      final otroRegistro = guard.permitirAlerta(alerta(registro: '31'));
      guard.finalizar(consulta, consultaRepetida: true, idHdrEventoResum: 30);
      expect(await otroRegistro, isTrue);
      expect(await guard.permitirAlerta(alerta(registro: '31')), isTrue);
    },
  );

  test(
    'descarta mensajes de duplicados por registro aunque no traigan documento',
    () async {
      final consulta = guard.iniciar(idOperativo: 20, documento: '1712345678');
      final permitir = guard.permitirAlerta(alerta(documento: ''));
      guard.finalizar(consulta, consultaRepetida: true, idHdrEventoResum: 30);
      expect(await permitir, isFalse);
    },
  );

  test('usa el documento cuando el push no incluye el registro', () async {
    final consulta = guard.iniciar(idOperativo: 20, documento: ' ab1234 ');
    guard.finalizar(consulta, consultaRepetida: true);
    expect(
      await guard.permitirAlerta(alerta(documento: 'AB1234', registro: '')),
      isFalse,
    );
    expect(
      await guard.permitirAlerta(alerta(documento: 'AB1235', registro: '')),
      isTrue,
    );
  });

  test(
    'un fallo HTTP libera la espera sin descartar una alerta válida',
    () async {
      final consulta = guard.iniciar(idOperativo: 20, documento: '1712345678');
      final permitir = guard.permitirAlerta(alerta());
      guard.finalizar(consulta);
      expect(await permitir, isTrue);
      guard.finalizar(consulta, consultaRepetida: true, idHdrEventoResum: 30);
      expect(await guard.permitirAlerta(alerta()), isTrue);
    },
  );

  test(
    'descarta un duplicado identificado por el servidor sin consulta local',
    () async {
      for (final flag in [true, 'true', '1', 1]) {
        expect(
          await guard.permitirAlerta({...alerta(), 'consultaRepetida': flag}),
          isFalse,
        );
      }
      expect(
        await guard.permitirAlerta({...alerta(), 'consultaRepetida': 'false'}),
        isTrue,
      );
    },
  );

  test(
    'salir del operativo libera esperas y elimina el estado de duplicados',
    () async {
      final repetida = guard.iniciar(idOperativo: 20, documento: '1712345678');
      guard.finalizar(repetida, consultaRepetida: true, idHdrEventoResum: 30);
      final pendiente = guard.iniciar(idOperativo: 20, documento: '1712345679');
      final permitir = guard.permitirAlerta(alerta(documento: '1712345679'));
      guard.limpiar();
      expect(await permitir, isTrue);
      guard.finalizar(pendiente, consultaRepetida: true, idHdrEventoResum: 31);
      expect(await guard.permitirAlerta(alerta()), isTrue);
      expect(
        await guard.permitirAlerta(
          alerta(documento: '1712345679', registro: '31'),
        ),
        isTrue,
      );
    },
  );

  test('cada consulta relacionada permite la boleta aunque repita persona y registro', () async {
    for (var intento = 0; intento < 3; intento++) {
      final consulta = guard.iniciar(
        idOperativo: 20,
        documento: '1712345678',
        relacionadaVehiculo: true,
      );
      final payload = {...alerta(), 'consultaRepetida': 'true'};
      final permitir = guard.permitirAlerta(payload);
      guard.finalizar(consulta, consultaRepetida: true, idHdrEventoResum: 30);
      expect(await permitir, isTrue);
      expect(await guard.permitirAlerta(payload), isTrue);
    }
  });

  test('un conductor u ocupante vuelve a alertar tras una consulta general repetida', () async {
    final general = guard.iniciar(idOperativo: 20, documento: '1712345678');
    guard.finalizar(general, consultaRepetida: true, idHdrEventoResum: 30);
    expect(await guard.permitirAlerta(alerta()), isFalse);

    final relacionada = guard.iniciar(
      idOperativo: 20,
      documento: '1712345678',
      relacionadaVehiculo: true,
    );
    final permitir = guard.permitirAlerta(alerta());
    guard.finalizar(relacionada, consultaRepetida: true, idHdrEventoResum: 30);
    expect(await permitir, isTrue);
    expect(await guard.permitirAlerta(alerta()), isTrue);
    expect(await guard.permitirAlerta(alerta(documento: '')), isTrue);
    expect(await guard.permitirAlerta(alerta(registro: '')), isTrue);
  });

  test(
    'el payload de conductor y ocupante permite alertas en otro dispositivo',
    () async {
      for (final rol in ['CONDUCTOR', 'OCUPANTE']) {
        final payload = {
          ...alerta(),
          'tipoRelacion': rol,
          'consultaRepetida': 'true',
        };
        expect(await guard.permitirAlerta(payload), isTrue);
        expect(await guard.permitirAlerta(payload), isTrue);
      }
    },
  );

  test('las consultas generales repetidas siguen bloqueadas después de una relación', () async {
    final relacionada = guard.iniciar(
      idOperativo: 20,
      documento: '1712345678',
      relacionadaVehiculo: true,
    );
    guard.finalizar(relacionada, consultaRepetida: true, idHdrEventoResum: 30);
    final general = guard.iniciar(idOperativo: 20, documento: '1712345678');
    final permitir = guard.permitirAlerta(alerta());
    guard.finalizar(general, consultaRepetida: true, idHdrEventoResum: 30);
    expect(await permitir, isFalse);
    expect(await guard.permitirAlerta(alerta()), isFalse);
  });
}
