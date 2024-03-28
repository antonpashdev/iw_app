import 'package:flutter/material.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

buildDetails(BuildContext context, Organization org) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        org.name!,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      if (org.link != null && org.link!.isNotEmpty)
        Column(
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(org.link!);
                    if (!(await launchUrl(url))) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  icon: const Icon(Icons.link),
                  label: Text(org.link!),
                  style: TextButton.styleFrom(
                    iconColor: COLOR_BLUE,
                    foregroundColor: COLOR_BLUE,
                  ),
                ),
              ],
            ),
          ],
        ),
      if (org.description != null && org.description!.isNotEmpty)
        Column(
          children: [
            const SizedBox(height: 20),
            Text(
              org.description!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
    ],
  );
}
