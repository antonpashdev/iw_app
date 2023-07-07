import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';

class AppProgressBar extends StatefulWidget {
  final double progress;
  final double? size;
  final Color backgroundColor;
  final Color progressColor;
  final Function(AnimationStatus)? onStatusUpdate;
  final Function(double)? onUpdate;

  const AppProgressBar({
    Key? key,
    required this.progress,
    this.size,
    this.backgroundColor = COLOR_PURPLE2,
    this.progressColor = COLOR_PINK,
    this.onStatusUpdate,
    this.onUpdate,
  }) : super(key: key);

  @override
  State<AppProgressBar> createState() => _AppProgressBarState();
}

class _AppProgressBarState extends State<AppProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );
    _progress = CurvedAnimation(parent: _controller, curve: Curves.linear);
    if (widget.onStatusUpdate != null) {
      _progress.addStatusListener(widget.onStatusUpdate!);
    }
    if (widget.onUpdate != null) {
      _progress.addListener(() {
        widget.onUpdate!(_progress.value);
      });
    }
    _controller.animateTo(widget.progress);
  }

  @override
  void didUpdateWidget(AppProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress <= 1) {
      _controller.animateTo(widget.progress);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AnimatedAppProgressBar(
      progress: _progress,
      size: widget.size,
      backgroundColor: widget.backgroundColor,
      progressColor: widget.progressColor,
    );
  }
}

class _AnimatedAppProgressBar extends AnimatedWidget {
  final double? size;
  final Color backgroundColor;
  final Color progressColor;

  const _AnimatedAppProgressBar({
    required Animation<double> progress,
    this.size,
    required this.backgroundColor,
    required this.progressColor,
  }) : super(listenable: progress);

  @override
  Widget build(BuildContext context) {
    final progress = listenable as Animation<double>;
    return CustomPaint(
      painter: _AppProgressBarPainter(
        progress: progress.value,
        backgroundColor: backgroundColor,
        progressColor: progressColor,
      ),
      size: size != null ? Size.square(size!) : Size.zero,
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
