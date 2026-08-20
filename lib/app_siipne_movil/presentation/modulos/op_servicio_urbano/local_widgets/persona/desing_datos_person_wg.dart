part of '../operativo_polco_local_widgets.dart';

class DesingDatosPersonaWg extends StatelessWidget {
  final LocalPersonSuModel data;
  final Color colorTexto;
  final Color colorTitulos;
  final bool tieneOrdenCaptura;

  const DesingDatosPersonaWg({
    Key? key,
    required this.data,
    this.colorTexto=Colors.black,
    this.colorTitulos=Colors.blueAccent,
    this.tieneOrdenCaptura=false,
  }):super(key:key);

  @override
  Widget build(BuildContext context){
    return Container(
      width:double.infinity,
      padding:const EdgeInsets.all(10),
      decoration:BoxDecoration(
        color:tieneOrdenCaptura
            ?const Color(0xFFFFF5F4)
            :const Color(0xFFF8FAFD),
        borderRadius:BorderRadius.circular(16),
        border:Border.all(
          color:tieneOrdenCaptura
              ?const Color(0xFFE6AAA6)
              :const Color(0xFFD8E3EE),
        ),
      ),
      child:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children:[
          _encabezado(),
          const SizedBox(height:9),

          LayoutBuilder(
            builder:(context,constraints){
              return Row(
                crossAxisAlignment:CrossAxisAlignment.start,
                children:[
                  _fotoPersona(),
                  const SizedBox(width:10),

                  Expanded(
                    child:Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children:[
                        Text(
                          _valor(data.nombres),
                          maxLines:3,
                          overflow:TextOverflow.ellipsis,
                          style:const TextStyle(
                            color:Color(0xFF1F2937),
                            fontSize:13,
                            height:1.2,
                            fontWeight:FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height:8),
                        _gridDatos(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _encabezado(){
    String titulo="ECUATORIANO";

    final String pais=(data.pais??"").trim();

    if(pais.isNotEmpty && pais.toUpperCase()!="ECUADOR"){
      titulo="EXTRANJERO";
    }
    return Row(
      children:[
        Container(
          width: 45,
          height: 45,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: tieneOrdenCaptura
                ? const Color(0xFFF7D7D4)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            AppSiipneMovilImages.icon_RegistroCivil,
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(width:7),

        Expanded(
          child:Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children:[
              const Text(
                "DATOS DE IDENTIFICACIÓN",
                style:TextStyle(
                  color:Color(0xFF7D8D9D),
                  fontSize:10,
                  fontWeight:FontWeight.w900,
                  letterSpacing:.4,
                ),
              ),

              Text(
                titulo,
                style:TextStyle(
                  color:tieneOrdenCaptura
                      ?const Color(0xFF9F2D27)
                      :const Color(0xFF195BA6),
                  fontSize:10.5,
                  fontWeight:FontWeight.w900,
                  letterSpacing:.3,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding:const EdgeInsets.symmetric(
            horizontal:7,
            vertical:4,
          ),
          decoration:BoxDecoration(
            color:tieneOrdenCaptura
                ?const Color(0xFFF8D8D5)
                :const Color(0xFFE6F2FC),
            borderRadius:BorderRadius.circular(20),
          ),
          child:Row(
            mainAxisSize:MainAxisSize.min,
            children:[
              Icon(
                Icons.verified_user_rounded,
                size:11,
                color:tieneOrdenCaptura
                    ?const Color(0xFFB42318)
                    :const Color(0xFF195BA6),
              ),
              const SizedBox(width:3),
              Text(
                "IDENTIFICADO",
                style:TextStyle(
                  color:tieneOrdenCaptura
                      ?const Color(0xFF9F2D27)
                      :const Color(0xFF195BA6),
                  fontSize:7,
                  fontWeight:FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fotoPersona(){
    dynamic imgMemory;

    try{
      final String? foto=data.foto;

      if(foto!=null && foto.trim().length>5){
        imgMemory=PhotoHelper.convertStringToUint8List(
          foto.trim(),
        );
      }
    }catch(e){
      debugPrint("Error procesando fotografía: $e");
      imgMemory=null;
    }

    return GestureDetector(
      onTap:imgMemory==null
          ?null
          :(){
        DialogosDesingWidget.getDialogoXImgMemory(
          title:'FOTOGRAFÍA',
          imgMemory:imgMemory,
        );
      },
      child:Container(
        width:86,
        height:110,
        padding:const EdgeInsets.all(3),
        decoration:BoxDecoration(
          color:Colors.white,
          borderRadius:BorderRadius.circular(14),
          border:Border.all(
            color:tieneOrdenCaptura
                ?const Color(0xFFD9554D)
                :const Color(0xFF195BA6),
            width:1.7,
          ),
          boxShadow:[
            BoxShadow(
              color:tieneOrdenCaptura
                  ?Colors.red.withOpacity(.10)
                  :const Color(0xFF195BA6).withOpacity(.10),
              blurRadius:8,
              offset:const Offset(0,3),
            ),
          ],
        ),
        child:ClipRRect(
          borderRadius:BorderRadius.circular(10),
          child:imgMemory!=null
              ?Image.memory(
            imgMemory,
            fit:BoxFit.cover,
            gaplessPlayback:true,
            errorBuilder:(context,error,stackTrace)=>_fotoDefault(),
          )
              :_fotoDefault(),
        ),
      ),
    );
  }

  Widget _fotoDefault(){
    final String pais=(data.pais??"").trim().toUpperCase();

    final String asset=pais.isEmpty || pais=="ECUADOR"
        ?AppSiipneMovilImages.icon_RegistroCivil
        :AppSiipneMovilImages.icon_Extranjero;

    return Container(
      color:tieneOrdenCaptura
          ?const Color(0xFFFFECEA)
          :const Color(0xFFEAF2FB),
      padding:const EdgeInsets.all(8),
      child:Image.asset(
        asset,
        fit:BoxFit.contain,
        errorBuilder:(context,error,stackTrace){
          return Icon(
            Icons.person_rounded,
            color:tieneOrdenCaptura
                ?const Color(0xFFB42318)
                :const Color(0xFF195BA6),
            size:40,
          );
        },
      ),
    );
  }

  Widget _gridDatos(){
    final List<_DatoPersonaItem> datos=[
      _DatoPersonaItem(
        icon:Icons.badge_outlined,
        titulo:"DOCUMENTO",
        valor:data.documento,
      ),
      _DatoPersonaItem(
        icon:Icons.cake_outlined,
        titulo:"F. NACIMIENTO",
        valor:data.fechaNcaimiento,
      ),
      _DatoPersonaItem(
        icon:Icons.calendar_month_outlined,
        titulo:"EDAD",
        valor:data.edad,
      ),
      _DatoPersonaItem(
        icon:Icons.person_outline_rounded,
        titulo:"SEXO / GÉNERO",
        valor:data.sexo,
      ),
      _DatoPersonaItem(
        icon:Icons.home_outlined,
        titulo:"DOMICILIO",
        valor:data.domicilio,
      ),
      _DatoPersonaItem(
        icon:Icons.favorite_border_rounded,
        titulo:"ESTADO CIVIL",
        valor:data.estadoCivil,
      ),
    ].where((e)=>_valor(e.valor)!="NO REGISTRADO").toList();

    return LayoutBuilder(
      builder:(context,constraints){
        const double espacio=6;
        final double ancho=(constraints.maxWidth-espacio)/2;

        return Wrap(
          spacing:espacio,
          runSpacing:6,
          children:datos.map((item){
            return SizedBox(
              width:ancho,
              child:_cardDato(
                icon:item.icon,
                titulo:item.titulo,
                detalle:item.valor,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _cardDato({
    required IconData icon,
    required String titulo,
    required String? detalle,
  }){
    return Container(
      constraints:const BoxConstraints(
        minHeight:20,
      ),
      padding:const EdgeInsets.symmetric(
        horizontal:7,
        vertical:6,
      ),
      decoration:BoxDecoration(
        color:tieneOrdenCaptura
            ?const Color(0xFFFFEDEC)
            :Colors.white,
        borderRadius:BorderRadius.circular(10),
        border:Border.all(
          color:tieneOrdenCaptura
              ?const Color(0xFFF0CBC8)
              :const Color(0xFFE0E8F0),
        ),
      ),
      child:Row(
        crossAxisAlignment:CrossAxisAlignment.start,
        children:[
          Container(
            width:23,
            height:23,
            decoration:BoxDecoration(
              color:tieneOrdenCaptura
                  ?const Color(0xFFF8D8D5)
                  :const Color(0xFFE8F2FC),
              borderRadius:BorderRadius.circular(7),
            ),
            child:Icon(
              icon,
              size:13,
              color:tieneOrdenCaptura
                  ?const Color(0xFFB42318)
                  :const Color(0xFF195BA6),
            ),
          ),

          const SizedBox(width:5),

          Expanded(
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              mainAxisAlignment:MainAxisAlignment.center,
              children:[
                Text(
                  titulo,
                  maxLines:1,
                  overflow:TextOverflow.ellipsis,
                  style:TextStyle(
                    color:Colors.brown,
                    fontSize:8,
                    fontWeight:FontWeight.w900,
                    letterSpacing:.2,
                  ),
                ),

                const SizedBox(height:2),

                Text(
                  _valor(detalle),
                  maxLines:3,
                  overflow:TextOverflow.ellipsis,
                  style:const TextStyle(
                    color:Color(0xFF263746),
                    fontSize:10,
                    fontWeight:FontWeight.w700,
                    height:1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _valor(dynamic value){
    if(value==null)return "NO REGISTRADO";

    final String dato=value.toString().trim();

    if(dato.isEmpty)return "NO REGISTRADO";

    return dato;
  }
}

class _DatoPersonaItem {
  final IconData icon;
  final String titulo;
  final String? valor;

  const _DatoPersonaItem({
    required this.icon,
    required this.titulo,
    required this.valor,
  });
}