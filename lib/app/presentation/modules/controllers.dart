import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_provider/core/api_config.dart';
import 'package:api_provider/core/exceptions/exceptions.dart';
import 'package:api_provider/core/utils/prints_msj.dart';
import 'package:api_provider/domain/enums/enums.dart';
import 'package:app_mi_upc/app_mi_upc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/core/utils/utilidadesUtil.dart';
import '../../../app/presentation/widgets/custom_app_widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../../../app_siipne_movil/data/models/models_siipne_movil.dart';
import '../../../app_siipne_movil/domain/request/request_siipne_movil.dart';
import '../../../app_siipne_movil/domain/use_cases/siipne_movil_use_case.dart';
import '../../../app_siipne_movil/presentation/routes/siipne_movil_routes.dart';
import '../../../feactures/app_moviles/data/models/apps_model.dart';
import '../../../feactures/app_moviles/domain/request/verificar_update_request.dart';
import '../../../feactures/app_moviles/domain/use_cases/verificar_update_app.dart';

import '../../../feactures/user/domain/entities/user.dart';
import '../../../feactures/user/domain/use_cases/local_store.dart';
import '../../../feactures/user/presentation/modules/controllers.dart';
import '../../../feactures/user/presentation/routes/user_routes.dart';
import '../../core/app_config.dart';

import '../../core/exceptions/exception_dialogos.dart';
import '../../core/utils/device_info_app.dart';

import '../../core/values/mensajes_string.dart';

import '../../domain/enums/enums.dart';
import '../routes/app_routes.dart';

part 'splash/splash_controller.dart';
part 'bienvenido/bienvenido_controller.dart';
part 'home/home_controller.dart';
part 'pdf/pdf_view_controller.dart';
part 'menu/menu_app_controller.dart';
part 'acuerdo_app/acuerdo_app_controller.dart';
