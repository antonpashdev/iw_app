import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/config_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/screens/nickname_screen.dart';
import 'package:iw_app/screens/restore_account.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/buttons/secondary_button.dart';
import 'package:iw_app/widgets/state/config.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  onLogoPressed(Config config, BuildContext context) async {
    if (config.mode == Mode.Lite) {
      config.mode = Mode.Pro;
    } else {
      config.mode = Mode.Lite;
    }
    try {
      await configApi.updateConfig(config);
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Config config = ConfigState.of(context).config;
    String slogan = config.mode == Mode.Lite
        ? 'Manage your equity in projects like never before'
        : AppLocalizations.of(context)!.loginScreen_slogan;
    String logoPath = 'assets/images/logo_with_text.png';
    return Scaffold(
      backgroundColor: APP_BODY_BG,
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: AppPadding(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Stack(
                  children: [
                    Image.asset(
                      logoPath,
                      width: 250,
                    ),
                    GestureDetector(
                      // onTap: () => onLogoPressed(config, context),
                      onTap: null,
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
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
                        slogan,
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
                flex: 1,
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
                                        const NicknameScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            SecondaryButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RestoreAccountScreen(),
                                  ),
                                );
                              },
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
