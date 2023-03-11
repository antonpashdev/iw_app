import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/api/base_api.dart';

class CreateUserResponse {
  CreateUserResponse(String body) {
    final data = jsonDecode(body);
    secretLink = data['secretLink'];
    token = data['token'];
  }

  late String secretLink;
  late String token;
}

class _UsersApi extends BaseApi {
  final _dioClient = Dio(BaseOptions(
    baseUrl: 'https://impact-wallet.herokuapp.com',
  ));

  // POST create user
  Future<CreateUserResponse> createUser(
      String name, String nickName, Uint8List? avatar) async {
    FormData payload = FormData.fromMap({
      'name': name,
      'nickname': nickName,
      'avatar': avatar != null ? MultipartFile.fromBytes(avatar) : null,
    });

    final response = await _dioClient.post(
      '/users',
      data: payload,
      options: Options(contentType: 'multipart/form-data'),
    );

    final userResponse = CreateUserResponse(jsonDecode(response.data));
    return userResponse;
  }
}

final usersApi = _UsersApi();
