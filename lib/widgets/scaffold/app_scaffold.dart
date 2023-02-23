import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';

class AppScaffold extends StatelessWidget {
  final Widget? child;

  const AppScaffold({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: APP_BODY_BG,
      body: child,
    );
  }
}
