import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final int maxLines;
  final int minLines;
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
    this.maxLines = 1,
    this.minLines = 1,
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
      maxLines: maxLines,
      minLines: minLines,
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
  final int minLines;
  final TextInputAction? textInputAction;
  final String? initialValue;
  final FloatingLabelBehavior? floatingLabelBehavior;

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
    this.minLines = 1,
    this.textInputAction,
    this.initialValue,
    this.floatingLabelBehavior,
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
      minLines: minLines,
      style:
          Theme.of(context).textTheme.bodyLarge!.copyWith(color: COLOR_BLACK),
      decoration: InputDecoration(
        floatingLabelBehavior: floatingLabelBehavior,
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

enum AppTextFormSize {
  small,
  medium,
  large,
}

class AppTextFormFieldBordered extends StatelessWidget {
  final TextAlign textAlign;
  final Widget? label;
  final String? labelText;
  final Widget? prefix;
  final Widget? suffix;
  final Function(String value)? onChanged;
  final Function(String? value)? onSaved;
  final Function(String value)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final TextStyle? errorStyle;
  final AppTextFormSize size;
  final bool? enabled;
  final String? initialValue;
  final TextEditingController? controller;
  final int minLines;
  final int maxLines;
  final bool autofocus;
  final bool readOnly;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextFormFieldBordered({
    Key? key,
    this.textAlign = TextAlign.start,
    this.label,
    this.labelText,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.validator,
    this.inputType,
    this.errorStyle,
    this.size = AppTextFormSize.medium,
    this.enabled = true,
    this.initialValue,
    this.controller,
    this.minLines = 1,
    this.maxLines = 1,
    this.autofocus = false,
    this.readOnly = false,
    this.errorText,
    this.inputFormatters = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contentPadding = EdgeInsets.symmetric(
      vertical: size == AppTextFormSize.small ? 10 : 18,
      horizontal: 15,
    );
    final borderRadius = BorderRadius.circular(
      size == AppTextFormSize.small ? 6 : 12,
    );

    return TextFormField(
      inputFormatters: inputFormatters,
      enabled: enabled,
      controller: controller,
      keyboardType: inputType,
      textAlign: textAlign,
      onChanged: onChanged,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      initialValue: initialValue,
      minLines: minLines,
      maxLines: maxLines,
      autofocus: autofocus,
      readOnly: readOnly,
      decoration: InputDecoration(
        errorText: errorText,
        errorStyle: errorStyle,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        label: label,
        labelText: labelText,
        alignLabelWithHint: true,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          color: COLOR_GRAY2,
          fontSize: 15,
        ),
        prefix: prefix,
        suffix: suffix,
        contentPadding: contentPadding,
        filled: enabled != null && !enabled!,
        fillColor: COLOR_LIGHT_GRAY,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: COLOR_LIGHT_GRAY,
          ),
          borderRadius: borderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: COLOR_ALMOST_BLACK,
          ),
          borderRadius: borderRadius,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: borderRadius,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: borderRadius,
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: COLOR_LIGHT_GRAY,
          ),
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
