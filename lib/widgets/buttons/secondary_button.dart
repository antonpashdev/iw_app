import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';

class SecondaryButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onPressed;

  const SecondaryButton({
    Key? key,
    this.child,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        side: const BorderSide(
          color: COLOR_ALMOST_BLACK,
        ),
        foregroundColor: COLOR_BLACK,
      ),
      child: child,
    );
  }
}
