import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/models/account_model.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/list/generic_list_tile.dart';

import '../../api/users_api.dart';
import '../../models/organization_member_model.dart';
import '../media/network_image_auth.dart';

class AccountsListWidget extends StatelessWidget {
  final Account? currentAccount;
  final List<OrganizationMemberWithOtherMembers>? orgs;

  const AccountsListWidget({super.key, this.currentAccount, this.orgs});

  @override
  Widget build(BuildContext context) {
    List<OrganizationMemberWithOtherMembers> filteredItems = orgs
            is List<OrganizationMemberWithOtherMembers>
        ? orgs!.where((item) => item.member?.role == MemberRole.Admin).toList()
        : [];

    return Flex(
      direction: Axis.vertical,
      children: [
        Column(
          children: [
            // current account
            InkWell(
              onTap: () {
                Navigator.of(context).pop(currentAccount?.user);
              },
              child: GenericListTile(
                title: currentAccount?.user?.name,
                subtitle: currentAccount?.user?.nickname,
                showMiniIcon: false,
                trailing: currentAccount?.id == currentAccount?.user?.id
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: COLOR_BLUE,
                        size: 25,
                      )
                    : null,
                image: currentAccount?.user?.avatar != null
                    ? NetworkImageAuth(
                        imageUrl:
                            '${usersApi.baseUrl}${currentAccount?.user?.avatar}',
                      )
                    : const Icon(
                        CupertinoIcons.person_fill,
                        color: COLOR_LIGHT_GRAY,
                      ),
              ),
            ),
            const Divider(
              color: COLOR_GRAY,
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.maxFinite,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop(filteredItems[index]);
                },
                child: GenericListTile(
                  title: filteredItems[index].member?.org.name ?? '',
                  subtitle:
                      '@${filteredItems[index].member?.org.username ?? ''}',
                  showMiniIcon: false,
                  image: NetworkImageAuth(
                    imageUrl:
                        '${usersApi.baseUrl}${filteredItems[index].member?.org.logo}',
                  ),
                  trailing:
                      currentAccount?.id == filteredItems[index].member?.org.id
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: COLOR_BLUE,
                              size: 25,
                            )
                          : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
