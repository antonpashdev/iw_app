import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class CheckLoginLinkScreen extends StatefulWidget {
  final String link;

  const CheckLoginLinkScreen({Key? key, required this.link}) : super(key: key);

  @override
  State<CheckLoginLinkScreen> createState() => _CheckLoginLinkScreen();
}

class _CheckLoginLinkScreen extends State<CheckLoginLinkScreen> {
  String get link => widget.link;
  bool? linksMatch;

  handleNext() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const HomeScreen(isOnboarding: true);
    }));
  }

  getValidationStatusText() {
    if (linksMatch == null) {
      return 'Paste the link to make sure you have copied it.';
    }
    if (linksMatch == true) {
      return 'The link is valid';
    }
    return 'The link is not valid';
  }

  getValidationStatusIcon() {
    if (linksMatch == true) {
      return 'assets/icons/check_filled.svg';
    }
    return 'assets/icons/cross_red.svg';
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Check the Link to your Account',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 80),
          const Text(
            'Paste the link to make\nsure you have copied it.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 50),
          InputForm(
            child: AppTextFormFieldBordered(
              maxLines: 8,
              minLines: 8,
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  linksMatch = value == link;
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                getValidationStatusText(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF87899B),
                ),
              ),
              const SizedBox(width: 5),
              linksMatch != null
                  ? SvgPicture.asset(getValidationStatusIcon())
                  : Container(),
            ],
          ),
          const SizedBox(height: 40),
          Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 240,
                  child: ElevatedButton(
                      onPressed: handleNext,
                      child: const Text('Finish Creating Account ')))),
          const SizedBox(height: 20),
          const Text(
            'Be sure you save the link.\nYou won’t be able to get\naccess to your account\nwithout this link.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFFBB3A79),
            ),
          )
        ],
      ),
    );
  }
}
