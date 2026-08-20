import 'dart:async';

import 'package:api_provider/core/exceptions/exceptions.dart';
import 'package:api_provider/core/utils/parse_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:siipnemovil_v2/app/presentation/widgets/custom_app_widgets.dart';
import 'package:local_auth/local_auth.dart';
import '../../../app/core/exceptions/exception_dialogos.dart';

import '../../../app/core/utils/device_info_app.dart';
import '../../../app/core/utils/utilidadesUtil.dart';
import '../../../app/presentation/routes/app_routes.dart';
import '../../../feactures/gps/presentation/location/location_bloc.dart';
import '../../../feactures/user/domain/entities/user.dart';
import '../../../feactures/user/presentation/modules/controllers.dart';
import '../../core/values/app_siipne_movil_images.dart';
import '../../data/datasources/datasource_impl_siipne_movil.dart';
import '../../data/models/models_siipne_movil.dart';
import '../../domain/request/request_siipne_movil.dart';
import '../../domain/use_cases/siipne_movil_use_case.dart';
import '../routes/siipne_movil_routes.dart';


part 'menu/menu_siipne_movil_controller.dart';
part 'op_servicio_urbano/op_servicio_urbano_controller.dart';
part 'op_servicio_urbano/tipo_operativo/tipo_operativo_controller.dart';
part 'op_servicio_urbano/anexarse/anexarse_controller.dart';
