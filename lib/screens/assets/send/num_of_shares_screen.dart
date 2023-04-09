import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/assets/send/preview_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

const LAMPORTS_IN_SOL = 1000000000;
RegExp trimZeroesRegExp = RegExp(r'([.]*0+)(?!.*\d)');

class NumberOfSharesScreen extends StatefulWidget {
  final OrganizationMemberWithEquity memberWithEquity;
  final User receiver;

  const NumberOfSharesScreen(
      {super.key, required this.memberWithEquity, required this.receiver});

  @override
  State<NumberOfSharesScreen> createState() => _NumberOfSharesScreenState();
}

class _NumberOfSharesScreenState extends State<NumberOfSharesScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  final equityController = TextEditingController();
  final amountController = TextEditingController();

  OrganizationMemberWithEquity get memberWithEquity => widget.memberWithEquity;
  User get receiver => widget.receiver;

  onImpactSharesChange(String? value) {
    final parsedValue = double.tryParse(value ?? '1.00');
    equityController.text =
        ((parsedValue! / _getParcedTokets()) * 100).toStringAsFixed(2);
  }

  onEquityChange(String? value) {
    final parsedValue = int.tryParse(value ?? '0');

    amountController.text =
        ((parsedValue! / 100) * _getParcedTokets()).toStringAsFixed(2);
  }

  double _getParcedTokets() {
    final tokens = (memberWithEquity.equity!.lamportsEarned! / LAMPORTS_IN_SOL)
        .toStringAsFixed(4)
        .replaceAll(trimZeroesRegExp, '');
    final parcedTokens = double.tryParse(tokens) ?? 0.00;

    return parcedTokens;
  }

  String? validateEquity(String? value) {
    if (value == null) {
      return 'Please enter a value';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < 0 || number > 100) {
      return 'Please enter a number between 0 and 100';
    }
    return null;
  }

  String? validateNumOfShares(String? value) {
    if (value == null) {
      return 'Please enter a value';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    final tokensAmount = _getParcedTokets();

    if (number < 0 || number > tokensAmount) {
      return 'Please enter a number between 0 and $tokensAmount';
    }
    return null;
  }

  handleNext() {
    if (!formGlobalKey.currentState!.validate()) {
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PreviewScreen(
                  memberWithEquity: memberWithEquity,
                  equity: equityController.text,
                  tokens: amountController.text,
                  receiver: receiver,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Number of Impact Shares',
        child: Form(
            key: formGlobalKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Enter number of Impact Shares you want to send',
                    style: TextStyle(
                        color: COLOR_GRAY,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 55),
                  const Text('Number of Impact Shares'),
                  const SizedBox(height: 5),
                  AppTextFormFieldBordered(
                    controller: amountController,
                    validator: validateNumOfShares,
                    autofocus: true,
                    suffix: const Text('Max'),
                    label: const Text('-'),
                    inputType: TextInputType.number,
                    onChanged: onImpactSharesChange,
                  ),
                  const SizedBox(height: 20),
                  const Text('Equity to date'),
                  const SizedBox(height: 5),
                  AppTextFormFieldBordered(
                    controller: equityController,
                    validator: validateEquity,
                    suffix: const Text('Max'),
                    label: const Text('%'),
                    inputType: TextInputType.number,
                    onChanged: onEquityChange,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 290,
                    child: ElevatedButton(
                        onPressed: handleNext, child: const Text('Preview')),
                  )
                ])));
  }
}
