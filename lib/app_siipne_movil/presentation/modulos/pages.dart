import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart' hide Transition;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';


import '../../../app/core/app_config.dart';
import '../../../app/core/utils/responsiveUtil.dart';


import '../../../app/core/values/app_colors.dart';
import '../../../app/core/values/app_images.dart';
import '../../../app/domain/enums/enums.dart';
import '../../../app/presentation/widgets/custom_app_widgets.dart';
import '../../../app/presentation/widgets/img_perfil_redonda.dart';
import '../../../feactures/pushNotification/services/bloc/notifications_bloc.dart';

import '../../core/utils/operativo_qr_util.dart';
import '../../core/values/app_siipne_movil_images.dart';
import '../../data/models/models_siipne_movil.dart';
import '../routes/siipne_movil_routes.dart';
import '../widgets/custom_siipne_movil_widgets.dart';
import 'controllers.dart';
import 'menu/widgets/indicador_scroll.dart';
import 'op_servicio_urbano/local_widgets/btnIconOperativoWidget.dart';
import 'op_servicio_urbano/local_widgets/colors_local.dart';
import 'op_servicio_urbano/local_widgets/desing_busqueda_por_cedula_widget.dart';
import 'op_servicio_urbano/local_widgets/operativo_polco_local_widgets.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

part 'menu/menu_siipne_movil_page.dart';
part 'op_servicio_urbano/op_servicio_urbano_page.dart';
part 'op_servicio_urbano/tipo_operativo/tipo_operativo_page.dart';
part 'op_servicio_urbano/anexarse/anexarse_page.dart';
part 'op_servicio_urbano/ocupantes/op_Vehiculo_Personas_Page.dart';
