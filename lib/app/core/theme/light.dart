/// 라이트 테마 색상 및 스타일 정의

import 'package:flutter/material.dart';

import 'colors.dart';
import 'theme.dart';
import 'typography.dart';

/// 라이트 모드 색상 정의
/// 밝은 배경에 어두운 텍스트 색상 사용
class CustomLightThemeColors extends CustomColors {
  CustomLightThemeColors()
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
        solidTranslucentRed: const Color(0x1AFF4035),
        solidTranslucentOrange: const Color(0x1AFF9A05),
        solidTranslucentYellow: const Color(0x1AF5C905),
        solidTranslucentGreen: const Color(0x1A32CC58),
        solidTranslucentBlue: const Color(0x1A057FFF),
        solidTranslucentIndigo: const Color(0x1A5B59DE),
        solidTranslucentPurple: const Color(0x1AB756E8),
        solidTranslucentPink: const Color(0x1AFF325A),
        solidTranslucentBrown: const Color(0x1AA78963),
        solidTranslucentBlack: const Color(0x1A000000),
        solidTranslucentWhite: const Color(0x1AFFFFFF),
        backgroundStandardPrimary: const Color(0xFFFFFFFF),
        backgroundStandardSecondary: const Color(0xFFEDEEF2),
        backgroundInvertedPrimary: const Color(0xFF000000),
        backgroundInvertedSecondary: const Color(0xFF0E0E0F),
        contentStandardPrimary: const Color(0xFF292A2E),
        contentStandardSecondary: const Color(0xB3292A2E),
        contentStandardTertiary: const Color(0x80292A2E),
        contentStandardQuaternary: const Color(0x4D292A2E),
        contentInvertedPrimary: const Color(0xFFF4F4F5),
        contentInvertedSecondary: const Color(0x99F4F4F5),
        contentInvertedTertiary: const Color(0x66F4F4F5),
        contentInvertedQuaternary: const Color(0x33F4F4F5),
        lineDivider: const Color(0x29797B8A),
        lineOutline: const Color(0x1F797B8A),
        componentsFillStandardPrimary: const Color(0xFFFAFAFA),
        componentsFillStandardSecondary: const Color(0xFFF7F7F7),
        componentsFillStandardTertiary: const Color(0xFFF0F0F0),
        componentsFillInvertedPrimary: const Color(0xFF131314),
        componentsFillInvertedSecondary: const Color(0xFF161617),
        componentsFillInvertedTertiary: const Color(0xFF1B1C1D),
        componentsInteractiveHover: const Color(0x14292A2E),
        componentsInteractiveFocused: const Color(0x1F292A2E),
        componentsInteractivePressed: const Color(0x29292A2E),
        componentsTranslucentPrimary: const Color(0x1A797C8A),
        componentsTranslucentSecondary: const Color(0x14797C8A),
        componentsTranslucentTertiary: const Color(0x0A797C8A),
        coreAccent: const Color(0xFFED8B00),
        coreAccentTranslucent: const Color(0x1AED8B00),
        coreStatusPositive: const Color(0xFF32CC58),
        coreStatusWarning: const Color(0xFFF5C905),
        coreStatusNegative: const Color(0xFFFF4035),
        syntaxComment: const Color(0x80292A2E),
        syntaxFunction: const Color(0xFF5B59DE),
        syntaxVariable: const Color(0xFFE08804),
        syntaxString: const Color(0xFF32CC58),
        syntaxConstant: const Color(0xFF057FFF),
        syntaxOperator: const Color(0xFFB756E8),
        syntaxKeyword: const Color(0xFFFF325A),
      );
}

/// 라이트 모드 타이포그래피
class DanALightThemeTypography extends CustomTypography {
  DanALightThemeTypography()
    : super(defaultColor: CustomLightThemeColors().contentStandardPrimary);
}

/// 라이트 테마 전체 구성
class CustomLightTheme extends CustomTheme {
  CustomLightTheme()
    : super(
        colors: CustomLightThemeColors(),
        textStyle: DanALightThemeTypography(),
      );
}
