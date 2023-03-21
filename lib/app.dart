import 'package:flutter/material.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/screens/contribution/contribution_screen.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/screens/login_screen.dart';
import 'package:iw_app/storybook/app_storybook.dart';
import 'package:iw_app/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Impact Wallet',
      theme: getAppTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        AppStorybook.routeName: (context) => const AppStorybook(),
      },
      home: FutureBuilder(
        future: authApi.token,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const LoginScreen();
          }
          return const HomeScreen();
        },
      ),
    );
  }
}
