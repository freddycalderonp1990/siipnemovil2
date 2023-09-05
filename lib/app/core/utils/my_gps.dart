import 'dart:async';

import 'package:geolocator/geolocator.dart' as myGeolocator;
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong2/latlong.dart';
import '../../../app_siipne_movil/presentation/widgets/customWidgets.dart';
import '../app_config.dart';


class MyGps{


static myGeolocator.LocationSettings get getConfig{
  final myGeolocator.LocationSettings locationSettings = myGeolocator.LocationSettings(
    accuracy: myGeolocator.LocationAccuracy.high,
    distanceFilter: 50,
  );

  return locationSettings;

}

 static Future<bool> verificarGPS() async{
   cancelarSeguimiento();
   AppConfig.ubicacionLista.value=false;
    // PermisoGPS verifica si el usuario ya dio permisos
    bool permisoGPS = await _checkGpsPermisoStatus();
    //True el usuario dio permisos
   print("verificarGPS check servivio de gps = ${permisoGPS}");

    if(!permisoGPS){
      String msj="Necesitamos acceder a la ubicación del Dispositivo.\n\n Por favor active los Permisos de la Ubicación";
      DialogosAwesome.getWarning(descripcion: msj,btnOkOnPress: ()async{
        permisoGPS=await _checkGpsPermisoStatus2();
      });
      return false;
    }

    //verificamos que el GPS del dispositivo este encendido
    final gpsActivo = await myGeolocator.Geolocator.isLocationServiceEnabled();
    if(!gpsActivo){
      String msj= "Necesitamos acceder a la ubicación del Dispositivo.\n\n Por favor active el GPS - Ubicación  de su dispositivo";
      DialogosAwesome.getWarning(descripcion: msj,btnOkOnPress: (){
        Get.back();

      });
      return false;
    }

    if(permisoGPS && gpsActivo  ){
      return true;
    }
    else{
      DialogosAwesome.getError(descripcion: "No se puede obtener información del GSP. Es necesario los permisos del Gps para continuar",title: "Error Gps");
      return false;
    }

  }

 static Future<bool> _checkGpsPermisoStatus( ) async {
   myGeolocator. LocationPermission permission  = await myGeolocator.Geolocator.checkPermission();


    bool result=true;
    switch (permission) {
      //Permiso denegado
      case myGeolocator.LocationPermission.denied:

        result= false;

        break;
//Permiso Permanentemente denegado
      case myGeolocator.LocationPermission.deniedForever:
        result= false;

        break;
  //Activo cuando la aplicacion esta en uso
      case myGeolocator.LocationPermission.whileInUse:

        result= true;

        break;
   //Activo siemre
      case myGeolocator.LocationPermission.always:

        result= true;

        break;

   //Permiso no  se puede determinar el estado del permiso. Este permiso es sólo
   //   /// devuelto por el método `Geolocator.checkPermission()` en la plataforma web
   //   /// para navegadores que no implementan la API de permiso (consulte https://developer.mozilla.org/en-US/docs/Web/API/Permissions_API).
     case myGeolocator.LocationPermission.unableToDetermine:
       result= false;

       break;



   }

    return result;
  }


static Future<bool> _checkGpsPermisoStatus2() async {
  bool serviceEnabled;
  myGeolocator. LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await myGeolocator.Geolocator.isLocationServiceEnabled();
  print("verificar servivio de gps = ${serviceEnabled}");
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.

   // return Future.error('Location services are disabled.');
    return false;
  }

  permission = await myGeolocator.Geolocator.checkPermission();



  print("checkPermission servivio de gps = ${permission}");
  if (permission == myGeolocator.LocationPermission.denied) {
    permission = await myGeolocator.Geolocator.requestPermission();
    print("requestPermission servivio de gps = ${permission}");
    if (permission == myGeolocator.LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
     // return Future.error('Location permissions are denied');
      return false;
    }
  }

  if (permission == myGeolocator.LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return await  openAppSettings();
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return true;
}

 static Future iniciarSeguimiento() async {

    bool gpsListo=await verificarGPS();
    if(!gpsListo){
      return;
    }

   if (AppConfig.positionSubscription == null) {

     print("iniciarSeguimiento");


     final positionStream =myGeolocator.Geolocator.getPositionStream(locationSettings: MyGps.getConfig
     );
     AppConfig.positionSubscription = positionStream.handleError((error) {
       print("tcambia ubicacion ${error}");
       AppConfig.positionSubscription!.cancel();
       AppConfig.positionSubscription = null;

     }).listen((position) {
       AppConfig.ubicacion.value=  LatLng(position.latitude, position.longitude);
       print("cambia ubicacion ${AppConfig.ubicacion.value.latitude}, ${AppConfig.ubicacion.value.longitude}");
       AppConfig.ubicacionLista.value=true;
     });

   }


 }

 static void cancelarSeguimiento() {

   AppConfig.positionSubscription?.cancel();
   AppConfig.positionSubscription=null;
 }
}