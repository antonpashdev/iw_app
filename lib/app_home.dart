import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/app_storage.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/screens/login_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/url.dart';

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
      future: authApi.token,
      builder: (context, snapshot) {
        final url = Uri.base.toString();
        if (isOfferUrl(url)) {
          appStorage.write('offer_url', url);
        }
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
        if (snapshot.data == null) {
          return const LoginScreen();
        }
        return const HomeScreen();
      },
    );
  }
}
