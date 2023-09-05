
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';


import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/core/utils/encriptar_util.dart';
import '../../../app/data/provider/providers_impl_app.dart';



import '../../../app/core/exceptions/exception_helper.dart';
import '../../../app/core/exceptions/exceptions.dart';


import '../../../app/core/utils/insert_update_model.dart';
import '../../core/utils/photo_helper.dart';

import '../../data/models/models.dart';
import '../../domain/repositories/domain_repositories.dart';
import '../../domain/request/auth_request.dart';
import '../../domain/request/operativo_create_request.dart';
import '../../presentation/widgets/customWidgets.dart';


part 'remote/apis/host/host_siipne_movil.dart';

part 'remote/apis/auth_api_provider.dart';
part 'remote/apis/host/url_api_provider_siipne_movil.dart';
part 'remote/apis/modulos_api_provider.dart';
part 'remote/apis/operativos_api_provider.dart';


part 'local/local_store_provider.dart';





