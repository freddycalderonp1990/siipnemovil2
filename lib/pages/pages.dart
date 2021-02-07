
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:siipnemovil2/apis/apis.dart';

import '../bloc/mapa/mapa_bloc.dart';
import '../bloc/mi_ubicacion/mi_ubicacion_bloc.dart';

import '../utils/myGps.dart';
import '../widgets/combos/combosWidget.dart';


import '../appConfig.dart';
import '../providers/providers.dart';
import '../utils/utils.dart';
import '../widgets/customWidgets.dart';
import '../models/models.dart';

part 'loginPage.dart';
part 'homePage.dart';
part 'menuSatPage.dart';
part 'satRegistroVictimaPage.dart';
part 'verificarGpsPage.dart';
part 'satMapaRegistroVictimasPage.dart';
part 'satMapaVisitasVictimasPage.dart';
part 'satRegistroVisitaVictimaPage.dart';
part 'satRegistroParte.dart';

//Sistema Recinto Electoral
part 'recintoElectoral/menuRecintoElectoral.dart';
part 'recintoElectoral/recElecAbrir.dart';
part 'recintoElectoral/recElecRegistrarse.dart';
part 'recintoElectoral/recElecRegistrarNovedades.dart';
part 'recintoElectoral/recElecAddPersonal.dart';
part 'recintoElectoral/recElectPersonalDetalle.dart';
part 'recintoElectoral/recElectNovedadesDetalle.dart';






