import 'package:flutter/material.dart';

class DesignBtnLoginRapidoWidget extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String descripcion;
  final VoidCallback? onTap;

  const DesignBtnLoginRapidoWidget({
    super.key,
    required this.icon,
    required this.titulo,
    required this.descripcion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context){
    const Color azul=Color(0xFF0D4C9C);
    const Color fondoIcono=Color(0xFFF0F5FF);

    return Material(
      color:Colors.transparent,
      child:InkWell(
        borderRadius:BorderRadius.circular(22),
        onTap:onTap,
        child:Ink(
          decoration:BoxDecoration(
            color:Colors.white,
            borderRadius:BorderRadius.circular(22),
            border:Border.all(
              color:azul.withOpacity(.10),
              width:1,
            ),
            boxShadow:[
              BoxShadow(
                color:Colors.black.withOpacity(.06),
                blurRadius:18,
                offset:const Offset(0,7),
              ),
            ],
          ),
          child:Padding(
            padding:const EdgeInsets.symmetric(
              horizontal:14,
              vertical:13,
            ),
            child:Column(
              mainAxisSize:MainAxisSize.min,
              children:[
                Container(
                  width:62,
                  height:62,
                  decoration:BoxDecoration(
                    color:fondoIcono,
                    shape:BoxShape.circle,
                    border:Border.all(
                      color:azul.withOpacity(.08),
                    ),
                  ),
                  child:Icon(
                    icon,
                    size:32,
                    color:azul,
                  ),
                ),

                const SizedBox(height:11),

                Text(
                  titulo,
                  textAlign:TextAlign.center,
                  maxLines:2,
                  overflow:TextOverflow.ellipsis,
                  style:const TextStyle(
                    fontSize:13,
                    height:1.15,
                    fontWeight:FontWeight.w800,
                    color:azul,
                  ),
                ),

                const SizedBox(height:5),

                Text(
                  descripcion,
                  textAlign:TextAlign.center,
                  maxLines:2,
                  overflow:TextOverflow.ellipsis,
                  style:TextStyle(
                    fontSize:10.5,
                    height:1.2,
                    fontWeight:FontWeight.w500,
                    color:Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height:12),

                Container(
                  padding:const EdgeInsets.symmetric(
                    horizontal:11,
                    vertical:6,
                  ),
                  decoration:BoxDecoration(
                    color:azul.withOpacity(.07),
                    borderRadius:BorderRadius.circular(20),
                  ),
                  child:const Row(
                    mainAxisSize:MainAxisSize.min,
                    children:[
                      Text(
                        "INGRESAR",
                        style:TextStyle(
                          color:azul,
                          fontSize:9,
                          fontWeight:FontWeight.w800,
                          letterSpacing:.5,
                        ),
                      ),
                      SizedBox(width:4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size:14,
                        color:azul,
                      ),
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
}