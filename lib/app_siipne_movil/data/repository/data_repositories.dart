
import 'dart:typed_data';

import 'package:get/get.dart';



import '../../../app/core/exceptions/exception_helper.dart';
import '../../../app/core/exceptions/exceptions.dart';
import '../../data/models/models.dart';
import '../../data/providers/providers_impl.dart';
import '../../domain/repositories/domain_repositories.dart';
import '../../domain/request/auth_request.dart';
import '../../domain/request/operativo_create_request.dart';


part 'remote/apis/auth_api_impl.dart';

part 'remote/apis/modulos_api_impl.dart';
part 'remote/apis/operativos_api_impl.dart';


part 'local/local_store_impl.dart';
