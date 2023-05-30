import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/constants/send_asset_type.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/assets/send/num_of_shares_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/debounce.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

Debouncer _debouncer = Debouncer(duration: const Duration(milliseconds: 500));

class ReceiverScreen extends StatefulWidget {
  final Organization organization;
  final OrganizationMember member;
  final SendAssetType sendAssetType;

  const ReceiverScreen({
    super.key,
    required this.member,
    required this.organization,
    required this.sendAssetType,
  });

  @override
  State<ReceiverScreen> createState() => _ReceiverScreenState();
}

class _ReceiverScreenState extends State<ReceiverScreen> {
  bool _disabled = true;
  bool _isLoading = false;
  bool? _error;
  User? receiver;
  String? receiverAddress;

  OrganizationMember get member => widget.member;

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

  onReceiverChanged(String? receiver) {
    if (widget.sendAssetType == SendAssetType.ToUser) {
      _debouncer.debounce(() async {
        final trimmedNickname = receiver?.trim();
        setState(() {
          _disabled = trimmedNickname == null;
          _isLoading = trimmedNickname != null;
        });

        if (trimmedNickname != null) {
          await callFetchUserByNickname(trimmedNickname);
        }
      });
    } else {
      setState(() {
        _disabled = receiver == null || receiver.isEmpty;
        receiverAddress = receiver;
      });
    }
  }

  handleNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NumberOfSharesScreen(
          organization: widget.organization,
          member: member,
          receiver: receiver,
          receiverAddress: receiverAddress,
          sendAssetType: widget.sendAssetType,
        ),
      ),
    );
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
        children: <Widget>[
          Text(
            widget.sendAssetType == SendAssetType.ToUser
                ? 'Enter Impact Wallet Username of a person you want to send your Asset'
                : 'Enter Solana Wallet Address of a person you want to send your Asset',
            style: const TextStyle(
              color: COLOR_GRAY,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 55),
            child: Row(
              children: [
                Flexible(
                    flex: 1,
                    child: AppTextFormField(
                      prefix: widget.sendAssetType == SendAssetType.ToUser
                          ? '@'
                          : null,
                      inputType: TextInputType.text,
                      labelText: widget.sendAssetType == SendAssetType.ToUser
                          ? '@username'
                          : 'Solana Wallet Address',
                      onChanged: onReceiverChanged,
                    ),),
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
              onPressed:
                  _disabled || _isLoading || _error == true ? null : handleNext,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoading) const CircularProgressIndicator.adaptive(),
                  if (!_isLoading) const Text('Next'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
