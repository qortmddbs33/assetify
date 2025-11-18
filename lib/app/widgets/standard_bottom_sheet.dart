import 'package:flutter/material.dart';

import '../core/theme/colors.dart';
import '../core/theme/static.dart';
import '../core/theme/typography.dart';

typedef StandardBottomSheetBuilder =
    Widget Function(
      BuildContext sheetContext,
      CustomColors colorTheme,
      CustomTypography textTheme,
    );

Future<T?> showStandardBottomSheet<T>(
  BuildContext context,
  StandardBottomSheetBuilder builder,
) {
  final CustomColors colorTheme = Theme.of(context).extension<CustomColors>()!;
  final CustomTypography textTheme = Theme.of(
    context,
  ).extension<CustomTypography>()!;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: colorTheme.componentsFillStandardPrimary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(CustomRadius.radius600),
      ),
    ),
    clipBehavior: Clip.antiAlias,
    builder: (sheetContext) {
      final double bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: CustomSpacing.spacing500,
            right: CustomSpacing.spacing500,
            top: CustomSpacing.spacing400,
            bottom: bottomInset + CustomSpacing.spacing400,
          ),
          child: builder(sheetContext, colorTheme, textTheme),
        ),
      );
    },
  );
}

class StandardSheetContentWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final CustomColors colorTheme;
  final CustomTypography textTheme;
  final VoidCallback onClose;

  const StandardSheetContentWrapper({
    super.key,
    required this.title,
    required this.child,
    required this.colorTheme,
    required this.textTheme,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 4,
              margin: const EdgeInsets.only(bottom: CustomSpacing.spacing400),
              decoration: BoxDecoration(
                color: colorTheme.lineOutline.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: textTheme.title.copyWith(
                    color: colorTheme.contentStandardPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: CustomSpacing.spacing300),
          child,
        ],
      ),
    );
  }
}

class StandardSheetCard extends StatelessWidget {
  final Widget child;
  final CustomColors colorTheme;

  const StandardSheetCard({
    super.key,
    required this.child,
    required this.colorTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(CustomSpacing.spacing400),
      decoration: BoxDecoration(
        color: colorTheme.componentsFillStandardSecondary,
        borderRadius: BorderRadius.circular(CustomRadius.radius600),
      ),
      child: child,
    );
  }
}

class StandardSheetListTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final CustomColors colorTheme;
  final CustomTypography textTheme;
  final bool destructive;

  const StandardSheetListTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.colorTheme,
    required this.textTheme,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = destructive
        ? colorTheme.coreStatusNegative
        : colorTheme.contentStandardPrimary;
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(label, style: textTheme.body.copyWith(color: textColor)),
      onTap: onTap,
    );
  }
}

class StandardSheetActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool primary;
  final bool destructive;
  final CustomColors colorTheme;
  final CustomTypography textTheme;
  final bool enabled;

  const StandardSheetActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.colorTheme,
    required this.textTheme,
    this.primary = false,
    this.destructive = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (primary) {
      final Color background = destructive
          ? colorTheme.coreStatusNegative
          : colorTheme.coreAccent;
      return Expanded(
        child: FilledButton(
          onPressed: enabled ? onPressed : null,
          style: FilledButton.styleFrom(
            backgroundColor: background,
            foregroundColor: colorTheme.contentInvertedPrimary,
            padding: EdgeInsets.symmetric(vertical: CustomSpacing.spacing400),
          ),
          child: Text(
            label,
            style: textTheme.heading.copyWith(
              color: colorTheme.contentInvertedPrimary,
            ),
          ),
        ),
      );
    }
    final Color textColor = destructive
        ? colorTheme.coreStatusNegative
        : colorTheme.contentStandardPrimary;
    return Expanded(
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: BorderSide(
            color: destructive
                ? colorTheme.coreStatusNegative
                : colorTheme.lineOutline,
          ),
          padding: EdgeInsets.symmetric(vertical: CustomSpacing.spacing400),
        ),
        child: Text(label, style: textTheme.heading.copyWith(color: textColor)),
      ),
    );
  }
}
