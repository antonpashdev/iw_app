import 'package:flutter/material.dart';
import 'package:iw_app/screens/onboarding/check_login_link_screen.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class DontShowTheLinkScreen extends StatelessWidget {
  final String link;

  const DontShowTheLinkScreen({Key? key, required this.link}) : super(key: key);

  handleNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CheckLoginLinkScreen(
            link: link,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(
      fontSize: 18,
      color: Color(0xFFBB3A79),
      fontWeight: FontWeight.w700,
    );

    return ScreenScaffold(
      title: 'Don’t Show the Link',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 80),
          const Text(
            "Don't show the Link to Your'\nAccount to anyone else.",
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          const Text(
            "Don't send the Link to Your\nAccount to anyone else.",
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: textStyle,
              children: [
                TextSpan(
                  text: "Don't put this link to any\nwebsites except\n",
                ),
                TextSpan(
                  text: 'app.equitywallet.org',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 45),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 270,
              child: ElevatedButton(
                onPressed: () => handleNext(context),
                child: const Text(
                  'Got it. Continue.',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
