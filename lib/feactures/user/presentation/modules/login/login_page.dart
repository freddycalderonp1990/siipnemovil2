part of '../pages.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  static const Color _azulInstitucional=Color(0xFF195BA6);
  static const Color _azulOscuro=Color(0xFFCDCDCD);

  @override
  Widget build(BuildContext context) {
    final ResponsiveUtil responsive=ResponsiveUtil();

    return Scaffold(
      resizeToAvoidBottomInset:true,
      backgroundColor:_azulOscuro,
      body:Stack(
        children:[
          _fondo(),
          _capaFondo(),

          SafeArea(
            child:Column(
              children:[
                _barraSuperior(context),

                Expanded(
                  child:SingleChildScrollView(
                    physics:const BouncingScrollPhysics(),
                    keyboardDismissBehavior:ScrollViewKeyboardDismissBehavior.onDrag,
                    padding:EdgeInsets.fromLTRB(
                      responsive.anchoP(5),
                      responsive.altoP(1),
                      responsive.anchoP(5),
                      responsive.altoP(2),
                    ),
                    child:ConstrainedBox(
                      constraints:BoxConstraints(
                        minHeight:MediaQuery.of(context).size.height-
                            MediaQuery.of(context).padding.top-
                            MediaQuery.of(context).padding.bottom-
                            responsive.altoP(15),
                      ),
                      child:Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children:[
                          _encabezado(responsive),
                          SizedBox(height:responsive.altoP(3)),
                          _formulario(responsive),
                          SizedBox(height:responsive.altoP(2.2)),
                          _piePagina(),
                        ],
                      ),
                    ),
                  ),
                ),

                _versionApp(context),
              ],
            ),
          ),

          Obx(()=>CargandoWidget(
            mostrar:controller.peticionServerState.value,
            titulo:'VERIFICANDO CREDENCIALES',
            mensaje:'Preparando los servicios institucionales...',
          )),
        ],
      ),
    );
  }

  Widget _fondo(){
    return Positioned.fill(
      child:Image.asset(
        AppImages.imgFondoLogin,
        fit:BoxFit.cover,
        alignment:Alignment.center,
        errorBuilder:(context,error,stackTrace)=>Container(color:_azulOscuro),
      ),
    );
  }

  Widget _capaFondo(){
    return Positioned.fill(
      child:Container(
        decoration:const BoxDecoration(
          gradient:LinearGradient(
            begin:Alignment.topCenter,
            end:Alignment.bottomCenter,
            colors:[
              Color(0xB3BBBCBD),
              Color(0x990D315A),
              Color(0xFF101A30),
            ],
            stops:[0,.48,1],
          ),
        ),
      ),
    );
  }

  Widget _barraSuperior(BuildContext context){
    return Padding(
      padding:const EdgeInsets.fromLTRB(40,0,0,0),
      child:Row(
        children:[
          Expanded(
            child:Align(
              alignment:Alignment.center,
              child:Image.asset(
                AppImages.imgSiipneMovil,
                height:60,
                fit:BoxFit.contain,
                alignment:Alignment.center,
              ),
            ),
          ),

          Obx(()=>AnimatedSwitcher(
            duration:const Duration(milliseconds:220),
            child:controller.mostrarBtnHome.value
                ?Material(
              key:const ValueKey('btnHome'),
              color:Colors.transparent,
              child:InkWell(
                borderRadius:BorderRadius.circular(13),
                onTap:()=>controller.setAppPageSelect(PageAppsSelect.Bienvenida),
                child:Container(
                  width:42,
                  height:42,
                  decoration:BoxDecoration(
                    color:Colors.white.withOpacity(.12),
                    borderRadius:BorderRadius.circular(13),
                    border:Border.all(color:Colors.white.withOpacity(.18)),
                  ),
                  child:const Icon(
                    Icons.home_rounded,
                    color:Colors.white,
                    size:22,
                  ),
                ),
              ),
            )
                :const SizedBox(
              key:ValueKey('sinBtnHome'),
              width:42,
              height:42,
            ),
          )),
        ],
      ),
    );
  }

  Widget _encabezado(ResponsiveUtil responsive){
    return ConstrainedBox(
      constraints:const BoxConstraints(maxWidth:430),
      child:Column(
        children:[

          Image.asset(
            AppImages.escudopoliciaPlomo,
            width:90,
            height:90,
            fit:BoxFit.contain,
          ),

          SizedBox(height:responsive.altoP(1.5)),

          const Text(
            'INICIO DE SESIÓN',
            textAlign:TextAlign.center,
            style:TextStyle(
              color:Colors.white,
              fontSize:23,
              fontWeight:FontWeight.w800,
              letterSpacing:.5,
              height:1.1,
            ),
          ),

          const SizedBox(height:7),

          Text(
            'Ingrese sus credenciales institucionales para continuar',
            textAlign:TextAlign.center,
            style:TextStyle(
              color:Colors.white.withOpacity(.82),
              fontSize:13,
              fontWeight:FontWeight.w400,
              height:1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _formulario(ResponsiveUtil responsive){
    return ConstrainedBox(
      constraints:const BoxConstraints(maxWidth:430),
      child:Container(
        width:double.infinity,
        padding:EdgeInsets.symmetric(
          horizontal:responsive.anchoP(4.5),
          vertical:responsive.altoP(2.4),
        ),
        decoration:BoxDecoration(
          color:Colors.white.withOpacity(.96),
          borderRadius:BorderRadius.circular(24),
          border:Border.all(
            color:Colors.white.withOpacity(.80),
            width:1,
          ),
          boxShadow:[
            BoxShadow(
              color:Colors.black.withOpacity(.18),
              blurRadius:28,
              spreadRadius:1,
              offset:const Offset(0,12),
            ),
          ],
        ),
        child:WgLogin(
          onPressed:()=>controller.login(),
          controllerPass:controller.controllerPass,
          controllerUser:controller.controllerUser,
          formKey:controller.formKey,
        ),
      ),
    );
  }

  Widget _piePagina(){
    return Column(
      children:[
        Image.asset(
          AppImages.imgloginPoliciaEcuador,
          height:40,
          fit:BoxFit.contain,
        ),
      ],
    );
  }

  Widget _versionApp(BuildContext context){
    final bool keyboardVisible=MediaQuery.of(context).viewInsets.bottom>0;

    if(keyboardVisible){
      return const SizedBox.shrink();
    }

    return FutureBuilder<String>(
      future:DeviceInfoApp.getVersionCodeNameApp,
      builder:(context,snapshot){
        final String version=snapshot.data??'';

        if(version.isEmpty){
          return const SizedBox(height:20);
        }

        return Padding(
          padding:const EdgeInsets.fromLTRB(24,4,24,10),
          child:Column(
            mainAxisSize:MainAxisSize.min,
            children:[
              Row(
                children:[
                  Expanded(
                    child:Container(
                      height:1,
                      decoration:BoxDecoration(
                        gradient:LinearGradient(
                          colors:[
                            Colors.transparent,
                            Colors.white.withOpacity(.25),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width:12),

                  Container(
                    width:38,
                    height:38,
                    decoration:BoxDecoration(
                      color:Colors.white.withOpacity(.12),
                      shape:BoxShape.circle,
                      border:Border.all(
                        color:Colors.white.withOpacity(.22),
                      ),
                    ),
                    child:Icon(
                      Icons.gpp_good_outlined,
                      size:21,
                      color:Colors.white.withOpacity(.85),
                    ),
                  ),

                  const SizedBox(width:12),

                  Expanded(
                    child:Container(
                      height:1,
                      decoration:BoxDecoration(
                        gradient:LinearGradient(
                          colors:[
                            Colors.white.withOpacity(.25),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height:12),

              Container(
                padding:const EdgeInsets.symmetric(
                  horizontal:15,
                  vertical:7,
                ),
                decoration:BoxDecoration(
                  color:Colors.white.withOpacity(.12),
                  borderRadius:BorderRadius.circular(30),
                  border:Border.all(
                    color:Colors.white.withOpacity(.18),
                  ),
                ),
                child:Row(
                  mainAxisSize:MainAxisSize.min,
                  children:[
                    Text(
                      version,
                      style:TextStyle(
                        fontSize:12,
                        color:Colors.white.withOpacity(.88),
                        fontWeight:FontWeight.w600,
                        letterSpacing:.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}