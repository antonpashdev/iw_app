import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/screens/nickname_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/buttons/secondary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: APP_BODY_BG,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Center(
                  child: SvgPicture.asset('assets/images/logo_with_text.svg'),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 350),
                      child: Image.asset(
                        'assets/images/onboarding_chart.png',
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: Text(
                        AppLocalizations.of(context)!.loginScreen_slogan,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/icons/question_circle.svg',
                          ),
                          label: Text(
                            AppLocalizations.of(context)!
                                .loginScreen_textBtnTitle,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Gilroy',
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .loginScreen_primaryBtnTitle,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NicknameScreen()),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            SecondaryButton(
                              onPressed: () {},
                              child: Text(
                                AppLocalizations.of(context)!
                                    .loginScreen_secondaryBtnTitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
