/// 앱 전체에서 사용하는 커스텀 색상 정의
/// ThemeExtension을 상속하여 테마 시스템과 통합

import 'package:flutter/material.dart';

/// 커스텀 색상 테마 확장 클래스
/// 기본 색상, 배경색, 텍스트 색상, 컴포넌트 색상 등을 정의
class CustomColors extends ThemeExtension<CustomColors> {
  // 기본 단색 (Solid Colors)
  final Color solidRed;
  final Color solidOrange;
  final Color solidYellow;
  final Color solidGreen;
  final Color solidBlue;
  final Color solidIndigo;
  final Color solidPurple;
  final Color solidPink;
  final Color solidBrown;
  final Color solidBlack;
  final Color solidWhite;

  // 반투명 색상 (Translucent Colors)
  final Color solidTranslucentRed;
  final Color solidTranslucentOrange;
  final Color solidTranslucentYellow;
  final Color solidTranslucentGreen;
  final Color solidTranslucentBlue;
  final Color solidTranslucentIndigo;
  final Color solidTranslucentPurple;
  final Color solidTranslucentPink;
  final Color solidTranslucentBrown;
  final Color solidTranslucentBlack;
  final Color solidTranslucentWhite;

  // 배경색 (Background Colors)
  final Color backgroundStandardPrimary;
  final Color backgroundStandardSecondary;
  final Color backgroundInvertedPrimary;
  final Color backgroundInvertedSecondary;

  // 콘텐츠/텍스트 색상 (Content Colors)
  final Color contentStandardPrimary;
  final Color contentStandardSecondary;
  final Color contentStandardTertiary;
  final Color contentStandardQuaternary;

  final Color contentInvertedPrimary;
  final Color contentInvertedSecondary;
  final Color contentInvertedTertiary;
  final Color contentInvertedQuaternary;

  // 선/구분선 색상 (Line Colors)
  final Color lineDivider;
  final Color lineOutline;

  // 컴포넌트 채우기 색상 (Component Fill Colors)
  final Color componentsFillStandardPrimary;
  final Color componentsFillStandardSecondary;
  final Color componentsFillStandardTertiary;

  final Color componentsFillInvertedPrimary;
  final Color componentsFillInvertedSecondary;
  final Color componentsFillInvertedTertiary;

  // 인터랙션 색상 (Interactive Colors)
  final Color componentsInteractiveHover;
  final Color componentsInteractiveFocused;
  final Color componentsInteractivePressed;

  final Color componentsTranslucentPrimary;
  final Color componentsTranslucentSecondary;
  final Color componentsTranslucentTertiary;

  // 핵심 색상 (Core Colors)
  final Color coreAccent;
  final Color coreAccentTranslucent;

  final Color coreStatusPositive;
  final Color coreStatusWarning;
  final Color coreStatusNegative;

  // 코드 구문 강조 색상 (Syntax Highlighting Colors)
  final Color syntaxComment;
  final Color syntaxFunction;
  final Color syntaxVariable;
  final Color syntaxString;
  final Color syntaxConstant;
  final Color syntaxOperator;
  final Color syntaxKeyword;

