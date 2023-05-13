import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/api/config_api.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/contribution_model.dart';
import 'package:iw_app/screens/contribution/contribution_screen.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/screens/login_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/state/config.dart';

import 'api/auth_api.dart';

class AppHome extends StatefulWidget {
  static const routeName = '/';

  const AppHome({Key? key}) : super(key: key);

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  late Future<List<Contribution>?> futureContributions;
  late Future<Config?> futureConfig;

  @override
  void initState() {
    super.initState();
    futureContributions = fetchContributions();
    futureConfig = fetchConfig();
  }

  Future<List<Contribution>?> fetchContributions() async {
    try {
      final userId = await authApi.userId;
      if (userId == null) {
        return Future.value(null);
      }
      final response = await usersApi.getUserContributions(
        userId,
        isStopped: false,
      );
      return (response.data as List)
          .map((contribution) => Contribution.fromJson(contribution))
          .toList();
    } on DioError catch (err) {
      print(err);
      if (err.response!.statusCode == 401) {
        rethrow;
      }
    } catch (err) {
      print(err);
    }
    return null;
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
            child: FutureBuilder(
              future: Future.wait([
                authApi.token,
                futureContributions,
              ]),
              builder: (context, snapshot) {
                if (snapshot.hasError &&
                    snapshot.error is DioError &&
                    (snapshot.error as DioError).response!.statusCode == 401) {
                  return const LoginScreen();
                }
                if (!snapshot.hasData) {
                  return const Scaffold(
                    backgroundColor: APP_BODY_BG,
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.data![0] == null) {
                  return const LoginScreen();
                }
                final contributions = (snapshot.data![1] as List<Contribution>);
                final Contribution? contribution =
                    contributions.isNotEmpty ? contributions.first : null;
                if (contribution != null) {
                  return ContributionScreen(contribution: contribution);
                }
                return const HomeScreen();
              },
            ),
          );
        });
  }
}
