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

  Future<bool> isUserExists(String nickName) async {
    try {
      await client.post('/users/exists', data: {
        'nickname': nickName,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Response> getUserMemberships(String userId) {
    return client.get('/users/$userId/memberships');
  }

  Future<Response> getUserContributions(String userId,
      {bool? isStopped, String? orgId}) {
    final Map<String, dynamic> params = {};
    if (isStopped != null) {
      params['isStopped'] = isStopped;
    }
    if (orgId != null) {
      params['orgId'] = orgId;
    }
    return client.get('/users/$userId/contributions', queryParameters: params);
  }
}

final usersApi = _UsersApi();