  CustomColors({
    required this.solidRed,
    required this.solidOrange,
    required this.solidYellow,
    required this.solidGreen,
    required this.solidBlue,
    required this.solidIndigo,
    required this.solidPurple,
    required this.solidPink,
    required this.solidBrown,
    required this.solidBlack,
    required this.solidWhite,
    required this.solidTranslucentRed,
    required this.solidTranslucentOrange,
    required this.solidTranslucentYellow,
    required this.solidTranslucentGreen,
    required this.solidTranslucentBlue,
    required this.solidTranslucentIndigo,
    required this.solidTranslucentPurple,
    required this.solidTranslucentPink,
    required this.solidTranslucentBrown,
    required this.solidTranslucentBlack,
    required this.solidTranslucentWhite,
    required this.backgroundStandardPrimary,
    required this.backgroundStandardSecondary,
    required this.backgroundInvertedPrimary,
    required this.backgroundInvertedSecondary,
    required this.contentStandardPrimary,
    required this.contentStandardSecondary,
    required this.contentStandardTertiary,
    required this.contentStandardQuaternary,
    required this.contentInvertedPrimary,
    required this.contentInvertedSecondary,
    required this.contentInvertedTertiary,
    required this.contentInvertedQuaternary,
    required this.lineDivider,
    required this.lineOutline,
    required this.componentsFillStandardPrimary,
    required this.componentsFillStandardSecondary,
    required this.componentsFillStandardTertiary,
    required this.componentsFillInvertedPrimary,
    required this.componentsFillInvertedSecondary,
    required this.componentsFillInvertedTertiary,
    required this.componentsInteractiveHover,
    required this.componentsInteractiveFocused,
    required this.componentsInteractivePressed,
    required this.componentsTranslucentPrimary,
    required this.componentsTranslucentSecondary,
    required this.componentsTranslucentTertiary,
    required this.coreAccent,
    required this.coreAccentTranslucent,
    required this.coreStatusPositive,
    required this.coreStatusWarning,
    required this.coreStatusNegative,
    required this.syntaxComment,
    required this.syntaxFunction,
    required this.syntaxVariable,
    required this.syntaxString,
    required this.syntaxConstant,
    required this.syntaxOperator,
    required this.syntaxKeyword,
  });

