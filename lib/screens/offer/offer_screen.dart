import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/app_home.dart';
import 'package:iw_app/app_storage.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/account_model.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/payment_model.dart';
import 'package:iw_app/screens/offer/offer_investor_invest_amount_screen.dart';
import 'package:iw_app/screens/organization/org_details/org_details_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/buttons/secondary_button.dart';
import 'package:iw_app/widgets/components/investment_progress.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/widgets/state/config.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferScreen extends StatefulWidget {
  static String routeName = '/offer';

  final String orgId;
  final String offerId;

  const OfferScreen({
    Key? key,
    required this.orgId,
    required this.offerId,
  }) : super(key: key);

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  bool isLoading = false;
  Payment? payment;
  String? offerError;
  late Future<Offer?> futureOffer;
  late Future<Account?> futureAccount;

  @override
  initState() {
    futureOffer = fetchOffer();
    futureAccount = fetchAccount();
    super.initState();
  }

  Future<Account?> fetchAccount() async {
    try {
      final response = await authApi.getMe();
      return Account.fromJson(response.data);
    } on DioError catch (err) {
      if (err.response?.statusCode == 401) {
        await appStorage.write(
          'redirect_to',
          '/offer?i=${widget.offerId}&oi=${widget.orgId}',
        );
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppHome.routeName,
            (route) => false,
          );
        }
      }
      rethrow;
    } catch (err) {
      print(err);
    }
    return null;
  }

  Future<Offer?> fetchOffer() async {
    try {
      final response = await orgsApi.getOfferById(widget.orgId, widget.offerId);
      return Offer.fromJson(response.data);
    } catch (err) {
      print(err);
    }
    return null;
  }

  buildOrganizationSection(BuildContext context, Offer offer) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrgDetailsScreen(
              orgId: widget.orgId,
              isPreviewMode: true,
            ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: COLOR_GRAY,
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Hero(
                tag: 'org-logo-${offer.org.id}',
                child: NetworkImageAuth(
                  imageUrl: '${orgsApi.baseUrl}${offer.org.logo!}',
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.type == OfferType.Investor ? 'Invest to' : 'From',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: COLOR_GRAY,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${offer.org.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '@${offer.org.username}',
                  style: const TextStyle(color: COLOR_GRAY),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: COLOR_ALMOST_BLACK,
          ),
        ],
      ),
    );
  }

  buildInvestorDetails(BuildContext context, Offer offer) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: COLOR_LIGHT_GRAY,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Offer for Investors',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const Divider(
                color: COLOR_LIGHT_GRAY2,
                height: 1,
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Hi,\n\nWe invite you to invest in our organization on following conditions',
                ),
              ),
              const Divider(
                color: COLOR_LIGHT_GRAY2,
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Raising Sum',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '\$${NumberFormat('#,###').format(offer.investorSettings!.amount)}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Equity Allocation',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${offer.investorSettings!.equity}%',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Minimal Investment',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '\$${NumberFormat("#,###").format(offer.investorSettings!.minimalInvestment)}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        InvestmentProgressWidget(
          progress: offer.availableInvestment!.amount! /
              offer.investorSettings!.amount!,
          invested: offer.availableInvestment!.amount!,
          investors: offer.memberProspects?.length ?? 0,
        ),
      ],
    );
  }

  buildMemberDetailsPro(BuildContext context, Offer offer) {
    final memberProspect = offer.memberProspects!.first;
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: COLOR_LIGHT_GRAY,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Role',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                memberProspect.role!.name,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 26),
          const Divider(
            color: COLOR_LIGHT_GRAY2,
            height: 1,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Occupation',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                memberProspect.occupation!,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Impact Ratio',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '${memberProspect.impactRatio}x',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (memberProspect.compensation != null)
            Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Monthly Compensation',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$${memberProspect.compensation?.amount}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          if (memberProspect.isAutoContributing!)
            Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Auto Contribution',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${memberProspect.hoursPerWeek} hours / week',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  buildMemberDetailsLite(BuildContext context, Offer offer) {
    final memberProspect = offer.memberProspects!.first;
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: COLOR_LIGHT_GRAY,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Role',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '${memberProspect.role?.name}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 26),
          const Divider(
            color: COLOR_LIGHT_GRAY2,
            height: 1,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Occupation',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '${memberProspect.occupation}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (memberProspect.equityAmount != null)
            Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Equity',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${memberProspect.equityAmount}%',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                if (memberProspect.equityType == EquityType.DuringPeriod)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Period to get equity'),
                      Text(
                        '${memberProspect.equityPeriod?.value} ${memberProspect.equityPeriod?.timeframe?.name.toLowerCase()}',
                      ),
                    ],
                  ),
              ],
            ),
          if (memberProspect.compensation != null)
            Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      memberProspect.compensation?.type ==
                              CompensationType.PerMonth
                          ? 'Paycheck per month'
                          : 'One-time payment',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$${memberProspect.compensation?.amount}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                if (memberProspect.compensation?.type ==
                    CompensationType.OneTime)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Period to get payment'),
                      Text(
                        '${memberProspect.compensation?.period?.value} ${memberProspect.compensation?.period?.timeframe?.name.toLowerCase()}',
                      ),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }

  buildMemberDetails(BuildContext context, Offer offer) {
    Config config = ConfigState.of(context).config;
    if (config.mode == Mode.Pro) {
      return buildMemberDetailsPro(context, offer);
    } else {
      return buildMemberDetailsLite(context, offer);
    }
  }

  Future<void> openPaymentLink(String link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  acceptDeclineOffer(Offer offer, String status) async {
    if (offer.type == OfferType.Investor) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OfferInvestorInvestAmount(
            offer: offer,
            maxEquity: offer.investorSettings!.equity!,
            maxInvestment: offer.investorSettings!.amount!,
          ),
        ),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    Config config = ConfigState.of(context).config;
    try {
      await orgsApi.acceptDeclineOffer(
        offer.org.id,
        offer.id!,
        status,
        config.mode == Mode.Lite,
      );
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } on DioError catch (err) {
      final message = err.response!.data['message'];
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: COLOR_RED,
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

  callSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 70,
          left: 20,
          right: 20,
        ),
        content: Text(
          AppLocalizations.of(context)!.common_link_copied,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(milliseconds: 300),
        backgroundColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  handleCopyPressed(BuildContext context) {
    Clipboard.setData(ClipboardData(text: payment!.cpPaymentUrl!));
    callSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Offer Preview',
      child: FutureBuilder(
        future: Future.wait([
          futureOffer,
          futureAccount,
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final offer = snapshot.data![0] as Offer;
          final account = snapshot.data![1] as Account;
          bool isInvestmentComplete = false;
          if (offer.type == OfferType.Investor) {
            isInvestmentComplete = offer.availableInvestment!.amount! /
                    offer.investorSettings!.amount! >=
                1;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: KeyboardDismissableListView(
                  children: [
                    buildOrganizationSection(context, offer),
                    const SizedBox(height: 20),
                    const Divider(
                      color: COLOR_LIGHT_GRAY2,
                      height: 1,
                    ),
                    const SizedBox(height: 20),
                    if (offer.type != OfferType.Investor)
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                'assets/icons/terms_icon.svg',
                                width: 20,
                                height: 20,
                              ),
                              label: const Text(
                                'View Terms',
                                style: TextStyle(fontSize: 16),
                              ),
                              style: TextButton.styleFrom(
                                iconColor: COLOR_BLUE,
                                foregroundColor: COLOR_BLUE,
                              ),
                            ),
                          ),
                          const SizedBox(height: 17),
                        ],
                      ),
                    if (offer.type != OfferType.Investor)
                      const Column(
                        children: [
                          Text(
                            'You are invited to join this Impact Organization under the following conditions.',
                            style: TextStyle(color: COLOR_GRAY),
                          ),
                          SizedBox(height: 25),
                        ],
                      ),
                    if (offer.type == OfferType.Investor)
                      buildInvestorDetails(context, offer),
                    if (offer.type != OfferType.Investor)
                      buildMemberDetails(context, offer),
                  ],
                ),
              ),
              if (payment != null)
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(right: 13.0),
                        child: TextButton.icon(
                          onPressed: () async {
                            final url = Uri.parse(payment!.cpPaymentUrl!);
                            if (!(await launchUrl(url))) {
                              throw Exception('Could not launch $url');
                            }
                          },
                          icon: const Icon(Icons.link),
                          label: Text(
                            payment!.cpPaymentUrl!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          style: TextButton.styleFrom(
                            iconColor: COLOR_BLUE,
                            foregroundColor: COLOR_BLUE,
                          ),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      label: const Text('Copy'),
                      icon: const Icon(Icons.copy, size: 12),
                      onPressed: () => handleCopyPressed(context),
                    )
                  ],
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (offer.type != OfferType.Investor)
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 290),
                      child: SecondaryButton(
                        onPressed: () => acceptDeclineOffer(offer, 'declined'),
                        child: const Text('Decline Offer'),
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (payment == null)
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 290),
                      child: ElevatedButton(
                        onPressed: isLoading || isInvestmentComplete
                            ? null
                            : () => acceptDeclineOffer(offer, 'accepted'),
                        child: isLoading
                            ? const CircularProgressIndicator.adaptive()
                            : Text(
                                offer.type == OfferType.Investor
                                    ? 'Invest as @${account.username}'
                                    : 'Accept Offer as @${account.username}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
