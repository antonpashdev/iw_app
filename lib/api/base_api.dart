import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:iw_app/api/auth_api.dart';

const TIMEOUT = Duration(days: 1);

class BaseApi {
  final _dioClient = Dio(
    BaseOptions(
      // baseUrl: 'http://localhost:9898',
      baseUrl: 'https://impact-wallet.herokuapp.com',
      connectTimeout: TIMEOUT,
      sendTimeout: TIMEOUT,
      receiveTimeout: TIMEOUT,
      followRedirects: true,
    ),
  )..interceptors.add(tokenInterceptor);

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
