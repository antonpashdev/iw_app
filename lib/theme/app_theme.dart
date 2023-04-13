import 'package:flutter/material.dart';

ThemeData getAppTheme() {
  return ThemeData(
    fontFamily: 'SF Pro Display',
    scaffoldBackgroundColor: COLOR_WHITE,
    hoverColor: Colors.transparent,
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
        visualDensity: const VisualDensity(vertical: 0),
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
      titleSpacing: 20,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'SF Pro Display',
        fontSize: 18,
        color: COLOR_ALMOST_BLACK,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: COLOR_ALMOST_BLACK,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: COLOR_ALMOST_BLACK,
      ),
      headlineSmall: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        color: COLOR_ALMOST_BLACK,
      ),
      displayLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w300,
        color: COLOR_ALMOST_BLACK,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w300,
        color: COLOR_ALMOST_BLACK,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: COLOR_ALMOST_BLACK,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: COLOR_ALMOST_BLACK,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: COLOR_ALMOST_BLACK,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        color: COLOR_ALMOST_BLACK,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: COLOR_GRAY2,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelStyle: TextStyle(
        color: COLOR_BLACK,
        fontWeight: FontWeight.w400,
      ),
      prefixStyle: TextStyle(
        color: COLOR_BLACK,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      helperStyle: TextStyle(color: COLOR_GRAY),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: COLOR_LIGHT_GRAY,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1),
      ),
      contentPadding: EdgeInsets.only(bottom: 10),
      isDense: true,
    ),
  );
}

const Color COLOR_WHITE = Color(0xffffffff);
const Color COLOR_BLACK = Color(0xff000000);
const Color COLOR_ALMOST_BLACK = Color(0xff222222);
const Color COLOR_LIGHT_GRAY = Color(0xffEEF0F3);
const Color COLOR_LIGHT_GRAY2 = Color(0xffC4C4C4);
const Color COLOR_LIGHT_GRAY3 = Color(0xfff3f4f6);
const Color COLOR_GRAY = Color(0xff87899B);
const Color COLOR_GRAY2 = Color(0xffB8BFCA);
const Color COLOR_GREEN = Color(0xff0E9E17);
const Color COLOR_BLUE = Color(0xff1D55E4);
const Color COLOR_RED = Color(0xffD02626);
const Color COLOR_ORANGE = Color(0xffECA240);
const Color COLOR_CORAL = Color(0xff3EA592);

const Color APP_BODY_BG = COLOR_WHITE;
const Color BTN_BLUE_BG = COLOR_BLUE;
const Color BTN_GRAY_GB = COLOR_LIGHT_GRAY3;
