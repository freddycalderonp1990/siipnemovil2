part of '../custom_app_widgets.dart';

class DialogosAwesome {
  static bool isDiaslogoShow=false;

  static Color colorWarning=const Color(0xFFF46B40);
  static Color colorInformacion=AppColors.colorAzul;
  static Color colorError=const Color(0xFFEA4236);
  static Color colorSucess=const Color(0xFF10C26E);

  static String imgDefault=AppImages.escudopolicia;

  static showIconPolicia({
    bool mostrarSegungoBtn=true,
    Color colorBtnSi=AppColors.colorBotones,
    Color colorTitle=AppColors.colorAzul,
    Color colorCircleImg=AppColors.colorAzul,
    String imgString=AppImages.escudopolicia,
    required String title,
    IconData iconBtnSi=Icons.check_circle_outline,
    IconData iconBtnNo=Icons.cancel_outlined,
    String titleBtnSi='Aceptar',
    String titleBtnNo='Cancelar',
    required String descripcion,
    required Function() btnOkOnPress,
    Function()? btnCancelOnPress,
  }){
    return _getIconPolicia(
      mostrarSegungoBtn:mostrarSegungoBtn,
      colorBtnSi:colorBtnSi,
      colorTitle:colorTitle,
      colorCircleImg:colorCircleImg,
      imgString:imgString,
      title:title,
      iconBtnSi:iconBtnSi,
      iconBtnNo:iconBtnNo,
      titleBtnSi:titleBtnSi,
      titleBtnNo:titleBtnNo,
      descripcion:descripcion,
      btnOkOnPress:btnOkOnPress,
      btnCancelOnPress:btnCancelOnPress,
    );
  }

  static _getIconPolicia({
    bool mostrarSegungoBtn=true,
    Color colorBtnSi=AppColors.colorBotones,
    Color colorTitle=AppColors.colorAzul,
    Color colorCircleImg=AppColors.colorAzul,
    String imgString=AppImages.escudopolicia,
    required String title,
    IconData iconBtnSi=Icons.check_circle_outline,
    IconData iconBtnNo=Icons.cancel_outlined,
    String titleBtnSi='Aceptar',
    String titleBtnNo='Cancelar',
    required String descripcion,
    required Function() btnOkOnPress,
    Function()? btnCancelOnPress,
  }){
    if(isDiaslogoShow)return;

    isDiaslogoShow=true;

    AwesomeDialog(
      dismissOnTouchOutside:false,
      dismissOnBackKeyPress:false,
      context:Get.context!,
      dialogType:DialogType.info,
      headerAnimationLoop:true,
      customHeader:Container(
        width:80,
        height:80,
        decoration:BoxDecoration(
          shape:BoxShape.circle,
          border:Border.all(color:colorCircleImg,width:3),
        ),
        child:Center(
          child:Image.asset(
            imgString,
            width:60,
            height:60,
            fit:BoxFit.contain,
          ),
        ),
      ),
      animType:AnimType.scale,
      title:title,
      titleTextStyle:TextStyle(
        color:colorTitle,
        fontWeight:FontWeight.bold,
        fontSize:18,
      ),
      btnCancel:BtnIconWidget(
        colorBtn:colorBtnSi,
        icon:iconBtnSi,
        onPressed:(){
          isDiaslogoShow=false;
          Get.back();
          Future.delayed(
            const Duration(milliseconds:100),
            btnOkOnPress,
          );
        },
        titulo:titleBtnSi,
      ),
      btnOk:!mostrarSegungoBtn
          ?null
          :BtnIconWidget(
        colorBtn:AppColors.colorRojo_60,
        icon:iconBtnNo,
        onPressed:(){
          isDiaslogoShow=false;
          Get.back();

          if(btnCancelOnPress!=null){
            Future.delayed(
              const Duration(milliseconds:100),
              btnCancelOnPress,
            );
          }
        },
        titulo:titleBtnNo,
      ),
      desc:descripcion,
    ).show();
  }

  // ============================================================
  // WARNING
  // ============================================================

