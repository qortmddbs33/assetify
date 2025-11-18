import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/static.dart';
import '../../core/theme/typography.dart';
import '../../services/notion/model.dart';
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

      final bool wasSuccessful = await controller.handleScannedValue(
        scannedValue,
      );
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
            _OptionSelectorButton(colorTheme: colorTheme, textTheme: textTheme),
            const SizedBox(height: CustomSpacing.spacing400),
            _ScanButton(
              onScanRequested: () => _openBarcodeScanner(context),
              colorTheme: colorTheme,
              textTheme: textTheme,
            ),
            const SizedBox(height: CustomSpacing.spacing200),
            _ContinuousModeToggle(colorTheme: colorTheme, textTheme: textTheme),
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
        onChanged: (value) => controller.setContinuousMode(value ?? false),
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

class _OptionSelectorButton extends StatelessWidget {
  final CustomColors colorTheme;
  final CustomTypography textTheme;

  const _OptionSelectorButton({
    required this.colorTheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _openOptionsSheet(context),
        icon: const Icon(Icons.tune_rounded),
        label: Text(
          '옵션 선택하기',
          style: textTheme.body.copyWith(
            color: colorTheme.contentStandardPrimary,
          ),
        ),
      ),
    );
  }

  Future<void> _openOptionsSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorTheme.componentsFillStandardPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CustomRadius.radius600),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (sheetContext) =>
          _FieldOptionsSheet(colorTheme: colorTheme, textTheme: textTheme),
    );
  }
}

class _FieldOptionsSheet extends StatelessWidget {
  final CustomColors colorTheme;
  final CustomTypography textTheme;

  const _FieldOptionsSheet({required this.colorTheme, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    final QuickStatusController controller = Get.find<QuickStatusController>();
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: CustomSpacing.spacing500,
          right: CustomSpacing.spacing500,
          top: CustomSpacing.spacing400,
          bottom: bottomInset + CustomSpacing.spacing400,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  margin: const EdgeInsets.only(
                    bottom: CustomSpacing.spacing400,
                  ),
                  decoration: BoxDecoration(
                    color: colorTheme.lineOutline.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: CustomSpacing.spacing300),
              _DateActionDropdown(
                label: '사용일자',
                action: controller.usageDateAction,
                onSelected: controller.setUsageDateAction,
                colorTheme: colorTheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: CustomSpacing.spacing300),
              _DateActionDropdown(
                label: '반납일자',
                action: controller.returnDateAction,
                onSelected: controller.setReturnDateAction,
                colorTheme: colorTheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: CustomSpacing.spacing300),
              _DateActionDropdown(
                label: '수리일자',
                action: controller.repairDateAction,
                onSelected: controller.setRepairDateAction,
                colorTheme: colorTheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: CustomSpacing.spacing400),
              _SelectOptionControl(
                label: '반납사유',
                options: controller.returnReasonOptions,
                selection: controller.selectedReturnReason,
                onSelected: controller.setReturnReasonSelection,
              ),
              const SizedBox(height: CustomSpacing.spacing300),
              _SelectOptionControl(
                label: '수리 작업 유형',
                options: controller.repairWorkTypeOptions,
                selection: controller.selectedRepairWorkType,
                onSelected: controller.setRepairWorkTypeSelection,
              ),
              const SizedBox(height: CustomSpacing.spacing300),
              _SelectOptionControl(
                label: '수리진행상황',
                options: controller.repairStatusOptions,
                selection: controller.selectedRepairStatus,
                onSelected: controller.setRepairStatusSelection,
              ),
              const SizedBox(height: CustomSpacing.spacing300),
              _SelectOptionControl(
                label: '출고진행상황',
                options: controller.shipmentStatusOptions,
                selection: controller.selectedShipmentStatus,
                onSelected: controller.setShipmentStatusSelection,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateActionDropdown extends StatelessWidget {
  final String label;
  final Rx<QuickStatusDateAction> action;
  final void Function(QuickStatusDateAction action) onSelected;
  final CustomColors colorTheme;
  final CustomTypography textTheme;

  const _DateActionDropdown({
    required this.label,
    required this.action,
    required this.onSelected,
    required this.colorTheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<QuickStatusDateAction>(
        value: action.value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CustomRadius.radius600),
          ),
        ),
        items: QuickStatusDateAction.values
            .map(
              (option) => DropdownMenuItem<QuickStatusDateAction>(
                value: option,
                child: Text(_dateActionLabel(option)),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onSelected(value);
          }
        },
      ),
    );
  }

  String _dateActionLabel(QuickStatusDateAction action) {
    switch (action) {
      case QuickStatusDateAction.none:
        return '변경 없음';
      case QuickStatusDateAction.setToday:
        return '오늘 기록';
      case QuickStatusDateAction.clear:
        return '기록 삭제';
    }
  }
}

class _SelectOptionControl extends StatelessWidget {
  final String label;
  final Rx<String?> selection;
  final RxList<NotionPropertyOption> options;
  final void Function(String? value) onSelected;

  const _SelectOptionControl({
    required this.label,
    required this.selection,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final String? current = selection.value;
      final List<DropdownMenuItem<String?>> items = [
        const DropdownMenuItem<String?>(value: null, child: Text('변경 없음')),
        const DropdownMenuItem<String?>(
          value: QuickStatusController.clearSelectionValue,
          child: Text('기록 삭제'),
        ),
        ...options
            .map(
              (option) => DropdownMenuItem<String?>(
                value: option.name,
                child: Text(option.name),
              ),
            )
            .toList(),
      ];
      return DropdownButtonFormField<String?>(
        value: current,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CustomRadius.radius600),
          ),
        ),
        items: items,
        onChanged: onSelected,
      );
    });
  }
}
