import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:latlong/latlong.dart';

//con show importamos solo lo que nos interesa

import 'package:meta/meta.dart';

part 'mi_ubicacion_event.dart';

part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(MiUbicacionState());
  StreamSubscription<Geolocator.Position> _positionSubscription;

  void iniciarSeguimiento() {
    //escucha los cambios de la posicion del GPS
    this._positionSubscription = Geolocator.getPositionStream(
            //configuracion de la presion del GPS
            //entre mas preciso mas consumo de bateria
            desiredAccuracy: Geolocator.LocationAccuracy.high,
            distanceFilter:
                10 //la distancia en metros que captura un nuevo valor el gps cuando el usuario se mueve
            )
        .listen((Geolocator.Position position) {
      print("position");
      print(position);


      final ubicacion= new LatLng(position.latitude, position.longitude);
      add(OnUbicacionCambio(ubicacion));

    });
  }

  void cancelarSeguimiento() {
    this._positionSubscription?.cancel();
  }

  @override
  Stream<MiUbicacionState> mapEventToState(
    MiUbicacionEvent event,
  ) async* {

    if(event is OnUbicacionCambio){
      print("event.ubicacion");
      print(event.ubicacion);
      //      yield emite un nuevo estado
      yield state.copyWith(
        existeUbicacion: true,
        ubicacion: event.ubicacion
      );

    }
  }
}