  /// 특정 색상만 변경한 새 인스턴스 생성
  @override
  ThemeExtension<CustomColors> copyWith({
    Color? solidRed,
    Color? solidOrange,
    Color? solidYellow,
    Color? solidGreen,
    Color? solidBlue,
    Color? solidIndigo,
    Color? solidPurple,
    Color? solidPink,
    Color? solidBrown,
    Color? solidBlack,
    Color? solidWhite,
    Color? solidTranslucentRed,
    Color? solidTranslucentOrange,
    Color? solidTranslucentYellow,
    Color? solidTranslucentGreen,
    Color? solidTranslucentBlue,
    Color? solidTranslucentIndigo,
    Color? solidTranslucentPurple,
    Color? solidTranslucentPink,
    Color? solidTranslucentBrown,
    Color? solidTranslucentBlack,
    Color? solidTranslucentWhite,
    Color? backgroundStandardPrimary,
    Color? backgroundStandardSecondary,
    Color? backgroundInvertedPrimary,
    Color? backgroundInvertedSecondary,
    Color? contentStandardPrimary,
    Color? contentStandardSecondary,
    Color? contentStandardTertiary,
    Color? contentStandardQuaternary,
    Color? contentInvertedPrimary,
    Color? contentInvertedSecondary,
    Color? contentInvertedTertiary,
    Color? contentInvertedQuaternary,
    Color? lineDivider,
    Color? lineOutline,
    Color? componentsFillStandardPrimary,
    Color? componentsFillStandardSecondary,
    Color? componentsFillStandardTertiary,
    Color? componentsFillInvertedPrimary,
    Color? componentsFillInvertedSecondary,
    Color? componentsFillInvertedTertiary,
    Color? componentsInteractiveHover,
    Color? componentsInteractiveFocused,
    Color? componentsInteractivePressed,
    Color? componentsTranslucentPrimary,
    Color? componentsTranslucentSecondary,
    Color? componentsTranslucentTertiary,
    Color? coreAccent,
    Color? coreAccentTranslucent,
    Color? coreStatusPositive,
    Color? coreStatusWarning,
    Color? coreStatusNegative,
    Color? syntaxComment,
    Color? syntaxFunction,
    Color? syntaxVariable,
    Color? syntaxString,
    Color? syntaxConstant,
    Color? syntaxOperator,
    Color? syntaxKeyword,
  }) {
    return CustomColors(
      solidRed: solidRed ?? this.solidRed,
      solidOrange: solidOrange ?? this.solidOrange,
      solidYellow: solidYellow ?? this.solidYellow,
      solidGreen: solidGreen ?? this.solidGreen,
      solidBlue: solidBlue ?? this.solidBlue,
      solidIndigo: solidIndigo ?? this.solidIndigo,
      solidPurple: solidPurple ?? this.solidPurple,
      solidPink: solidPink ?? this.solidPink,
      solidBrown: solidBrown ?? this.solidBrown,
      solidBlack: solidBlack ?? this.solidBlack,
      solidWhite: solidWhite ?? this.solidWhite,
      solidTranslucentRed: solidTranslucentRed ?? this.solidTranslucentRed,
      solidTranslucentOrange: solidTranslucentOrange ?? this.solidTranslucentOrange,
      solidTranslucentYellow: solidTranslucentYellow ?? this.solidTranslucentYellow,
      solidTranslucentGreen: solidTranslucentGreen ?? this.solidTranslucentGreen,
      solidTranslucentBlue: solidTranslucentBlue ?? this.solidTranslucentBlue,
      solidTranslucentIndigo: solidTranslucentIndigo ?? this.solidTranslucentIndigo,
      solidTranslucentPurple: solidTranslucentPurple ?? this.solidTranslucentPurple,
      solidTranslucentPink: solidTranslucentPink ?? this.solidTranslucentPink,
      solidTranslucentBrown: solidTranslucentBrown ?? this.solidTranslucentBrown,
      solidTranslucentBlack: solidTranslucentBlack ?? this.solidTranslucentBlack,
      solidTranslucentWhite: solidTranslucentWhite ?? this.solidTranslucentWhite,
      backgroundStandardPrimary: backgroundStandardPrimary ?? this.backgroundStandardPrimary,
      backgroundStandardSecondary: backgroundStandardSecondary ?? this.backgroundStandardSecondary,
      backgroundInvertedPrimary: backgroundInvertedPrimary ?? this.backgroundInvertedPrimary,
      backgroundInvertedSecondary: backgroundInvertedSecondary ?? this.backgroundInvertedSecondary,
      contentStandardPrimary: contentStandardPrimary ?? this.contentStandardPrimary,
      contentStandardSecondary: contentStandardSecondary ?? this.contentStandardSecondary,
      contentStandardTertiary: contentStandardTertiary ?? this.contentStandardTertiary,
      contentStandardQuaternary: contentStandardQuaternary ?? this.contentStandardQuaternary,
      contentInvertedPrimary: contentInvertedPrimary ?? this.contentInvertedPrimary,
      contentInvertedSecondary: contentInvertedSecondary ?? this.contentInvertedSecondary,
      contentInvertedTertiary: contentInvertedTertiary ?? this.contentInvertedTertiary,
      contentInvertedQuaternary: contentInvertedQuaternary ?? this.contentInvertedQuaternary,
      lineDivider: lineDivider ?? this.lineDivider,
      lineOutline: lineOutline ?? this.lineOutline,
      componentsFillStandardPrimary: componentsFillStandardPrimary ?? this.componentsFillStandardPrimary,
      componentsFillStandardSecondary: componentsFillStandardSecondary ?? this.componentsFillStandardSecondary,
      componentsFillStandardTertiary: componentsFillStandardTertiary ?? this.componentsFillStandardTertiary,
      componentsFillInvertedPrimary: componentsFillInvertedPrimary ?? this.componentsFillInvertedPrimary,
      componentsFillInvertedSecondary: componentsFillInvertedSecondary ?? this.componentsFillInvertedSecondary,
      componentsFillInvertedTertiary: componentsFillInvertedTertiary ?? this.componentsFillInvertedTertiary,
      componentsInteractiveHover: componentsInteractiveHover ?? this.componentsInteractiveHover,
      componentsInteractiveFocused: componentsInteractiveFocused ?? this.componentsInteractiveFocused,
      componentsInteractivePressed: componentsInteractivePressed ?? this.componentsInteractivePressed,
      componentsTranslucentPrimary: componentsTranslucentPrimary ?? this.componentsTranslucentPrimary,
      componentsTranslucentSecondary: componentsTranslucentSecondary ?? this.componentsTranslucentSecondary,
      componentsTranslucentTertiary: componentsTranslucentTertiary ?? this.componentsTranslucentTertiary,
      coreAccent: coreAccent ?? this.coreAccent,
      coreAccentTranslucent: coreAccentTranslucent ?? this.coreAccentTranslucent,
      coreStatusPositive: coreStatusPositive ?? this.coreStatusPositive,
      coreStatusWarning: coreStatusWarning ?? this.coreStatusWarning,
      coreStatusNegative: coreStatusNegative ?? this.coreStatusNegative,
      syntaxComment: syntaxComment ?? this.syntaxComment,
      syntaxFunction: syntaxFunction ?? this.syntaxFunction,
      syntaxVariable: syntaxVariable ?? this.syntaxVariable,
      syntaxString: syntaxString ?? this.syntaxString,
      syntaxConstant: syntaxConstant ?? this.syntaxConstant,
      syntaxOperator: syntaxOperator ?? this.syntaxOperator,
      syntaxKeyword: syntaxKeyword ?? this.syntaxKeyword,
    );
  }

