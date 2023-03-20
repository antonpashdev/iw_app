import 'package:flutter/material.dart';

class KeyboardDismissableListView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const KeyboardDismissableListView({
    Key? key,
    required this.children,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: padding,
      children: children,
    );
  }
}
