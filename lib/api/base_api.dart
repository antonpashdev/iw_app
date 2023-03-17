import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:iw_app/api/auth_api.dart';

class BaseApi {
  final _dioClient = Dio(BaseOptions(
    baseUrl: 'http://localhost:9898',
  ));

  BaseApi() {
    _dioClient.interceptors.add(tokenInterceptor);
  }

  @protected
  Dio get client {
    return _dioClient;
  }
}

final tokenInterceptor = InterceptorsWrapper(
  onRequest: (options, handler) async {
    final token = await authApi.token;
    if (token != null) {
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }
    handler.next(options);
  },
);
