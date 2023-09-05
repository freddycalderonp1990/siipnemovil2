import 'dart:convert';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../../app_siipne_movil/core/values/siipne_colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart' as grafo;



import 'package:audioplayers/audioplayers.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/core/utils/algoritmo_TOTP.dart';
import '../../../app/core/utils/utilidadesUtil.dart';
import '../../../app/core/values/app_colors.dart';
import '../../../app/core/values/app_images.dart';

import '../../../app/presentation/routes/app_routes.dart';
import '../../../app_siipne_movil/presentation/modules/operativos/relacional/local_widgets/desing_datos_relacional_wg.dart';


import '../../../app/presentation/widgets/custom_app_widgets.dart';
import '../../../app_siipne_movil/core/siipne_config.dart';

import '../../../app_siipne_movil/presentation/widgets/customWidgets.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

import '../widgets/pdf/pdf_resumen_consulta.dart';
import 'controllers.dart';



import '../../presentation/modules/login/local_widgets/desingBtn.dart';


import '../../data/models/models.dart';
import '../../presentation/routes/siipne_routes.dart';

import '../../presentation/modules/login/local_widgets/wgLogin.dart';




import '../../core/values/siipne_strings.dart';

import '../../core/values/siipne_images.dart';

import '../../../app/core/utils/responsiveUtil.dart';

import '../../presentation/widgets/customWidgets.dart';
import 'home/local_widgets/gridDashboard.dart';
import 'login/local_widgets/WorkAreaLoginPageWidget.dart';
import 'operativos/polco/local_widgets/desing_busqueda_por_cedula_widget.dart';
import 'operativos/polco/local_widgets/operativo_polco_local_widgets.dart';




part 'home/home_page.dart';

part 'login/login_page.dart';
part 'login/inicio_rapido/inicio_rapido_page.dart';
part 'ant/ant_page.dart';
part 'operativos/polco/operativoPolco_page.dart';
part 'operativos/relacional/operativoRelacional_page.dart';
part 'operativos/relacional/operativoRelacionalGrafo_page.dart';


