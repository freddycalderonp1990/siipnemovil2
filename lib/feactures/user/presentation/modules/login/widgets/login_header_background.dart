import 'package:flutter/material.dart';

class LoginHeaderBackground extends StatelessWidget {
  final double height;

  const LoginHeaderBackground({
    super.key,
    this.height = 260,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: HeaderPainter(),
      ),
    );
  }
}

class HeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /// Fondo azul
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xff012D7A),
          Color(0xff0B4FB5),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      background,
    );

    /// Onda gris (la sombra que está detrás)
    final shadow = Path();

    shadow.moveTo(0, size.height * .88);

    shadow.quadraticBezierTo(
      size.width * .22,
      size.height * .45,
      size.width * .55,
      size.height * .58,
    );

    shadow.quadraticBezierTo(
      size.width * .80,
      size.height * .70,
      size.width,
      size.height * .55,
    );

    shadow.lineTo(size.width, size.height);
    shadow.lineTo(0, size.height);
    shadow.close();

    canvas.drawPath(
      shadow,
      Paint()..color = Colors.grey.shade300,
    );

    /// Onda blanca
    final white = Path();

    white.moveTo(0, size.height * .84);

    white.quadraticBezierTo(
      size.width * .25,
      size.height * .35,
      size.width * .58,
      size.height * .56,
    );

    white.quadraticBezierTo(
      size.width * .84,
      size.height * .73,
      size.width,
      size.height * .50,
    );

    white.lineTo(size.width, size.height);
    white.lineTo(0, size.height);
    white.close();

    canvas.drawPath(
      white,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}