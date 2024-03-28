import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iw_app/screens/onboarding/dont_show_the_link_screen.dart';
import 'package:iw_app/widgets/buttons/secondary_button.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class LoginLinkScreen extends StatefulWidget {
  final String link;

  const LoginLinkScreen({Key? key, required this.link}) : super(key: key);

  @override
  State<LoginLinkScreen> createState() => _LoginLinkScreen();
}

class _LoginLinkScreen extends State<LoginLinkScreen> {
  String get link => widget.link;
  bool _copied = false;

  handleNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DontShowTheLinkScreen(
            link: link,
          );
        },
      ),
    );
  }

  callSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 70,
          left: 20,
          right: 20,
        ),
        content: const Text(
          'Link copied',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(milliseconds: 300),
        backgroundColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Link is your login',
      child: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'This unique link is a login to your account.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFBB3A79),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFBB3A79),
                fontWeight: FontWeight.w700,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Please, ',
                ),
                TextSpan(
                  text: 'copy the link and save it in the safe place ',
                  style: TextStyle(color: Color(0xFF000000)),
                ),
                TextSpan(
                  text: 'to be able to log in to your account.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppTextFormFieldBordered(
            enabled: false,
            readOnly: true,
            minLines: 8,
            maxLines: 8,
            controller: TextEditingController(text: link),
          ),
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: 290,
              child: SecondaryButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: link));
                  callSnackBar(context);
                  setState(() {
                    _copied = true;
                  });
                },
                child: const Text(
                  'Copy the Link',
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 290,
              child: ElevatedButton(
                onPressed: _copied ? handleNext : null,
                child: const Text('Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
