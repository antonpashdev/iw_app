import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/screens/create_org_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/list/assets_list_tile.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> organizations = [];

  Widget buildCallToCreateCard(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.6,
          child: Card(
            margin: const EdgeInsets.all(0),
            color: COLOR_LIGHT_GRAY,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CreateOrgScreen()));
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: COLOR_LIGHT_GRAY2,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: const Icon(
                        CupertinoIcons.add,
                        size: 30,
                        color: COLOR_ALMOST_BLACK,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!
                          .homeScreen_createNewOrgTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 35),
                    // ignore: prefer_const_constructors
                    Text(
                      AppLocalizations.of(context)!.homeScreen_createNewOrgDesc,
                      style: const TextStyle(color: COLOR_GRAY),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildOrganizationCard(BuildContext context, int index) {}

  buildAssetExample() {
    return AssetsListTile(
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: COLOR_LIGHT_GRAY2,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      name: AppLocalizations.of(context)!.homeScreen_assetsExampleTitle,
      account: '@orgs_account',
      tokensAmount: '-',
      equity: '-',
    );
  }

  @override
  Widget build(BuildContext context) {
    final organizationsCards = organizations.isEmpty
        ? buildCallToCreateCard(context)
        : ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...organizations
                  .asMap()
                  .map(
                    (i, organization) =>
                        MapEntry(i, buildOrganizationCard(context, i)),
                  )
                  .values
                  .toList(),
            ],
          );

    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: COLOR_GRAY,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 10),
              const Text('@my_account'),
            ],
          ),
          centerTitle: false,
          titleTextStyle: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            AppPadding(
              child: Text(
                '\$0.00',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 45),
            AppPadding(
              child: Text(
                AppLocalizations.of(context)!.homeScreen_organizationsTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 290,
              child: organizationsCards,
            ),
            const SizedBox(height: 45),
            AppPadding(
              child: Text(
                AppLocalizations.of(context)!.homeScreen_assetsTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 15),
            AppPadding(
              child: buildAssetExample(),
            ),
            if (organizations.isEmpty)
              AppPadding(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    SvgPicture.asset('assets/icons/arrow_up_big.svg'),
                    const SizedBox(height: 15),
                    Text(
                      AppLocalizations.of(context)!
                          .homeScreen_assetsExampleDesc,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
