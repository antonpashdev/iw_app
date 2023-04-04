import 'package:flutter/material.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/contribution_model.dart';
import 'package:iw_app/screens/home_screen.dart';
import 'package:iw_app/theme/app_theme.dart';

const LAMPORTS_IN_SOL = 1000000000;
RegExp trimZeroesRegExp = RegExp(r'([.]*0+)(?!.*\d)');

class ContributionDetailsScreen extends StatelessWidget {
  final Contribution contribution;

  const ContributionDetailsScreen({Key? key, required this.contribution})
      : super(key: key);

  Duration get diffDuration {
    final startDate = DateTime.parse(contribution.createdAt!);
    final stopDate = DateTime.parse(contribution.stoppedAt!);
    return stopDate.difference(startDate);
  }

  buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: COLOR_GRAY,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: FittedBox(
            fit: BoxFit.cover,
            child: FutureBuilder(
              future: orgsApi.getLogo(contribution.org.logo),
              builder: (_, snapshot) {
                if (!snapshot.hasData) return Container();
                return Image.memory(snapshot.data!);
              },
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'to',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: COLOR_GRAY),
              ),
              Text(
                contribution.org.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '@${contribution.org.username}',
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

  buildSharesResult(BuildContext context) {
    final h = (diffDuration.inMilliseconds / 1000 / 60 / 60)
        .toStringAsFixed(4)
        .replaceAll(trimZeroesRegExp, '');
    final tokensAmount = (contribution.lamportsEarned! / LAMPORTS_IN_SOL)
        .toStringAsFixed(4)
        .replaceAll(trimZeroesRegExp, '');

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Text(
                  '${h}h',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Contribution',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.w300,
                      color: COLOR_GRAY,
                    ),
              ),
            ],
          ),
          Text(
            '×',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Text(
                  contribution.impactRatio.toString(),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Ratio',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.w300,
                      color: COLOR_GRAY,
                    ),
              ),
            ],
          ),
          Text(
            '=',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: COLOR_ALMOST_BLACK,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  tokensAmount,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: COLOR_WHITE,
                      ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Impact Shares',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.w300,
                      color: COLOR_GRAY,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildDuration(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String h = twoDigits(diffDuration.inHours.remainder(60));
    String m = twoDigits(diffDuration.inMinutes.remainder(60));
    return Text(
      '${h}h : ${m}m',
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontFamily: 'Gilroy',
            fontSize: 36,
          ),
    );
  }

  buildMainSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          'assets/images/party_popper.png',
          width: 96,
          height: 96,
        ),
        Text(
          'Congratulations!\nYou’ve just earned your Impact Shares!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        buildSharesResult(context),
        buildDuration(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          title: const Text('Contribution'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              buildHeader(context),
              Expanded(
                child: Center(
                  child: buildMainSection(context),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Done'),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
