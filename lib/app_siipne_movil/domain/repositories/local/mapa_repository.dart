part of '../domain_repositories.dart';
abstract class MapaRepository{

  Future<LatLng> moveToUbicacion({required LatLng destino,required double zoomMap});
  Future<LatLng> moveCamera({required LatLng destino,required double zoomMap});
  Future<LatLng>  zoomMas({required LatLng destino});
  Future<LatLng> zoomMenos({required LatLng destino});



}