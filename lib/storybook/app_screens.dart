import 'package:iw_app/models/offer_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/models/user_model.dart';
import 'package:iw_app/screens/offer/offer_preview_screen.dart';
import 'package:iw_app/screens/onboarding/dont_show_the_link_screen.dart';
import 'package:iw_app/screens/onboarding/login_link_screen.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

List<Story> appScreens() {
  return [
    Story(
      name: 'Screens/User Offer',
      builder: (context) {
        final org = Organization(
          description: 'My test organization',
          name: 'Test',
          logo: '/orgs/logo/d67ef715-14c6-4476-834f-e7180d5c4092.jpg',
          link: null,
          username: 'Test',
          wallet: '3RfZBjYzpuLfuMfR7fPAdAzMr39VRyLrHJGAW3B3kEfw',
        );
        org.settings = OrganizationSettings(treasury: 20);
        org.id = '6448c3faca4ad8218c87787f';
        final member = OrganizationMember(
          hoursPerWeek: 40,
          impactRatio: 7,
          isAutoContributing: true,
          occupation: 'Frontend',
          org: '6429d40d370950b4635db8b6',
          role: context.knobs.options(
            label: 'Role',
            initial: MemberRole.Admin,
            options: [
              const Option(label: 'Admin', value: MemberRole.Admin),
              const Option(label: 'Co Owner', value: MemberRole.CoOwner),
              const Option(label: 'Investor', value: MemberRole.Investor),
              const Option(label: 'Member', value: MemberRole.Member)
            ],
          ),
          user: User(
            avatar: '/users/avatar/8ed4952c-7d98-4b0c-bfe0-4aeaa5c43932.jpg',
            avatarToSet: null,
            name: 'Test',
            id: '6429d3bc370950b4635db8a6',
            nickname: 'Test nuckname',
            wallet: '8vmEKTrbDRH2wYQ2g7z3DD5tpRTQ7z2LpEfXQbK5qMMz',
          ),
        );

        return OfferPreviewScreen(
          member: member,
          organization: org,
          offer: Offer(id: '1', org: org, memberProspects: []),
        );
      },
    ),
    Story(
      name: 'Screens/Link onboarding',
      builder: (context) {
        return const LoginLinkScreen(
          link: 'some-link',
        );
      },
    ),
    Story(
        name: 'Screens/Dont show the link',
        builder: (context) {
          return const DontShowTheLinkScreen(
            link: 'some-link',
          );
        })
  ];
}
