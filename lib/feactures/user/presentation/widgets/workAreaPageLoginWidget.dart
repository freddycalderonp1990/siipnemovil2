part of 'user_custom_widgets.dart';

class WorkAreaPageLoginWidget extends StatefulWidget {
  final RxBool peticionServer;
  final Widget contenido;
  final dynamic imgPerfil;
  final dynamic imgFondo;
  final String nombresServidor;
  final String gradoServidor;
  final String estadoServidor;
  final bool mostrarBtnHome;
  final VoidCallback? onPressedBtnHome;

  const WorkAreaPageLoginWidget({
    super.key,
    required this.peticionServer,
    required this.contenido,
    this.imgPerfil,
    this.imgFondo,
    this.nombresServidor='',
    this.gradoServidor='',
    this.estadoServidor='Credenciales institucionales registradas',
    this.mostrarBtnHome=false,
    this.onPressedBtnHome,
  });

  @override
  State<WorkAreaPageLoginWidget> createState()=>_WorkAreaPageLoginWidgetState();
}

class _WorkAreaPageLoginWidgetState extends State<WorkAreaPageLoginWidget> {
  String version='';
  final ResponsiveUtil responsive=ResponsiveUtil();

  @override
  void initState(){
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async{
    try{
      String valor=await DeviceInfoApp.getVersionCodeNameApp;

      if(mounted){
        setState((){
          version=valor;
        });
      }
    }catch(e){
      if(mounted){
        setState((){
          version='';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context){
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor:AppColors.colorPrimary,
        statusBarIconBrightness:Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor:Colors.white,
      body:Stack(
        fit:StackFit.expand,
        children:[
          _buildFondo(),

          _buildHeader(),

          _buildLogin(),

          Positioned(
            left:0,
            right:0,
            bottom:MediaQuery.of(context).padding.bottom,
            child:getVersion(),
          ),

          getBtnHome(),

          Obx(
                ()=>CargandoWidget(
              mostrar:widget.peticionServer.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFondo(){
    if(widget.imgFondo==null){
      return Container(color:Colors.white);
    }

    return Positioned.fill(
      child:Image.asset(
        widget.imgFondo,
        fit:BoxFit.cover,
        errorBuilder:(context,error,stackTrace){
          return Container(color:Colors.white);
        },
      ),
    );
  }

  Widget _buildHeader(){
    return Positioned(
      top:0,
      left:0,
      right:0,
      child:SizedBox(
        height:responsive.diagonalP(40),
        child:Image.asset(
          AppImages.imgLoginHeader,
          fit:BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildLogin(){
    return Positioned(
      top:responsive.diagonalP(10),
      left:0,
      right:0,
      bottom:60,
      child:SingleChildScrollView(
        physics:const BouncingScrollPhysics(),
        child:ConstrainedBox(
          constraints:BoxConstraints(
            minHeight:responsive.altoP(80),
          ),
          child:Column(
            children:[
              _buildLogo(),

              SizedBox(height:responsive.altoP(4)),

              _buildCardServidor(),

              SizedBox(height:responsive.altoP(2)),

              widget.contenido,

              const SizedBox(height:20),

              SizedBox(height:responsive.altoP(4)),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCardServidor(){
    final bool sinImagen=widget.imgPerfil==null||
        (widget.imgPerfil is String&&widget.imgPerfil.toString().trim().isEmpty);

    final String nombres=widget.nombresServidor.trim().isEmpty
        ?'SERVIDOR POLICIAL'
        :widget.nombresServidor.trim();

    final String grado=widget.gradoServidor.trim();

    return Padding(
      padding:EdgeInsets.symmetric(horizontal:responsive.anchoP(5)),
      child:Container(
        width:double.infinity,
        margin:const EdgeInsets.symmetric(
          horizontal:18,
          vertical:10,
        ),
        padding:const EdgeInsets.symmetric(
          horizontal:18,
          vertical:16,
        ),
        decoration:BoxDecoration(
          color:Colors.white.withOpacity(.94),
          borderRadius:BorderRadius.circular(24),
          border:Border.all(
            color:Colors.white.withOpacity(.75),
            width:1,
          ),
          boxShadow:[
            BoxShadow(
              color:Colors.black.withOpacity(.16),
              blurRadius:24,
              offset:const Offset(0,10),
            ),
          ],
        ),
        child:Column(
          children:[
            Row(
              crossAxisAlignment:CrossAxisAlignment.center,
              children:[
                Stack(
                  clipBehavior:Clip.none,
                  children:[
                    Container(
                      width:responsive.diagonalP(11.5),
                      height:responsive.diagonalP(11.5),
                      padding:const EdgeInsets.all(3),
                      decoration:BoxDecoration(
                        shape:BoxShape.circle,
                        gradient:LinearGradient(
                          begin:Alignment.topLeft,
                          end:Alignment.bottomRight,
                          colors:[
                            AppColors.colorAzul_1,
                            AppColors.colorAzul_1.withOpacity(.35),
                          ],
                        ),
                        boxShadow:[
                          BoxShadow(
                            color:AppColors.colorAzul_1.withOpacity(.20),
                            blurRadius:18,
                            spreadRadius:1,
                          ),
                        ],
                      ),
                      child:Container(
                        padding:const EdgeInsets.all(3),
                        decoration:const BoxDecoration(
                          color:Colors.white,
                          shape:BoxShape.circle,
                        ),
                        child:ClipOval(
                          child:sinImagen
                              ?Image.asset(
                            AppImages.imgIconApp,
                            fit:BoxFit.cover,
                          )
                              :ImgPerfilRedonda(
                            size:responsive.diagonalP(AppConfig.tamIcons),
                            img:widget.imgPerfil,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      right:-1,
                      bottom:3,
                      child:Container(
                        width:22,
                        height:22,
                        decoration:BoxDecoration(
                          color:const Color(0xFF24A565),
                          shape:BoxShape.circle,
                          border:Border.all(
                            color:Colors.white,
                            width:3,
                          ),
                          boxShadow:[
                            BoxShadow(
                              color:Colors.black.withOpacity(.10),
                              blurRadius:6,
                            ),
                          ],
                        ),
                        child:const Icon(
                          Icons.check_rounded,
                          size:12,
                          color:Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(width:responsive.anchoP(4)),

                Expanded(
                  child:Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children:[
                      Row(
                        children:[
                          Expanded(
                            child:Text(
                              'SERVIDOR POLICIAL',
                              maxLines:1,
                              overflow:TextOverflow.ellipsis,
                              style:TextStyle(
                                color:AppColors.colorAzul_1,
                                fontSize:responsive.diagonalP(.92),
                                fontWeight:FontWeight.w900,
                                letterSpacing:1.1,
                              ),
                            ),
                          ),

                          Container(
                            width:34,
                            height:34,
                            decoration:BoxDecoration(
                              color:AppColors.colorAzul_1.withOpacity(.08),
                              borderRadius:BorderRadius.circular(11),
                            ),
                            child:Icon(
                              Icons.verified_user_rounded,
                              color:AppColors.colorAzul_80,
                              size:19,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height:responsive.altoP(.5)),

                      if(grado.isNotEmpty)
                        Text(
                          grado.toUpperCase(),
                          maxLines:1,
                          overflow:TextOverflow.ellipsis,
                          style:TextStyle(
                            color:AppColors.colorPlomo,
                            fontSize:responsive.diagonalP(.95),
                            fontWeight:FontWeight.w800,
                            letterSpacing:.6,
                          ),
                        ),

                      SizedBox(height:responsive.altoP(.25)),

                      Text(
                        nombres.toUpperCase(),
                        maxLines:2,
                        overflow:TextOverflow.ellipsis,
                        style:TextStyle(
                          color:const Color(0xFF1E293B),
                          fontSize:responsive.diagonalP(1.22),
                          fontWeight:FontWeight.w900,
                          height:1.18,
                        ),
                      ),

                      SizedBox(height:responsive.altoP(.7)),

                      Row(
                        children:[
                          Container(
                            width:7,
                            height:7,
                            decoration:const BoxDecoration(
                              color:Color(0xFF24A565),
                              shape:BoxShape.circle,
                            ),
                          ),

                          SizedBox(width:responsive.anchoP(1.4)),

                          Expanded(
                            child:Text(
                              widget.estadoServidor,
                              maxLines:1,
                              overflow:TextOverflow.ellipsis,
                              style:TextStyle(
                                color:Colors.grey.shade600,
                                fontSize:responsive.diagonalP(.85),
                                fontWeight:FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height:responsive.altoP(1.5)),

            Container(
              height:1,
              decoration:BoxDecoration(
                gradient:LinearGradient(
                  colors:[
                    Colors.transparent,
                    AppColors.colorAzul_1.withOpacity(.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            SizedBox(height:responsive.altoP(1.2)),

            Row(
              children:[
                Container(
                  width:3,
                  height:28,
                  decoration:BoxDecoration(
                    color:AppColors.colorAzul_1,
                    borderRadius:BorderRadius.circular(20),
                  ),
                ),

                SizedBox(width:responsive.anchoP(2)),

                Expanded(
                  child:Text(
                    'IDENTIDAD DIGITAL INSTITUCIONAL',
                    maxLines:1,
                    overflow:TextOverflow.ellipsis,
                    style:TextStyle(
                      color:AppColors.colorAzul_1.withOpacity(.75),
                      fontSize:responsive.diagonalP(.78),
                      fontWeight:FontWeight.w800,
                      letterSpacing:1,
                    ),
                  ),
                ),

                SizedBox(
                  width:responsive.diagonalP(9),
                  height:responsive.diagonalP(3.5),
                  child:Image.asset(
                    AppImages.imgloginPoliciaEcuador,
                    fit:BoxFit.contain,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildLogo(){
    return SizedBox(
      height:responsive.diagonalP(8),
      width:responsive.ancho,
      child:Padding(
        padding:EdgeInsets.symmetric(
          horizontal:responsive.anchoP(5),
        ),
        child:Image.asset(
          AppImages.imgSiipneMovil,
          fit:BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildPerfil(){
    bool sinImagen=widget.imgPerfil==null||
        (widget.imgPerfil is String&&
            widget.imgPerfil.toString().trim().isEmpty);

    return SizedBox(
      height:responsive.diagonalP(12),
      width:responsive.diagonalP(12),
      child:sinImagen
          ?Image.asset(
        AppImages.imgIconApp,
        fit:BoxFit.contain,
      )
          :ImgPerfilRedonda(
        size:responsive.diagonalP(AppConfig.tamIcons),
        img:widget.imgPerfil,
      ),
    );
  }

  Widget _buildLogoPolicia(){
    return SizedBox(
      width:responsive.diagonalP(12),
      child:Image.asset(
        AppImages.imgloginPoliciaEcuador,
        fit:BoxFit.contain,
      ),
    );
  }

  Widget getBtnHome(){
    if(!widget.mostrarBtnHome){
      return const SizedBox.shrink();
    }

    return Positioned(
      top:responsive.altoP(5),
      right:10,
      child:BtnIconWidget(
        colorIcon:AppColors.colorIcons,
        colorTxt:AppColors.colorIcons,
        colorLineas:AppColors.colorIcons,
        colorBtn:Colors.white,
        onPressed:widget.onPressedBtnHome,
        icon:Icons.menu,
        titulo:"Home",
      ),
    );
  }

  Widget getVersion(){
    final keyboardVisible=MediaQuery.of(context).viewInsets.bottom>0;

    if(keyboardVisible){
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize:MainAxisSize.min,
      children:[
        Row(
          children:[
            Expanded(
              child:Container(
                height:1,
                color:const Color(0xFFE5E5E5),
              ),
            ),

            const SizedBox(width:14),

            Container(
              width:40,
              height:40,
              decoration:BoxDecoration(
                color:Colors.white,
                shape:BoxShape.circle,
                border:Border.all(
                  color:const Color(0xFFE5E5E5),
                ),
              ),
              child:const Icon(
                Icons.gpp_good_outlined,
                size:22,
                color:Color(0xFF9E9E9E),
              ),
            ),

            const SizedBox(width:14),

            Expanded(
              child:Container(
                height:1,
                color:const Color(0xFFE5E5E5),
              ),
            ),
          ],
        ),

        const SizedBox(height:16),

        Container(
          padding:const EdgeInsets.symmetric(
            horizontal:14,
            vertical:8,
          ),
          decoration:BoxDecoration(
            color:const Color(0xFFF0F5FF),
            borderRadius:BorderRadius.circular(30),
          ),
          child:Row(
            mainAxisSize:MainAxisSize.min,
            children:[
              const Icon(
                Icons.gpp_good_rounded,
                size:18,
                color:Color(0xFF0D4C9C),
              ),

              const SizedBox(width:8),

              Text(
                version,
                style:const TextStyle(
                  fontSize:14,
                  color:Color(0xFF0D4C9C),
                  fontWeight:FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height:10),
      ],
    );
  }
}