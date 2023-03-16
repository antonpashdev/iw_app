import 'package:iw_app/api/base_api.dart';

class _OrgsApi extends BaseApi {
  getOrgByUsername(String username) async {
    final params = {
      'searchTerm': username,
    };
    final response = await client.get(
      '/orgs/username',
      queryParameters: params,
    );
    return response;
  }
}

final orgsApi = _OrgsApi();
