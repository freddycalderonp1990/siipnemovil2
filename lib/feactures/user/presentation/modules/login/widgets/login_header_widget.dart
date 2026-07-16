import 'package:flutter/material.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo SIIPNE
        Image.asset(
          'assets/images/logo_siipne.png',
          width: 95,
          height: 95,
        ),

        const SizedBox(height: 15),

        const Text(
          "SIIPNE MÓVIL",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          "Sistema Integrado de Información\nPolicial del Ecuador",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 30),

        // Escudo
        Container(
          width: 115,
          height: 115,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.10),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Image.asset(
              'assets/images/escudo_policia.png',
              fit: BoxFit.contain,
            ),
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          "POLICÍA NACIONAL",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xff003A88),
            letterSpacing: .8,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          "DEL ECUADOR",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}