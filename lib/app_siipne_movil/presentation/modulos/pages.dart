import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';


import '../../../app/core/app_config.dart';
import '../../../app/core/utils/responsiveUtil.dart';


import '../../../app/core/values/app_colors.dart';
import '../../../app/domain/enums/enums.dart';
import '../../../app/presentation/widgets/custom_app_widgets.dart';
import '../../../feactures/pushNotification/services/bloc/notifications_bloc.dart';

import '../../core/values/app_siipne_movil_images.dart';
import '../routes/siipne_movil_routes.dart';
import '../widgets/custom_siipne_movil_widgets.dart';
import 'controllers.dart';
import 'menu/widgets/indicador_scroll.dart';
import 'op_servicio_urbano/local_widgets/btnIconOperativoWidget.dart';
import 'op_servicio_urbano/local_widgets/colors_local.dart';
import 'op_servicio_urbano/local_widgets/desing_busqueda_por_cedula_widget.dart';
import 'op_servicio_urbano/local_widgets/operativo_polco_local_widgets.dart';


part 'menu/menu_siipne_movil_page.dart';
part 'op_servicio_urbano/op_servicio_urbano_page.dart';
part 'op_servicio_urbano/tipo_operativo/tipo_operativo_page.dart';
