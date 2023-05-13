import 'package:dio/dio.dart';
import 'package:iw_app/api/base_api.dart';
import 'package:iw_app/models/config_model.dart';

class _ConfigApi extends BaseApi {
  Future<Response> getConfig() {
    return client.get('/config');
  }

  Future<Response> updateConfig(Config config) {
    Map data = config.toJson();
    return client.put('/config', data: data);
  }
}

final configApi = _ConfigApi();
