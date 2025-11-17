import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/static.dart';
import '../../core/theme/typography.dart';
import '../../routes/routes.dart';
import '../../widgets/gestureDetector.dart';
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
                '사내 자산 현황을 한눈에 확인하고\nNotion 기반 데이터를 안전하게 관리하세요.',
                style: textTheme.body.copyWith(
                  color: colorTheme.contentStandardSecondary,
                ),
              ),
              const SizedBox(height: CustomSpacing.spacing900),
              _HomeMenuGrid(colorTheme: colorTheme, textTheme: textTheme),
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

  const _HomeMenuGrid({required this.colorTheme, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    final menus = [
      _HomeMenuItem(
        title: '자산 현황',
        description: '자산을 검색하고, 상태를 확인, 변경할 수 있어요.',
        onTap: () => Get.toNamed(Routes.ASSET_OVERVIEW),
      ),
      _HomeMenuItem(
        title: '바코드 조회',
        description: '바코드를 스캔해 자산 정보를 찾을 수 있어요.',
        onTap: () {},
      ),
      _HomeMenuItem(
        title: '일괄 변경',
        description: '바코드로 상태를 한 번에 변경할 수 있어요.',
        onTap: () {},
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
