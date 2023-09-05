part of '../domain_repositories.dart';

abstract class GpsMovilRepository {
  Future<LatLng?> iniciarSeguimiento();

  Future<void> cancelarSeguimiento(StreamSubscription<myGeolocator.Position> _positionSubscription );

  Future<StreamSubscription<myGeolocator.Position>>? getPeticionUbicacion(
      {required LatLng destino});

  Future<LatLng> getUbicacion();
}
