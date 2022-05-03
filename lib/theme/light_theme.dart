import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    selectionHandleColor: Colors.transparent,
  ),
  fontFamily: 'Poppins',
  accentColor: Color(0xFF4c73f4),
  primaryColor: Color(0xFF4c73f4),
  brightness: Brightness.light,
  cardColor: Colors.white,
  focusColor: Color(0xFFABC5FE),
  hintColor: Color(0xFF52575C),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
