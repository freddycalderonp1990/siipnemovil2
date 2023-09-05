
import 'dart:async';
import 'dart:typed_data';


import '../../domain/request/operativo_create_request.dart';
import 'package:geolocator/geolocator.dart' as myGeolocator;

import 'package:latlong2/latlong.dart';

import '../../data/models/models.dart';
import '../../domain/request/auth_request.dart';


part 'local/local_storage_repository.dart';
part 'local/mapa_repository.dart';
part 'local/gps_movil_repository.dart';

part 'remote/apis/auth_repository.dart';
part 'remote/apis/test_ant.dart';
part 'remote/apis/modulos_repository.dart';
part 'remote/apis/operativos_repository.dart';

