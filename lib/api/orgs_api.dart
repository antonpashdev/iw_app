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

  Future<Response> createOrg(Organization organization) {
    final orgMap = organization.toMap();

    final body = FormData.fromMap(orgMap);
    body.files.add(
      MapEntry(
        'logo',
        MultipartFile.fromBytes(
          organization.logo!,
          filename: 'logo',
        ),
      ),
    );

    return client.post('/orgs', data: body);
  }

  Future<Response> addMemberToOrg(String orgId, OrganizationMember member) {
    final body = member.toJson();
    return client.post('/orgs/$orgId/members', data: body);
  }
}

final orgsApi = _OrgsApi();
