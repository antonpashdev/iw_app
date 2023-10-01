import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/txn_history_item_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/utils/datetime.dart';
import 'package:iw_app/utils/numbers.dart';
import 'package:iw_app/widgets/list/generic_list_tile.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';

const LAMPORTS_PER_USDC = 1000000;

buildHistoryItem(
  BuildContext context,
  TxnHistoryItem item,
  TxnHistoryItem? prevItem,
) {
  final sign = item.amount != null && item.amount! < 0 ? '-' : '+';
  final color = item.amount != null && item.amount! < 0
      ? COLOR_ALMOST_BLACK
      : COLOR_GREEN;
  final amount = item.amount != null
      ? '$sign \$${trimZeros(item.amount!.abs() / LAMPORTS_PER_USDC)} Credit\$'
      : '-';
  final title = item.addressOrUsername == null
      ? ''
      : item.addressOrUsername!.length == 44
          ? item.addressOrUsername!.replaceRange(4, 40, '...')
          : item.addressOrUsername!;
  final icon = Icon(
    item.amount != null && item.amount! < 0
        ? Icons.arrow_outward_rounded
        : Icons.arrow_downward_rounded,
    size: 12,
    color: COLOR_WHITE,
  );
  final primaryColor =
      item.amount != null && item.amount! < 0 ? COLOR_ALMOST_BLACK : COLOR_BLUE;
  final processedAt = item.processedAt != null
      ? DateTime.fromMillisecondsSinceEpoch(item.processedAt!)
      : DateTime.now();
  final processedAtStr = getFormattedDate(processedAt);
  bool shouldDisplayDate = true;
  if (prevItem != null) {
    final prevProcessedAt = prevItem.processedAt != null
        ? DateTime.fromMillisecondsSinceEpoch(prevItem.processedAt!)
        : DateTime.now();
    final prevProcessedAtStr = getFormattedDate(prevProcessedAt);
    shouldDisplayDate = prevProcessedAtStr != processedAtStr;
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (shouldDisplayDate)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              processedAtStr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: COLOR_GRAY,
                  ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      GenericListTile(
        title: title,
        subtitle: item.description,
        image: item.img != null && item.img!.isNotEmpty
            ? NetworkImageAuth(imageUrl: '${usersApi.baseUrl}${item.img}')
            : Image.asset('assets/images/avatar_placeholder.png'),
        trailing: Text(
          amount,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
              ),
        ),
        icon: icon,
        primaryColor: primaryColor,
      ),
    ],
  );
}
