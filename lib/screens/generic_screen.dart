import 'package:flutter/material.dart';
import 'package:iw_app/widgets/list/keyboard_dismissable_list.dart';
import 'package:iw_app/widgets/scaffold/screen_scaffold.dart';

class GenericScreen extends StatelessWidget {
  final String title;
  final Widget child;

  const GenericScreen({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: title,
      child: KeyboardDismissableListView(
        children: [child],
      ),
    );
  }
}
