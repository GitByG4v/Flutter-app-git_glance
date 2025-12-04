import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/constants.dart';

class LiquidBackground extends StatefulWidget {
  final Widget child;
  const LiquidBackground({super.key, required this.child});

  @override
  State<LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<LiquidBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Background
        Container(color: AppColors.backgroundWhite),
        
        // Animated Liquid Shapes
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: LiquidPainter(
                animationValue: _controller.value,
                color: AppColors.primaryLight.withOpacity(0.1),
              ),
              size: Size.infinite,
            );
          },
        ),
        
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: LiquidPainter(
                animationValue: _controller.value + 0.5,
                color: AppColors.primaryBlue.withOpacity(0.05),
                offset: const Offset(100, 200),
              ),
              size: Size.infinite,
            );
          },
        ),

        // Content
        widget.child,
      ],
    );
  }
}

class LiquidPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final Offset offset;

  LiquidPainter({
    required this.animationValue,
    required this.color,
    this.offset = Offset.zero,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final yOffset = size.height * 0.5;
    final waveHeight = size.height * 0.1;
    
    path.moveTo(0, 0);
    path.lineTo(0, yOffset);

    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        yOffset +
            math.sin((i / size.width * 2 * math.pi) + (animationValue * 2 * math.pi) + offset.dx) * waveHeight +
            math.cos((i / size.width * 3 * math.pi) + (animationValue * 2 * math.pi) + offset.dy) * (waveHeight * 0.5),
      );
    }

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
    
    // Draw a second blob at bottom right
    final path2 = Path();
    path2.addOval(Rect.fromCircle(
      center: Offset(
        size.width * 0.8 + math.sin(animationValue * 2 * math.pi) * 20,
        size.height * 0.8 + math.cos(animationValue * 2 * math.pi) * 20,
      ),
      radius: size.width * 0.3,
    ));
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant LiquidPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
