import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/config_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/state/config.dart';

buildMember(BuildContext context, OrganizationMemberWithEquity data) {
  Config config = ConfigState.of(context).config;
  return SizedBox(
    width: 100,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xffe2e2e8),
                borderRadius: BorderRadius.circular(30),
              ),
              clipBehavior: Clip.antiAlias,
              child: FittedBox(
                fit: BoxFit.cover,
                child: data.member!.image != null
                    ? FutureBuilder(
                        future: usersApi.getAvatar(data.member!.image!),
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) return Container();
                          return Image.memory(snapshot.data!);
                        },
                      )
                    : Container(),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              data.member!.username!,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        if (config.mode == Mode.Pro || data.member!.equity != null)
          FutureBuilder(
            future: config.mode == Mode.Pro
                ? data.futureEquity
                : Future.value(MemberEquity()),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return Positioned(
                top: -5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: COLOR_ALMOST_BLACK,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    config.mode == Mode.Pro
                        ? '${(snapshot.data!.equity! * 100).toStringAsFixed(1)}%'
                        : '${data.member!.equity!.amount!.toStringAsFixed(1)}%',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: COLOR_WHITE),
                  ),
                ),
              );
            },
          ),
      ],
    ),
  );
}