  static getWarning({
    String title='ADVERTENCIA',
    String titleBtnOk='Ok',
    required String descripcion,
    Function()? btnOkOnPress,
  }){
    return _getIconPolicia(
      colorBtnSi:colorWarning,
      colorCircleImg:colorWarning,
      colorTitle:colorWarning,
      title:title,
      descripcion:descripcion,
      btnOkOnPress:btnOkOnPress??(){},
      titleBtnSi:"ACEPTAR",
      mostrarSegungoBtn:false,
    );
  }

  static getWarningSiNo({
    String title='ADVERTENCIA',
    required String descripcion,
    Function()? btnOkOnPress,
    Function()? btnCancelOnPress,
  }){
    return _getIconPolicia(
      colorBtnSi:colorInformacion,
      colorCircleImg:colorWarning,
      colorTitle:colorWarning,
      title:title,
      descripcion:descripcion,
      btnOkOnPress:btnOkOnPress??(){},
      titleBtnSi:"SI",
      mostrarSegungoBtn:true,
      titleBtnNo:"NO",
      btnCancelOnPress:btnCancelOnPress??(){},
    );
  }

  // ============================================================
  // WARNING CON CONTADOR
  // ============================================================

  static getWarningSiNoContador({
    String title='ADVERTENCIA',
    required String descripcion,
    Function()? btnOkOnPress,
    Function()? btnCancelOnPress,
  }){
    int segundos=5;
    bool botonesHabilitados=false;
    Timer? timer;

    late AwesomeDialog dialog;

    dialog=AwesomeDialog(
      dismissOnTouchOutside:false,
      dismissOnBackKeyPress:false,
      context:Get.context!,
      dialogType:DialogType.warning,
      headerAnimationLoop:false,
      animType:AnimType.scale,
      customHeader:Container(
        width:80,
        height:80,
        decoration:BoxDecoration(
          shape:BoxShape.circle,
          border:Border.all(color:colorWarning,width:3),
        ),
        child:Center(
          child:Image.asset(
            AppImages.escudopolicia,
            width:60,
            height:60,
            fit:BoxFit.contain,
          ),
        ),
      ),
      body:StatefulBuilder(
        builder:(context,setState){
          timer??=Timer.periodic(
            const Duration(seconds:1),
                (t){
              if(segundos>1){
                setState(()=>segundos--);
              }else{
                setState((){
                  segundos=0;
                  botonesHabilitados=true;
                });
                t.cancel();
              }
            },
          );

          return Padding(
            padding:const EdgeInsets.symmetric(horizontal:12),
            child:Column(
              mainAxisSize:MainAxisSize.min,
              children:[
                Text(
                  title,
                  textAlign:TextAlign.center,
                  style:TextStyle(
                    color:colorWarning,
                    fontWeight:FontWeight.bold,
                    fontSize:18,
                  ),
                ),

                const SizedBox(height:10),

                TextoColorParser.textoConColores(
                  descripcion,
                ),

                const SizedBox(height:18),

                if(!botonesHabilitados)...[
                  Text(
                    "Espere $segundos segundos...",
                    style:const TextStyle(
                      color:AppColors.colorAzul,
                      fontWeight:FontWeight.bold,
                      fontSize:14,
                    ),
                  ),
                  const SizedBox(height:10),
                  const CircularProgressIndicator(
                    color:AppColors.colorAzul,
                  ),
                ],

                if(botonesHabilitados)
                  Row(
                    children:[
                      Expanded(
                        child:ElevatedButton.icon(
                          icon:const Icon(
                            Icons.check_circle_outline,
                          ),
                          label:const Text("SÍ"),
                          style:ElevatedButton.styleFrom(
                            backgroundColor:AppColors.colorBotones,
                            foregroundColor:Colors.white,
                          ),
                          onPressed:(){
                            timer?.cancel();
                            dialog.dismiss();

                            Future.delayed(
                              const Duration(milliseconds:100),
                                  ()=>btnOkOnPress?.call(),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width:8),

                      Expanded(
                        child:ElevatedButton.icon(
                          icon:const Icon(
                            Icons.cancel_outlined,
                          ),
                          label:const Text("NO"),
                          style:ElevatedButton.styleFrom(
                            backgroundColor:Colors.red.shade400,
                            foregroundColor:Colors.white,
                          ),
                          onPressed:(){
                            timer?.cancel();
                            dialog.dismiss();

                            Future.delayed(
                              const Duration(milliseconds:100),
                                  ()=>btnCancelOnPress?.call(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height:10),
              ],
            ),
          );
        },
      ),
    );

    dialog.show();
  }

  // ============================================================
  // ERROR
  // ============================================================

  static getError({
    String title='ERROR',
    required String descripcion,
    Function()? btnOkOnPress,
  }){
    return _getIconPolicia(
      colorBtnSi:colorError,
      colorCircleImg:colorError,
      colorTitle:colorError,
      title:title,
      descripcion:descripcion,
      btnOkOnPress:btnOkOnPress??(){},
      titleBtnSi:"ACEPTAR",
      mostrarSegungoBtn:false,
    );
  }

  // ============================================================
  // SUCCESS
  // ============================================================

  static getSucess({
    String title='ÉXITO',
    required String descripcion,
    Function()? btnOkOnPress,
  }){
    return _getIconPolicia(
      colorBtnSi:colorSucess,
      colorCircleImg:colorSucess,
      colorTitle:colorSucess,
      title:title,
      descripcion:descripcion,
      btnOkOnPress:btnOkOnPress??(){},
      titleBtnSi:"ACEPTAR",
      mostrarSegungoBtn:false,
    );
  }

  // ============================================================
  // INFORMATION
  // ============================================================

  static getInformation({
    String title='INFORMACIÓN',
    String titleBtn='Ok',
    required String descripcion,
    Function()? btnOkOnPress,
  }){
    return _getIconPolicia(
      colorBtnSi:colorInformacion,
      colorCircleImg:colorInformacion,
      colorTitle:colorInformacion,
      title:title,
      descripcion:descripcion,
      btnOkOnPress:btnOkOnPress??(){},
      titleBtnSi:titleBtn,
      mostrarSegungoBtn:false,
    );
  }

  static getInformationSiNo({
    String title='INFORMACIÓN',
    required String descripcion,
    Function()? btnOkOnPress,
    Function()? btnCancelOnPress,
  }){
    return _getIconPolicia(
      colorBtnSi:colorInformacion,
      colorCircleImg:colorInformacion,
      colorTitle:colorInformacion,
      title:title,
      descripcion:descripcion,
      btnOkOnPress:btnOkOnPress??(){},
      titleBtnNo:"NO",
      titleBtnSi:"SI",
      mostrarSegungoBtn:true,
      btnCancelOnPress:btnCancelOnPress??(){},
    );
  }



  // ============================================================
  // CLAVE + BIOMETRÍA
  //
  // Mantiene el comportamiento existente:
  // loginController.validarPass(pass)
  //
  // y permite opcionalmente biometría.
  // ============================================================

  static getDesingChangePass({
    required GlobalKey<FormState> formKey,
    required TextEditingController controllerPass,
    VoidCallback? onPressed,
    String title='INFO',
    required int idDgoCreaOpReci,
    String? descripcion,
    bool mostrarBiometria=false,
    Future<bool> Function()? onBiometria,
    String textoConfirmacion='¿Está seguro de continuar?',
  }){
    final ResponsiveUtil responsive=ResponsiveUtil();
    final double sizeTxt=
    responsive.diagonalP(
      AppConfig.tamTextoTitulo,
    );

    descripcion??=
    "Para abandonar el código $idDgoCreaOpReci, ingrese su clave de seguridad";

    void abrirDialogo(){
      late AwesomeDialog dialog;

      void confirmar(){
        Future.delayed(
          const Duration(milliseconds:150),
              (){
            DialogosAwesome.getWarningSiNo(
              title:"CONFIRMACIÓN",
              descripcion:textoConfirmacion,
              btnOkOnPress:(){
                onPressed?.call();
              },
            );
          },
        );
      }

      dialog=AwesomeDialog(
        dismissOnTouchOutside:false,
        dismissOnBackKeyPress:false,
        dialogType:DialogType.info,
        headerAnimationLoop:false,
        animType:AnimType.topSlide,
        customHeader:Container(
          width:80,
          height:80,
          decoration:BoxDecoration(
            shape:BoxShape.circle,
            border:Border.all(
              color:colorInformacion,
              width:3,
            ),
          ),
          child:Center(
            child:Image.asset(
              AppImages.escudopolicia,
              width:60,
              height:60,
              fit:BoxFit.contain,
            ),
          ),
        ),
        context:Get.context!,
        showCloseIcon:true,
        keyboardAware:true,
        body:Form(
          key:formKey,
          child:Column(
            mainAxisSize:MainAxisSize.min,
            children:<Widget>[
              TituloTextWidget(
                title:title,
              ),

              Text(
                descripcion!,
                textAlign:TextAlign.center,
              ),

              const SizedBox(height:10),

              Container(
                decoration:BoxDecoration(
                  color:Colors.white,
                  borderRadius:BorderRadius.circular(
                    15.0,
                  ),
                ),
                child:ImputTextWidget(
                  imgString:AppImages.icon_clave,
                  elevation:1,
                  isSegura:true,
                  controller:controllerPass,
                  hitText:"Ingrese la clave",
                  label:"Clave",
                  fonSize:sizeTxt,
                  validar:(text){
                    if(
                    text!=null &&
                        text.length>=8
                    ){
                      return null;
                    }

                    return "Clave no válida";
                  },
                ),
              ),

              const SizedBox(height:15),

              BotonesWidget(
                iconData:Icons.check_circle,
                title:"VALIDAR CLAVE",
                onPressed:()async{
                  final bool isValid=
                      formKey.currentState
                          ?.validate() ??
                          false;

                  if(!isValid)return;

                  final LoginController loginController=
                  Get.find<LoginController>();

                  final String pass=
                      controllerPass.text;

                  final bool result=
                  await loginController
                      .validarPass(pass);

                  controllerPass.clear();

                  if(!result){
                    dialog.dismiss();

                    Future.delayed(
                      const Duration(milliseconds:150),
                          (){
                        DialogosAwesome.getError(
                          descripcion:
                          "La clave ingresada no es la correcta",
                          btnOkOnPress:(){
                            abrirDialogo();
                          },
                        );
                      },
                    );

                    return;
                  }

                  dialog.dismiss();
                  confirmar();
                },
              ),

              if(
              mostrarBiometria &&
                  onBiometria!=null
              )...[
                const SizedBox(height:12),

                Row(
                  children:[
                    const Expanded(
                      child:Divider(),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal:8,
                      ),
                      child:Text(
                        "O",
                        style:TextStyle(
                          color:Colors.grey.shade600,
                          fontWeight:FontWeight.bold,
                        ),
                      ),
                    ),
                    const Expanded(
                      child:Divider(),
                    ),
                  ],
                ),

                const SizedBox(height:10),

                BotonesWidget(
                  iconData:Icons.fingerprint,
                  title:"HUELLA / BIOMETRÍA",
                  onPressed:()async{
                    FocusManager
                        .instance
                        .primaryFocus
                        ?.unfocus();

                    final bool autenticado=
                    await onBiometria();

                    if(!autenticado){
                      dialog.dismiss();

                      Future.delayed(
                        const Duration(milliseconds:150),
                            (){
                          DialogosAwesome.getError(
                            title:"AUTENTICACIÓN",
                            descripcion:
                            "No fue posible validar su identidad mediante biometría.",
                            btnOkOnPress:(){
                              abrirDialogo();
                            },
                          );
                        },
                      );

                      return;
                    }

                    controllerPass.clear();

                    dialog.dismiss();
                    confirmar();
                  },
                ),
              ],

              const SizedBox(height:10),
            ],
          ),
        ),
      );

      dialog.show();
    }

    abrirDialogo();
  }

  // ============================================================
  // PERSONALIZADO
  // ============================================================

  static getPersonalizado({
    String title='Información',
    required String descripcion,
  }){
    AwesomeDialog(
      dismissOnTouchOutside:false,
      dismissOnBackKeyPress:false,
      context:Get.context!,
      animType:AnimType.scale,
      customHeader:const Icon(
        Icons.face,
        size:50,
        color:Colors.black,
      ),
      title:title,
      desc:descripcion,
      btnOk:TextButton(
        child:const Text(
          'Cerrar',
        ),
        onPressed:(){
          Get.back();
        },
      ),
      btnOkOnPress:(){},
    ).show();
  }
  static getSelectItem<T>({
    String title='SELECCIONE',
    required String descripcion,
    required List<T> items,
    required String Function(T item) itemText,
    required Function(T item) onSelected,
    Function()? onCancel,
    String hintText='Seleccione una opción',
  }){
    if(items.isEmpty){
      DialogosAwesome.getWarning(
        descripcion:"No existen opciones disponibles.",
      );
      return;
    }

    T? seleccionado;

    late AwesomeDialog dialog;

    dialog=AwesomeDialog(
      dismissOnTouchOutside:false,
      dismissOnBackKeyPress:false,
      context:Get.context!,
      dialogType:DialogType.info,
      headerAnimationLoop:false,
      animType:AnimType.scale,
      customHeader:Container(
        width:80,
        height:80,
        decoration:BoxDecoration(
          shape:BoxShape.circle,
          border:Border.all(
            color:colorInformacion,
            width:3,
          ),
        ),
        child:Center(
          child:Image.asset(
            AppImages.escudopolicia,
            width:60,
            height:60,
            fit:BoxFit.contain,
          ),
        ),
      ),
      body:StatefulBuilder(
        builder:(context,setState){
          return Padding(
            padding:const EdgeInsets.fromLTRB(
              12,
              0,
              12,
              8,
            ),
            child:Column(
              mainAxisSize:MainAxisSize.min,
              children:[
                Text(
                  title,
                  textAlign:TextAlign.center,
                  style:TextStyle(
                    color:colorInformacion,
                    fontWeight:FontWeight.bold,
                    fontSize:17,
                  ),
                ),

                const SizedBox(height:7),

                Text(
                  descripcion,
                  textAlign:TextAlign.center,
                  style:const TextStyle(
                    color:Color(0xFF64748B),
                    fontSize:10.5,
                    height:1.3,
                  ),
                ),

                const SizedBox(height:13),

                DropdownButtonFormField<T>(
                  value:seleccionado,
                  isExpanded:true,
                  menuMaxHeight:320,
                  hint:Text(
                    hintText,
                    style:const TextStyle(
                      fontSize:10,
                    ),
                  ),
                  decoration:InputDecoration(
                    filled:true,
                    fillColor:const Color(0xFFF5F8FB),
                    prefixIcon:const Icon(
                      Icons.fact_check_outlined,
                      color:AppColors.colorAzul,
                    ),
                    contentPadding:const EdgeInsets.symmetric(
                      horizontal:10,
                      vertical:10,
                    ),
                    border:OutlineInputBorder(
                      borderRadius:BorderRadius.circular(12),
                      borderSide:const BorderSide(
                        color:Color(0xFFD8E3EE),
                      ),
                    ),
                    enabledBorder:OutlineInputBorder(
                      borderRadius:BorderRadius.circular(12),
                      borderSide:const BorderSide(
                        color:Color(0xFFD8E3EE),
                      ),
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderRadius:BorderRadius.circular(12),
                      borderSide:const BorderSide(
                        color:AppColors.colorAzul,
                        width:1.3,
                      ),
                    ),
                  ),
                  items:items.map(
                        (T item)=>DropdownMenuItem<T>(
                      value:item,
                      child:Text(
                        itemText(item),
                        maxLines:2,
                        overflow:TextOverflow.ellipsis,
                        style:const TextStyle(
                          color:Color(0xFF334155),
                          fontSize:10,
                          fontWeight:FontWeight.w700,
                        ),
                      ),
                    ),
                  ).toList(),
                  onChanged:(T? value){
                    setState((){
                      seleccionado=value;
                    });
                  },
                ),

                const SizedBox(height:15),

                Row(
                  children:[
                    Expanded(
                      child:OutlinedButton.icon(
                        onPressed:(){
                          dialog.dismiss();

                          Future.delayed(
                            const Duration(milliseconds:120),
                                ()=>onCancel?.call(),
                          );
                        },
                        icon:const Icon(
                          Icons.close_rounded,
                          size:16,
                        ),
                        label:const Text(
                          "CANCELAR",
                          style:TextStyle(
                            fontSize:9,
                            fontWeight:FontWeight.w900,
                          ),
                        ),
                        style:OutlinedButton.styleFrom(
                          foregroundColor:
                          AppColors.colorRojo_60,
                          side:BorderSide(
                            color:AppColors.colorRojo_60,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width:8),

                    Expanded(
                      flex:2,
                      child:ElevatedButton.icon(
                        onPressed:(){
                          if(seleccionado==null){
                            return;
                          }

                          final T item=
                          seleccionado as T;

                          dialog.dismiss();

                          Future.delayed(
                            const Duration(milliseconds:150),
                                ()=>onSelected(item),
                          );
                        },
                        icon:const Icon(
                          Icons.check_circle_outline,
                          size:17,
                        ),
                        label:const Text(
                          "CONTINUAR",
                          style:TextStyle(
                            fontSize:9,
                            fontWeight:FontWeight.w900,
                          ),
                        ),
                        style:ElevatedButton.styleFrom(
                          backgroundColor:
                          AppColors.colorBotones,
                          foregroundColor:
                          Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height:4),
              ],
            ),
          );
        },
      ),
    );

    dialog.show();
  }
  static getFinalizarOperativo({
    required GlobalKey<FormState> formKey,
    required TextEditingController controllerPass,
    required int numeroOperativo,
    required Future<bool> Function() onBiometria,
    required Future<void> Function() onFinalizar,
  }){
    late AwesomeDialog dialog;

    final ResponsiveUtil responsive=
    ResponsiveUtil();

    final double sizeTxt=
    responsive.diagonalP(
      AppConfig.tamTextoTitulo,
    );

    void abrirConfirmacion(){
      Future.delayed(
        const Duration(milliseconds:150),
            (){
          DialogosAwesome.getWarningSiNo(
            title:"CONFIRMAR FINALIZACIÓN",
            descripcion:
            "¿Está seguro de finalizar el operativo N° $numeroOperativo?\n\n"
                "Esta acción cerrará el operativo y no permitirá registrar nuevas consultas.",
            btnOkOnPress:()async{
              await onFinalizar();
            },
          );
        },
      );
    }

    void abrirDialogo(){
      dialog=AwesomeDialog(
        dismissOnTouchOutside:false,
        dismissOnBackKeyPress:false,
        context:Get.context!,
        dialogType:DialogType.warning,
        headerAnimationLoop:false,
        animType:AnimType.scale,
        keyboardAware:true,
        customHeader:Container(
          width:82,
          height:82,
          decoration:BoxDecoration(
            shape:BoxShape.circle,
            color:const Color(0xFFFFF3F1),
            border:Border.all(
              color:colorWarning,
              width:3,
            ),
          ),
          child:Center(
            child:Image.asset(
              AppImages.escudopolicia,
              width:60,
              height:60,
              fit:BoxFit.contain,
            ),
          ),
        ),
        body:SingleChildScrollView(
          child:Form(
            key:formKey,
            child:Padding(
              padding:const EdgeInsets.fromLTRB(
                12,
                0,
                12,
                8,
              ),
              child:Column(
                mainAxisSize:MainAxisSize.min,
                children:[
                  const Text(
                    "FINALIZAR OPERATIVO",
                    textAlign:TextAlign.center,
                    style:TextStyle(
                      color:Color(0xFFB42318),
                      fontSize:17,
                      fontWeight:FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height:4),

                  Container(
                    padding:const EdgeInsets.symmetric(
                      horizontal:12,
                      vertical:7,
                    ),
                    decoration:BoxDecoration(
                      color:const Color(0xFFF4F7FA),
                      borderRadius:BorderRadius.circular(20),
                    ),
                    child:Text(
                      "OPERATIVO N° $numeroOperativo",
                      style:const TextStyle(
                        color:Color(0xFF43566A),
                        fontSize:16,
                        fontWeight:FontWeight.w900,
                      ),
                    ),
                  ),

                  const SizedBox(height:8),

                  const Text(
                    "Para proteger el cierre del operativo debe validar su identidad mediante su clave institucional o biometría.",
                    textAlign:TextAlign.center,
                    style:TextStyle(
                      color:Color(0xFF64748B),
                      fontSize:10,
                      height:1.35,
                    ),
                  ),

                  const SizedBox(height:13),

                  Container(
                    decoration:BoxDecoration(
                      color:Colors.white,
                      borderRadius:BorderRadius.circular(15),
                      border:Border.all(
                        color:const Color(0xFFD9E3ED),
                      ),
                    ),
                    child:ImputTextWidget(
                      imgString:
                      AppImages.icon_clave,
                      elevation:0,
                      isSegura:true,
                      controller:controllerPass,
                      hitText:
                      "Ingrese la clave",
                      label:
                      "Clave institucional",
                      fonSize:sizeTxt,
                      validar:(text){
                        if(
                        text!=null &&
                            text.trim().length>=8
                        ){
                          return null;
                        }

                        return "Clave no válida";
                      },
                    ),
                  ),

                  const SizedBox(height:11),

                  SizedBox(
                    width:double.infinity,
                    child:BotonesWidget(
                      iconData:
                      Icons.lock_open_rounded,
                      title:
                      "VALIDAR CON CLAVE",
                      onPressed:()async{
                        final bool valido=
                            formKey.currentState
                                ?.validate() ??
                                false;

                        if(!valido)return;

                        final LoginController loginController=
                        Get.find<LoginController>();

                        final String pass=
                            controllerPass.text;

                        final bool resultado=
                        await loginController
                            .validarPass(
                          pass,
                        );

                        controllerPass.clear();

                        if(!resultado){
                          dialog.dismiss();

                          Future.delayed(
                            const Duration(
                              milliseconds:150,
                            ),
                                (){
                              DialogosAwesome.getError(
                                title:
                                "CLAVE INCORRECTA",
                                descripcion:
                                "La clave institucional ingresada no es correcta.",
                                btnOkOnPress:(){
                                  abrirDialogo();
                                },
                              );
                            },
                          );

                          return;
                        }

                        dialog.dismiss();
                        abrirConfirmacion();
                      },
                    ),
                  ),

                  const SizedBox(height:10),

                  const Row(
                    children:[
                      Expanded(
                        child:Divider(),
                      ),
                      Padding(
                        padding:EdgeInsets.symmetric(
                          horizontal:8,
                        ),
                        child:Text(
                          "O VALIDE CON",
                          style:TextStyle(
                            color:Color(0xFF8A97A6),
                            fontSize:8,
                            fontWeight:FontWeight.w800,
                          ),
                        ),
                      ),
                      Expanded(
                        child:Divider(),
                      ),
                    ],
                  ),

                  const SizedBox(height:10),

                  Material(
                    color:Colors.transparent,
                    child:InkWell(
                      borderRadius:BorderRadius.circular(15),
                      onTap:()async{
                        FocusManager
                            .instance
                            .primaryFocus
                            ?.unfocus();

                        final bool autenticado=
                        await onBiometria();

                        if(!autenticado){
                          dialog.dismiss();

                          Future.delayed(
                            const Duration(
                              milliseconds:150,
                            ),
                                (){
                              DialogosAwesome.getError(
                                title:
                                "BIOMETRÍA NO VALIDADA",
                                descripcion:
                                "No fue posible validar su identidad mediante huella o biometría.",
                                btnOkOnPress:(){
                                  abrirDialogo();
                                },
                              );
                            },
                          );

                          return;
                        }

                        controllerPass.clear();

                        dialog.dismiss();

                        abrirConfirmacion();
                      },
                      child:Container(
                        width:double.infinity,
                        padding:const EdgeInsets.symmetric(
                          vertical:11,
                        ),
                        decoration:BoxDecoration(
                          color:const Color(0xFFEAF3FC),
                          borderRadius:
                          BorderRadius.circular(15),
                          border:Border.all(
                            color:
                            const Color(0xFFA7C6E3),
                          ),
                        ),
                        child:const Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children:[
                            Icon(
                              Icons.fingerprint_rounded,
                              color:Color(0xFF195BA6),
                              size:30,
                            ),
                            SizedBox(width:8),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children:[
                                Text(
                                  "HUELLA / BIOMETRÍA",
                                  style:TextStyle(
                                    color:Color(0xFF195BA6),
                                    fontSize:10,
                                    fontWeight:FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  "Validación rápida de identidad",
                                  style:TextStyle(
                                    color:Color(0xFF70859A),
                                    fontSize:7.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height:9),

                  TextButton.icon(
                    onPressed:(){
                      controllerPass.clear();
                      dialog.dismiss();
                    },
                    icon:const Icon(
                      Icons.close_rounded,
                      size:16,
                    ),
                    label:const Text(
                      "CANCELAR",
                      style:TextStyle(
                        fontWeight:FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(height:3),
                ],
              ),
            ),
          ),
        ),
      );

      dialog.show();
    }

    abrirDialogo();
  }
}