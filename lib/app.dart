import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/screens/login_screen.dart';
import 'package:iw_app/screens/organization/create_org_member_screen.dart';
import 'package:iw_app/screens/organization/create_org_name_screen.dart';
import 'package:iw_app/screens/organization/create_org_screen.dart';
import 'package:iw_app/screens/organization/create_org_settings_screen.dart';
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
      home: const CreateOrgScreen(),
      routes: {
        AppStorybook.routeName: (context) => const AppStorybook(),
      },
    );
  }
}
