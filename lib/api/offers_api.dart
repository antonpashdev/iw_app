import 'package:dio/dio.dart';
import 'package:iw_app/api/base_api.dart';

class _OffersApi extends BaseApi {
  Future<Response> createSaleOffer({
    required double amount,
    required double price,
    required String userId,
    required String orgId,
  }) {
    final body = {
      'tokensAmount': amount,
      'price': price,
      'userId': userId,
      'orgId': orgId,
    };
    return client.post('/offers/sale', data: body);
  }

  Future<Response> getSaleOffer(String offerId) {
    return client.get('/offers/sale/$offerId');
  }

  Future<Response> acceptDeclineSaleOffer(
    String offerId,
    String status,
    bool isLite,
  ) {
    final body = {
      'status': status,
    };

    if (isLite) {
      return client.patch('/lite/offers/sale/$offerId', data: body);
    }

    return client.patch('/offers/sale/$offerId', data: body);
  }
}

final offersApi = _OffersApi();
