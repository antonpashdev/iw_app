import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/screens/login_screen.dart';
import 'package:iw_app/theme/app_theme.dart';

import 'api/auth_api.dart';

class AppHome extends StatefulWidget {
  static const routeName = '/';

  const AppHome({Key? key}) : super(key: key);

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        authApi.token,
        authApi.getMe(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError &&
            snapshot.error is DioError &&
            (snapshot.error as DioError).response!.statusCode == 401) {
          return const LoginScreen();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: APP_BODY_BG,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final token = snapshot.data?[0];
        if (token == null) {
          return const LoginScreen();
        }
        return const HomeScreen();
      },
    );
  }
}
