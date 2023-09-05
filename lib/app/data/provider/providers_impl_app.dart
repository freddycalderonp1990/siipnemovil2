
import 'dart:async';
import 'dart:convert';
import 'dart:developer';



import 'dart:io' as doc;

//NECESARIOS PARA SUBIR ARCHIVOS
import 'package:async/async.dart'; //DelegatingStream
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';




import '../../../app_siipne_movil/data/models/models.dart';
import '../../../app_siipne_movil/domain/repositories/domain_repositories.dart';
import '../../core/app_config.dart';
import '../../core/exceptions/exception_helper.dart';
import '../../core/exceptions/exceptions.dart';
import '../../core/utils/parse_model.dart';



part 'remote/apis/host/host_app.dart';
part 'remote/apis/host/cabecera_json_model.dart';
part 'remote/apis/host/url_api_provider_app.dart';







