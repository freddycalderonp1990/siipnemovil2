import 'dart:async';

import 'package:country_utils/country_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siipnemovil_v2/app/presentation/widgets/custom_app_widgets.dart';
import 'package:siipnemovil_v2/app_siipne_movil/presentation/modulos/op_servicio_urbano/local_widgets/dialogo_consulta_operativa.dart';
import 'package:siipnemovil_v2/app_siipne_movil/presentation/widgets/selector_nacionalidad_widget.dart';
import 'package:siipnemovil_v2/app_siipne_movil/domain/request/request_siipne_movil.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await CountryLocalizations(const Locale('en')).load();
  });

  ConsultarPersonaRequest request({
    required String siglasNacionalidad,
    bool relacionado = false,
  }) => ConsultarPersonaRequest(
    idOperativo: 20,
    documento: 'AB123456',
    latitud: -0.2,
    longitud: -78.5,
    ip: '127.0.0.1',
    idGenUsuario: 10,
    idVariableResultado: 3,
    consultadoPor: 'Policía',
    hdrIdHdrResum: relacionado ? 30 : 0,
    tipoRelacion: relacionado ? 'OCUPANTE' : '',
    siglasNacionalidad: siglasNacionalidad,
      idGenPersona:1
  );

  test('la consulta urbana solo añade nacionalidad al cuerpo existente', () {
    final original = request(siglasNacionalidad: '').toJson();
    final extranjero = request(siglasNacionalidad: ' col ').toJson();
    expect(extranjero.remove('nacionalidad'), 'COL');
    expect(extranjero, original);
    // Los consumidores existentes, incluido migración, conservan su petición.
    expect(original.containsKey('nacionalidad'), isFalse);
  });

  test('conserva la relación de ocupante al añadir nacionalidad', () {
    final body = request(siglasNacionalidad: 'PER', relacionado: true).toJson();
    expect(body['hdr_idHdrEventoResum'], 30);
    expect(body['tipoRelacion'], 'OCUPANTE');
    expect(body['nacionalidad'], 'PER');
  });

  Future<void> abrir(
    WidgetTester tester, {
    bool esPersona = true,
    required GlobalKey<FormState> formKey,
    required TextEditingController documento,
    required Future<bool> Function(String) consultar,
    String error = '',
    bool Function()? esConsultaRepetida,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) => DialogoConsultaOperativa(
                  titulo: esPersona
                      ? 'Consulta de persona'
                      : 'Consulta de vehículo',
                  esPersona: esPersona,
                  formKey: formKey,
                  documentoController: documento,
                  onConsultar: consultar,
                  obtenerError: () => error,
                  esConsultaRepetida: esConsultaRepetida,
                ),
              ),
              child: const Text('ABRIR'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('ABRIR'));
    await tester.pumpAndSettle();
  }

  Future<void> confirmar(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('CONSULTAR'));
    await tester.tap(find.text('CONSULTAR'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SÍ, CONSULTAR'));
    await tester.pumpAndSettle();
  }

  BotonDialogoInstitucional botonConsultar(WidgetTester tester) =>
      tester.widget(
        find.byWidgetPredicate(
          (widget) =>
              widget is BotonDialogoInstitucional &&
              widget.titulo == 'CONSULTAR',
        ),
      );

  testWidgets('Consultar empieza deshabilitado y exige una cédula completa', (
    tester,
  ) async {
    final documento = TextEditingController();
    final key = GlobalKey<FormState>();
    var llamadas = 0;
    await abrir(
      tester,
      formKey: key,
      documento: documento,
      consultar: (_) async {
        llamadas++;
        return true;
      },
    );
    expect(botonConsultar(tester).onPressed, isNull);
    await tester.enterText(find.byType(TextFormField), '17123');
    await tester.pumpAndSettle();
    expect(botonConsultar(tester).onPressed, isNull);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('Confirmar consulta'), findsNothing);
    expect(llamadas, 0);
    await tester.enterText(find.byType(TextFormField), '1712345678');
    await tester.pumpAndSettle();
    expect(botonConsultar(tester).onPressed, isNotNull);
    documento.clear();
    await tester.pumpAndSettle();
    expect(botonConsultar(tester).onPressed, isNull);
    await tester.pumpWidget(const SizedBox());
    documento.dispose();
  });

  testWidgets('consulta nacional mantiene el formulario montado y envía ECU', (
    tester,
  ) async {
    final documento = TextEditingController();
    final key = GlobalKey<FormState>();
    String? enviado;
    await abrir(
      tester,
      formKey: key,
      documento: documento,
      consultar: (pais) async {
        expect(key.currentState?.validate(), isTrue);
        expect(documento.text, '1712345678');
        enviado = pais;
        return true;
      },
    );
    await tester.enterText(find.byType(TextFormField), '1712345678');
    await confirmar(tester);
    expect(enviado, 'ECU');
    expect(find.byType(DialogoConsultaOperativa), findsNothing);
    await tester.pumpWidget(const SizedBox());
    documento.dispose();
  });

  testWidgets(
    'extranjero exige país y consulta directamente con documento y COL',
    (tester) async {
      final documento = TextEditingController();
      final key = GlobalKey<FormState>();
      String? enviado;
      await abrir(
        tester,
        formKey: key,
        documento: documento,
        consultar: (pais) async {
          expect(documento.text, 'AB123456');
          enviado = pais;
          return true;
        },
      );
      await tester.tap(find.text('Extranjero'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'ab123456');
      await tester.ensureVisible(find.text('CONSULTAR'));
      await tester.tap(find.text('CONSULTAR'));
      await tester.pumpAndSettle();
      expect(botonConsultar(tester).onPressed, isNull);
      expect(find.text('Confirmar consulta'), findsNothing);
      expect(enviado, isNull);

      await tester.ensureVisible(find.byType(SelectorNacionalidadWidget));
      await tester.tap(find.byType(SelectorNacionalidadWidget));
      await tester.pumpAndSettle();
      final paisInput = find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(TextField),
      );
      await tester.enterText(paisInput, 'ECU');
      await tester.pumpAndSettle();
      expect(find.text('No se encontraron países.'), findsOneWidget);
      await tester.enterText(paisInput, ' co ');
      await tester.pumpAndSettle();
      expect(find.text('Colombia'), findsOneWidget);
      expect(find.text('COL'), findsOneWidget);
      await tester.enterText(paisInput, 'Colombia');
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(ListView),
          matching: find.text('Colombia'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Colombia'), findsOneWidget);
      expect(find.text('COL'), findsOneWidget);
      final bandera = find.descendant(
        of: find.byType(SelectorNacionalidadWidget),
        matching: find.byType(RTMCountryFlag),
      );
      expect(tester.widget<RTMCountryFlag>(bandera).countryCode, 'co');
      expect(botonConsultar(tester).onPressed, isNotNull);
      await tester.tap(find.byType(SelectorNacionalidadWidget));
      await tester.pumpAndSettle();
      await tester.enterText(paisInput, 'COL');
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.byIcon(Icons.check_circle_rounded),
        ),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Cerrar selector'));
      await tester.pumpAndSettle();
      expect(find.text('Colombia'), findsOneWidget);
      expect(botonConsultar(tester).onPressed, isNotNull);
      await confirmar(tester);
      expect(enviado, 'COL');
      expect(find.byType(DialogoConsultaOperativa), findsNothing);
      await tester.pumpWidget(const SizedBox());
      documento.dispose();
    },
  );

  testWidgets(
    'cambiar el tipo de documento limpia los datos y bloquea Consultar',
    (tester) async {
      final documento = TextEditingController();
      final key = GlobalKey<FormState>();
      await abrir(
        tester,
        formKey: key,
        documento: documento,
        consultar: (_) async => true,
      );
      await tester.enterText(find.byType(TextFormField), '1712345678');
      await tester.pumpAndSettle();
      expect(botonConsultar(tester).onPressed, isNotNull);
      await tester.tap(find.text('Extranjero'));
      await tester.pumpAndSettle();
      expect(documento.text, isEmpty);
      expect(botonConsultar(tester).onPressed, isNull);
      await tester.enterText(find.byType(TextFormField), 'AB123456');
      await tester.tap(find.text('Nacional'));
      await tester.pumpAndSettle();
      expect(documento.text, isEmpty);
      expect(find.byType(SelectorNacionalidadWidget), findsNothing);
      expect(botonConsultar(tester).onPressed, isNull);
      await tester.pumpWidget(const SizedBox());
      documento.dispose();
    },
  );

  testWidgets('volver de la confirmación conserva el dato sin consultar', (
    tester,
  ) async {
    final documento = TextEditingController();
    final key = GlobalKey<FormState>();
    var llamadas = 0;
    await abrir(
      tester,
      formKey: key,
      documento: documento,
      esPersona: false,
      consultar: (_) async {
        llamadas++;
        return true;
      },
    );
    await tester.enterText(find.byType(TextFormField), 'ABC1234');
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONSULTAR'));
    await tester.pumpAndSettle();
    expect(find.text('ABC1234'), findsWidgets);
    expect(find.text('PLACA A CONSULTAR'), findsOneWidget);
    await tester.tap(find.text('VOLVER'));
    await tester.pumpAndSettle();
    expect(llamadas, 0);
    expect(documento.text, 'ABC1234');
    expect(botonConsultar(tester).onPressed, isNotNull);
    await tester.pumpWidget(const SizedBox());
    documento.dispose();
  });

  testWidgets('placa conserva validación y no muestra nacionalidades', (
    tester,
  ) async {
    final documento = TextEditingController();
    final key = GlobalKey<FormState>();
    int llamadas = 0;
    await abrir(
      tester,
      esPersona: false,
      formKey: key,
      documento: documento,
      consultar: (_) async {
        expect(documento.text, 'ABC1234');
        llamadas++;
        return true;
      },
    );
    expect(find.text('Extranjero'), findsNothing);
    expect(botonConsultar(tester).onPressed, isNull);
    await tester.enterText(find.byType(TextFormField), 'abc12');
    await tester.tap(find.text('CONSULTAR'));
    await tester.pumpAndSettle();
    expect(
      find.text('La placa debe tener mínimo 6 caracteres.'),
      findsOneWidget,
    );
    expect(llamadas, 0);
    expect(botonConsultar(tester).onPressed, isNull);
    await tester.enterText(find.byType(TextFormField), 'abc1234');
    await confirmar(tester);
    expect(llamadas, 1);
    await tester.pumpWidget(const SizedBox());
    documento.dispose();
  });

  testWidgets(
    'bloquea envíos simultáneos y conserva el formulario tras un error',
    (tester) async {
      final documento = TextEditingController();
      final key = GlobalKey<FormState>();
      final pendiente = Completer<bool>();
      int llamadas = 0;
      await abrir(
        tester,
        formKey: key,
        documento: documento,
        error: 'Sin conexión',
        consultar: (_) {
          llamadas++;
          return pendiente.future;
        },
      );
      await tester.enterText(find.byType(TextFormField), '1712345678');
      await tester.pumpAndSettle();
      await tester.tap(find.text('CONSULTAR'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('SÍ, CONSULTAR'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(llamadas, 1);
      final boton = tester.widget<BotonDialogoInstitucional>(
        find.byWidgetPredicate(
          (widget) =>
              widget is BotonDialogoInstitucional &&
              widget.titulo == 'CONSULTANDO...',
        ),
      );
      expect(boton.onPressed, isNull);
      expect(find.byType(CargandoWidget), findsOneWidget);
      expect(find.byType(Loading), findsOneWidget);
      expect(key.currentState?.validate(), isTrue);
      pendiente.complete(false);
      await tester.pumpAndSettle();
      expect(find.text('Sin conexión'), findsOneWidget);
      expect(find.byType(DialogoConsultaOperativa), findsOneWidget);
      expect(documento.text, '1712345678');
      expect(find.byType(CargandoWidget), findsNothing);
      expect(botonConsultar(tester).onPressed, isNotNull);
      await tester.pumpWidget(const SizedBox());
      documento.dispose();
    },
  );
  testWidgets('una consulta repetida muestra el aviso y exige otro documento', (
    tester,
  ) async {
    final documento = TextEditingController();
    var llamadas = 0;
    await abrir(
      tester,
      formKey: GlobalKey<FormState>(),
      documento: documento,
      esConsultaRepetida: () => true,
      consultar: (_) async {
        llamadas++;
        return false;
      },
    );
    await tester.enterText(find.byType(TextFormField), '1712345678');
    await confirmar(tester);
    expect(find.text('PERSONA YA CONSULTADA'), findsOneWidget);
    expect(find.text('1712345678'), findsNWidgets(2));
    expect(botonConsultar(tester).onPressed, isNull);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(llamadas, 1);
    expect(find.text('Confirmar consulta'), findsNothing);
    await tester.enterText(find.byType(TextFormField), '1712345679');
    await tester.pumpAndSettle();
    expect(find.text('PERSONA YA CONSULTADA'), findsNothing);
    expect(botonConsultar(tester).onPressed, isNotNull);
    await tester.pumpWidget(const SizedBox());
    documento.dispose();
  });

  for (final esPersona in [true, false]) {
    testWidgets(
      'SALIR cierra la consulta de ${esPersona ? 'persona' : 'vehículo'} sin enviarla',
      (tester) async {
        final documento = TextEditingController();
        var llamadas = 0;
        await abrir(
          tester,
          esPersona: esPersona,
          formKey: GlobalKey<FormState>(),
          documento: documento,
          consultar: (_) async {
            llamadas++;
            return true;
          },
        );
        await tester.ensureVisible(find.text('SALIR'));
        await tester.tap(find.text('SALIR'));
        await tester.pumpAndSettle();
        expect(find.byType(DialogoConsultaOperativa), findsNothing);
        expect(llamadas, 0);
        await tester.pumpWidget(const SizedBox());
        documento.dispose();
      },
    );
  }

  testWidgets(
    'conserva una alerta que aparece encima al terminar la consulta',
    (tester) async {
      final documento = TextEditingController();
      final key = GlobalKey<FormState>();
      await abrir(
        tester,
        formKey: key,
        documento: documento,
        consultar: (_) async {
          final context = tester.element(find.byType(DialogoConsultaOperativa));
          unawaited(
            showDialog<void>(
              context: context,
              builder: (_) =>
                  const AlertDialog(title: Text('Alerta de vehículo')),
            ),
          );
          return true;
        },
      );
      await tester.enterText(find.byType(TextFormField), '1712345678');
      await confirmar(tester);
      expect(find.text('Alerta de vehículo'), findsOneWidget);
      expect(
        find.byType(DialogoConsultaOperativa, skipOffstage: false),
        findsNothing,
      );
      await tester.pumpWidget(const SizedBox());
      documento.dispose();
    },
  );

  testWidgets('el formulario cabe en un teléfono con teclado abierto', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 640);
    tester.view.viewInsets = const FakeViewPadding(bottom: 250);
    addTearDown(tester.view.reset);
    final documento = TextEditingController();
    final key = GlobalKey<FormState>();
    await abrir(
      tester,
      formKey: key,
      documento: documento,
      consultar: (_) async => true,
    );
    await tester.tap(find.text('Extranjero'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(SelectorNacionalidadWidget));
    await tester.tap(find.byType(SelectorNacionalidadWidget));
    await tester.pumpAndSettle();
    final paisInput = find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(paisInput, 'PER');
    await tester.pumpAndSettle();
    expect(find.text('Peru'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Peru'));
    await tester.pumpAndSettle();
    expect(find.text('PER'), findsOneWidget);
    await tester.ensureVisible(find.text('CONSULTAR'));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    documento.dispose();
  });
}
