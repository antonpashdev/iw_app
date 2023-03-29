import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class OfferPreviewScreen extends StatefulWidget {
  final Organization organization;
  final OrganizationMember member;

  const OfferPreviewScreen({
    Key? key,
    required this.organization,
    required this.member,
  }) : super(key: key);

  @override
  State<OfferPreviewScreen> createState() => _OfferPreviewScreenState();
}

class _OfferPreviewScreenState extends State<OfferPreviewScreen> {
  bool isLoading = false;
  Offer? offer;

  buildOrganizationSection(BuildContext context) {
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
              imageUrl: '${orgsApi.baseUrl}${widget.organization.logo!}',
            ),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: COLOR_GRAY,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              '${widget.organization.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              '@${widget.organization.username}',
              style: const TextStyle(color: COLOR_GRAY),
            ),
          ],
        ),
      ],
    );
  }

  buildMemberDetails(BuildContext context) {
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
                '${widget.member.role?.name}',
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
                '${widget.member.occupation}',
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
                '${widget.member.impactRatio}x',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (widget.member.isMonthlyCompensated!)
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
                      '\$${widget.member.monthlyCompensation}',
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

  handleCreatePressed() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await orgsApi.createOffer(
        widget.organization.id!,
        widget.member,
      );
      setState(() {
        offer = Offer.fromJson(response.data);
      });
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

  handleCopyPressed() async {
    Clipboard.setData(ClipboardData(
        text:
            'app.impactwallet.xyz/offer?i=${offer!.id}&oi=${widget.organization.id}'));
    callSnackBar(context);

    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Offer Preview',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: [
                buildOrganizationSection(context),
                const SizedBox(height: 20),
                const Divider(
                  color: COLOR_LIGHT_GRAY2,
                  height: 1,
                ),
                const SizedBox(height: 20),
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
                const Text(
                  'You are invited to join this Impact Organization under the  following conditions.',
                  style: TextStyle(color: COLOR_GRAY),
                ),
                const SizedBox(height: 25),
                buildMemberDetails(context),
                if (offer != null)
                  Column(
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'This Offer is available by the link below. Send it to the person you want to invite to the organization.',
                        style: TextStyle(
                          color: COLOR_CORAL,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'app.impactwallet.xyz/offer?i=${offer!.id}&oi=${widget.organization.id}',
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
                    ],
                  ),
              ],
            ),
          ),
          if (offer == null)
            Align(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 290,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleCreatePressed,
                    child: isLoading
                        ? const CircularProgressIndicator.adaptive()
                        : const Text('Create Offer'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
