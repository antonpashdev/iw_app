import 'package:flutter/material.dart';
import 'package:iw_app/app_home.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/screens/offer/offer_screen.dart';
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
      onGenerateRoute: (settings) {
        if (settings.name!.contains(OfferScreen.routeName)) {
          // final orgId = settings.name!.split('=')[1];
          // final offerId = settings.name!.split('=')[1];
          final settingsUri = Uri.parse(settings.name!);
          String? offerId = settingsUri.queryParameters['i'];
          String? orgId = settingsUri.queryParameters['oi'];
          return MaterialPageRoute(
            builder: (_) => OfferScreen(
              orgId: orgId!,
              offerId: offerId!,
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      },
      home: const AppHome(),
    );
  }
}
