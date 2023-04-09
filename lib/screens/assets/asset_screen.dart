import 'package:flutter/material.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/screens/assets/sell_asset_screen.dart';
import 'package:iw_app/screens/assets/send/receiver_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

const LAMPORTS_IN_SOL = 1000000000;
RegExp trimZeroesRegExp = RegExp(r'([.]*0+)(?!.*\d)');

class AssetScreen extends StatelessWidget {
  final OrganizationMemberWithEquity memberWithEquity;

  const AssetScreen({super.key, required this.memberWithEquity});

  buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: COLOR_GRAY,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: FittedBox(
            fit: BoxFit.cover,
            child: NetworkImageAuth(
              imageUrl:
                  '${orgsApi.baseUrl}${memberWithEquity.member!.org.logo!}',
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${memberWithEquity.member!.org.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '@${memberWithEquity.member!.org.username}',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: COLOR_GRAY,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildAmount(BuildContext context, String amount, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Impact Shares',
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            amount,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  buildAmounts(BuildContext context) {
    final tokensAmount =
        (memberWithEquity.equity!.lamportsEarned! / LAMPORTS_IN_SOL)
            .toStringAsFixed(4)
            .replaceAll(trimZeroesRegExp, '');
    final equity = (memberWithEquity.equity!.equity! * 100).toStringAsFixed(1);
    return Row(
      children: [
        Expanded(
          child: buildAmount(
            context,
            tokensAmount,
            COLOR_BLUE,
            COLOR_LIGHT_GRAY,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: buildAmount(
            context,
            '$equity%',
            COLOR_GREEN,
            const Color(0xffb2e789).withAlpha(100),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Asset',
      child: Column(
        children: [
          const SizedBox(height: 20),
          buildHeader(context),
          const SizedBox(height: 20),
          buildAmounts(context),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: memberWithEquity.equity!.lamportsEarned == 0
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ReceiverScreen(
                                      memberWithEquity: memberWithEquity)));
                        },
                  child: const Text('Send Asset'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: memberWithEquity.equity!.lamportsEarned == 0
                      ? null
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => SellAssetScreen(
                                    organization: memberWithEquity.member!.org,
                                    member: memberWithEquity.member!,
                                  )));
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: COLOR_BLUE,
                  ),
                  child: const Text('Sell Asset'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
