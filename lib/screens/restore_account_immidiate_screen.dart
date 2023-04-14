import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/app_home.dart';
import 'package:iw_app/app_storage.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class RestoreAccountImmidiateScreen extends StatefulWidget {
  static const routeName = '/restore/';

  final String code;

  const RestoreAccountImmidiateScreen({Key? key, required this.code})
      : super(key: key);

  @override
  State<RestoreAccountImmidiateScreen> createState() =>
      _RestoreAccountImmidiateScreenState();
}

class _RestoreAccountImmidiateScreenState
    extends State<RestoreAccountImmidiateScreen> {
  handleError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: COLOR_RED,
        duration: const Duration(days: 365),
        showCloseIcon: true,
        closeIconColor: COLOR_WHITE,
      ),
    );
  }

  Future applyRestore() async {
    try {
      final response = await usersApi.restoreAccount(widget.code);
      await appStorage.write('jwt_token', response.token);
      if (context.mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppHome.routeName, (route) => false);
      }
    } on DioError catch (err) {
      handleError(err.response?.data['message'] ?? err.message);
      rethrow;
    } catch (err) {
      handleError(err.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: '',
      child: FutureBuilder(
        future: applyRestore(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ups...\nSomething went wrong...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontFamily: 'Gilroy',
                      fontStyle: FontStyle.italic,
                      color: COLOR_GRAY,
                    ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
