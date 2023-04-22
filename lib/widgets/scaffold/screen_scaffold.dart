import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iw_app/theme/app_theme.dart';

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
    return Scaffold(
      backgroundColor: APP_BODY_BG,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
          child: child,
        ),
      ),
    );
  }
}
