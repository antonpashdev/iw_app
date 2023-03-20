import 'package:flutter/material.dart';

class AppPadding extends StatelessWidget {
  final Widget? child;

  const AppPadding({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }
}
