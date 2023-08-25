import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/screens/organization/org_details/org_details_screen.dart';
import 'package:iw_app/screens/organization/receive_money_screen.dart';
import 'package:iw_app/screens/send_money/send_money_recipient_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/media/network_image_auth.dart';

buildHeader(
  BuildContext context,
  Organization org,
  OrganizationMember? member,
  bool isPreviewMode,
  Future<String?>? futureBalance,
) {
  return Row(
    children: [
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        clipBehavior: Clip.antiAlias,
        child: FittedBox(
          fit: BoxFit.cover,
          child: Hero(
            tag: 'org-logo-${org.id}',
            child: NetworkImageAuth(
              imageUrl: '${orgsApi.baseUrl}${org.logo!}',
            ),
          ),
        ),
      ),
      const SizedBox(width: 20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isPreviewMode)
            FutureBuilder(
              future: futureBalance,
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator.adaptive();
                }
                return Text(
                  '\$${snapshot.data}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                );
              },
            ),
          const SizedBox(height: 5),
          Text(
            'Treasury ${org.settings?.treasury}%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: COLOR_GRAY,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: isPreviewMode ||
                        member != null && !member.permissions!.canSendMoney
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SendMoneyRecipientScreen(
                              senderWallet: org.wallet!,
                              onSendMoney: (SendMoneyData data) =>
                                  orgsApi.sendMoney(org.id!, data),
                              originScreenFactory: () => OrgDetailsScreen(
                                orgId: org.id!,
                                member: member,
                              ),
                            ),
                          ),
                        );
                      },
                icon: SvgPicture.asset(
                  'assets/icons/arrow_up_box.svg',
                ),
                label: const Text('Send'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  visualDensity: const VisualDensity(vertical: -1),
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(),
                ),
              ),
              const SizedBox(width: 5),
              ElevatedButton.icon(
                onPressed: isPreviewMode
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReceiveMoneyScreen(
                              organization: org,
                            ),
                          ),
                        );
                      },
                icon: SvgPicture.asset('assets/icons/arrow_down_box.svg'),
                label: const Text('Receive'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  visualDensity: const VisualDensity(vertical: -1),
                  backgroundColor: BTN_BLUE_BG,
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
