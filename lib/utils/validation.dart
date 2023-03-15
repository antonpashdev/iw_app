import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iw_app/l10n/generated/app_localizations.dart';

AppLocalizations? _appLocalizations = lookupAppLocalizations(
  Locale(
    Intl.getCurrentLocale().split('_')[0],
    Intl.getCurrentLocale().split('_')[1],
  ),
);

String? Function(String?) numberField(String fieldName) {
  return (value) {
    if (value != null &&
        value.trim().isNotEmpty &&
        int.tryParse(value) == null) {
      return '$fieldName must be a number';
    }
    return null;
  };
}

String? Function(String?) requiredField(String fieldName) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${_appLocalizations!.required}';
    }
    return null;
  };
}

String? Function(String?) multiValidate(
  List<String? Function(String?)> validators,
) {
  return (value) {
    String? message;

    for (var validator in validators) {
      message = validator(value);
      if (message != null) {
        break;
      }
    }

    return message;
  };
}
