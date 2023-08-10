import 'package:dio/dio.dart';
import 'package:iw_app/api/base_api.dart';

class _PaymentApi extends BaseApi {
  Future<Response> getPayment(String id) async {
    return client.get('/payment/$id');
  }

  Future<Response> performPayment(String id) async {
    return client.post('/payment/$id');
  }
}

final paymentApi = _PaymentApi();
