import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'input_form.dart';

class BoardedTextFieldWithTitle extends StatelessWidget {
  final String title;
  final String prefix;
  final String suffix;
  final TextEditingController textFieldController;
  final void Function()? onSuffixTap;
  final dynamic Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool focus;

  const BoardedTextFieldWithTitle({
    Key? key,
    required this.title,
    required this.textFieldController,
    required this.onSuffixTap,
    required this.prefix,
    required this.suffix,
    this.onChanged,
    this.focus = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: COLOR_ALMOST_BLACK,
          ),
        ),
        const SizedBox(height: 7),
        AppTextFormFieldBordered(
          autofocus: focus,
          validator: validator,
          controller: textFieldController,
          prefix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Text(prefix),
          ),
          suffix: InkWell(
            onTap: onSuffixTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                suffix,
                style: Theme.of(context).textTheme.bodySmall!,
              ),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
