import 'package:flutter/material.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/offers_api.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/sale_offer_model.dart';
import 'package:iw_app/screens/offer/sale_offer_preview_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

const LAMPORTS_IN_SOL = 1000000000;

class SellAssetScreen extends StatefulWidget {
  final Organization organization;
  final OrganizationMember member;

  const SellAssetScreen({
    Key? key,
    required this.organization,
    required this.member,
  }) : super(key: key);

  @override
  State<SellAssetScreen> createState() => _SellAssetScreenState();
}

class _SellAssetScreenState extends State<SellAssetScreen> {
  final formKey = GlobalKey<FormState>();
  final equityController = TextEditingController();
  final amountController = TextEditingController();
  SaleOffer saleOffer = SaleOffer(tokensAmount: 0);
  bool isLoading = false;
  int? lamportsMinted;

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
    final equity =
        ((saleOffer.tokensAmount! * LAMPORTS_IN_SOL) / lamportsMinted! * 100)
            .toStringAsFixed(1);
    return equity;
  }

  buildForm(BuildContext context) {
    return InputForm(
      formKey: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Number of Impact Shares',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
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
                  saleOffer.tokensAmount =
                      widget.member.lamportsEarned! / LAMPORTS_IN_SOL;
                });
                amountController.text = saleOffer.tokensAmount.toString();
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
              saleOffer.tokensAmount = double.tryParse(value);
              fetchEquity();
            },
          ),
          const SizedBox(height: 30),
          const Text(
            'Equity',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          AppTextFormFieldBordered(
            controller: equityController,
            prefix: const Text('%'),
            suffix: InkWell(
              onTap: () {
                setState(() {
                  saleOffer.tokensAmount =
                      widget.member.lamportsEarned! / LAMPORTS_IN_SOL;
                });
                amountController.text = saleOffer.tokensAmount.toString();
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
          const SizedBox(height: 30),
          const Text(
            'Price',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          AppTextFormFieldBordered(
            prefix: const Text('\$'),
            validator: multiValidate([
              requiredField('Price'),
              numberField('Price'),
            ]),
            onChanged: (value) {
              saleOffer.price = double.tryParse(value);
            },
          ),
        ],
      ),
    );
  }

  handleNextPressed() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final response = await offersApi.createSaleOffer(
        amount: saleOffer.tokensAmount!,
        price: saleOffer.price!,
        orgId: widget.organization.id!,
        userId: (await authApi.userId)!,
      );
      final newSaleOffer = SaleOffer.fromJson(response.data!);
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SaleOfferPreviewScreen(
              saleOffer: newSaleOffer,
            ),
          ),
        );
      }
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Number of iShares and Price',
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Enter number of Impact Shares and the price',
                  style:
                      TextStyle(color: COLOR_GRAY, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),
                buildForm(context),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 290,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleNextPressed,
                child: isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
