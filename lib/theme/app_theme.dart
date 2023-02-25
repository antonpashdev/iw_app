import 'package:flutter/material.dart';

ThemeData getAppTheme() {
  return ThemeData(
      fontFamily: 'SF Pro Display',
      scaffoldBackgroundColor: COLOR_WHITE,
      colorScheme: const ColorScheme.light(
        primary: COLOR_ALMOST_BLACK,
        secondary: COLOR_WHITE,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 14,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(15),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Display',
          ),
          shadowColor: Colors.transparent,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(color: COLOR_ALMOST_BLACK),
        foregroundColor: COLOR_ALMOST_BLACK,
        backgroundColor: COLOR_WHITE,
        elevation: 0,
      ));
}

const Color COLOR_WHITE = Color(0xffffffff);
const Color COLOR_BLACK = Color(0xff000000);
const Color COLOR_ALMOST_BLACK = Color(0xff222222);

const Color APP_BODY_BG = COLOR_WHITE;
