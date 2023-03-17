import 'dart:typed_data';
import 'package:dio/dio.dart';
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
  // POST create user
  Future<CreateUserResponse> createUser(
    String name,
    String nickName,
    Uint8List? avatar,
  ) async {
    final Map<String, dynamic> userMap = {
      'name': name,
      'nickname': nickName,
    };

    if (avatar != null) {
      userMap['avatar'] = MultipartFile.fromBytes(avatar, filename: 'avatar');
    }

    FormData payload = FormData.fromMap(userMap);

    final response = await client.post(
      '/users',
      data: payload,
      options: Options(contentType: 'multipart/form-data'),
    );

    final userResponse = CreateUserResponse.fromJson(response.data);
    return userResponse;
  }
}

final usersApi = _UsersApi();
