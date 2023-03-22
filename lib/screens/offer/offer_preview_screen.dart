import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class OfferPreviewScreen extends StatelessWidget {
  final Organization organization;

  const OfferPreviewScreen({Key? key, required this.organization})
      : super(key: key);

  buildOrganizationSection(BuildContext context) {
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
            child: Image.memory(organization.logo!),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('From',
                style: TextStyle(
                    color: COLOR_GRAY,
                    fontWeight: FontWeight.w500,
                    fontSize: 12)),
            const SizedBox(height: 10),
            Text(
              organization.name!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '@${organization.username}',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: COLOR_GRAY,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Offer Preview',
        child: Column(children: [
          buildOrganizationSection(context),
          const SizedBox(height: 20),
          const Divider(
            color: COLOR_LIGHT_GRAY2,
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/terms_icon.svg',
                  width: 20,
                  height: 20,
                ),
                label: const Text('View Terms', style: TextStyle(fontSize: 16)),
                style: TextButton.styleFrom(
                  iconColor: COLOR_BLUE,
                  foregroundColor: COLOR_BLUE,
                ),
              )
            ],
          ),
          const SizedBox(height: 17),
          const Text(
            'You are invited to join this Impact Organization under the  following conditions.',
            style: TextStyle(color: COLOR_GRAY),
          ),
          const SizedBox(height: 25),
        ]));
  }
}
