part of 'user_custom_widgets.dart';

class WorkAreaPageLoginWidget extends StatefulWidget {
  final RxBool peticionServer;
  final Widget contenido;
  final dynamic imgPerfil;
  final dynamic imgFondo;
  final bool mostrarBtnHome;
  final VoidCallback? onPressedBtnHome;

  const WorkAreaPageLoginWidget({
    super.key,
    required this.peticionServer,
    required this.contenido,
    this.imgPerfil,
    this.imgFondo,
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

              _buildPerfil(),

              SizedBox(height:responsive.altoP(1)),

              _buildLogoPolicia(),

              SizedBox(height:responsive.altoP(1)),

              widget.contenido,

              const SizedBox(height:20),

              SizedBox(height:responsive.altoP(4)),
            ],
          ),
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