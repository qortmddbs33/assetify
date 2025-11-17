import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dark.dart';

final CustomDarkTheme _darkTheme = CustomDarkTheme();

ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'WantedSans',
  colorScheme: ColorScheme.fromSeed(
    seedColor: _darkTheme.colors.coreAccent,
    brightness: Brightness.dark,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleSpacing: 0,
    foregroundColor: _darkTheme.colors.contentStandardPrimary,
    centerTitle: false,
  ),
  textSelectionTheme: TextSelectionThemeData(
      selectionColor: _darkTheme.colors.coreAccent.withAlpha(100),
      selectionHandleColor: _darkTheme.colors.coreAccent),
  cupertinoOverrideTheme:
      CupertinoThemeData(primaryColor: _darkTheme.colors.coreAccent),
  scaffoldBackgroundColor: _darkTheme.colors.backgroundStandardPrimary,
  extensions: [_darkTheme.colors, _darkTheme.textStyle],
  cardColor: _darkTheme.colors.componentsFillStandardPrimary,
);
