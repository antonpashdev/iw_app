import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/org_events_history_item_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';
import 'package:iw_app/utils/numbers.dart';

Future<Organization> fetchOrg(String orgId) async {
  final response = await orgsApi.getOrgById(orgId);
  final org = Organization.fromJson(response.data);
  return org;
}

Future<List<OrganizationMemberWithEquity>> fetchMembers(String orgId) async {
  final response = await orgsApi.getOrgMembers(orgId);
  return (response.data as List).map((memberJson) {
    final member = OrganizationMember.fromJson(memberJson);
    return OrganizationMemberWithEquity(
      member: member,
      futureEquity: fetchMemberEquity(member),
    );
  }).toList();
}

Future<List<OrgEventsHistoryItem>> fetchHistory(String orgId) async {
  try {
    final response = await orgsApi.getOrgEventsHistory(orgId);
    return (response.data as List)
        .map((itemJson) => OrgEventsHistoryItem.fromJson(itemJson))
        .toList();
  } catch (e) {
    print(e);
  }
  return [];
}

Future<MemberEquity> fetchMemberEquity(OrganizationMember member) async {
  final response = await orgsApi.getMemberEquity(member.org, member.id!);
  return MemberEquity.fromJson(response.data);
}

Future<double> fetchBalance(String orgId) async {
  final response = await orgsApi.getBalance(orgId);
  return intToDouble(response.data['balance'])!;
}
