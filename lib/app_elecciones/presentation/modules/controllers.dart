


import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../app/core/app_config.dart';
import '../../../app/core/utils/my_gps.dart';
import '../../../app/core/values/app_images.dart';
import '../../../app_elecciones/core/values/app_elecciones_images.dart';
import '../../../app_elecciones/presentation/routes/elecciones_pages.dart';
import '../../../app_elecciones/presentation/routes/elecciones_routes.dart';
import '../../../app_siipne_movil/presentation/routes/siipne_routes.dart';

import '../../../app/core/exceptions/exceptions.dart';
import '../../../app/core/utils/device_info.dart';
import '../../../app/core/utils/fotografia_util.dart';
import '../../../app/core/utils/insert_update_model.dart';
import '../../../app/presentation/widgets/custom_app_widgets.dart';
import '../../../app_siipne_movil/domain/repositories/domain_repositories.dart';
import '../../../app_siipne_movil/presentation/modules/controllers.dart';
import '../../../app_siipne_movil/presentation/widgets/customWidgets.dart';
import '../../core/app_elecciones_config.dart';
import '../../data/models/models.dart';
import '../../data/repository/data_repositories.dart';
import 'package:geolocator/geolocator.dart' as myGeolocator;
import 'package:latlong2/latlong.dart';

import '../../domain/request/elecciones_request.dart';




part 'verificar_opertaivo_recinto_abierto/verificar_opertaivo_recinto_abierto_controller.dart';
part 'home/home_elecciones_controller.dart';
part 'procesos_operativos/procesos_operativos_elecciones_controller.dart';
part 'tipo_servicios/tipo_servicios_controller.dart';
part 'ejes_unidades_policiales/ejes_unidades_policiales_controller.dart';
part 'ejes_hijos/ejes_hijos_controller.dart';
part 'instalaciones/instalaciones_controller.dart';
part 'novedades/novedades_controller.dart';
part 'add_personal/add_personal_controller.dart';
part 'personal_asignado/personal_asignado_controller.dart';

part 'menu/menu_jefe_controller.dart';


