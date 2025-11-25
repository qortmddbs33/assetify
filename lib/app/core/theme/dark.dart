/// 다크 테마 색상 및 스타일 정의
library;

import 'package:flutter/material.dart';

import 'colors.dart';
import 'theme.dart';
import 'typography.dart';

/// 다크 모드 색상 정의
/// 어두운 배경에 밝은 텍스트 색상 사용
class CustomDarkThemeColors extends CustomColors {
  CustomDarkThemeColors()
      : super(
    solidRed: const Color(0xFFFF4035),
    solidOrange: const Color(0xFFFF9A05),
    solidYellow: const Color(0xFFF5C905),
    solidGreen: const Color(0xFF32CC58),
    solidBlue: const Color(0xFF057FFF),
    solidIndigo: const Color(0xFF5B59DE),
    solidPurple: const Color(0xFFB756E8),
    solidPink: const Color(0xFFFF325A),
    solidBrown: const Color(0xFFA78963),
    solidBlack: const Color(0xFF000000),
    solidWhite: const Color(0xFFFFFFFF),
    solidTranslucentRed: const Color(0x33FF4035),
    solidTranslucentOrange: const Color(0x33FF9A05),
    solidTranslucentYellow: const Color(0x33F5C905),
    solidTranslucentGreen: const Color(0x3332CC58),
    solidTranslucentBlue: const Color(0x33057FFF),
    solidTranslucentIndigo: const Color(0x335B59DE),
    solidTranslucentPurple: const Color(0x33B756E8),
    solidTranslucentPink: const Color(0x33FF325A),
    solidTranslucentBrown: const Color(0x33A78963),
    solidTranslucentBlack: const Color(0x33000000),
    solidTranslucentWhite: const Color(0x33FFFFFF),
    backgroundStandardPrimary: const Color(0xFF000000),
    backgroundStandardSecondary: const Color(0xFF0E0E0F),
    backgroundInvertedPrimary: const Color(0xFFFFFFFF),
    backgroundInvertedSecondary: const Color(0xFFEDEEF2),
    contentStandardPrimary: const Color(0xFFF4F4F5),
    contentStandardSecondary: const Color(0xB3F4F4F5),
    contentStandardTertiary: const Color(0x80F4F4F5),
    contentStandardQuaternary: const Color(0x4DF4F4F5),
    contentInvertedPrimary: const Color(0xFF202128),
    contentInvertedSecondary: const Color(0x99202128),
    contentInvertedTertiary: const Color(0x66202128),
    contentInvertedQuaternary: const Color(0x33202128),
    lineDivider: const Color(0x52797B8A),
    lineOutline: const Color(0x3D797B8A),
    componentsFillStandardPrimary: const Color(0xFF131314),
    componentsFillStandardSecondary: const Color(0xFF161617),
    componentsFillStandardTertiary: const Color(0xFF1B1C1D),
    componentsFillInvertedPrimary: const Color(0xFFFEFEFF),
    componentsFillInvertedSecondary: const Color(0xFFFAFAFA),
    componentsFillInvertedTertiary: const Color(0xFFFEFEFF),
    componentsInteractiveHover: const Color(0x14F4F4F5),
    componentsInteractiveFocused: const Color(0x1FF4F4F5),
    componentsInteractivePressed: const Color(0x29F4F4F5),
    componentsTranslucentPrimary: const Color(0x33797C8A),
    componentsTranslucentSecondary: const Color(0x2E797C8A),
    componentsTranslucentTertiary: const Color(0x29797C8A),
    coreAccent: const Color(0xFFED8B00),
    coreAccentTranslucent: const Color(0x33ED8B00),
    coreStatusPositive: const Color(0xFF32CC58),
    coreStatusWarning: const Color(0xFFF5C905),
    coreStatusNegative: const Color(0xFFFF4035),
    syntaxComment: const Color(0x80F4F4F5),
    syntaxFunction: const Color(0xFF5B59DE),
    syntaxVariable: const Color(0xFFE08804),
    syntaxString: const Color(0xFF32CC58),
    syntaxConstant: const Color(0xFF057FFF),
    syntaxOperator: const Color(0xFFB756E8),
    syntaxKeyword: const Color(0xFFFF325A),
  );
}

/// 다크 모드 타이포그래피
class CustomDarkThemeTypography extends CustomTypography {
  CustomDarkThemeTypography()
      : super(defaultColor: CustomDarkThemeColors().contentStandardPrimary);
}

/// 다크 테마 전체 구성
class CustomDarkTheme extends CustomTheme {
  CustomDarkTheme()
      : super(
      colors: CustomDarkThemeColors(),
      textStyle: CustomDarkThemeTypography());
}