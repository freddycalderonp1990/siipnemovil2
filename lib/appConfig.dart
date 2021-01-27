import 'package:flutter/material.dart';

class AppConfig {

  static const nameApp = "SIIPNE MOVIL V2"; //tamaño del texto en porcentaje
  static const rutaImg = "assets/img/";
  static const rutaIcon = "assets/icon/";

  static const double tamTexto = 3.5; //tamaño del texto en porcentaje

  static const double tamTextoTitulo = 4.0; //tamaño del texto en porcentaje
  static const int numDecimalesLatLong = 8; //numero de decimales para las coordenadas

  //Configuracion Mapa
  static Color colorBtnMapa = Colors.blue;
  static  Color colorBtnRelleno = Colors.white;
  static  double sizeBtnSobreMapa = 40;



  static  String formatoFecha =  'yyyy-MM-dd';
  static  String formatoHora =  'HH:mm';
  static  String formatoSoloHora =  'HH';
  static  String formatoSoloMinuto =  'mm';

  static  String formatoFechaEnviarServer =  'yyyy_MM_dd';
  static  String formatoHoraEnviarServer =  'HH:mm:ss';

  static  String formatoFechaHora =  AppConfig.formatoFecha+" "+AppConfig.formatoHora;

  static const List<Color> colorCirculo1 = [
    Colors.white,
    Colors.lightBlueAccent
  ];
  static const List<Color> colorCirculo2 = [
    Colors.white,
    Colors.white,
    Colors.lightBlue
  ];
  static const Color colorBanner = Colors.lightBlue;
  static const Color colorBotonesWidget = Colors.lightBlue;

  static const Color colorBordecajas = Colors.blueAccent;
  static const double sobraBordecajas = 8.0;
  static const double radioBordecajas = 15.0;
  static const double anchoContenedor = 90.0;
  static const double anchoContenedorHijos = 20.0;// para mostra el tamaño de los hijos dentro del contenedor, este valor se resta al ancho total que tenga la pantalla  responsive.anchoP(anchoContenedor)-20.0
  static const Color colorIcons= Colors.black38;
  //-*********************** ICONOS *******************************
  static const iconNoImg = AppConfig.rutaIcon + "icon_no_img.png";
  static const icon_abrir_rec_elec = AppConfig.rutaIcon + "icon_abrir_rec_elec.png";
  static const icon_eliminar_rec_elec = AppConfig.rutaIcon + "icon_eliminar_rec_elec.png";
  static const icon_finalizar_rec_elec = AppConfig.rutaIcon + "icon_finalizar_rec_elec.png";
  static const icon_registrar_novedades_rec_elec = AppConfig.rutaIcon + "icon_registrar_novedades_rec_elec.png";
  static const icon_registrarse_rec_elect = AppConfig.rutaIcon + "icon_registrarse_rec_elect.png";
  static const icon_abandonar_rec_elec = AppConfig.rutaIcon + "icon_abandonar_rec_elec.png";
  static const icon_agregar_personal = AppConfig.rutaIcon + "icon_agregar_personal.png";
  static const icon_usuario = AppConfig.rutaIcon + "icon_usuario.png";
  static const icon_clave = AppConfig.rutaIcon + "icon_clave.png";
  static const icon_camara = AppConfig.rutaIcon + "icon_camara.png";


  static const imgMinisterio = AppConfig.rutaImg + "logoMinisterio.png";
  static const imgPaquito = AppConfig.rutaImg + "paquito.png";
  static const imgSello = AppConfig.rutaImg + "icondgi.png";
  static const imgFondo = AppConfig.rutaImg + "fondo.png";
  static const imgFondoLogin = AppConfig.rutaImg + "fondo_login.png";
  static const imgPolice = AppConfig.rutaImg + "ic_police.png";
  static const imgInstalaciones = AppConfig.rutaImg + "ic_instalaciones.png";
  static const imgVehiculo = AppConfig.rutaImg + "ic_vehiculo.png";
  static const imgRuta = AppConfig.rutaImg + "ic_ruta.png";
  static const imgPie = AppConfig.rutaImg + "pie.png";
  static const imgLocationAccess = AppConfig.rutaImg + "location_access.png";
  static const escudopolicia = AppConfig.rutaImg + "escudopolicia.png";


  static const pantallaPruebas = "pruebas";
  static const pantallaLogin = "login";
  static const pantallaPrincipal = "principal";
  static const pantallaVerificarGps = "verificarGps";

  //SISTEMA DE ALERTAS TEMPRANAS
  static const pantallaMenuSat = "menuSat";
  static const pantallaSatRegistroVictima = "satRegistroVictima";
  static const pantallaSatMapasRegistroVictimas = "satMapasRegistroVictimas";
  static const pantallaSatMapasVisitasVictimas = "satMapasVisitasVictimas";
  static const pantallaSatRegistroVisitasVictimas = "satRegistroVisitasVictimas";
  static const pantallaSatRegistroParte = "satRegistroParte";


  //RECINTOS ELECTORALES
  static const pantallaMenuRecintoElectoral = "menuRecintoElectoral";
  static const pantallaRecElecAbrir = "recElecAbrir";
  static const pantallaRecElecRegistrarseRecintoElectoral = "recElecRegistrarseRecintoElectoral";
  static const pantallaRecElecRegistrarNovedades = "recElecRegistrarNovedades";
  static const pantallaRecElecAddPersonal = "recElecAddPersonal";
  static const pantallaRecElecPersonalDetalle = "recElecPersonalDetalle";
  static const pantallaRecElecNovedadesDetalle = "recElecNovedadesDetalle";

  //Porcentaje de validacion de las matrizes

  static const double porcentajeValidacion = 70.0;

  //distancia para realizar cualquier accion
  //vairble que valida la distancia minima cuando la posicon cambien para realizar una accion, se da en metros
  static const double distanciaMinima= 20
  ;

  //distancia minima en metros para dibujar nuevos marcadores
  //este valñor debe ser igual o mayor que distanciaMinima
  static const double distanciaMinimaMarker= 20.0;

  static const Color colorMarcadorMiUbicacion= Colors.red;
  static const double sizeMarcadorMiUbicacion= 38.0;
  static const IconData iconMarcadorMiUbicacion=Icons.person_pin_circle;

  static const Color colorMarcadorRastro= Colors.black;
  static const double sizeMarcadorRastro= 38.0;
  static const IconData iconMarcadorRastro= Icons.check_circle;




}