import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/payment_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/buttons/secondary_button.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
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
  Future<Offer?>? futureOffer;
  Payment? payment;

  @override
  initState() {
    futureOffer = fetchOffer();
    super.initState();
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            child: NetworkImageAuth(
              imageUrl: '${orgsApi.baseUrl}${offer.org.logo!}',
            ),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offer.memberProspect!.role == MemberRole.Investor
                  ? 'Invest to'
                  : 'From',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: COLOR_GRAY,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              '${offer.org.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              '@${offer.org.username}',
              style: const TextStyle(color: COLOR_GRAY),
            ),
          ],
        ),
      ],
    );
  }

  buildInvestorDetails(BuildContext context, Offer offer) {
    return Container(
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
                      '\$${offer.memberProspect!.investorSettings!.investmentAmount}',
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
                      '${offer.memberProspect!.investorSettings!.equityAllocation}%',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildMemberDetails(BuildContext context, Offer offer) {
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
                offer.memberProspect!.role!.name,
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
                offer.memberProspect!.occupation!,
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
                '${offer.memberProspect!.impactRatio}x',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (offer.memberProspect!.isMonthlyCompensated!)
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
                      '\$${offer.memberProspect!.monthlyCompensation}',
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

  Future<void> openPaymentLink(String link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  handlePressed(Offer offer, String status) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await orgsApi.acceptDeclineOffer(
        offer.org.id,
        offer.id!,
        status,
      );
      if (offer.memberProspect!.role == MemberRole.Investor) {
        setState(() {
          payment = Payment.fromJson(response.data!);
        });
        openPaymentLink(payment!.cpPaymentUrl!);
      }
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        isLoading = false;
      });
      if (offer.memberProspect!.role != MemberRole.Investor &&
          context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
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
        content: Text(AppLocalizations.of(context)!.common_link_copied,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white)),
        duration: const Duration(milliseconds: 300),
        backgroundColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  handleCopyPressed(BuildContext context) {
    Clipboard.setData(ClipboardData(text: payment!.cpPaymentUrl));
    callSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Offer Preview',
      child: FutureBuilder(
          future: futureOffer,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      buildOrganizationSection(context, snapshot.data!),
                      const SizedBox(height: 20),
                      const Divider(
                        color: COLOR_LIGHT_GRAY2,
                        height: 1,
                      ),
                      const SizedBox(height: 20),
                      if (snapshot.data!.memberProspect!.role !=
                          MemberRole.Investor)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'assets/icons/terms_icon.svg',
                              width: 20,
                              height: 20,
                            ),
                            label: const Text('View Terms',
                                style: TextStyle(fontSize: 16)),
                            style: TextButton.styleFrom(
                              iconColor: COLOR_BLUE,
                              foregroundColor: COLOR_BLUE,
                            ),
                          ),
                        ),
                      const SizedBox(height: 17),
                      if (snapshot.data!.memberProspect!.role !=
                          MemberRole.Investor)
                        const Text(
                          'You are invited to join this Impact Organization under the  following conditions.',
                          style: TextStyle(color: COLOR_GRAY),
                        ),
                      const SizedBox(height: 25),
                      if (snapshot.data!.memberProspect!.role ==
                          MemberRole.Investor)
                        buildInvestorDetails(context, snapshot.data!),
                      if (snapshot.data!.memberProspect!.role !=
                          MemberRole.Investor)
                        buildMemberDetails(context, snapshot.data!),
                    ],
                  ),
                ),
                if (payment != null)
                  Row(children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(right: 13.0),
                        child: Text(
                          payment!.cpPaymentUrl!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      label: const Text('Copy'),
                      icon: const Icon(Icons.copy, size: 12),
                      onPressed: () => handleCopyPressed(context),
                    )
                  ]),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: isLoading
                        ? const CircularProgressIndicator.adaptive()
                        : SizedBox(
                            width: 290,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (snapshot.data!.memberProspect!.role !=
                                    MemberRole.Investor)
                                  SecondaryButton(
                                    onPressed: () => handlePressed(
                                        snapshot.data!, 'declined'),
                                    child: const Text('Decline Offer'),
                                  ),
                                const SizedBox(height: 10),
                                if (payment == null)
                                  ElevatedButton(
                                    onPressed: () => handlePressed(
                                        snapshot.data!, 'accepted'),
                                    child: Text(
                                      snapshot.data!.memberProspect!.role ==
                                              MemberRole.Investor
                                          ? 'Invest'
                                          : 'Accept Offer',
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
