import 'package:flutter/material.dart';

class AppSelect extends StatelessWidget {
  final Map? value;
  final List<Map> options;
  final Function(Map? value) onChanged;

  const AppSelect(
    this.value, {
    Key? key,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options
          .map(
            (option) => ListTile(
              minLeadingWidth: 0,
              leading: Radio(
                activeColor: Colors.black,
                value: option['value'],
                groupValue: value?['value'],
                onChanged: (value) {
                  onChanged(option);
                },
              ),
              title: Text(option['title']),
              onTap: () {
                onChanged(option);
              },
            ),
          )
          .toList(),
    );
  }
}
