import 'package:flutter/material.dart';
import 'package:iw_app/screens/login_screen.dart';
import 'package:iw_app/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impact Wallet',
      theme: getAppTheme(),
      home: const LoginScreen(),
    );
  }
}
