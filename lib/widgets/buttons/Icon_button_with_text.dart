import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';

class IconButtonWithText extends StatelessWidget {
  final Widget image;
  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  final double? buttonSize;
  final Function()? onPressed;

  const IconButtonWithText({
    super.key,
    required this.image,
    required this.text,
    this.textColor,
    this.onPressed,
    this.backgroundColor,
    this.buttonSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: buttonSize ?? 50,
          width: buttonSize ?? 50,
          decoration: BoxDecoration(
            color: backgroundColor ?? COLOR_WHITE,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: IconButton(
              icon: image,
              onPressed: onPressed,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: textColor ?? COLOR_ALMOST_BLACK,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
