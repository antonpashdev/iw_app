import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:iw_app/api/base_api.dart';
import 'package:iw_app/api/models/org_offers_filter_model.dart';
import 'package:iw_app/api/models/org_to_update.model.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';

import '../models/offer_model.dart';

class _OrgsApi extends BaseApi {
  getOrgByUsername(String username) {
    final params = {
      'searchTerm': username,
    };
    return client.get(
      '/orgs/username',
      queryParameters: params,
    );
  }

  Future<Response> createOrg(
    Organization organization,
    OrganizationMember member,
    bool isLite,
  ) {
    final orgMap = organization.toMap(member);
    orgMap['logo'] = MultipartFile.fromBytes(
      organization.logoToSet!,
      filename: 'logo',
    );

    final body = FormData.fromMap(orgMap);

    if (isLite) {
      return client.post('/lite/orgs', data: body);
    }
    return client.post('/orgs', data: body);
  }

  Future<Response> addMemberToOrg(String orgId, OrganizationMember member) {
    final body = member.toMap();
    return client.post('/orgs/$orgId/members', data: body);
  }

  Future<Response> getOrgMembers(String orgId) {
    return client.get('/orgs/$orgId/members');
  }

  Future<Response> getMemberEquity(String orgId, String memberId) {
    return client.get('/orgs/$orgId/members/$memberId/equity');
  }

  Future<Response> getOrgById(String orgId) {
    return client.get('/orgs/$orgId');
  }

  Future<Response> startContribution(String orgId, String memberId) {
    final body = {
      'memberId': memberId,
    };
    return client.post('/orgs/$orgId/contributions', data: body);
  }

  Future<Response> stopContribution(
    String orgId,
    String contributionId,
    String? memo,
  ) {
    final body = {
      'memo': memo,
    };
    return client.patch(
      '/orgs/$orgId/contributions/$contributionId',
      data: body,
    );
  }

  Future<Response> recordContribution(String orgId, String? memo) {
    final body = {
      'memo': memo,
    };
    return client.post(
      '/lite/orgs/$orgId/contributions',
      data: body,
    );
  }

  Future<Response> createOffer(
    String orgId,
    bool isLite,
    Offer offer, {
    OrganizationMember? member,
  }) {
    if (isLite) {
      return client.post(
        '/lite/orgs/$orgId/offers',
        data: offer.toJson(member),
      );
    }

    final body = {
      'memberProspect': member?.toMap(),
    };

    return client.post('/orgs/$orgId/offers', data: body);
  }

  Future<Response> acceptDeclineOffer(
    String orgId,
    String offerId,
    String status,
    bool isLite, {
    double? amount,
  }) {
    final body = {
      'status': status,
      'amount': amount,
    };

    if (isLite) {
      return client.patch('/lite/orgs/$orgId/offers/$offerId', data: body);
    }

    return client.patch('/orgs/$orgId/offers/$offerId', data: body);
  }

  Future<Response> getOfferById(String orgId, String offerId) {
    return client.get('/orgs/$orgId/offers/$offerId');
  }

  Future<Response> getOffers(String orgId, OrgOffersFilter filter) {
    final params = filter.toMap();
    return client.get('/orgs/$orgId/offers', queryParameters: params);
  }

  Future<Uint8List> getLogo(String url) async {
    final response = await client.get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    return response.data;
  }

  Future<Response> receivePayment(
    String orgId,
    String item,
    double price,
  ) {
    final body = {
      'items': [
        {
          'name': item,
          'amount': price,
        }
      ],
    };

    return client.post('/orgs/$orgId/payments/receive', data: body);
  }

  Future<Response> getBalance(String orgId) {
    return client.get('/orgs/$orgId/usdc/balance');
  }

  Future<Response> sendMoney(String orgId, SendMoneyData data) {
    final body = {
      'recipient': data.recipient,
      'amount': data.amount,
    };
    return client.post('/orgs/$orgId/usdc/send', data: body);
  }

  Future<Response> getOrgEventsHistory(String orgId) {
    return client.get('/orgs/$orgId/history');
  }

  Future<Response> getMemberships(String orgId) {
    return client.get('/orgs/$orgId/memberships');
  }

  Future<Response> loginAsOrg(String orgId) {
    return client.post('/orgs/$orgId/login');
  }

  Future<Response> getOrgs({String? username, bool? isExactMatch}) {
    final params = {
      'username': username,
      'isExactMatch': isExactMatch,
    };
    return client.get('/orgs', queryParameters: params);
  }

  Future<Response> updateOrg(String orgId, OrgToUpdate orgToUpdate) {
    return client.put('/orgs/$orgId/update', data: orgToUpdate.toMap());
  }

  Future<Response<String>> uploadLogo(Uint8List logo) {
    final data = FormData.fromMap({
      'logo': MultipartFile.fromBytes(logo, filename: 'logo'),
    });
    return client.post('/orgs/upload-logo', data: data);
  }

  Future<Response> removeLogos(List<String> imageNames) {
    return client.post('/orgs/delete-avatars', data: {'fileName': imageNames});
  }
}

final orgsApi = _OrgsApi();
