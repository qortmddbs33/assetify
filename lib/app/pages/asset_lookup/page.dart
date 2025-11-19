import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/static.dart';
import '../../core/theme/typography.dart';
import 'controller.dart';

class AssetLookupPage extends GetView<AssetLookupController> {
  const AssetLookupPage({super.key});

  Future<void> _openBarcodeScanner(BuildContext context) async {
    var hasResult = false;
    final scannedValue = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (scannerContext) => Scaffold(
          appBar: AppBar(title: const Text('바코드 스캔')),
          body: MobileScanner(
            onDetect: (capture) {
              if (hasResult || capture.barcodes.isEmpty) {
                return;
              }
              final rawValue = capture.barcodes
                      .firstWhere(
                        (barcode) => (barcode.rawValue ?? '').isNotEmpty,
                        orElse: () => capture.barcodes.first,
                      )
                      .rawValue ??
                  '';
              if (rawValue.isEmpty) {
                return;
              }
              hasResult = true;
              Navigator.of(scannerContext).pop(rawValue);
            },
          ),
        ),
      ),
    );

    if (scannedValue == null || scannedValue.isEmpty) {
      return;
    }

    controller.assetNumberController.text = scannedValue;
    await controller.searchAsset();
  }

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
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  tooltip: '바코드로 입력',
                  onPressed: () => _openBarcodeScanner(context),
                ),
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
