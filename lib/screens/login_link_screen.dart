import 'package:flutter/material.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class LoginLinkScreen extends StatelessWidget {
  final String link;

  const LoginLinkScreen({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(link);
    return const ScreenScaffold(
      title: 'Link is Your Login',
      child: Text('Link is your login'),
    );
  }
}
