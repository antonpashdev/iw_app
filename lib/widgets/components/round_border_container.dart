import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';

class RoundBorderContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;

  const RoundBorderContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: padding ?? const EdgeInsets.fromLTRB(19, 24, 19, 19),
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? COLOR_LIGHT_GRAY3,
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        border: Border.all(
          color: borderColor ?? Theme.of(context).colorScheme.surface,
          width: borderWidth ?? 0,
        ),
      ),
      child: child,
    );
  }
}
