import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/components/investment_progress.dart';
import 'package:iw_app/widgets/components/url_qr_code.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';
import 'package:iw_app/widgets/state/config.dart';

class OfferPreviewScreen extends StatefulWidget {
  final Organization organization;
  final OrganizationMember? member;
  final Offer offer;

  const OfferPreviewScreen({
    Key? key,
    required this.organization,
    required this.offer,
    this.member,
  }) : super(key: key);

  @override
  State<OfferPreviewScreen> createState() => _OfferPreviewScreenState();
}

class _OfferPreviewScreenState extends State<OfferPreviewScreen> {
  bool isLoading = false;
  late Offer offer;

  String get offerUrl {
    return 'app.equitywallet.org/offer?i=${offer.id}&oi=${widget.organization.id}';
  }

  bool get isInvestor {
    return offer.type == OfferType.Investor;
  }

  double get raisingAmount {
    return offer.investorSettings?.amount ?? 0;
  }

  double get equityAllocation {
    return offer.investorSettings?.equity ?? 0;
  }

  bool get isNewOffer {
    return offer.id == null;
  }

  @override
  initState() {
    super.initState();
    offer = widget.offer;
  }

  buildOrganizationSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
              imageUrl: '${orgsApi.baseUrl}${widget.organization.logo!}',
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isInvestor ? 'Invest to' : 'From',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: COLOR_GRAY,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.organization.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                '@${widget.organization.username}',
                style: const TextStyle(color: COLOR_GRAY),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildInvestorDetails(BuildContext context) {
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
                          '\$${NumberFormat("#,###").format(raisingAmount)}',
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
                          '$equityAllocation%',
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
        const SizedBox(
          height: 10,
        ),
        InvestmentProgressWidget(
          progress: offer.availableInvestment!.amount! /
              offer.investorSettings!.amount!,
          invested: offer.availableInvestment!.amount!,
          investors: offer.memberProspects?.length ?? 0,
        ),
      ],
    );
  }

  buildMemberDetailsPro(BuildContext context, OrganizationMember member) {
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
                '${member.role?.name}',
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
                '${member.occupation}',
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
                '${member.impactRatio}x',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (member.compensation != null)
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
                      '\$${member.compensation?.amount}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          if (member.isAutoContributing!)
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
                      '${member.hoursPerWeek} hours / week',
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

  buildMemberDetailsLite(BuildContext context, OrganizationMember member) {
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
                '${member.role?.name}',
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
                '${member.occupation}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (member.equity != null)
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
                      '${member.equity?.amount}%',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                if (member.equity?.type == EquityType.DuringPeriod)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Period to get equity'),
                      Text(
                        '${member.equity?.period?.value} ${member.equity?.period?.timeframe?.name.toLowerCase()}',
                      ),
                    ],
                  ),
              ],
            ),
          if (member.compensation != null)
            Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      member.compensation?.type == CompensationType.PerMonth
                          ? 'Paycheck per month'
                          : 'One-time payment',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$${member.compensation?.amount}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                if (member.compensation?.type == CompensationType.OneTime)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Period to get payment'),
                      Text(
                        '${member.compensation?.period?.value} ${member.compensation?.period?.timeframe?.name.toLowerCase()}',
                      ),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }

  buildMemberDetails(BuildContext context) {
    Config config = ConfigState.of(context).config;
    final member = widget.member;
    if (config.mode == Mode.Pro && member != null) {
      return buildMemberDetailsPro(context, member);
    } else if (config.mode == Mode.Lite && member != null) {
      return buildMemberDetailsLite(context, member);
    }
  }

  handleCreatePressed() async {
    setState(() {
      isLoading = true;
    });
    Config config = ConfigState.of(context).config;
    try {
      final response = await orgsApi.createOffer(
        widget.organization.id!,
        config.mode == Mode.Lite,
        offer,
        member: widget.member,
      );
      setState(() {
        offer = Offer.fromJson(response.data);
      });
    } on DioError catch (err) {
      final equityError = err.response?.data['equityAllocation'];
      if (equityError != null && context.mounted) {
        Navigator.of(context).pop(equityError);
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

  handleCopyPressed() async {
    Clipboard.setData(ClipboardData(text: offerUrl));
    callSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: isInvestor ? 'Investment Proposal Preview' : 'Offer Preview',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: KeyboardDismissableListView(
              children: [
                buildOrganizationSection(context),
                const SizedBox(height: 20),
                const Divider(
                  color: COLOR_LIGHT_GRAY2,
                  height: 1,
                ),
                const SizedBox(height: 20),
                if (isInvestor)
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
                if (isInvestor)
                  const Column(
                    children: [
                      Text(
                        'You are invited to join this Impact Organization under the following conditions.',
                        style: TextStyle(color: COLOR_GRAY),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                if (!isInvestor) buildMemberDetails(context),
                if (isInvestor) buildInvestorDetails(context),
                if (!isNewOffer)
                  Column(
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        isInvestor
                            ? 'This Investment Proposal is available by the link below. Send it to the right person.'
                            : 'This Offer is available by the link below. Send it to the person you want to invite to the organization.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: COLOR_CORAL,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        offerUrl,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: COLOR_GRAY),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: 290,
                        child: ElevatedButton(
                          onPressed: handleCopyPressed,
                          child: const Text('Copy Link to this Offer'),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: QRCodeWidget(
                              url: offerUrl,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 25),
              ],
            ),
          ),
          if (isNewOffer)
            Align(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 290,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleCreatePressed,
                    child: isLoading
                        ? const CircularProgressIndicator.adaptive()
                        : Text(
                            'Create ${isInvestor ? 'Investment Proposal' : 'Offer'}',
                          ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
