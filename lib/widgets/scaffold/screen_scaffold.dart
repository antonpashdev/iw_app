import 'package:flutter/material.dart';

class ScreenScaffold extends StatelessWidget {
  final Widget child;
  final String title;

  const ScreenScaffold({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: child,
        ),
      ),
    );
  }
}
