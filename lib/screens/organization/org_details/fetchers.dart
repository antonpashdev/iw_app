import 'package:iw_app/api/orgs_api.dart';
import 'package:iw_app/models/org_events_history_item_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';

Future<Organization> fetchOrg(String orgId) async {
  final response = await orgsApi.getOrgById(orgId);
  final org = Organization.fromJson(response.data);
  return org;
}

Future<List<OrganizationMemberWithEquity>> fetchMembers(String orgId) async {
  final response = await orgsApi.getOrgMembers(orgId);
  return (response.data['list'] as List).map((memberJson) {
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

Future<String> fetchMemberEquity(OrganizationMember member) async {
  final response = await orgsApi.getMemberEquity(member.org.id, member.id!);
  final tokenAmount = TokenAmount.fromJson(response.data);
  return tokenAmount.uiAmountString!;
}

Future<String?> fetchBalance(String orgId) async {
  final response = await orgsApi.getBalance(orgId);
  return TokenAmount.fromJson(response.data['balance']).uiAmountString;
}
