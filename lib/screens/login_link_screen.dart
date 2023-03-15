import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iw_app/widgets/buttons/secondary_button.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';

class LoginLinkScreen extends StatelessWidget {
  final String link;

  const LoginLinkScreen({Key? key, required this.link}) : super(key: key);

  callSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 70,
          left: 20,
          right: 20,
        ),
        content: Text(AppLocalizations.of(context)!.common_link_copied,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        )));
  }

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
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Text(
                          AppLocalizations.of(context)!
                              .linkIsYourLoginScreen_title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFFBB3A79),
                              fontWeight: FontWeight.w700),
                        )),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFBB3A79),
                                    fontWeight: FontWeight.w700),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .linkIsYourLoginScreen_description_2_1),
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .linkIsYourLoginScreen_description_2_2,
                                      style: const TextStyle(
                                          color: Color(0xFF000000))),
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .linkIsYourLoginScreen_description_2_3),
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
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: link));
                                callSnackBar(context);
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .common_copy_the_link),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: null,
                                child: Text(
                                    AppLocalizations.of(context)!.common_next))
                          ]),
                    )
                  ],
                ),
              )),
        ));
  }
}
