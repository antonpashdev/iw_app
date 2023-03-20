import 'package:flutter/material.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';
import 'package:iw_app/theme/app_theme.dart';

class AssetsListTile extends StatelessWidget {
  final double padding = 6;
  final Widget? leading;
  final String name;
  final String account;
  final String tokensAmount;
  final String equity;

  const AssetsListTile({
    Key? key,
    this.leading,
    required this.name,
    required this.account,
    required this.tokensAmount,
    required this.equity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: leading,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          account,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: COLOR_GRAY),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'iShares',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: COLOR_GRAY),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              tokensAmount,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .homeScreen_assetsExampleEquity,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: COLOR_GRAY),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              equity,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: COLOR_GREEN,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
