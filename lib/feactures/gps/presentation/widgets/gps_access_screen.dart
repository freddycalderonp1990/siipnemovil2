import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/core/utils/responsiveUtil.dart';
import '../../../../app/core/values/app_images.dart';

import '../../../../app/domain/enums/enums.dart';
import '../../../../app/presentation/widgets/custom_app_widgets.dart';
import '../bloc/gps/gps_bloc.dart';
import '../location/location_bloc.dart';

class GpsAccessScreen extends StatelessWidget {
  final Widget contenido;
  final NamApps namApps;
  final bool useSafeArea;

  const GpsAccessScreen({
    super.key,
    required this.contenido,
    required this.namApps,
    this.useSafeArea=false,
  });

  @override
  Widget build(BuildContext context){
    final Widget wg=BlocBuilder<GpsBloc,GpsState>(
      builder:(context,state){
        if(state.isGpsEnabled&&state.isGpsPermissionGranted){
          final locationBloc=BlocProvider.of<LocationBloc>(context);

          locationBloc.getCurrentPosition();

          return BlocBuilder<LocationBloc,LocationState>(
            builder:(context,state){
              if(state.lastKnownLocation==null){
                return _GpsLoadingWidget();
              }

              return contenido;
            },
          );
        }

        return !state.isGpsEnabled
            ?_EnableGpsMessage(namApps:namApps)
            :_AccessButton(namApps:namApps);
      },
    );

    if(useSafeArea){
      return Scaffold(
        backgroundColor:Colors.transparent,
        body:SafeArea(child:wg),
      );
    }

    return wg;
  }
}

// ============================================================
// CARGANDO COORDENADAS
// ============================================================

