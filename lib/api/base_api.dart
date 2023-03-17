import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:iw_app/api/auth_api.dart';

class BaseApi {
  final _dioClient = Dio(BaseOptions(
    baseUrl: 'http://localhost:9898',
  ));

  BaseApi() {
    _dioClient.interceptors.add(TokenInterceptor());
  }

  @protected
  Dio get client {
    return _dioClient;
  }
}

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    options.headers.addAll({'Authorization': 'Bearer ${authApi.token}'});
  }
}
