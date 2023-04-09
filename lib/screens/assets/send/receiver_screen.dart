import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/assets/send/num_of_shares_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/debounce.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

Debouncer _debouncer = Debouncer(duration: const Duration(milliseconds: 500));

class ReceiverScreen extends StatefulWidget {
  final OrganizationMemberWithEquity memberWithEquity;

  const ReceiverScreen({super.key, required this.memberWithEquity});

  @override
  State<ReceiverScreen> createState() => _ReceiverScreenState();
}

class _ReceiverScreenState extends State<ReceiverScreen> {
  bool _disabled = true;
  bool _isLoading = false;
  bool? _error;
  User? receiver;

  OrganizationMemberWithEquity get memberWithEquity => widget.memberWithEquity;

  callFetchUserByNickname(String nickname) async {
    setState(() {
      _error = false;
    });

    try {
      var user = await usersApi.getUserByNickname(nickname);
      setState(() {
        receiver = user;
      });
    } catch (ex) {
      setState(() {
        _error = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  onNicknameChnaged(String? nickname) {
    _debouncer.debounce(() async {
      final trimmedNickname = nickname?.trim();
      setState(() {
        _disabled = trimmedNickname == null;
        _isLoading = trimmedNickname != null;
      });

      if (trimmedNickname != null) {
        await callFetchUserByNickname(trimmedNickname);
      }
    });
  }

  handleNext() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => NumberOfSharesScreen(
                  memberWithEquity: memberWithEquity,
                  receiver: receiver!,
                )));
  }

  getValidationStatusIcon() {
    if (_error == false) {
      return 'assets/icons/check_filled.svg';
    }
    return 'assets/icons/cross_red.svg';
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Receiver',
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Enter username of a person you want to send your Asset',
                style: TextStyle(
                    color: COLOR_GRAY,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 55),
                child: Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: AppTextFormField(
                          prefix: '@',
                          inputType: TextInputType.text,
                          labelText: '@username',
                          onChanged: onNicknameChnaged,
                        )),
                    SizedBox(width: _error != null ? 10 : 0),
                    _error != null
                        ? _isLoading == true
                            ? const CircularProgressIndicator.adaptive()
                            : SvgPicture.asset(getValidationStatusIcon())
                        : Container()
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 290,
                child: ElevatedButton(
                  onPressed: _disabled || _isLoading || _error == true
                      ? null
                      : handleNext,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading)
                        const CircularProgressIndicator.adaptive(),
                      if (!_isLoading) const Text('Next'),
                    ],
                  ),
                ),
              )
            ]));
  }
}
