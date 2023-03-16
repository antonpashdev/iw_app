import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const TOKEN =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiQW50b24iLCJuaWNrbmFtZSI6ImFudG9ucGFzIiwid2FsbGV0IjoiNlBzM3VDbTNHNTU2aGV6NjJQdm93VGdmNlJoeG9zOHpTNktIcVZvZ1RmRzEiLCJpYXQiOjE2Nzg5OTU4ODJ9.y3vDUUoqDQmu1hXwN4lYSmODH9syALUqUHcCR8Z43pY';

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
    options.headers.addAll({'Authorization': 'Bearer $TOKEN'});
  }
}
