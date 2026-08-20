part of '../pages.dart';

class AcuerdoAppPage extends GetView<AcuerdoAppController> {
  const AcuerdoAppPage({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context){
    return Obx((){
      /*
     * Mientras verificamos O mientras ya estamos navegando
     * jamás construimos visualmente el acuerdo.
     */
      if(
      controller.verificandoAcuerdoInicial.value ||
          controller.redireccionando.value
      ){
        return _verificando();
      }

      return _pantallaAcuerdo(context);
    });
  }
  // ============================================================
  // VERIFICANDO
  // ============================================================

  Widget _verificando(){
    return Scaffold(
      backgroundColor:AppColors.colorPrimary,
      body:const SafeArea(
        child:Center(
          child:Column(
            mainAxisSize:MainAxisSize.min,
            children:[
              SizedBox(
                width:34,
                height:34,
                child:CircularProgressIndicator(
                  strokeWidth:3,
                  color:Colors.white,
                ),
              ),
              SizedBox(height:14),
              Text(
                "VERIFICANDO ACCESO...",
                style:TextStyle(
                  color:Colors.white,
                  fontSize:11,
                  fontWeight:FontWeight.w800,
                  letterSpacing:.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PANTALLA ACUERDO
  // ============================================================

  Widget _pantallaAcuerdo(BuildContext context){
    final responsive=ResponsiveUtil();

    return WorkAreaPageWidget(
      title:null,
      contenidoExpandido:true,
      peticionServer:controller.peticionServerState,
      contenido:Padding(
        padding:EdgeInsets.fromLTRB(
          responsive.anchoP(1),
          responsive.altoP(.5),
          responsive.anchoP(1),
          responsive.altoP(.5),
        ),
        child:Container(
          width:double.infinity,
          decoration:BoxDecoration(
            color:Colors.white,
            borderRadius:BorderRadius.circular(22),
            boxShadow:[
              BoxShadow(
                color:Colors.black.withOpacity(.10),
                blurRadius:24,
                offset:const Offset(0,8),
              ),
            ],
          ),
          child:ClipRRect(
            borderRadius:BorderRadius.circular(22),
            child:Column(
              children:[
                _encabezado(responsive),

                Expanded(
                  child:Padding(
                    padding:EdgeInsets.fromLTRB(
                      responsive.anchoP(3.5),
                      responsive.altoP(1.3),
                      responsive.anchoP(3.5),
                      responsive.altoP(.8),
                    ),
                    child:Column(
                      children:[
                        _alerta(),

                        SizedBox(
                          height:responsive.altoP(1),
                        ),

                        Expanded(
                          child:_contenido(),
                        ),

                        SizedBox(
                          height:responsive.altoP(1),
                        ),

                        _acepto(),

                        SizedBox(
                          height:responsive.altoP(1),
                        ),

                        _acciones(),

                        SizedBox(
                          height:responsive.altoP(.4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ENCABEZADO
  // ============================================================

  Widget _encabezado(ResponsiveUtil responsive){
    return Container(
      width:double.infinity,
      padding:EdgeInsets.symmetric(
        horizontal:responsive.anchoP(4),
        vertical:responsive.altoP(1.4),
      ),
      decoration:const BoxDecoration(
        gradient:LinearGradient(
          begin:Alignment.centerLeft,
          end:Alignment.centerRight,
          colors:[
            Color(0xFF0D4C9C),
            Color(0xFF123A69),
          ],
        ),
      ),
      child:Row(
        children:[
          Container(
            width:48,
            height:48,
            decoration:BoxDecoration(
              color:Colors.white.withOpacity(.14),
              borderRadius:BorderRadius.circular(14),
              border:Border.all(
                color:Colors.white.withOpacity(.22),
              ),
            ),
            child:const Icon(
              Icons.policy_rounded,
              color:Colors.white,
              size:27,
            ),
          ),

          const SizedBox(width:11),

          const Expanded(
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children:[
                Text(
                  "AVISO LEGAL",
                  style:TextStyle(
                    color:Colors.white,
                    fontSize:17,
                    fontWeight:FontWeight.w900,
                    letterSpacing:.4,
                  ),
                ),

                SizedBox(height:2),

                Text(
                  "Conocimiento y aceptación de uso de SIIPNE MÓVIL",
                  style:TextStyle(
                    color:Color(0xE6FFFFFF),
                    fontSize:10.5,
                    fontWeight:FontWeight.w500,
                    height:1.2,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:const EdgeInsets.symmetric(
              horizontal:8,
              vertical:5,
            ),
            decoration:BoxDecoration(
              color:Colors.white.withOpacity(.13),
              borderRadius:BorderRadius.circular(20),
            ),
            child:const Row(
              mainAxisSize:MainAxisSize.min,
              children:[
                Icon(
                  Icons.verified_user_rounded,
                  color:Colors.white,
                  size:14,
                ),

                SizedBox(width:4),

                Text(
                  "SEGURIDAD",
                  style:TextStyle(
                    color:Colors.white,
                    fontSize:8,
                    fontWeight:FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ALERTA
  // ============================================================

  Widget _alerta(){
    return Container(
      width:double.infinity,
      padding:const EdgeInsets.all(10),
      decoration:BoxDecoration(
        color:const Color(0xFFFFF8E6),
        borderRadius:BorderRadius.circular(13),
        border:Border.all(
          color:const Color(0xFFFFD670),
        ),
      ),
      child:const Row(
        crossAxisAlignment:CrossAxisAlignment.start,
        children:[
          Icon(
            Icons.warning_amber_rounded,
            color:Color(0xFFB77900),
            size:21,
          ),

          SizedBox(width:8),

          Expanded(
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children:[
                Text(
                  "IMPORTANTE",
                  style:TextStyle(
                    color:Color(0xFF8A5A00),
                    fontSize:10.5,
                    fontWeight:FontWeight.w900,
                  ),
                ),

                SizedBox(height:2),

                Text(
                  "Debe leer completamente las condiciones antes de habilitar la aceptación.",
                  style:TextStyle(
                    color:Color(0xFF6B520F),
                    fontSize:10.5,
                    height:1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TEXTO ACUERDO
  // ============================================================

  Widget _contenido(){
    return Container(
      width:double.infinity,
      decoration:BoxDecoration(
        color:const Color(0xFFF8FAFC),
        borderRadius:BorderRadius.circular(14),
        border:Border.all(
          color:const Color(0xFFDDE4EC),
        ),
      ),
      child:Column(
        children:[
          Container(
            width:double.infinity,
            padding:const EdgeInsets.symmetric(
              horizontal:12,
              vertical:8,
            ),
            decoration:const BoxDecoration(
              color:Color(0xFFF0F4F8),
              borderRadius:BorderRadius.only(
                topLeft:Radius.circular(13),
                topRight:Radius.circular(13),
              ),
            ),
            child:const Row(
              children:[
                Icon(
                  Icons.description_outlined,
                  color:Color(0xFF0D4C9C),
                  size:17,
                ),

                SizedBox(width:7),

                Expanded(
                  child:Text(
                    "CONDICIONES DE USO DEL APLICATIVO",
                    style:TextStyle(
                      color:Color(0xFF334155),
                      fontSize:10.5,
                      fontWeight:FontWeight.w900,
                    ),
                  ),
                ),

                Icon(
                  Icons.swipe_up_alt_rounded,
                  color:Color(0xFF94A3B8),
                  size:18,
                ),
              ],
            ),
          ),

          Expanded(
            child:Scrollbar(
              controller:controller.scrollController,
              thumbVisibility:true,
              radius:const Radius.circular(10),
              child:SingleChildScrollView(
                controller:controller.scrollController,
                physics:const BouncingScrollPhysics(),
                padding:const EdgeInsets.fromLTRB(
                  14,
                  12,
                  18,
                  15,
                ),
                child:Obx(
                      ()=>Text(
                    controller.textoAcuerdo.value,
                    textAlign:TextAlign.justify,
                    style:const TextStyle(
                      color:Color(0xFF374151),
                      fontSize:16,
                      height:1.5,
                      fontWeight:FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACEPTACIÓN
  // ============================================================

  Widget _acepto(){
    return Obx(
          ()=>Container(
        width:double.infinity,
        decoration:BoxDecoration(
          color:controller.acepta.value
              ?const Color(0xFFEAF3FF)
              :const Color(0xFFF7F8FA),
          borderRadius:BorderRadius.circular(13),
          border:Border.all(
            color:controller.acepta.value
                ?AppColors.colorAzul.withOpacity(.45)
                :const Color(0xFFDDE2E8),
          ),
        ),
        child:CheckboxListTile(
          value:controller.acepta.value,
          onChanged:
          controller.puedeAceptar.value &&
              !controller.procesandoAceptacion.value
              ?controller.cambiarAceptacion
              :null,
          controlAffinity:ListTileControlAffinity.leading,
          activeColor:AppColors.colorAzul,
          dense:true,
          visualDensity:VisualDensity.compact,
          contentPadding:const EdgeInsets.symmetric(
            horizontal:6,
            vertical:0,
          ),
          title:Text(
            controller.puedeAceptar.value
                ?"He leído y acepto el Aviso Legal y las Condiciones de Uso."
                :"Lea completamente el documento para habilitar esta opción.",
            style:TextStyle(
              color:controller.puedeAceptar.value
                  ?const Color(0xFF25364A)
                  :Colors.grey.shade500,
              fontSize:10.5,
              fontWeight:FontWeight.w600,
              height:1.2,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ACCIONES
  // ============================================================

  Widget _acciones(){
    return Row(
      children:[
        Expanded(
          flex:2,
          child:_botonContinuar(),
        ),

        const SizedBox(width:8),

        Expanded(
          child:_botonSalir(),
        ),
      ],
    );
  }

  Widget _botonContinuar(){
    return Obx(
          ()=>ElevatedButton.icon(
        onPressed:controller.puedeContinuar
            ?_confirmarAceptacion
            :null,
        icon:controller.procesandoAceptacion.value
            ?const SizedBox(
          width:17,
          height:17,
          child:CircularProgressIndicator(
            strokeWidth:2,
            color:Colors.white,
          ),
        )
            :const Icon(
          Icons.check_circle_rounded,
          size:18,
        ),
        label:Text(
          controller.procesandoAceptacion.value
              ?"REGISTRANDO..."
              :"ACEPTAR Y CONTINUAR",
          maxLines:1,
          overflow:TextOverflow.ellipsis,
          style:const TextStyle(
            fontSize:10,
            fontWeight:FontWeight.w900,
          ),
        ),
        style:ElevatedButton.styleFrom(
          minimumSize:const Size.fromHeight(45),
          backgroundColor:AppColors.colorAzul,
          foregroundColor:Colors.white,
          disabledBackgroundColor:const Color(0xFFCBD5E1),
          elevation:0,
          shape:RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _botonSalir(){
    return Obx(
          ()=>OutlinedButton.icon(
        onPressed:controller.procesandoAceptacion.value
            ?null
            :controller.cerrarSession,
        icon:const Icon(
          Icons.logout_rounded,
          size:16,
        ),
        label:const Text(
          "SALIR",
          style:TextStyle(
            fontSize:10,
            fontWeight:FontWeight.w800,
          ),
        ),
        style:OutlinedButton.styleFrom(
          minimumSize:const Size.fromHeight(45),
          foregroundColor:const Color(0xFF64748B),
          side:const BorderSide(
            color:Color(0xFFCBD5E1),
          ),
          shape:RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONFIRMAR
  // ============================================================

  Future<void> _confirmarAceptacion()async{
    final bool? confirmar=await Get.dialog<bool>(
      AlertDialog(
        backgroundColor:Colors.white,
        shape:RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(18),
        ),
        title:const Row(
          children:[
            Icon(
              Icons.verified_user_rounded,
              color:Color(0xFF0D4C9C),
              size:25,
            ),

            SizedBox(width:9),

            Expanded(
              child:Text(
                "CONFIRMAR ACEPTACIÓN",
                style:TextStyle(
                  color:Color(0xFF25364A),
                  fontSize:14,
                  fontWeight:FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        content:const Text(
          "¿Está seguro de aceptar el Aviso Legal y las Condiciones de Uso de SIIPNE Móvil?",
          textAlign:TextAlign.justify,
          style:TextStyle(
            color:Color(0xFF475569),
            fontSize:12,
            height:1.4,
          ),
        ),
        actions:[
          TextButton(
            onPressed:()=>Get.back(result:false),
            child:const Text(
              "CANCELAR",
            ),
          ),

          ElevatedButton.icon(
            onPressed:()=>Get.back(result:true),
            icon:const Icon(
              Icons.check_circle_rounded,
              size:17,
            ),
            label:const Text(
              "SÍ, ACEPTO",
            ),
            style:ElevatedButton.styleFrom(
              backgroundColor:AppColors.colorAzul,
              foregroundColor:Colors.white,
            ),
          ),
        ],
      ),
      barrierDismissible:false,
    );

    if(confirmar!=true)return;

    final bool resultado=
    await controller.registrarAcuerdo();

    if(!resultado){
      _mostrarError(
        controller.mensajeError.isEmpty
            ?"No fue posible registrar la aceptación del acuerdo."
            :controller.mensajeError,
      );
    }
  }

  void _mostrarError(String mensaje){
    Get.snackbar(
      "No se pudo continuar",
      mensaje,
      snackPosition:SnackPosition.BOTTOM,
      backgroundColor:const Color(0xFFB3261E),
      colorText:Colors.white,
      margin:const EdgeInsets.all(14),
      borderRadius:12,
      icon:const Icon(
        Icons.error_outline_rounded,
        color:Colors.white,
      ),
      duration:const Duration(seconds:4),
    );
  }
}