import 'package:flutter/cupertino.dart';
import 'package:iw_app/theme/app_theme.dart';

buildTitleShimmer() {
  return [
    Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: COLOR_LIGHT_GRAY,
      ),
    ),
    const SizedBox(width: 5),
    Container(
      width: 60,
      height: 10,
      decoration: const BoxDecoration(
        color: COLOR_LIGHT_GRAY,
      ),
    ),
  ];
}
