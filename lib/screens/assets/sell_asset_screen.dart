import 'package:flutter/material.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/offers_api.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/sale_offer_model.dart';
import 'package:iw_app/screens/offer/sale_offer_preview_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/debounce.dart';
import 'package:iw_app/utils/validation.dart';
import 'package:iw_app/widgets/form/input_form.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/widgets/state/config.dart';

const LAMPORTS_IN_SOL = 1000000000;
final _debouncer = Debouncer(duration: const Duration(milliseconds: 1000));

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
    final equity =
        ((saleOffer.tokensAmount! * LAMPORTS_IN_SOL) / lamportsMinted! * 100)
            .toStringAsFixed(1);
    return equity;
  }

  buildForm(BuildContext context) {
    Config config = ConfigState.of(context).config;
    return InputForm(
      formKey: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (config.mode == Mode.Pro)
            Column(
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
                    max(widget.member.lamportsEarned! / LAMPORTS_IN_SOL),
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
              ],
            ),
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
              if (config.mode == Mode.Pro) {
                equityController.text = equity ?? '';
              } else {
                saleOffer.tokensAmount = double.tryParse(value);
              }
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
    Config config = ConfigState.of(context).config;
    return ScreenScaffold(
      title: config.mode == Mode.Lite
          ? 'Percent of Equity'
          : 'Number of iShares and Price',
      child: Column(
        children: [
          Expanded(
            child: KeyboardDismissableListView(
              children: [
                const SizedBox(height: 10),
                Text(
                  config.mode == Mode.Lite
                      ? 'Enter percent of equity you would like to sell'
                      : 'Enter number of Impact Shares and the price',
                  style: const TextStyle(
                    color: COLOR_GRAY,
                    fontWeight: FontWeight.w500,
                  ),
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
