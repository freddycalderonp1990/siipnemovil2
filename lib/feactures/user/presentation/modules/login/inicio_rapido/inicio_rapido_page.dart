part of '../../pages.dart';

class InicioRapidoPage extends GetView<InicioRapidoController> {
  const InicioRapidoPage({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context){
    final responsive=ResponsiveUtil();

    return Obx(
          ()=>WorkAreaPageLoginWidget(
        imgFondo:AppImages.imgFondoLogin,
        imgPerfil:_getFotoPerfil(),
        mostrarBtnHome:controller.mostrarBtnHome.value,
        onPressedBtnHome:(){},
        peticionServer:controller.peticionServerState,
        contenido:getContenido(responsive),
      ),
    );
  }

  dynamic _getFotoPerfil(){
    final foto=controller.user.value.foto;

    if(foto==null){
      return null;
    }

    if(foto is String&&foto.trim().isEmpty){
      return null;
    }

    return foto;
  }

  Widget getContenido(ResponsiveUtil responsive){
    return SingleChildScrollView(
      child:Column(
        children:[
          Obx(
                ()=>DesingTextNameUser(
              sizeText:responsive.diagonalP(AppConfig.tamTextoTitulo-.4),
              sexo:controller.user.value.sexo,
              text:controller.user.value.nombres,
            ),
          ),

          SizedBox(height:responsive.altoP(2)),

          Container(
            padding:EdgeInsets.symmetric(
              horizontal:responsive.anchoP(10),
            ),
            child:Row(
              children:[
                Expanded(
                  child:wgHuella(),
                ),

                SizedBox(width:responsive.anchoP(3)),

                Expanded(
                  child:wgOtroUsuario(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget wgHuella(){
    return DesignBtnLoginRapidoWidget(
      icon:Icons.fingerprint_rounded,
      titulo:"Huella / Face ID",
      descripcion:"Ingresar con biometría",
      onTap:()=>controller.loginConBiometrico(),
    );
  }

  Widget wgOtroUsuario(){
    return DesignBtnLoginRapidoWidget(
      icon:Icons.lock_person_rounded,
      titulo:"Usuario y contraseña",
      descripcion:"Ingresar de forma tradicional",
      onTap:()=>controller.ingresoConOtroUsuario(),
    );
  }
}