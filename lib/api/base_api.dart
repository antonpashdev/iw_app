import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BaseApi {
  final _dioClient = Dio(BaseOptions(
    baseUrl: 'https://impact-wallet.herokuapp.com',
  ));

  @protected
  get client {
    return _dioClient;
  }
}
