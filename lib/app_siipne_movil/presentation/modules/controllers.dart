



import 'dart:async';
import 'dart:convert';
import 'dart:developer';


import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import '../../../app/core/app_config.dart';
import '../../../app/core/exceptions/exceptions.dart';
import '../../../app/core/utils/algoritmo_TOTP.dart';

import '../../../app_siipne_movil/core/values/siipne_images.dart';
import 'package:latlong2/latlong.dart';
import '../../../app_siipne_movil/domain/request/operativo_create_request.dart';

import '../../../app/core/utils/device_info.dart';
import '../../../app/core/utils/encriptar_util.dart';
import '../../../app/core/utils/my_gps.dart';
import '../../../app/presentation/routes/app_routes.dart';
import '../../../app/core/utils/responsiveUtil.dart';

import '../../../app/presentation/widgets/custom_app_widgets.dart';
import '../../data/repository/data_repositories.dart';
import '../../presentation/gps/gps_impl_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:typed_data';
import 'package:get/get.dart';


import '../../data/models/models.dart';
import '../../domain/repositories/domain_repositories.dart';
import '../../domain/request/auth_request.dart';

import '../../core/siipne_config.dart';

import '../../../app/core/utils/utilidadesUtil.dart';
import '../../presentation/routes/siipne_routes.dart';

import '../../../app/core/utils/biometricUtil.dart';

import 'package:geolocator/geolocator.dart' as myGeolocator;







import '../../presentation/widgets/customWidgets.dart';
import '../widgets/pdf/pdf_resumen_consulta.dart';
import 'login/local_widgets/pin_code_widget.dart';

part 'home/home_controller.dart';

part 'login/login_controller.dart';
part 'login/inicio_rapido/inicio_rapido_controller.dart';
part 'ant/ant_controller.dart';

part 'operativos/polco/operativoPolco_controller.dart';
part 'operativos/relacional/operativoRelacional_controller.dart';
