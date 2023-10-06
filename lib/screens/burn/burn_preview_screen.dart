import 'package:flutter/material.dart';
import 'package:iw_app/api/users_api.dart';
import 'package:iw_app/screens/burn/burn_success_screen.dart';
import 'package:iw_app/theme/app_theme.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class BurnPreviewScreen<T extends Widget> extends StatefulWidget {
  final double amount;

  const BurnPreviewScreen({
    Key? key,
    required this.amount,
  }) : super(key: key);

  @override
  State<BurnPreviewScreen> createState() => _BurnPreviewScreenState();
}

class _BurnPreviewScreenState extends State<BurnPreviewScreen> {
  bool isLoading = false;

  handleNextPressed(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await usersApi.burnCredits(widget.amount);

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BurnSuccessScreen(
              amount: widget.amount,
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  buildAmount(BuildContext context) {
    return Column(
      children: [
        const Text(
          'You Burn',
          style: TextStyle(color: COLOR_GRAY),
        ),
        const SizedBox(height: 10),
        Text(
          '\$${widget.amount} Credit\$',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Preview',
      child: Stack(
        children: [
          Positioned.fill(
            child: KeyboardDismissableListView(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: buildAmount(context),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 290,
                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : () => handleNextPressed(context),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : const Text('Burn'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
