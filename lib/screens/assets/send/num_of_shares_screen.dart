import 'package:flutter/material.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/constants/send_asset_type.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/assets/send/preview_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/debounce.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/widgets/state/config.dart';

const LAMPORTS_IN_SOL = 1000000000;
final _debouncer = Debouncer(duration: const Duration(milliseconds: 1000));

class NumberOfSharesScreen extends StatefulWidget {
  final Organization organization;
  final OrganizationMember member;
  final User? receiver;
  final String? receiverAddress;
  final SendAssetType sendAssetType;

  const NumberOfSharesScreen({
    super.key,
    required this.member,
    required this.receiver,
    required this.organization,
    required this.receiverAddress,
    required this.sendAssetType,
  });

  @override
  State<NumberOfSharesScreen> createState() => _NumberOfSharesScreenState();
}

class _NumberOfSharesScreenState extends State<NumberOfSharesScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  final equityController = TextEditingController();
  final amountController = TextEditingController();
  int? lamportsMinted;
  double? tokensAmount;

  OrganizationMember get member => widget.member;
  User? get receiver => widget.receiver;

  fetchEquity() async {
    _debouncer.debounce(() async {
      try {
        final response = await orgsApi.getOrgById(widget.organization.id!);
        lamportsMinted = response.data!['lamportsMinted'];
        equityController.text = equity!;
      } catch (err) {
        print(err);
      }
    });
  }

  String? get equity {
    if (lamportsMinted == null) {
      return null;
    }
    final equity = ((tokensAmount! * LAMPORTS_IN_SOL) / lamportsMinted! * 100)
        .toStringAsFixed(1);
    return equity;
  }

  handleNext() {
    if (!formGlobalKey.currentState!.validate()) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewScreen(
          organization: widget.organization,
          member: member,
          tokens: tokensAmount!,
          receiver: receiver,
          receiverAddress: widget.receiverAddress,
          sendAssetType: widget.sendAssetType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Config config = ConfigState.of(context).config;
    return ScreenScaffold(
      title: config.mode == Mode.Pro
          ? 'Number of Impact Shares'
          : 'Percent of Equity',
      child: Form(
        key: formGlobalKey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: KeyboardDismissableListView(
                children: [
                  Text(
                    config.mode == Mode.Pro
                        ? 'Enter number of Impact Shares you want to send'
                        : 'Enter percent of equity you want to send',
                    style: const TextStyle(
                        color: COLOR_GRAY,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 55),
                  if (config.mode == Mode.Pro)
                    Column(
                      children: [
                        const Text('Number of Impact Shares'),
                        const SizedBox(height: 15),
                        AppTextFormFieldBordered(
                          controller: amountController,
                          validator: multiValidate([
                            requiredField('Number of Impact Shares'),
                            numberField('Number of Impact Shares'),
                            max(member.lamportsEarned! / LAMPORTS_IN_SOL),
                          ]),
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                tokensAmount = widget.member.lamportsEarned! /
                                    LAMPORTS_IN_SOL;
                              });
                              amountController.text = tokensAmount.toString();
                              fetchEquity();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Max',
                                style: Theme.of(context).textTheme.bodySmall!,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            tokensAmount = double.tryParse(value);
                            fetchEquity();
                          },
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  Text(config.mode == Mode.Pro ? 'Equity to date' : 'Equity'),
                  const SizedBox(height: 15),
                  AppTextFormFieldBordered(
                    controller: equityController,
                    prefix: const Text('%'),
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          tokensAmount =
                              widget.member.lamportsEarned! / LAMPORTS_IN_SOL;
                        });
                        amountController.text = tokensAmount.toString();
                        fetchEquity();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Max',
                          style: Theme.of(context).textTheme.bodySmall!,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (config.mode == Mode.Pro) {
                        equityController.text = equity ?? '';
                      } else {
                        tokensAmount = double.tryParse(value);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 290,
              child: ElevatedButton(
                  onPressed: handleNext, child: const Text('Preview')),
            )
          ],
        ),
      ),
    );
  }
}
