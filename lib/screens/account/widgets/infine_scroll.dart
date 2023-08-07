import 'package:flutter/material.dart';
import 'package:iw_app/models/txn_history_item_model.dart';
import 'package:iw_app/screens/account/builders/history_item.dart';
import 'package:iw_app/theme/app_theme.dart';

class InfiniteScrollListWidget extends StatefulWidget {
  final Future<dynamic> Function() onRefresh;
  final Function(String before, {int? limit}) onFetchMore;
  final List<TxnHistoryItem> initialData;

  const InfiniteScrollListWidget({
    super.key,
    required this.onRefresh,
    required this.onFetchMore,
    required this.initialData,
  });

  @override
  InfiniteScrollListWidgetState createState() =>
      InfiniteScrollListWidgetState();
}

class InfiniteScrollListWidgetState extends State<InfiniteScrollListWidget> {
  // List<String> items = List.generate(20, (index) => 'Item ${index + 1}');
  String? lastTransactionSignature = '';
  List<TxnHistoryItem> items = [];
  bool isLoading = false;
  bool hasMore = true;

  final ScrollController _scrollController = ScrollController();

  Future<void> _onRefresh() async {
    setState(() {
      items = [];
      lastTransactionSignature = '';
      hasMore = true;
    });
    await widget.onRefresh();
  }

  void _loadMoreData() async {
    int limit = 10;
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final historyItems = await widget
          .onFetchMore(lastTransactionSignature ?? '', limit: limit);
      if (historyItems.isEmpty) {
        return;
      }

      if (historyItems.length < limit) {
        hasMore = false;
      }

      setState(() {
        items.addAll(historyItems);
        lastTransactionSignature =
            (historyItems.last as TxnHistoryItem).transactionSignature;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    items = widget.initialData;
    lastTransactionSignature = widget.initialData.last.transactionSignature;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: items.length + 1,
          itemBuilder: (context, index) {
            if (index == items.length) {
              return Center(
                child: hasMore
                    ? const CircularProgressIndicator.adaptive()
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'That\'s all!',
                          style: TextStyle(
                            color: COLOR_ALMOST_BLACK,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
              );
            } else {
              return buildHistoryItem(
                context,
                items[index],
                index > 0 ? items[index - 1] : null,
              );
            }
          },
        ),
      ),
    );
  }
}
