import 'package:flutter/material.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/theme/app_theme.dart';

import '../../../../widgets/media/network_image_auth.dart';

buildHeader(BuildContext context, Organization organization) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: FittedBox(
          fit: BoxFit.cover,
          child: NetworkImageAuth(
            imageUrl: '${orgsApi.baseUrl}${organization.logo}',
          ),
        ),
      ),
      const SizedBox(width: 15),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${organization.name}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 5),
            if (organization.link != null)
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.link),
                label: Text(organization.link!),
                style: TextButton.styleFrom(
                  iconColor: COLOR_BLUE,
                  foregroundColor: COLOR_BLUE,
                ),
              ),
          ],
        ),
      ),
    ],
  );
}
