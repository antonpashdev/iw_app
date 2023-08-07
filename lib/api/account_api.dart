import 'package:dio/dio.dart';
import 'package:iw_app/api/base_api.dart';

class _AccountApi extends BaseApi {
  Future<Response> getUsdcHistory(String before, {int? limit = 10}) {
    Map<String, dynamic> queryParameters = before.isEmpty
        ? {}
        : {
            'before': before,
            // 'limit': limit, TODO: check why this parameter causes 400 error
          };
    return client.get(
      '/account/usdc/history',
      queryParameters: queryParameters,
    );
  }
}

final accountApi = _AccountApi();
