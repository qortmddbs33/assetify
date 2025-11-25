/// Flutter ThemeData로 변환된 라이트 테마
/// 앱 전체에 적용되는 Material 테마 설정
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../light.dart';

final CustomLightTheme _lightTheme = CustomLightTheme();

/// Material ThemeData 형태의 라이트 테마
/// GetMaterialApp의 theme 속성에 적용
final ThemeData lightThemeData = ThemeData(
  fontFamily: 'WantedSans',
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _lightTheme.colors.coreAccent,
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleSpacing: 0,
    foregroundColor: _lightTheme.colors.contentStandardPrimary,
    centerTitle: false,
  ),
  textSelectionTheme: TextSelectionThemeData(
      selectionColor: _lightTheme.colors.coreAccent.withAlpha(100),
      selectionHandleColor: _lightTheme.colors.coreAccent),
  cupertinoOverrideTheme:
      CupertinoThemeData(primaryColor: _lightTheme.colors.coreAccent),
  scaffoldBackgroundColor: _lightTheme.colors.backgroundStandardPrimary,
  extensions: [_lightTheme.colors, _lightTheme.textStyle],
  cardColor: _lightTheme.colors.componentsFillStandardPrimary,
);
