import 'package:flutter/material.dart';
import 'package:iw_app/models/config_model.dart';

class ConfigState extends InheritedWidget {
  final Config config;

  const ConfigState({
    super.key,
    required this.config,
    required super.child,
  });

  static ConfigState? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ConfigState>();
  }

  static ConfigState of(BuildContext context) {
    final ConfigState? result = maybeOf(context);
    assert(result != null, 'No ConfigState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ConfigState oldWidget) {
    return config != oldWidget.config;
  }
}
