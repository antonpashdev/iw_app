import 'package:flutter/material.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/assets/send/preview_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

const LAMPORTS_IN_SOL = 1000000000;

class NumberOfSharesScreen extends StatefulWidget {
  final Organization organization;
  final OrganizationMember member;
  final User receiver;

  const NumberOfSharesScreen({
    super.key,
    required this.member,
    required this.receiver,
    required this.organization,
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
  User get receiver => widget.receiver;

  fetchEquity() async {
    try {
      final response = await orgsApi.getOrgById(widget.organization.id!);
      lamportsMinted = response.data!['lamportsMinted'];
      equityController.text = equity!;
    } catch (err) {
      print(err);
    }
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
                )));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Number of Impact Shares',
      child: Form(
        key: formGlobalKey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Enter number of Impact Shares you want to send',
                    style: TextStyle(
                        color: COLOR_GRAY,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 55),
                  const Text('Number of Impact Shares'),
                  const SizedBox(height: 15),
                  AppTextFormFieldBordered(
                    controller: amountController,
                    validator: multiValidate([
                      requiredField('Number of Impact Shares'),
                      numberField('Number of Impact Shares'),
                    ]),
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
                      tokensAmount = double.tryParse(value);
                      fetchEquity();
                    },
                  ),
                  const SizedBox(height: 30),
                  const Text('Equity to date'),
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
                      equityController.text = equity ?? '';
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
