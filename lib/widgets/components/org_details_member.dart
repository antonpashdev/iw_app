import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/theme/app_theme.dart';

class OrgDetailsMember extends StatefulWidget {
  final OrganizationMemberWithEquity data;

  const OrgDetailsMember({Key? key, required this.data}) : super(key: key);

  @override
  State<OrgDetailsMember> createState() => _OrgDetailsMemberState();
}

class _OrgDetailsMemberState extends State<OrgDetailsMember> {
  late Future<Uint8List?> futureAvatar;

  @override
  void initState() {
    futureAvatar = fetchAvatar();
    super.initState();
  }

  Future<Uint8List?> fetchAvatar() async {
    if (widget.data.member?.image == null) {
      return null;
    }
    return usersApi.getAvatar(widget.data.member!.image!);
  }

  @override
  Widget build(BuildContext context) {
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
                  child: FutureBuilder(
                    future: futureAvatar,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      if (!snapshot.hasData) {
                        return const Icon(
                          CupertinoIcons.person_fill,
                          color: COLOR_LIGHT_GRAY,
                        );
                      }
                      return Image.memory(snapshot.data!);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.data.member!.username!,
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
          FutureBuilder(
            future: widget.data.futureEquity,
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
                    '${snapshot.data}%',
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
}
