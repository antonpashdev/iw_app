import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:iw_app/api/base_api.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';

class _OrgsApi extends BaseApi {
  getOrgByUsername(String username) {
    final params = {
      'searchTerm': username,
    };
    return client.get(
      '/orgs/username',
      queryParameters: params,
    );
  }

  Future<Response> createOrg(
    Organization organization,
    OrganizationMember member,
  ) {
    final orgMap = organization.toMap(member);
    orgMap['logo'] = MultipartFile.fromBytes(
      organization.logoToSet!,
      filename: 'logo',
    );

    final body = FormData.fromMap(orgMap);

    return client.post('/orgs', data: body);
  }

  Future<Response> addMemberToOrg(String orgId, OrganizationMember member) {
    final body = member.toMap();
    return client.post('/orgs/$orgId/members', data: body);
  }

  Future<Response> getOrgMembers(String orgId) {
    return client.get('/orgs/$orgId/members');
  }

  Future<Response> getMemberEquity(String orgId, String memberId) {
    return client.get('/orgs/$orgId/members/$memberId/equity');
  }

  Future<Response> getOrgById(String orgId) {
    return client.get('/orgs/$orgId');
  }

  Future<Response> startContribution(String orgId, String memberId) {
    final body = {
      'memberId': memberId,
    };
    return client.post('/orgs/$orgId/contributions', data: body);
  }

  Future<Response> stopContribution(String orgId, String contributionId) {
    return client.delete('/orgs/$orgId/contributions/$contributionId');
  }

  Future<Response> createOffer(
    String orgId,
    OrganizationMember member,
  ) {
    final body = {
      'memberProspect': member.toMap(),
    };

    return client.post('/orgs/$orgId/offers', data: body);
  }

  Future<Response> acceptDeclineOffer(
    String orgId,
    String offerId,
    String userId,
    String status,
  ) {
    final body = {
      'status': status,
      'userId': userId,
    };

    return client.patch('/orgs/$orgId/offers/$offerId', data: body);
  }

  Future<Response> getOfferById(String orgId, String offerId) {
    return client.get('/orgs/$orgId/offers/$offerId');
  }

  Future<Uint8List> getLogo(String url) async {
    final response = await client.get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    return response.data;
  }
}

final orgsApi = _OrgsApi();
