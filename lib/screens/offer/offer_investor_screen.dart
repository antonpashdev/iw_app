import 'package:flutter/material.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/offer/offer_preview_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class OfferInvestorScreen extends StatelessWidget {
  final Organization organization;
  final formKey = GlobalKey<FormState>();
  final OrganizationMember memberProspect = OrganizationMember(
    role: MemberRole.Investor,
    investorSettings: InvestorSettings(),
  );

  OfferInvestorScreen({
    Key? key,
    required this.organization,
  }) : super(key: key);

  buildForm() {
    return InputForm(
      formKey: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What is the deal?',
            style: TextStyle(color: COLOR_GRAY),
          ),
          const SizedBox(height: 25),
          const Text(
            'Raising',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          AppTextFormFieldBordered(
            prefix: const Text('\$'),
            validator: multiValidate([
              requiredField('Raising'),
              numberField('Raising'),
            ]),
            onChanged: (value) {
              memberProspect.investorSettings!.investmentAmount =
                  double.tryParse(value);
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Equity Allocation',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          AppTextFormFieldBordered(
            prefix: const Text('%'),
            validator: multiValidate([
              requiredField('Equity Allocation'),
              numberField('Equity Allocation'),
            ]),
            onChanged: (value) {
              memberProspect.investorSettings!.equityAllocation =
                  double.tryParse(value);
            },
          ),
        ],
      ),
    );
  }

  handleNextPressed(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OfferPreviewScreen(
            organization: organization,
            member: memberProspect,
          ),
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Offer for Investors',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                buildForm(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 290,
              child: ElevatedButton(
                onPressed: () => handleNextPressed(context),
                child: const Text('Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
