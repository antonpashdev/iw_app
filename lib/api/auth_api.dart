import 'package:iw_app/api/base_api.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

const _TOKEN =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NDE0OTg4MTI1NjZkMWIzOTdmMTc3NTgiLCJuYW1lIjoiQW50b24iLCJuaWNrbmFtZSI6ImFudG9ucGFzIiwid2FsbGV0IjoiNDN3RkNDZDlQWVdmUHpkTURtWlVGTVNrOUpaQmZ1NkZVYXRNYnhuUVE1Rk0iLCJpYXQiOjE2NzkwNzEzNjJ9._xyLUjY_-qlOzRHwQzz9SrLzX1mMUdo2VOoqHrpSZRg';

class _AuthApi extends BaseApi {
  String get token {
    return _TOKEN;
  }

  String get userId {
    final decodedToken = JwtDecoder.decode(_TOKEN);

    return decodedToken['_id'];
  }
}

final authApi = _AuthApi();
