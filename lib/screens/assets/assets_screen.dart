import 'package:flutter/material.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class AssetsScreen extends StatelessWidget {
  final OrganizationMemberWithOtherMembers omm;

  const AssetsScreen({super.key, required this.omm});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        title: 'Assets',
        child: Column(children: <Widget>[Text(omm.futureEquity.toString())]));
  }
}
