import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iw_app/screens/onboarding/dont_show_the_link_screen.dart';
import 'package:iw_app/widgets/buttons/secondary_button.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';

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
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DontShowTheLinkScreen(
        link: link,
      );
    },),);
  }

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
            style: const TextStyle(color: Colors.white),),
        duration: const Duration(milliseconds: 300),
        backgroundColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),),);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: AppLocalizations.of(context)!.linkIsYourLoginScreen_title,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    AppLocalizations.of(context)!
                        .linkIsYourLoginScreen_description1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFFBB3A79),
                        fontWeight: FontWeight.w700,),
                  ),),
              const SizedBox(height: 20),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFFBB3A79),
                          fontWeight: FontWeight.w700,),
                      children: <TextSpan>[
                        TextSpan(
                            text: AppLocalizations.of(context)!
                                .linkIsYourLoginScreen_description_2_1,),
                        TextSpan(
                            text: AppLocalizations.of(context)!
                                .linkIsYourLoginScreen_description_2_2,
                            style: const TextStyle(color: Color(0xFF000000)),),
                        TextSpan(
                            text: AppLocalizations.of(context)!
                                .linkIsYourLoginScreen_description_2_3,),
                      ],),),
              const SizedBox(height: 20),
              AppTextFormFieldBordered(
                enabled: false,
                readOnly: true,
                minLines: 8,
                maxLines: 8,
                controller: TextEditingController(text: link),
              ),
              const SizedBox(height: 40),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SecondaryButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: link));
                        callSnackBar(context);
                        setState(() {
                          _copied = true;
                        });
                      },
                      child: Text(
                          AppLocalizations.of(context)!.common_copy_the_link,),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: _copied ? handleNext : null,
                        child: Text(AppLocalizations.of(context)!.common_next),)
                  ],)
            ],
          ),
        ),);
  }
}
