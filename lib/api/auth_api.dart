import 'package:dio/dio.dart';
import 'package:iw_app/api/base_api.dart';
import 'package:iw_app/app_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class _AuthApi extends BaseApi {
  Future<String?> get token {
    return appStorage.getValue('jwt_token');
  }

  Future<String?> get userId async {
    final decodedToken = JwtDecoder.decode((await token) ?? '');

    if (decodedToken.isEmpty) {
      return null;
    }

    return decodedToken['userId'] ?? decodedToken['_id'];
  }

  Future<String?> get orgId async {
    final decodedToken = JwtDecoder.decode((await token) ?? '');

    if (decodedToken.isEmpty) {
      return null;
    }

    return decodedToken['orgId'];
  }

  Future<Response> getMe() async {
    return client.get('/auth/me');
  }
}

final authApi = _AuthApi();
