import 'package:flutter/material.dart';
import 'package:iw_app/api/account_api.dart';
import 'package:iw_app/api/auth_api.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/models/account_model.dart';
import 'package:iw_app/models/organization_member_model.dart';
import 'package:iw_app/models/txn_history_item_model.dart';
import 'package:iw_app/screens/account/builders/header.dart';
import 'package:iw_app/screens/account/builders/title.dart';
import 'package:iw_app/screens/account/builders/title_shimmer.dart';
import 'package:iw_app/screens/account/widgets/infine_scroll.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late Future<Account?> futureAccount;
  late Future<String?> futureBalance;
  late Future<List<TxnHistoryItem>> futureHistory;

  @override
  void initState() {
    futureAccount = fetchAccount();
    futureBalance = fetchBalance();
    futureHistory = fetchHistory();
    super.initState();
  }

  Future<Account?> fetchAccount() async {
    try {
      final response = await authApi.getMe();
      return Account.fromJson(response.data);
    } catch (err) {
      print(err);
    }
    return null;
  }

  Future<String?> fetchBalance() async {
    final response = await usersApi.getBalance();
    return TokenAmount.fromJson(response.data['balance']['balance'])
        .uiAmountString;
  }

  Future<List<TxnHistoryItem>> fetchHistory() async {
    final response = await accountApi.getUsdcHistory('');
    final List<TxnHistoryItem> history = [];
    for (final item in response.data) {
      history.add(TxnHistoryItem.fromJson(item));
    }
    return history;
  }

  Future onRefresh() {
    setState(() {
      futureAccount = fetchAccount();
      futureBalance = fetchBalance();
      futureHistory = fetchHistory();
    });
    return Future.wait([futureAccount, futureBalance, futureHistory]);
  }

  fetchMoreTxnHistoryItems(String before, {int? limit}) async {
    final response = await accountApi.getUsdcHistory(before, limit: limit);
    final List<TxnHistoryItem> history = [];
    for (final item in response.data) {
      history.add(TxnHistoryItem.fromJson(item));
    }
    return history;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureAccount,
      builder: (_, snapshot) {
        return ScreenScaffold(
          title: FutureBuilder(
            future: futureAccount,
            builder: (context, snapshot) {
              final account = snapshot.data;
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      if (!snapshot.hasData) ...buildTitleShimmer(),
                      if (snapshot.hasData) ...buildTitle(account!),
                    ],
                  ),
                ],
              );
            },
          ),
          child: FutureBuilder(
            future: futureAccount,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final account = snapshot.data;
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder(
                    future: futureBalance,
                    builder: (_, snapshot) {
                      return buildHeader(account!, snapshot.data, context);
                    },
                  ),
                  const SizedBox(height: 5),
                  FutureBuilder(
                    future: futureHistory,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return const Flexible(
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }

                      return snapshot.data?.isEmpty == true
                          ? const Expanded(
                              child: Center(
                                child: Text(
                                  'There are no transactions 👀',
                                  style: TextStyle(
                                    fontSize: 21,
                                  ),
                                ),
                              ),
                            )
                          : InfiniteScrollListWidget(
                              initialData: snapshot.data!,
                              onRefresh: onRefresh,
                              onFetchMore: fetchMoreTxnHistoryItems,
                            );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
