import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/buttons/secondary_button.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

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
            child: Image.memory(offer.org.logo!),
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

  handlePressed(Offer offer, String status) async {
    setState(() {
      isLoading = true;
    });

    try {
      await orgsApi.acceptDeclineOffer(
        offer.org.id,
        offer.id!,
        (await authApi.userId)!,
        status,
      );
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        isLoading = false;
      });
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
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
                      buildMemberDetails(context, snapshot.data!),
                    ],
                  ),
                ),
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
                                SecondaryButton(
                                  onPressed: () =>
                                      handlePressed(snapshot.data!, 'declined'),
                                  child: const Text('Decline Offer'),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () =>
                                      handlePressed(snapshot.data!, 'accepted'),
                                  child: const Text('Accept Offer'),
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
