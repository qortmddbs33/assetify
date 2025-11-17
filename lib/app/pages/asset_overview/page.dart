import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/static.dart';
import '../../core/theme/typography.dart';
import '../../routes/routes.dart';
import '../../services/notion/model.dart';
import 'controller.dart';

class AssetOverviewPage extends GetView<AssetOverviewController> {
  const AssetOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<CustomColors>()!;
    final textTheme = Theme.of(context).extension<CustomTypography>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '자산 현황',
          style: textTheme.heading.copyWith(
            color: colorTheme.contentStandardPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CustomSpacing.spacing550,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '전체 자산 리스트',
              style: textTheme.body.copyWith(
                color: colorTheme.contentStandardSecondary,
              ),
            ),
            const SizedBox(height: CustomSpacing.spacing500),
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: colorTheme.coreAccent,
                      strokeWidth: 3,
                    ),
                  );
                }

                if (controller.errorMessage.isNotEmpty) {
                  return _AssetOverviewEmpty(
                    title: controller.errorMessage,
                    subtitle: '네트워크 연결을 확인한 뒤 다시 시도해주세요.',
                    buttonLabel: '다시 시도',
                    onTap: controller.loadAssets,
                    colorTheme: colorTheme,
                    textTheme: textTheme,
                    icon: Icons.cloud_off,
                  );
                }

                if (controller.items.isEmpty) {
                  return _AssetOverviewEmpty(
                    title: '등록된 자산이 없어요.',
                    subtitle: 'Notion에 자산을 추가하면 여기에 표시됩니다.',
                    buttonLabel: '새로고침',
                    onTap: controller.loadAssets,
                    colorTheme: colorTheme,
                    textTheme: textTheme,
                    icon: Icons.inventory_2_outlined,
                  );
                }

                return RefreshIndicator(
                  color: colorTheme.coreAccent,
                  onRefresh: controller.loadAssets,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: CustomSpacing.spacing400),
                    itemBuilder: (_, index) {
                      final page = controller.items[index];
                      return _AssetOverviewCard(
                        page: page,
                        colorTheme: colorTheme,
                        textTheme: textTheme,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssetOverviewCard extends StatelessWidget {
  final NotionPage page;
  final CustomColors colorTheme;
  final CustomTypography textTheme;

  const _AssetOverviewCard({
    required this.page,
    required this.colorTheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final props = page.properties;
    final statusColor = _statusColor(props.status, colorTheme);

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.ASSET_DETAIL, arguments: page),
      child: Container(
        padding: const EdgeInsets.all(CustomSpacing.spacing500),
        decoration: BoxDecoration(
          color: colorTheme.componentsFillStandardPrimary,
          borderRadius: BorderRadius.circular(CustomRadius.radius600),
          border: Border.all(color: colorTheme.lineOutline.withOpacity(0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    props.assetNumber.isEmpty ? '자산번호 없음' : props.assetNumber,
                    style: textTheme.heading.copyWith(
                      color: colorTheme.contentStandardPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CustomSpacing.spacing400,
                    vertical: CustomSpacing.spacing150,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(CustomRadius.radius500),
                  ),
                  child: Text(
                    props.status,
                    style: textTheme.footnote.copyWith(color: statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: CustomSpacing.spacing400),
            _InfoRow(
              label: '제조사',
              value: props.manufacturer,
              textTheme: textTheme,
              colorTheme: colorTheme,
            ),
            const SizedBox(height: CustomSpacing.spacing150),
            _InfoRow(
              label: 'CPU',
              value: props.CPU,
              textTheme: textTheme,
              colorTheme: colorTheme,
            ),
            const SizedBox(height: CustomSpacing.spacing150),
            _InfoRow(
              label: 'RAM',
              value: props.RAM,
              textTheme: textTheme,
              colorTheme: colorTheme,
            ),
            const SizedBox(height: CustomSpacing.spacing150),
            _InfoRow(
              label: '사용자',
              value: props.user,
              textTheme: textTheme,
              colorTheme: colorTheme,
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status, CustomColors colorTheme) {
    final normalized = status.toLowerCase();
    if (normalized.contains('사용')) {
      return colorTheme.coreStatusPositive;
    }
    if (normalized.contains('재고')) {
      return colorTheme.coreAccent;
    }
    if (normalized.contains('폐기') || normalized.contains('수리')) {
      return colorTheme.coreStatusNegative;
    }
    return colorTheme.contentStandardSecondary;
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final CustomTypography textTheme;
  final CustomColors colorTheme;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.textTheme,
    required this.colorTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: textTheme.footnote.copyWith(
              color: colorTheme.contentStandardTertiary,
            ),
          ),
        ),
        const SizedBox(width: CustomSpacing.spacing200),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            style: textTheme.body.copyWith(
              color: colorTheme.contentStandardSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _AssetOverviewEmpty extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;
  final IconData icon;
  final CustomColors colorTheme;
  final CustomTypography textTheme;

  const _AssetOverviewEmpty({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
    required this.icon,
    required this.colorTheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: colorTheme.contentStandardSecondary),
          const SizedBox(height: CustomSpacing.spacing400),
          Text(
            title,
            style: textTheme.heading.copyWith(
              color: colorTheme.contentStandardPrimary,
            ),
          ),
          const SizedBox(height: CustomSpacing.spacing200),
          Text(
            subtitle,
            style: textTheme.label.copyWith(
              color: colorTheme.contentStandardSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: CustomSpacing.spacing400),
          FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: colorTheme.coreAccent,
              foregroundColor: colorTheme.contentInvertedPrimary,
            ),
            child: Text(
              buttonLabel,
              style: textTheme.label.copyWith(
                color: colorTheme.contentInvertedPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
