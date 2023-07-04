import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';

class AppProgressBar extends StatelessWidget {
  final double progress;
  final double size;
  final Color backgroundColor;
  final Color progressColor;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.size = 100.0,
    this.backgroundColor = COLOR_PURPLE2,
    this.progressColor = COLOR_PINK,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AppProgressBarPainter(
        progress: progress,
        backgroundColor: backgroundColor,
        progressColor: progressColor,
      ),
      size: Size.square(size),
    );
  }
}

class _AppProgressBarPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _AppProgressBarPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arcs
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.fill;

    final progressAngle = 2 * pi * ((progress / 2).clamp(0.0, 0.5));
    const startAngle = pi / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progressAngle,
      true,
      progressPaint,
    );

    const reverseStartAngle = pi / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      reverseStartAngle,
      -progressAngle,
      true,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_AppProgressBarPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        backgroundColor != oldDelegate.backgroundColor ||
        progressColor != oldDelegate.progressColor;
  }
}
