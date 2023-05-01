import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:iw_app/api/base_api.dart';
import 'package:iw_app/api/models/org_offers_filter_model.dart';
import 'package:iw_app/api/models/send_money_data_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/organization_model.dart';

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
  ) {
    final orgMap = organization.toMap(member);
    orgMap['logo'] = MultipartFile.fromBytes(
      organization.logoToSet!,
      filename: 'logo',
    );

    final body = FormData.fromMap(orgMap);

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
      String orgId, String contributionId, String? memo) {
    final body = {
      'memo': memo,
    };
    return client.patch(
      '/orgs/$orgId/contributions/$contributionId',
      data: body,
    );
  }

  Future<Response> createOffer(
    String orgId,
    OrganizationMember member,
  ) {
    final body = {
      'memberProspect': member.toMap(),
    };

    return client.post('/orgs/$orgId/offers', data: body);
  }

  Future<Response> acceptDeclineOffer(
    String orgId,
    String offerId,
    String status,
  ) {
    final body = {
      'status': status,
    };

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
      'item': item,
      'amount': price,
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
}

final orgsApi = _OrgsApi();