class _GpsLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final responsive=ResponsiveUtil();

    return Center(
      child:Padding(
        padding:const EdgeInsets.symmetric(horizontal:18),
        child:Container(
          width:double.infinity,
          constraints:const BoxConstraints(
            maxWidth:420,
          ),
          padding:const EdgeInsets.fromLTRB(18,20,18,18),
          decoration:BoxDecoration(
            color:Colors.white.withOpacity(.96),
            borderRadius:BorderRadius.circular(22),
            border:Border.all(
              color:const Color(0xFFD7E3EF),
              width:1,
            ),
            boxShadow:[
              BoxShadow(
                color:const Color(0xFF0D4C9C).withOpacity(.10),
                blurRadius:18,
                offset:const Offset(0,7),
              ),
            ],
          ),
          child:Column(
            mainAxisSize:MainAxisSize.min,
            children:[
              Container(
                width:64,
                height:64,
                decoration:BoxDecoration(
                  gradient:const LinearGradient(
                    begin:Alignment.topLeft,
                    end:Alignment.bottomRight,
                    colors:[
                      Color(0xFF195BA6),
                      Color(0xFF0A3D7E),
                    ],
                  ),
                  borderRadius:BorderRadius.circular(20),
                  boxShadow:[
                    BoxShadow(
                      color:const Color(0xFF195BA6).withOpacity(.22),
                      blurRadius:12,
                      offset:const Offset(0,5),
                    ),
                  ],
                ),
                child:const Icon(
                  Icons.my_location_rounded,
                  color:Colors.white,
                  size:31,
                ),
              ),

              SizedBox(height:responsive.altoP(1.6)),

              const Text(
                "OBTENIENDO UBICACIÓN",
                textAlign:TextAlign.center,
                style:TextStyle(
                  color:Color(0xFF203A55),
                  fontSize:14,
                  fontWeight:FontWeight.w900,
                  letterSpacing:.5,
                ),
              ),

              const SizedBox(height:5),

              const Text(
                "Estamos determinando su posición actual para continuar con el proceso.",
                textAlign:TextAlign.center,
                style:TextStyle(
                  color:Color(0xFF738295),
                  fontSize:10.5,
                  height:1.35,
                  fontWeight:FontWeight.w500,
                ),
              ),

              const SizedBox(height:18),

              ClipRRect(
                borderRadius:BorderRadius.circular(20),
                child:const LinearProgressIndicator(
                  minHeight:5,
                  backgroundColor:Color(0xFFE9EEF4),
                  valueColor:AlwaysStoppedAnimation<Color>(
                    Color(0xFF195BA6),
                  ),
                ),
              ),

              const SizedBox(height:11),

              const Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children:[
                  Icon(
                    Icons.gps_fixed_rounded,
                    size:14,
                    color:Color(0xFF195BA6),
                  ),
                  SizedBox(width:5),
                  Text(
                    "GPS EN PROCESO",
                    style:TextStyle(
                      color:Color(0xFF688097),
                      fontSize:9,
                      fontWeight:FontWeight.w800,
                      letterSpacing:.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ACCESO GPS
// ============================================================

class _AccessButton extends StatelessWidget {
  final NamApps namApps;

  const _AccessButton({
    super.key,
    required this.namApps,
  });

  @override
  Widget build(BuildContext context){
    return MensajePermisoGps(
      namApps:namApps,
      title:'PERMISOS NECESARIOS',
      onPressed:(){
        final gpsBloc=BlocProvider.of<GpsBloc>(context);
        gpsBloc.askGpsAccess();
      },
    );
  }
}

// ============================================================
// MENSAJE PERMISOS GPS
// ============================================================

class MensajePermisoGps extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final NamApps namApps;

  const MensajePermisoGps({
    super.key,
    required this.title,
    this.onPressed,
    required this.namApps,
  });

  @override
  Widget build(BuildContext context){
    final responsive=ResponsiveUtil();

    return Center(
      child:SingleChildScrollView(
        physics:const BouncingScrollPhysics(),
        padding:const EdgeInsets.fromLTRB(16,20,16,24),
        child:Container(
          width:double.infinity,
          constraints:const BoxConstraints(
            maxWidth:460,
          ),
          decoration:BoxDecoration(
            color:Colors.white.withOpacity(.97),
            borderRadius:BorderRadius.circular(24),
            border:Border.all(
              color:const Color(0xFFD8E3EE),
            ),
            boxShadow:[
              BoxShadow(
                color:const Color(0xFF0D4C9C).withOpacity(.10),
                blurRadius:22,
                offset:const Offset(0,8),
              ),
            ],
          ),
          child:ClipRRect(
            borderRadius:BorderRadius.circular(24),
            child:Column(
              mainAxisSize:MainAxisSize.min,
              children:[
                _cabeceraPermiso(),

                Padding(
                  padding:const EdgeInsets.fromLTRB(18,18,18,18),
                  child:Column(
                    mainAxisSize:MainAxisSize.min,
                    children:[
                      Text(
                        title,
                        textAlign:TextAlign.center,
                        style:const TextStyle(
                          color:Color(0xFF233D58),
                          fontSize:16,
                          fontWeight:FontWeight.w900,
                          letterSpacing:.5,
                        ),
                      ),

                      const SizedBox(height:7),

                      Text(
                        "Necesitamos acceder a tu ubicación para utilizar todas las funciones de la aplicación.",
                        textAlign:TextAlign.center,
                        style:TextStyle(
                          fontSize:responsive.diagonalP(1.35),
                          color:const Color(0xFF6F7F90),
                          height:1.4,
                          fontWeight:FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height:18),

                      getMensajeGps(namApps),

                      const SizedBox(height:20),

                      if(onPressed!=null)
                        _btnContinuar(onPressed!),

                      const SizedBox(height:18),

                      _cardPrivacidad(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cabeceraPermiso(){
    return Container(
      width:double.infinity,
      padding:const EdgeInsets.symmetric(
        horizontal:16,
        vertical:16,
      ),
      decoration:const BoxDecoration(
        gradient:LinearGradient(
          begin:Alignment.centerLeft,
          end:Alignment.centerRight,
          colors:[
            Color(0xFF195BA6),
            Color(0xFF0A3D7E),
          ],
        ),
      ),
      child:Row(
        children:[
          Container(
            width:52,
            height:52,
            decoration:BoxDecoration(
              color:Colors.white.withOpacity(.15),
              borderRadius:BorderRadius.circular(16),
              border:Border.all(
                color:Colors.white.withOpacity(.18),
              ),
            ),
            child:const Icon(
              Icons.location_on_rounded,
              color:Colors.white,
              size:29,
            ),
          ),

          const SizedBox(width:12),

          const Expanded(
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children:[
                Text(
                  "ACCESO A UBICACIÓN",
                  style:TextStyle(
                    color:Colors.white,
                    fontSize:14,
                    fontWeight:FontWeight.w900,
                    letterSpacing:.5,
                  ),
                ),
                SizedBox(height:3),
                Text(
                  "Permiso requerido para continuar",
                  style:TextStyle(
                    color:Color(0xDFFFFFFF),
                    fontSize:9.5,
                    fontWeight:FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width:34,
            height:34,
            decoration:BoxDecoration(
              color:Colors.white.withOpacity(.13),
              borderRadius:BorderRadius.circular(10),
            ),
            child:const Icon(
              Icons.security_rounded,
              color:Colors.white,
              size:18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _btnContinuar(VoidCallback onPressed){
    return Material(
      color:Colors.transparent,
      borderRadius:BorderRadius.circular(16),
      child:InkWell(
        borderRadius:BorderRadius.circular(16),
        onTap:onPressed,
        child:Ink(
          width:double.infinity,
          height:54,
          decoration:BoxDecoration(
            gradient:const LinearGradient(
              begin:Alignment.centerLeft,
              end:Alignment.centerRight,
              colors:[
                Color(0xFF195BA6),
                Color(0xFF0A3D7E),
              ],
            ),
            borderRadius:BorderRadius.circular(16),
            boxShadow:[
              BoxShadow(
                color:const Color(0xFF195BA6).withOpacity(.24),
                blurRadius:12,
                offset:const Offset(0,5),
              ),
            ],
          ),
          child:const Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children:[
              Icon(
                Icons.my_location_rounded,
                color:Colors.white,
                size:19,
              ),
              SizedBox(width:8),
              Text(
                "CONTINUAR",
                style:TextStyle(
                  color:Colors.white,
                  fontSize:12,
                  fontWeight:FontWeight.w900,
                  letterSpacing:.7,
                ),
              ),
              SizedBox(width:8),
              Icon(
                Icons.arrow_forward_rounded,
                color:Colors.white,
                size:18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardPrivacidad(){
    return Container(
      width:double.infinity,
      padding:const EdgeInsets.all(12),
      decoration:BoxDecoration(
        color:const Color(0xFFF1F6FB),
        borderRadius:BorderRadius.circular(14),
        border:Border.all(
          color:const Color(0xFFD9E5F0),
        ),
      ),
      child:const Row(
        crossAxisAlignment:CrossAxisAlignment.start,
        children:[
          Icon(
            Icons.shield_outlined,
            color:Color(0xFF195BA6),
            size:20,
          ),

          SizedBox(width:9),

          Expanded(
            child:Text(
              "Tu ubicación está protegida. Solo será utilizada durante el proceso y no se compartirá con terceros.",
              style:TextStyle(
                fontSize:10,
                color:Color(0xFF5C7186),
                height:1.35,
                fontWeight:FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMensajeGps(NamApps namApps){
    switch(namApps){
      case NamApps.Elecciones:
        return getWdMsjElecciones();

      case NamApps.Censo:
        return getWdMsjAppCenso();

      default:
        return _mensajeGeneral();
    }
  }

  Widget _mensajeGeneral(){
    return Column(
      mainAxisSize:MainAxisSize.min,
      children:[
        _itemPermiso(
          numero:"1",
          titulo:"Ubicación operativa",
          detalle:"Determinar la posición actual del dispositivo.",
        ),

        const SizedBox(height:7),

        _itemPermiso(
          numero:"2",
          titulo:"Validación territorial",
          detalle:"Relacionar la operación con el lugar donde se ejecuta.",
        ),

        const SizedBox(height:7),

        _itemPermiso(
          numero:"3",
          titulo:"Seguridad y auditoría",
          detalle:"Registrar correctamente la ubicación durante los procesos institucionales.",
        ),
      ],
    );
  }

  Widget getWdMsjElecciones(){
    return Column(
      mainAxisSize:MainAxisSize.min,
      children:[
        _itemPermiso(
          numero:"1",
          titulo:"Operativos cercanos",
          detalle:"Verificar los operativos abiertos cercanos a tu ubicación.",
        ),

        const SizedBox(height:7),

        _itemPermiso(
          numero:"2",
          titulo:"Recintos y unidades",
          detalle:"Mostrar los Recintos Electorales o Unidades Policiales según la ubicación donde te encuentres.",
        ),

        const SizedBox(height:7),

        _itemPermiso(
          numero:"3",
          titulo:"Novedades y eventos",
          detalle:"Registrar Novedades y Eventos en el lugar donde ocurrieron.",
        ),
      ],
    );
  }

  Widget getWdMsjAppCenso(){
    return Column(
      mainAxisSize:MainAxisSize.min,
      children:[
        _itemPermiso(
          numero:"1",
          titulo:"Procesos cercanos",
          detalle:"Verificar los procesos de censo cercanos a tu ubicación.",
        ),

        const SizedBox(height:7),

        _itemPermiso(
          numero:"2",
          titulo:"Ubicación de mesas",
          detalle:"Mostrar las mesas según la ubicación donde te encuentres.",
        ),
      ],
    );
  }

  Widget _itemPermiso({
    required String numero,
    required String titulo,
    required String detalle,
  }){
    return Container(
      width:double.infinity,
      padding:const EdgeInsets.all(11),
      decoration:BoxDecoration(
        color:const Color(0xFFF8FAFD),
        borderRadius:BorderRadius.circular(13),
        border:Border.all(
          color:const Color(0xFFE0E7EF),
        ),
      ),
      child:Row(
        crossAxisAlignment:CrossAxisAlignment.start,
        children:[
          Container(
            width:28,
            height:28,
            decoration:BoxDecoration(
              color:const Color(0xFFE6F0FA),
              borderRadius:BorderRadius.circular(8),
            ),
            child:Center(
              child:Text(
                numero,
                style:const TextStyle(
                  color:Color(0xFF195BA6),
                  fontSize:11,
                  fontWeight:FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(width:9),

          Expanded(
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children:[
                Text(
                  titulo,
                  style:const TextStyle(
                    color:Color(0xFF30485F),
                    fontSize:10.5,
                    fontWeight:FontWeight.w800,
                  ),
                ),

                const SizedBox(height:2),

                Text(
                  detalle,
                  style:const TextStyle(
                    color:Color(0xFF748395),
                    fontSize:9.5,
                    height:1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// GPS DESACTIVADO
// ============================================================

class _EnableGpsMessage extends StatelessWidget {
  final NamApps namApps;

  const _EnableGpsMessage({
    super.key,
    required this.namApps,
  });

  @override
  Widget build(BuildContext context){
    return MensajePermisoGps(
      namApps:namApps,
      title:'ACTIVE EL GPS',
    );
  }
}