import 'package:country_utils/country_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:siipnemovil_v2/app_siipne_movil/domain/use_cases/siipne_movil_use_case.dart';
import 'package:siipnemovil_v2/app_siipne_movil/presentation/modulos/controllers.dart';
import 'package:siipnemovil_v2/app_siipne_movil/presentation/modulos/pages.dart';
import 'package:siipnemovil_v2/app_siipne_movil/presentation/modulos/op_servicio_urbano/local_widgets/dialogo_consulta_operativa.dart';
import 'package:siipnemovil_v2/feactures/user/presentation/modules/controllers.dart';

class _LoginSinSesion extends GetxController implements LoginController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UseCase extends Mock implements SiipneMovilUseCase {}

class _PaginaConsulta extends OpServicioUrbanoPage {
  _PaginaConsulta(this._controller);

  final OpServicioUrbanoController _controller;
  @override
  OpServicioUrbanoController get controller => _controller;

  @override
  Widget build(BuildContext context) => Scaffold(body: tipoDeConsulta());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late OpServicioUrbanoController controller;

  setUpAll(() async {
    await CountryLocalizations(const Locale('en')).load();
  });
  setUp(() {
    Get.testMode = true;
    Get.put<LoginController>(_LoginSinSesion());
    Get.put<SiipneMovilUseCase>(_UseCase());
    // Sin registrar el controlador no se inicia GPS, HTTP ni Firebase.
    controller = OpServicioUrbanoController();
  });
  tearDown(() {
    controller.onClose();
    Get.reset();
  });

  for (final esPersona in [true, false]) {
    for (final cerrarConX in [true, false]) {
      testWidgets(
        '${esPersona ? 'Persona' : 'Vehículo'}: ${cerrarConX ? 'cerrar' : 'SALIR'} limpia ambos botones y permite elegir otra consulta',
        (tester) async {
          await tester.pumpWidget(
            GetMaterialApp(home: _PaginaConsulta(controller)),
          );
          await tester.pumpAndSettle();
          expect(controller.selectPerson.value, isFalse);
          expect(controller.selectVehiculo.value, isFalse);
          final titulo = esPersona ? 'PERSONA' : 'VEHÍCULO/MOTO';
          await tester.tap(find.text(titulo));
          await tester.pumpAndSettle();
          expect(find.byType(DialogoConsultaOperativa), findsOneWidget);
          expect(controller.selectPerson.value, esPersona);
          expect(controller.selectVehiculo.value, !esPersona);
          if (cerrarConX) {
            await tester.tap(find.byTooltip('Cerrar'));
          } else {
            await tester.ensureVisible(find.text('SALIR'));
            await tester.tap(find.text('SALIR'));
          }
          await tester.pumpAndSettle();
          expect(find.byType(DialogoConsultaOperativa), findsNothing);
          expect(controller.selectPerson.value, isFalse);
          expect(controller.selectVehiculo.value, isFalse);
          expect(controller.dialogoConsultaAbierto.value, isFalse);
          expect(controller.variableResultadoSeleccionada.value, isNull);
          await tester.tap(find.text(titulo));
          await tester.pumpAndSettle();
          expect(find.byType(DialogoConsultaOperativa), findsOneWidget);
          await tester.tap(find.byTooltip('Cerrar'));
          await tester.pumpAndSettle();
          await tester.pumpWidget(const SizedBox());
        },
      );
    }

    testWidgets(
      'una consulta de ${esPersona ? 'persona' : 'vehículo'} exitosa conserva el tipo seleccionado',
      (tester) async {
        await tester.pumpWidget(
          GetMaterialApp(home: _PaginaConsulta(controller)),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text(esPersona ? 'PERSONA' : 'VEHÍCULO/MOTO'));
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(DialogoConsultaOperativa));
        Navigator.of(context).pop(true);
        await tester.pumpAndSettle();
        expect(controller.selectPerson.value, esPersona);
        expect(controller.selectVehiculo.value, !esPersona);
        expect(controller.dialogoConsultaAbierto.value, isFalse);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
}
