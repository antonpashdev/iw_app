import 'package:flutter/material.dart';

class ScreenScaffold extends StatelessWidget {
  final Widget child;
  final String title;

  const ScreenScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
          child: child,
        ),
      ),
    );
  }
}
