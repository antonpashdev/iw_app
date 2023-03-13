import 'package:flutter/material.dart';
import 'package:iw_app/theme/app_theme.dart';

class InputForm extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? prefix;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final Function(String value)? onChanged;
  final Function(String value)? onFieldSubmitted;
  final TextInputType? inputType;
  final bool enableInteractiveSelection;
  final bool autofocus;
  final bool enabled;
  final bool fieldRequired;
  final GlobalKey? formKey;
  final TextEditingController? controller;
  final Widget? child;

  const InputForm({
    Key? key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.prefix,
    this.suffix,
    this.validator,
    this.onChanged,
    this.inputType,
    this.enableInteractiveSelection = false,
    this.formKey,
    this.autofocus = false,
    this.controller,
    this.enabled = true,
    this.fieldRequired = true,
    this.onFieldSubmitted,
    this.child,
  }) : super(key: key);

  buildChild() {
    if (child != null) {
      return child;
    }
    return AppTextFormField(
      enabled: enabled,
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      validator: validator,
      enableInteractiveSelection: enableInteractiveSelection,
      inputType: inputType,
      hintText: hintText,
      helperText: helperText,
      prefix: prefix,
      suffix: suffix,
      labelText: labelText,
      fieldRequired: fieldRequired,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: buildChild(),
    );
  }
}

class AppTextFormField extends StatelessWidget {
  final bool enabled;
  final TextEditingController? controller;
  final bool autofocus;
  final Function(String value)? onChanged;
  final Function(String? value)? onSaved;
  final Function(String value)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool enableInteractiveSelection;
  final bool fieldRequired;
  final TextInputType? inputType;
  final String? hintText;
  final String? prefix;
  final Widget? suffix;
  final String? labelText;
  final String? errorText;
  final String? helperText;
  final int maxLines;
  final TextInputAction? textInputAction;
  final String? initialValue;

  const AppTextFormField({
    Key? key,
    this.enabled = true,
    this.controller,
    this.autofocus = false,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.enableInteractiveSelection = false,
    this.inputType,
    this.hintText,
    this.helperText,
    this.prefix,
    this.suffix,
    this.labelText,
    this.errorText,
    this.fieldRequired = true,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.textInputAction,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefix = this.prefix != null
        ? Text(
            '${this.prefix} ',
            style: Theme.of(context).inputDecorationTheme.prefixStyle,
          )
        : null;

    TextEditingController? controller;
    if (this.controller != null) {
      controller = this.controller;
    } else if (initialValue != null) {
      controller = TextEditingController.fromValue(
        TextEditingValue(
          text: initialValue!,
          selection: TextSelection.fromPosition(
            TextPosition(offset: initialValue!.length),
          ),
        ),
      );
    }

    return TextFormField(
      maxLines: maxLines,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      controller: controller,
      autofocus: autofocus,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      enableInteractiveSelection: enableInteractiveSelection,
      keyboardType: inputType,
      style:
          Theme.of(context).textTheme.bodyLarge!.copyWith(color: COLOR_BLACK),
      decoration: InputDecoration(
        errorText: errorText,
        counter: const SizedBox(height: 0),
        hintText: hintText,
        prefix: prefix,
        labelText: labelText,
        helperText: helperText,
        helperMaxLines: 10,
        suffix: suffix,
      ),
    );
  }
}
