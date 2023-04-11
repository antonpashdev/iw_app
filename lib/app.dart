import 'package:flutter/material.dart';
import 'package:iw_app/app_home.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/screens/offer/offer_screen.dart';
import 'package:iw_app/screens/offer/sale_offer_screen.dart';
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
        AppHome.routeName: (context) => const AppHome(),
        AppStorybook.routeName: (context) => const AppStorybook(),
      },
      onGenerateRoute: (settings) {
        if (settings.name!.contains(OfferScreen.routeName)) {
          final settingsUri = Uri.parse(settings.name!);
          String? offerId = settingsUri.queryParameters['i'];
          String? orgId = settingsUri.queryParameters['oi'];
          return MaterialPageRoute(
            builder: (_) => OfferScreen(
              orgId: orgId!,
              offerId: offerId!,
            ),
          );
        } else if (settings.name!.contains(SaleOfferScreen.routeName)) {
          final settingsUri = Uri.parse(settings.name!);
          String? offerId = settingsUri.queryParameters['i'];
          return MaterialPageRoute(
            builder: (_) => SaleOfferScreen(
              offerId: offerId!,
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      },
    );
  }
}
