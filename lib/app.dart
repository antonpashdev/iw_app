import 'package:flutter/material.dart';
import 'package:iw_app/api/config_api.dart';
import 'package:iw_app/app_home.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/screens/offer/offer_screen.dart';
import 'package:iw_app/screens/offer/sale_offer_screen.dart';
import 'package:iw_app/screens/payment/checkout_screen.dart';
import 'package:iw_app/screens/restore_account_immidiate_screen.dart';
import 'package:iw_app/storybook/app_storybook.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/common.dart';
import 'package:iw_app/widgets/state/config.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Future<Config?> futureConfig;

  @override
  void initState() {
    super.initState();
    futureConfig = fetchConfig();
  }

  Future<Config?> fetchConfig() async {
    try {
      final response = await configApi.getConfig();
      return Config.fromJson(response.data);
    } catch (err) {
      print(err);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DePlan',
      theme: getAppTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return FutureBuilder(
          future: futureConfig,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                backgroundColor: APP_BODY_BG,
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            Config config = snapshot.data as Config;
            return ConfigState(
              config: config,
              child: child!,
            );
          },
        );
      },
      routes: {
        AppHome.routeName: (context) => const AppHome(),
        AppStorybook.routeName: (context) => const AppStorybook(),
      },
      onGenerateRoute: (settings) {
        if (settings.name!.startsWith(SaleOfferScreen.routeName)) {
          final settingsUri = Uri.parse(settings.name!);
          String? offerId = settingsUri.queryParameters['i'];
          return MaterialPageRoute(
            builder: (_) => SaleOfferScreen(
              offerId: offerId!,
            ),
          );
        } else if (settings.name!
            .startsWith(RestoreAccountImmidiateScreen.routeName)) {
          final code = settings.name!
              .substring(RestoreAccountImmidiateScreen.routeName.length);
          return MaterialPageRoute(
            builder: (_) => RestoreAccountImmidiateScreen(
              code: code,
            ),
          );
        } else if (settings.name!.startsWith(CheckoutScreen.routeName)) {
          final paymentId = Uri.parse(settings.name!).pathSegments.last;
          if (CommonUtils.isObjectId(paymentId)) {
            return MaterialPageRoute(
              builder: (_) => CheckoutScreen(paymentId: paymentId),
            );
          }
        } else if (settings.name!.startsWith(OfferScreen.routeName)) {
          final uri = Uri.parse(settings.name!);
          final i = uri.queryParameters['i'];
          final oi = uri.queryParameters['oi'];
          if (CommonUtils.isObjectId(i) && CommonUtils.isObjectId(oi)) {
            return MaterialPageRoute(
              builder: (_) => OfferScreen(
                offerId: i!,
                orgId: oi!,
              ),
            );
          }
        }
        return null;
      },
    );
  }
}
