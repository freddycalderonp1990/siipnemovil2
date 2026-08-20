
import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:api_provider/core/api_config.dart';
import 'package:api_provider/core/exceptions/exception_helper.dart';
import 'package:api_provider/core/exceptions/exceptions.dart';
import 'package:api_provider/data/data_source/providers_impl_app.dart';
import 'package:api_provider/data/data_source/remote/apis/host/host_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/request/request_siipne_movil.dart';
import '../models/models_siipne_movil.dart';
import 'package:http/http.dart' as http;
part 'remote/apis/host/host_app_siipne_movil.dart';
part 'remote/apis/host/url_api_provider_app_siipne_movil.dart';

part 'remote/apis/siipne_movil_api_constantes.dart';
part 'remote/apis/siipne_movil_remote_data_source.dart';