  /// 테마 전환 시 색상 보간 처리
  @override
  ThemeExtension<CustomColors> lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      solidRed: Color.lerp(solidRed, other.solidRed, t)!,
      solidOrange: Color.lerp(solidOrange, other.solidOrange, t)!,
      solidYellow: Color.lerp(solidYellow, other.solidYellow, t)!,
      solidGreen: Color.lerp(solidGreen, other.solidGreen, t)!,
      solidBlue: Color.lerp(solidBlue, other.solidBlue, t)!,
      solidIndigo: Color.lerp(solidIndigo, other.solidIndigo, t)!,
      solidPurple: Color.lerp(solidPurple, other.solidPurple, t)!,
      solidPink: Color.lerp(solidPink, other.solidPink, t)!,
      solidBrown: Color.lerp(solidBrown, other.solidBrown, t)!,
      solidBlack: Color.lerp(solidBlack, other.solidBlack, t)!,
      solidWhite: Color.lerp(solidWhite, other.solidWhite, t)!,
      solidTranslucentRed: Color.lerp(solidTranslucentRed, other.solidTranslucentRed, t)!,
      solidTranslucentOrange: Color.lerp(solidTranslucentOrange, other.solidTranslucentOrange, t)!,
      solidTranslucentYellow: Color.lerp(solidTranslucentYellow, other.solidTranslucentYellow, t)!,
      solidTranslucentGreen: Color.lerp(solidTranslucentGreen, other.solidTranslucentGreen, t)!,
      solidTranslucentBlue: Color.lerp(solidTranslucentBlue, other.solidTranslucentBlue, t)!,
      solidTranslucentIndigo: Color.lerp(solidTranslucentIndigo, other.solidTranslucentIndigo, t)!,
      solidTranslucentPurple: Color.lerp(solidTranslucentPurple, other.solidTranslucentPurple, t)!,
      solidTranslucentPink: Color.lerp(solidTranslucentPink, other.solidTranslucentPink, t)!,
      solidTranslucentBrown: Color.lerp(solidTranslucentBrown, other.solidTranslucentBrown, t)!,
      solidTranslucentBlack: Color.lerp(solidTranslucentBlack, other.solidTranslucentBlack, t)!,
      solidTranslucentWhite: Color.lerp(solidTranslucentWhite, other.solidTranslucentWhite, t)!,
      backgroundStandardPrimary: Color.lerp(backgroundStandardPrimary, other.backgroundStandardPrimary, t)!,
      backgroundStandardSecondary: Color.lerp(backgroundStandardSecondary, other.backgroundStandardSecondary, t)!,
      backgroundInvertedPrimary: Color.lerp(backgroundInvertedPrimary, other.backgroundInvertedPrimary, t)!,
      backgroundInvertedSecondary: Color.lerp(backgroundInvertedSecondary, other.backgroundInvertedSecondary, t)!,
      contentStandardPrimary: Color.lerp(contentStandardPrimary, other.contentStandardPrimary, t)!,
      contentStandardSecondary: Color.lerp(contentStandardSecondary, other.contentStandardSecondary, t)!,
      contentStandardTertiary: Color.lerp(contentStandardTertiary, other.contentStandardTertiary, t)!,
      contentStandardQuaternary: Color.lerp(contentStandardQuaternary, other.contentStandardQuaternary, t)!,
      contentInvertedPrimary: Color.lerp(contentInvertedPrimary, other.contentInvertedPrimary, t)!,
      contentInvertedSecondary: Color.lerp(contentInvertedSecondary, other.contentInvertedSecondary, t)!,
      contentInvertedTertiary: Color.lerp(contentInvertedTertiary, other.contentInvertedTertiary, t)!,
      contentInvertedQuaternary: Color.lerp(contentInvertedQuaternary, other.contentInvertedQuaternary, t)!,
      lineDivider: Color.lerp(lineDivider, other.lineDivider, t)!,
      lineOutline: Color.lerp(lineOutline, other.lineOutline, t)!,
      componentsFillStandardPrimary: Color.lerp(componentsFillStandardPrimary, other.componentsFillStandardPrimary, t)!,
      componentsFillStandardSecondary: Color.lerp(componentsFillStandardSecondary, other.componentsFillStandardSecondary, t)!,
      componentsFillStandardTertiary: Color.lerp(componentsFillStandardTertiary, other.componentsFillStandardTertiary, t)!,
      componentsFillInvertedPrimary: Color.lerp(componentsFillInvertedPrimary, other.componentsFillInvertedPrimary, t)!,
      componentsFillInvertedSecondary: Color.lerp(componentsFillInvertedSecondary, other.componentsFillInvertedSecondary, t)!,
      componentsFillInvertedTertiary: Color.lerp(componentsFillInvertedTertiary, other.componentsFillInvertedTertiary, t)!,
      componentsInteractiveHover: Color.lerp(componentsInteractiveHover, other.componentsInteractiveHover, t)!,
      componentsInteractiveFocused: Color.lerp(componentsInteractiveFocused, other.componentsInteractiveFocused, t)!,
      componentsInteractivePressed: Color.lerp(componentsInteractivePressed, other.componentsInteractivePressed, t)!,
      componentsTranslucentPrimary: Color.lerp(componentsTranslucentPrimary, other.componentsTranslucentPrimary, t)!,
      componentsTranslucentSecondary: Color.lerp(componentsTranslucentSecondary, other.componentsTranslucentSecondary, t)!,
      componentsTranslucentTertiary: Color.lerp(componentsTranslucentTertiary, other.componentsTranslucentTertiary, t)!,
      coreAccent: Color.lerp(coreAccent, other.coreAccent, t)!,
      coreAccentTranslucent: Color.lerp(coreAccentTranslucent, other.coreAccentTranslucent, t)!,
      coreStatusPositive: Color.lerp(coreStatusPositive, other.coreStatusPositive, t)!,
      coreStatusWarning: Color.lerp(coreStatusWarning, other.coreStatusWarning, t)!,
      coreStatusNegative: Color.lerp(coreStatusNegative, other.coreStatusNegative, t)!,
      syntaxComment: Color.lerp(syntaxComment, other.syntaxComment, t)!,
      syntaxFunction: Color.lerp(syntaxFunction, other.syntaxFunction, t)!,
      syntaxVariable: Color.lerp(syntaxVariable, other.syntaxVariable, t)!,
      syntaxString: Color.lerp(syntaxString, other.syntaxString, t)!,
      syntaxConstant: Color.lerp(syntaxConstant, other.syntaxConstant, t)!,
      syntaxOperator: Color.lerp(syntaxOperator, other.syntaxOperator, t)!,
      syntaxKeyword: Color.lerp(syntaxKeyword, other.syntaxKeyword, t)!,
    );
  }
}