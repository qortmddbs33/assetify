import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/static.dart';
import '../../core/theme/typography.dart';
import 'controller.dart';

class QuickStatusPage extends GetView<QuickStatusController> {
  const QuickStatusPage({super.key});

  Future<void> _openBarcodeScanner(BuildContext context) async {
    while (true) {
      var hasResult = false;
      final scannedValue = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (scannerContext) => AiBarcodeScanner(
            appBarBuilder: (context, scannerController) =>
                AppBar(title: const Text('바코드 스캔')),
            onDetect: (capture) {
              if (hasResult || capture.barcodes.isEmpty) {
                return;
              }
              final rawValue = capture.barcodes.first.rawValue;
              if (rawValue == null || rawValue.isEmpty) {
                return;
              }
              hasResult = true;
              Navigator.of(scannerContext).pop(rawValue);
            },
          ),
        ),
      );

      if (scannedValue == null || scannedValue.isEmpty) {
        return;
      }

      final bool wasSuccessful =
          await controller.handleScannedValue(scannedValue);
      final bool continueScanning =
          wasSuccessful && controller.continuousModeEnabled.value;
      if (!continueScanning) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<CustomColors>()!;
    final textTheme = Theme.of(context).extension<CustomTypography>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '빠른 상태 변경',
          style: textTheme.heading.copyWith(
            color: colorTheme.contentStandardPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CustomSpacing.spacing600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusDropdown(colorTheme: colorTheme, textTheme: textTheme),
            const SizedBox(height: CustomSpacing.spacing400),
            _ScanButton(
              onScanRequested: () => _openBarcodeScanner(context),
              colorTheme: colorTheme,
              textTheme: textTheme,
            ),
            const SizedBox(height: CustomSpacing.spacing200),
            _ContinuousModeToggle(
              colorTheme: colorTheme,
              textTheme: textTheme,
            ),
            const SizedBox(height: CustomSpacing.spacing500),
            Obx(() {
              if (controller.results.isEmpty) {
                return Center(
                  child: Text(
                    '처리된 내역이 여기에 표시됩니다.',
                    style: textTheme.label.copyWith(
                      color: colorTheme.contentStandardSecondary,
                    ),
                  ),
                );
              }
              return Column(
                children: controller.results
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: CustomSpacing.spacing200,
                        ),
                        child: _ResultTile(
                          result: item,
                          colorTheme: colorTheme,
                          textTheme: textTheme,
                        ),
                      ),
                    )
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StatusDropdown extends StatelessWidget {
  final CustomColors colorTheme;
  final CustomTypography textTheme;

  const _StatusDropdown({required this.colorTheme, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    final QuickStatusController controller = Get.find<QuickStatusController>();
    return Obx(() {
      if (controller.isLoadingOptions.value) {
        return Center(
          child: CircularProgressIndicator(color: colorTheme.coreAccent),
        );
      }
      if (controller.statusOptions.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(CustomSpacing.spacing400),
          decoration: BoxDecoration(
            color: colorTheme.componentsFillStandardSecondary,
            borderRadius: BorderRadius.circular(CustomRadius.radius600),
          ),
          child: Text(
            'Notion에서 상태 옵션을 불러올 수 없어요.\n잠시 후 다시 시도해주세요.',
            style: textTheme.label.copyWith(
              color: colorTheme.coreStatusNegative,
            ),
          ),
        );
      }
      final selected = controller.selectedStatus.value;
      return DropdownButtonFormField<String>(
        value: selected.isEmpty ? null : selected,
        items: controller.statusOptions
            .map(
              (option) => DropdownMenuItem<String>(
                value: option.name,
                child: Text(option.name),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            controller.selectStatus(value);
          }
        },
        decoration: InputDecoration(
          labelText: '자산 상태',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CustomRadius.radius600),
          ),
        ),
      );
    });
  }
}

class _ScanButton extends StatelessWidget {
  final VoidCallback onScanRequested;
  final CustomColors colorTheme;
  final CustomTypography textTheme;

  const _ScanButton({
    required this.onScanRequested,
    required this.colorTheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed: onScanRequested,
        icon: const Icon(Icons.qr_code_scanner_rounded),
        iconSize: 128,
      ),
    );
  }
}

class _ContinuousModeToggle extends StatelessWidget {
  final CustomColors colorTheme;
  final CustomTypography textTheme;

  const _ContinuousModeToggle({
    required this.colorTheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final QuickStatusController controller = Get.find<QuickStatusController>();
    return Obx(
      () => CheckboxListTile(
        value: controller.continuousModeEnabled.value,
        onChanged: (value) =>
            controller.setContinuousMode(value ?? false),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: colorTheme.coreAccent,
        contentPadding: EdgeInsets.zero,
        title: Text(
          '연속으로 변경하기',
          style: textTheme.body.copyWith(
            color: colorTheme.contentStandardPrimary,
          ),
        ),
        subtitle: Text(
          '상태 변경이 완료되면 바코드 스캐너가 다시 열려요.',
          style: textTheme.caption.copyWith(
            color: colorTheme.contentStandardSecondary,
          ),
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final QuickStatusResult result;
  final CustomColors colorTheme;
  final CustomTypography textTheme;

  const _ResultTile({
    required this.result,
    required this.colorTheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = result.success
        ? colorTheme.coreStatusPositive
        : colorTheme.coreStatusNegative;
    return Container(
      padding: const EdgeInsets.all(CustomSpacing.spacing400),
      decoration: BoxDecoration(
        color: colorTheme.componentsFillStandardPrimary,
        borderRadius: BorderRadius.circular(CustomRadius.radius600),
        border: Border.all(color: colorTheme.lineOutline.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.assetNumber,
                  style: textTheme.title.copyWith(
                    color: colorTheme.contentStandardPrimary,
                  ),
                ),
                const SizedBox(height: CustomSpacing.spacing100),
                Text(
                  result.message,
                  style: textTheme.label.copyWith(
                    color: colorTheme.contentStandardSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: CustomSpacing.spacing300),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                result.status,
                style: textTheme.label.copyWith(color: statusColor),
              ),
              const SizedBox(height: CustomSpacing.spacing100),
              Text(
                _formatTimestamp(result.timestamp),
                style: textTheme.caption.copyWith(
                  color: colorTheme.contentStandardTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return '${time.month}/${time.day} $hour:$minute';
  }
}
