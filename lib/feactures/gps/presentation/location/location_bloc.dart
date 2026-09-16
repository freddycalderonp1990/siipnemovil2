import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' show LatLng;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? positionStream;

  // Guarda la petición que está en curso
  Future<LatLng>? _currentPositionFuture;

  LocationBloc() : super(const LocationState()) {
    on<OnStartFollowingUser>(
          (event, emit) => emit(state.copyWith(followingUser: true)),
    );

    on<OnStopFollowingUser>(
          (event, emit) => emit(state.copyWith(followingUser: false)),
    );

    on<OnNewUserLocationEvent>((event, emit) {
      emit(
        state.copyWith(
          lastKnownLocation: event.newLocation,
          myLocationHistory: [
            ...state.myLocationHistory,
            event.newLocation,
          ],
        ),
      );
    });
  }

  Future<LatLng> getCurrentPosition() {
    print("getCurrentPosition");
    // 1. Si ya tenemos ubicación, la retornamos inmediatamente
    if (state.lastKnownLocation != null) {
      print('📍 Retornando ubicación existente: ${state.lastKnownLocation}');
      return Future.value(state.lastKnownLocation!);
    }

    // 2. Si ya existe una petición en curso, reutilizamos esa misma petición
    if (_currentPositionFuture != null) {
      print('⏳ Ya existe una petición de ubicación, esperando la misma...');
      return _currentPositionFuture!;
    }

    // 3. Primera petición
    print('📍 Obteniendo coordenadas...');

    _currentPositionFuture = _obtainCurrentPosition();

    return _currentPositionFuture!;
  }

  Future<LatLng> _obtainCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition();

      final location = LatLng(
        position.latitude,
        position.longitude,
      );

      print('✅ Coordenadas obtenidas: $location');

      add(OnNewUserLocationEvent(location));

      return location;
    } catch (e) {
      print('❌ Error obteniendo ubicación: $e');
      rethrow;
    } finally {
      // La petición terminó.
      // Si no hay ubicación, permitimos volver a intentarlo.
      if (state.lastKnownLocation == null) {
        _currentPositionFuture = null;
      }
    }
  }

  void startFollowingUser() {
    add(OnStartFollowingUser());

    positionStream?.cancel();

    positionStream = Geolocator.getPositionStream().listen((position) {
      add(
        OnNewUserLocationEvent(
          LatLng(
            position.latitude,
            position.longitude,
          ),
        ),
      );
    });
  }

  void stopFollowingUser() {
    positionStream?.cancel();
    positionStream = null;

    add(OnStopFollowingUser());

    print('🛑 stopFollowingUser');
  }

  @override
  Future<void> close() {
    positionStream?.cancel();
    return super.close();
  }
}