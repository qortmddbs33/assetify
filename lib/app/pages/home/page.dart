import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/static.dart';
import '../../core/theme/typography.dart';
import '../../routes/routes.dart';
import '../../widgets/gesture_detector.dart';
import '../../widgets/standard_bottom_sheet.dart';
import 'controller.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<CustomColors>()!;
    final textTheme = Theme.of(context).extension<CustomTypography>()!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CustomSpacing.spacing700,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: CustomSpacing.spacing1000),
              RichText(
                text: TextSpan(
                  style: textTheme.display.copyWith(
                    color: colorTheme.contentStandardPrimary,
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: 'Assetify'),
                    TextSpan(
                      text: '.',
                      style: TextStyle(color: colorTheme.coreAccent),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: CustomSpacing.spacing200),
              Text(
                '사내 자산 정보을 간편하게 확인하고\nNotion 기반 데이터를 편리하게 관리하세요.',
                style: textTheme.body.copyWith(
                  color: colorTheme.contentStandardSecondary,
                ),
              ),
              const SizedBox(height: CustomSpacing.spacing700),
              Obx(() {
                return _ApiKeySection(
                  controller: controller,
                  colorTheme: colorTheme,
                  textTheme: textTheme,
                  hasKey: controller.hasStoredApiKey,
                );
              }),
              const SizedBox(height: CustomSpacing.spacing700),
              _HomeMenuGrid(
                colorTheme: colorTheme,
                textTheme: textTheme,
                controller: controller,
              ),
              const Spacer(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomGestureDetectorWithOpacityInteraction(
                      onTap: () => Get.toNamed(Routes.LICENSE),
                      child: Text(
                        'Open Source License',
                        style: textTheme.label.copyWith(
                          color: colorTheme.contentStandardTertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: CustomSpacing.spacing200),
                    Text(
                      '© 2025 IdsTrust. All rights reserved.',
                      style: textTheme.label.copyWith(
                        color: colorTheme.contentStandardTertiary,
                      ),
                    ),
                    const SizedBox(height: CustomSpacing.spacing550),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeMenuGrid extends StatelessWidget {
  final CustomColors colorTheme;
  final CustomTypography textTheme;
  final HomePageController controller;

  const _HomeMenuGrid({
    required this.colorTheme,
    required this.textTheme,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final menus = [
      _HomeMenuItem(
        title: '자산 조회',
        description: '자산을 검색하고, 정보를 변경할 수 있어요.',
        onTap: () => controller.navigateOrWarn(Routes.ASSET_LOOKUP),
      ),
      _HomeMenuItem(
        title: '빠른 상태 변경',
        description: '바코드로 상태를 한 번에 변경할 수 있어요.',
        onTap: () => controller.navigateOrWarn(Routes.QUICK_STATUS),
      ),
    ];

    return Column(
      children: menus
          .map(
            (menu) => Padding(
              padding: const EdgeInsets.only(bottom: CustomSpacing.spacing300),
              child: _HomeMenuTile(
                menu: menu,
                colorTheme: colorTheme,
                textTheme: textTheme,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _HomeMenuTile extends StatelessWidget {
  final _HomeMenuItem menu;
  final CustomColors colorTheme;
  final CustomTypography textTheme;

  const _HomeMenuTile({
    required this.menu,
    required this.colorTheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: menu.onTap,
      child: Container(
        padding: const EdgeInsets.all(CustomSpacing.spacing500),
        decoration: BoxDecoration(
          color: colorTheme.componentsFillStandardPrimary,
          borderRadius: BorderRadius.circular(CustomRadius.radius700),
          border: Border.all(color: colorTheme.lineOutline.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.title,
                    style: textTheme.heading.copyWith(
                      color: colorTheme.contentStandardPrimary,
                    ),
                  ),
                  const SizedBox(height: CustomSpacing.spacing100),
                  Text(
                    menu.description,
                    style: textTheme.label.copyWith(
                      color: colorTheme.contentStandardSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: colorTheme.contentStandardTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeMenuItem {
  final String title;
  final String description;
  final VoidCallback onTap;

  const _HomeMenuItem({
    required this.title,
    required this.description,
    required this.onTap,
  });
}

class _ApiKeySection extends StatelessWidget {
  final HomePageController controller;
  final CustomColors colorTheme;
  final CustomTypography textTheme;
  final bool hasKey;

  const _ApiKeySection({
    required this.controller,
    required this.colorTheme,
    required this.textTheme,
    required this.hasKey,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = hasKey
        ? colorTheme.coreAccent
        : colorTheme.coreStatusNegative;
    final IconData statusIcon = hasKey
        ? Icons.shield_outlined
        : Icons.warning_amber_rounded;
    final String statusMessage = hasKey
        ? 'API 키를 기기에 안전하게 보관 중이예요.'
        : 'API 키가 기기에 저장되어 있지 않아요.';
    final Color foregroundColor = colorTheme.contentInvertedPrimary;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(CustomRadius.radius700),
      child: InkWell(
        onTap: () => _openApiKeyBottomSheet(context),
        borderRadius: BorderRadius.circular(CustomRadius.radius700),
        child: Padding(
          padding: const EdgeInsets.all(CustomSpacing.spacing400),
          child: Row(
            children: [
              Icon(statusIcon, color: foregroundColor),
              const SizedBox(width: CustomSpacing.spacing200),
              Text(
                statusMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.label.copyWith(color: foregroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openApiKeyBottomSheet(BuildContext context) {
    controller.notionApiKeyController.text =
        controller.storedApiKey.value ?? '';
    showStandardBottomSheet<void>(context, (
      sheetContext,
      sheetColors,
      sheetTypography,
    ) {
      final NavigatorState navigator = Navigator.of(sheetContext);
      return Obx(() {
        final bool currentHasKey = controller.hasStoredApiKey;
        final bool isProcessing = controller.isSaving;
        return StandardSheetContentWrapper(
          title: 'Notion API 키 입력',
          colorTheme: sheetColors,
          textTheme: sheetTypography,
          onClose: navigator.pop,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StandardSheetCard(
                colorTheme: sheetColors,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notion API 키를 입력하면 기기에 암호화되어 저장돼요.',
                      style: sheetTypography.body.copyWith(
                        color: sheetColors.contentStandardSecondary,
                      ),
                    ),
                    const SizedBox(height: CustomSpacing.spacing300),
                    TextField(
                      controller: controller.notionApiKeyController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'ntn_...',
                        filled: true,
                        fillColor: sheetColors.componentsFillStandardPrimary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            CustomRadius.radius500,
                          ),
                          borderSide: BorderSide(
                            color: sheetColors.lineOutline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            CustomRadius.radius500,
                          ),
                          borderSide: BorderSide(color: sheetColors.coreAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: CustomSpacing.spacing400),
              Row(
                children: [
                  StandardSheetActionButton(
                    label: '취소',
                    onPressed: navigator.pop,
                    colorTheme: sheetColors,
                    textTheme: sheetTypography,
                    enabled: !isProcessing,
                  ),
                  const SizedBox(width: CustomSpacing.spacing300),
                  StandardSheetActionButton(
                    label: currentHasKey ? '업데이트' : '저장',
                    onPressed: () async {
                      await controller.saveApiKey();
                      navigator.pop();
                    },
                    colorTheme: sheetColors,
                    textTheme: sheetTypography,
                    primary: true,
                    enabled: !isProcessing,
                  ),
                ],
              ),
              if (currentHasKey) ...[
                const SizedBox(height: CustomSpacing.spacing300),
                Row(
                  children: [
                    StandardSheetActionButton(
                      label: 'API 키 삭제',
                      onPressed: () async {
                        await controller.clearApiKey();
                        navigator.pop();
                      },
                      colorTheme: sheetColors,
                      textTheme: sheetTypography,
                      destructive: true,
                      enabled: !isProcessing,
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      });
    });
  }
}
