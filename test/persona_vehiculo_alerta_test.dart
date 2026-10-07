import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers_platform_interface/audioplayers_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:siipnemovil_v2/app_siipne_movil/data/models/models_siipne_movil.dart';
import 'package:siipnemovil_v2/app_siipne_movil/domain/request/request_siipne_movil.dart';
import 'package:siipnemovil_v2/app_siipne_movil/domain/use_cases/siipne_movil_use_case.dart';
import 'package:siipnemovil_v2/app_siipne_movil/presentation/modulos/controllers.dart';
import 'package:siipnemovil_v2/app_siipne_movil/presentation/modulos/op_servicio_urbano/operativo_push_service.dart';
import 'package:siipnemovil_v2/feactures/gps/presentation/location/location_bloc.dart';
import 'package:siipnemovil_v2/feactures/user/domain/entities/user.dart';
import 'package:siipnemovil_v2/feactures/user/presentation/modules/controllers.dart';

class _LoginSinSesion extends GetxController implements LoginController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UseCase extends Mock implements SiipneMovilUseCase {}

class _Persona extends Mock implements DataConsultaPersona {}

class _Request extends Fake implements ConsultarPersonaRequest {}

class _Audio extends Mock implements AudioplayersPlatformInterface {}

class _AudioGlobal extends Mock
    implements GlobalAudioplayersPlatformInterface {}

class _Ubicacion extends LocationBloc {
  @override
  Future<LatLng> getCurrentPosition() async => const LatLng(-0.2, -78.5);
}

class _Red extends NetworkInfoPlatform {
  @override
  Future<String?> getWifiIP() async => '127.0.0.1';
}

class _CacheAudio extends AudioCache {
  @override
  Future<String> loadPath(String fileName) async => '/tmp/alerta-prueba.mp3';
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => registerFallbackValue(_Request()));

  for (final rol in ['CONDUCTOR', 'OCUPANTE']) {
    for (final conBoleta in [true, false]) {
      testWidgets(
        '$rol: cada consulta ${conBoleta ? 'con' : 'sin'} boleta ${conBoleta ? 'reproduce' : 'omite'} el audio',
        (tester) async {
          Get.testMode = true;
          debugDefaultTargetPlatformOverride = TargetPlatform.linux;
          final audioOriginal = AudioplayersPlatformInterface.instance;
          final globalOriginal = GlobalAudioplayersPlatformInterface.instance;
          final cacheOriginal = AudioCache.instance;
          final redOriginal = NetworkInfoPlatform.instance;
          final audio = _Audio();
          final global = _AudioGlobal();
          final streams = <String, StreamController<AudioEvent>>{};
          var reproducciones = 0;
          when(() => global.init()).thenAnswer((_) async {});
          when(() => global.getGlobalEventStream())
              .thenAnswer((_) => const Stream.empty());
          when(() => audio.create(any())).thenAnswer((call) async {
            streams[call.positionalArguments.first as String] =
                StreamController<AudioEvent>.broadcast();
          });
          when(() => audio.getEventStream(any())).thenAnswer(
            (call) => streams[call.positionalArguments.first]!.stream,
          );
          when(
            () => audio.setSourceUrl(
              any(),
              any(),
              isLocal: any(named: 'isLocal'),
              mimeType: any(named: 'mimeType'),
            ),
          ).thenAnswer((call) async {
            streams[call.positionalArguments.first]!.add(
              const AudioEvent(
                eventType: AudioEventType.prepared,
                isPrepared: true,
              ),
            );
          });
          when(() => audio.resume(any()))
              .thenAnswer((_) async => reproducciones++);
          when(() => audio.getCurrentPosition(any()))
              .thenAnswer((_) async => 0);
          when(() => audio.getDuration(any())).thenAnswer((_) async => 1000);
          when(() => audio.release(any())).thenAnswer((_) async {});
          AudioplayersPlatformInterface.instance = audio;
          GlobalAudioplayersPlatformInterface.instance = global;
          AudioCache.instance = _CacheAudio();
          NetworkInfoPlatform.instance = _Red();
          binding.defaultBinaryMessenger.setMockMethodCallHandler(
            const MethodChannel('vibration'),
            (_) async => false,
          );

          final useCase = _UseCase();
          Get.put<LoginController>(_LoginSinSesion());
          Get.put<SiipneMovilUseCase>(useCase);
          final controller = OpServicioUrbanoController();
          controller.user = UserEntities.fromJson({});
          controller.idHdrEventoActual.value = 20;
          final location = _Ubicacion();
          final formKey = GlobalKey<FormState>();
          var consultas = 0;
          when(
            () => useCase.consultarPersona(request: any(named: 'request')),
          ).thenAnswer((call) async {
            final request =
                call.namedArguments[#request] as ConsultarPersonaRequest;
            expect(request.tipoRelacion, rol);
            expect(request.idOperativo, 20);
            final persona = _Persona();
            when(() => persona.idHdrEventoResum).thenReturn(30);
            when(() => persona.consultaRepetida).thenReturn(consultas++ > 0);
            when(() => persona.ordenCaptura).thenReturn(
              OrdenCaptura(success: conBoleta, message: '', datosCaptura: []),
            );
            return persona;
          });

          addTearDown(() async {
            controller.onClose();
            OperativoPushService.instance.consultasPersona.limpiar();
            await location.close();
            for (final stream in streams.values) {
              await stream.close();
            }
            Get.reset();
            binding.defaultBinaryMessenger.setMockMethodCallHandler(
              const MethodChannel('vibration'),
              null,
            );
            AudioplayersPlatformInterface.instance = audioOriginal;
            GlobalAudioplayersPlatformInterface.instance = globalOriginal;
            AudioCache.instance = cacheOriginal;
            NetworkInfoPlatform.instance = redOriginal;
            debugDefaultTargetPlatformOverride = null;
          });

          await tester.pumpWidget(
            BlocProvider<LocationBloc>.value(
              value: location,
              child: GetMaterialApp(
                home: Scaffold(
                  body: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: controller.controllerCedulaVehiculo,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          for (var intento = 0; intento < 3; intento++) {
            // La misma persona se consulta en distintos vehículos del operativo.
            controller.dataVehiculo.assignAll([
              DataVehiculo.empty()..idHdrEventoResum = 100 + intento,
            ]);
            controller.documentosPersonasVehiculoRegistradas.clear();
            controller.dataPersona_conductor.clear();
            controller.dataPersona_ocupantes.clear();
            controller.tipoPersonaVehiculo.value = rol;
            controller.controllerCedulaVehiculo.text = '1712345678';
            final resultado = await tester.runAsync(() async {
              final consultado = await controller
                  .consultarPersonaRelacionadaVehiculo(key: formKey);
              for (final stream in streams.values) {
                stream.add(
                  const AudioEvent(eventType: AudioEventType.complete),
                );
              }
              await Future<void>.delayed(Duration.zero);
              return consultado;
            });
            expect(resultado, isTrue);
            await tester.pumpAndSettle();
          }
          expect(consultas, 3);
          expect(reproducciones, conBoleta ? 3 : 0);
          await tester.pumpWidget(const SizedBox());
          debugDefaultTargetPlatformOverride = null;
        },
      );
    }
  }
}
