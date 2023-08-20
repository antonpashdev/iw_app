import 'package:flutter/material.dart';

class BulletText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const BulletText({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: '\u2022 ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: text,
            style: style ??
                const TextStyle(
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );
  }
}
