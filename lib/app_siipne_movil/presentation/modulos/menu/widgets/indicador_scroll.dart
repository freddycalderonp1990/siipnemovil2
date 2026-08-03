
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndicadorScroll extends StatefulWidget {
  @override
  State<IndicadorScroll> createState() => _IndicadorScrollState();
}

class _IndicadorScrollState extends State<IndicadorScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _controller.value * 10),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.keyboard_double_arrow_down_rounded,
            size: 42,
            color: Color(0xFF164987),
          ),

          Text(
            "Desliza",
            style: TextStyle(
              color: Color(0xFF164987),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
