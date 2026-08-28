import 'dart:async';
import 'dart:io';

import 'package:app_mi_upc/app_mi_upc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:get/get.dart';

import '../../../app/core/utils/responsiveUtil.dart';

import '../../../app/core/values/app_images.dart';

import '../../../feactures/user/presentation/widgets/user_custom_widgets.dart';

import '../../core/app_config.dart';
import '../../core/utils/utilidadesUtil.dart';
import '../../core/values/app_colors.dart';

import '../../domain/enums/enums.dart';

import '../routes/app_routes.dart';
import '../widgets/custom_app_widgets.dart';
import '../widgets/img_perfil_redonda.dart';
import 'controllers.dart';

part 'splash/splash_page.dart';
part 'bienvenido/bienvenido_page.dart';
part 'home/home_page.dart';
part 'pdf/pdf_view_page.dart';
part 'menu/menu_app_page.dart';
part 'acuerdo_app/acuerdo_app_page.dart';
