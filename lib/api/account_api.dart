import 'package:dio/dio.dart';
import 'package:iw_app/api/base_api.dart';

class _AccountApi extends BaseApi {
  Future<Response> getUsdcHistory() {
    return client.get('/account/usdc/history');
  }
}

final accountApi = _AccountApi();
