import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class DontShowTheLinkScreen extends StatelessWidget {
  final String link;

  const DontShowTheLinkScreen({Key? key, required this.link}) : super(key: key);

  handleNext() {}

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(
        fontSize: 18, color: Color(0xFFBB3A79), fontWeight: FontWeight.w700);

    return ScreenScaffold(
        title: AppLocalizations.of(context)!.dontShowTheLinkScreen_title,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 80),
              Text(
                AppLocalizations.of(context)!.dontShowTheLinkScreen_description,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text(
                AppLocalizations.of(context)!
                    .dontShowTheLinkScreen_description2,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text(
                AppLocalizations.of(context)!
                    .dontShowTheLinkScreen_description3,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 45),
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: 270,
                      child: ElevatedButton(
                          onPressed: handleNext,
                          child: Text(AppLocalizations.of(context)!
                              .dontShowTheLinkScreen_gotIt__button_text)))),
            ]));
  }
}
