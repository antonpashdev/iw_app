import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';

class GrayButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const GrayButton({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: BTN_GRAY_GB,
        foregroundColor: COLOR_ALMOST_BLACK,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'Gilroy',
          height: 1,
        ),
      ),
      child: child,
    );
  }
}
