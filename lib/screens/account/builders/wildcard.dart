import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/numbers.dart';
import 'package:iw_app/widgets/utils/app_padding.dart';

buildIWCard(BuildContext context, Future<double> futureBalance) {
  return AppPadding(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 330),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 125,
                    height: 85,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.asset(
                        'assets/images/iw_card.png',
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      FutureBuilder(
                        future: futureBalance,
                        builder: (_, snapshot) {
                          double amount = 0;
                          if (snapshot.hasData) {
                            amount = snapshot.data!;
                          }
                          return Text(
                            '\$${trimZeros(amount)}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          );
                        },
                      ),
                      Text(
                        'DePlan Card',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: COLOR_GRAY),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: COLOR_LIGHT_GRAY.withAlpha(150),
                ),
              ),
            ),
            Positioned(
              bottom: 25,
              left: 155,
              child: Text(
                'Coming Soon...',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: COLOR_BLUE, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
