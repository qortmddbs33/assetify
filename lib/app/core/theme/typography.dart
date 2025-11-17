import 'package:flutter/material.dart';

TextStyle style(FontWeight weight, double size, double height, Color color,
        {bool underlined = false, double spacing = 0}) =>
    TextStyle(
      color: color,
      height: height / size,
      fontSize: size,
      fontFamily: 'WantedSans',
      fontWeight: weight,
      letterSpacing: spacing,
      decoration: underlined ? TextDecoration.underline : TextDecoration.none,
      decorationColor: color,
    );

abstract class Weight {
  static const thin = FontWeight.w100;
  static const extraLight = FontWeight.w200;
  static const light = FontWeight.w300;
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semiBold = FontWeight.w600;
  static const bold = FontWeight.w700;
  static const extraBold = FontWeight.w800;
  static const heavy = FontWeight.w900;
}

class CustomTypography extends ThemeExtension<CustomTypography> {
  final Color defaultColor;

  CustomTypography({
    required this.defaultColor,
    TextStyle? display,
    TextStyle? title,
    TextStyle? heading,
    TextStyle? body,
    TextStyle? label,
    TextStyle? footnote,
    TextStyle? caption,
  })  : display = display ??
            style(Weight.semiBold, 48, 64, defaultColor, spacing: -1.44),
        title = title ??
            style(Weight.semiBold, 24, 32, defaultColor, spacing: -0.48),
        heading = heading ??
            style(Weight.semiBold, 20, 28, defaultColor, spacing: -0.4),
        body =
            body ?? style(Weight.regular, 16, 24, defaultColor, spacing: -0.32),
        label = label ??
            style(Weight.regular, 14, 22, defaultColor, spacing: -0.28),
        footnote = footnote ??
            style(Weight.regular, 12, 20, defaultColor, spacing: -0.24),
        caption = caption ??
            style(Weight.regular, 10, 16, defaultColor, spacing: -0.2);

  final TextStyle display;
  final TextStyle title;
  final TextStyle heading;
  final TextStyle body;
  final TextStyle label;
  final TextStyle footnote;
  final TextStyle caption;

  @override
  ThemeExtension<CustomTypography> copyWith({
    Color? defaultColor,
    TextStyle? display,
    TextStyle? title,
    TextStyle? heading,
    TextStyle? body,
    TextStyle? label,
    TextStyle? footnote,
    TextStyle? caption,
  }) {
    return CustomTypography(
      defaultColor: defaultColor ?? this.defaultColor,
      display: display ?? this.display,
      title: title ?? this.title,
      heading: heading ?? this.heading,
      body: body ?? this.body,
      label: label ?? this.label,
      footnote: footnote ?? this.footnote,
      caption: caption ?? this.caption,
    );
  }

  @override
  ThemeExtension<CustomTypography> lerp(
      covariant ThemeExtension<CustomTypography>? other, double t) {
    if (other is! CustomTypography) {
      return this;
    }
    return CustomTypography(
      defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
      display: TextStyle.lerp(display, other.display, t),
      title: TextStyle.lerp(title, other.title, t),
      heading: TextStyle.lerp(heading, other.heading, t),
      body: TextStyle.lerp(body, other.body, t),
      label: TextStyle.lerp(label, other.label, t),
      footnote: TextStyle.lerp(footnote, other.footnote, t),
      caption: TextStyle.lerp(caption, other.caption, t),
    );
  }
}
