import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart' as myGeolocator;
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong2/latlong.dart';

enum Ambiente { desarrollo, prueba, produccion }

class AppConfig {

  static  String formatoFecha =  'yyyy-MM-dd';
  static  String formatoHora =  'HH:mm';


  static const double radioBotones = 15.0;

  static const AmbienteUrl=Ambiente.desarrollo;

  static const String linkAppAndroid =
      "https://play.google.com/store/apps/details?id=ecuador.policianacional.dntic.siipnemovil2";
  static const String linkAppIos =
      "https://apps.apple.com/ec/app/siipnemovil-2/id1552944115";


  static const Color colorBotonesWidget = Colors.lightBlue;

  static const double radioBordecajas = 15.0;
  static const double sobraBordecajas = 12.0;

  static const double tamTextoTitulo = 2.0; //tamaño del texto en porcentaje
  static const double tamTexto = 1.5; //tamaño del texto en porcentaje

  static const double anchoContenedor = 90.0;


  //VARIABLES PARA LOS OPERATIVOS DEL SIIPNE

  //OPERATIVOS POLCO

  //SIRVE PARA CARGAR LOS TIPOS DE OPERATIVOS SEGUN LOS OPERATIVOS POLCOS
  static const int idGenTipoTipificacionEcu_OperativoPolco  = 21271; //21271=OPERATIVO SERVICIO URBANO
  //Nota: idGenTipoTipificacionEcu
  //Es un código que viene del ECU911 con la información preliminar del tipo de tipificación del evento. Es decir, aqui viene
  // un id del Ecu que es el mismo en nuestra base de datos tabla genTipoTipificacion,  que identifica el tipo de incidente preliminar
  // que no necesariamente es el real.
  //El idGenTipoTipificacionEcu=21271 corresponde al OPERATIVO SERVICIO URBANO,





  //esta variable sirve para identificar el operativo que seleciona el usuario en la pantalla donde se cargan todos los operativos
  //segun este id carga el operativo polco (Consulta de personas y vehículos)
  static const int idGenModulo_OperativoPolco  = 44; //Móviles Operativos Polco (37=Pruebas, 44Desarrollo, )
  //Obtiene los tipo de tipificaciones de la tabla genTipoTipificacion segun el operativo polco



  //VARIABLES PARA OPERATIVOS RELACIONALES


  static const Duration defaultDuration = Duration(milliseconds: 300);



  static StreamSubscription<myGeolocator.Position>? positionSubscription;
  static Rx<LatLng> ubicacion=new LatLng(0.0,0.0).obs;
  static RxBool errorUbicacion=true.obs;
  static RxBool ubicacionLista=false.obs;


}
