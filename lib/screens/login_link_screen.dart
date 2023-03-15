import 'package:flutter/material.dart';
import 'package:iw_app/widgets/buttons/secondary_button.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';

class LoginLinkScreen extends StatelessWidget {
  final String link;

  const LoginLinkScreen({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: AppLocalizations.of(context)!.linkIsYourLoginScreen_title,
        child: Center(
          child: Padding(
              padding: const EdgeInsets.only(top: 75),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35),
                        child: Text(
                          'This unique link is a login to your account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFBB3A79),
                              fontWeight: FontWeight.w700),
                        )),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFBB3A79),
                                    fontWeight: FontWeight.w700),
                                children: <TextSpan>[
                                  TextSpan(text: 'Please, '),
                                  TextSpan(
                                      text:
                                          'copy the link and save it the safe place ',
                                      style:
                                          TextStyle(color: Color(0xFF000000))),
                                  TextSpan(
                                      text:
                                          'to be able to log in to your account.'),
                                ]))),
                    const SizedBox(height: 20),
                    TextField(
                      enabled: false,
                      readOnly: true,
                      minLines: 8,
                      maxLines: 8,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF87899B),
                          fontWeight: FontWeight.w700),
                      controller: TextEditingController(text: link),
                      decoration: const InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFF87899B),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SecondaryButton(
                              onPressed: () {},
                              child: const Text('Copy the Link'),
                            ),
                            const SizedBox(height: 5),
                            const ElevatedButton(
                                onPressed: null, child: Text('Next'))
                          ]),
                    )
                  ],
                ),
              )),
        ));
  }
}
