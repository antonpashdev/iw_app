import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iw_app/api/base_api.dart';

class CreateUserResponse {
  final String secretLink;
  final String token;

  const CreateUserResponse({
    required this.secretLink,
    required this.token,
  });

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) {
    return CreateUserResponse(
      secretLink: json['secretLink'],
      token: json['token'],
    );
  }
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

    final userResponse = CreateUserResponse.fromJson(response.data);
    return userResponse;
  }
}

final usersApi = _UsersApi();
