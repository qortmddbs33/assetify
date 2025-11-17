import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/static.dart';
import '../../core/theme/typography.dart';
import 'controller.dart';

class AssetLookupPage extends GetView<AssetLookupController> {
  const AssetLookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<CustomColors>()!;
    final textTheme = Theme.of(context).extension<CustomTypography>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '자산 조회',
          style: textTheme.heading.copyWith(
            color: colorTheme.contentStandardPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacing.spacing700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '자산번호로 검색해 상세 정보를 확인하세요.',
              style: textTheme.body.copyWith(
                color: colorTheme.contentStandardSecondary,
              ),
            ),
            const SizedBox(height: CustomSpacing.spacing600),
            TextField(
              controller: controller.assetNumberController,
              onSubmitted: (_) => controller.searchAsset(),
              decoration: InputDecoration(
                labelText: '자산번호',
                hintText: '예: 2309-N0001',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(CustomRadius.radius600),
                ),
              ),
            ),
            const SizedBox(height: CustomSpacing.spacing200),
            Obx(() {
              if (controller.errorMessage.isEmpty) {
                return const SizedBox.shrink();
              }
              return Text(
                controller.errorMessage,
                style: textTheme.footnote.copyWith(
                  color: colorTheme.coreStatusNegative,
                ),
              );
            }),
            const Spacer(),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: controller.isLoading
                      ? null
                      : controller.searchAsset,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorTheme.coreAccent,
                    foregroundColor: colorTheme.contentInvertedPrimary,
                    padding: EdgeInsets.symmetric(
                      vertical: CustomSpacing.spacing400,
                    ),
                  ),
                  child: controller.isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorTheme.contentInvertedPrimary,
                          ),
                        )
                      : Text(
                          '자산 조회하기',
                          style: textTheme.heading.copyWith(
                            color: colorTheme.contentInvertedPrimary,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
