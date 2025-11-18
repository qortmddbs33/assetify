import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/static.dart';
import '../../core/theme/typography.dart';
import '../../services/notion/model.dart';
import '../../widgets/standard_bottom_sheet.dart';
import 'controller.dart';

class AssetDetailPage extends GetView<AssetDetailController> {
  const AssetDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<CustomColors>()!;
    final textTheme = Theme.of(context).extension<CustomTypography>()!;
    return Obx(() {
      final NotionProperties props = controller.properties;
      final bool isUpdating = controller.isUpdating.value;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            props.assetNumber.isEmpty ? '자산 상세' : props.assetNumber,
            style: textTheme.heading.copyWith(
              color: colorTheme.contentStandardPrimary,
            ),
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            if (isUpdating) const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshPage,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(CustomSpacing.spacing550),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AssetDetailSummary(
                        props: props,
                        colorTheme: colorTheme,
                        textTheme: textTheme,
                      ),
                      const SizedBox(height: CustomSpacing.spacing500),
                      _AssetDetailSection(
                        title: '기본 정보',
                        rows: [
                          _DetailRow('사용자', props.user),
                          _DetailRow('법인명', props.corporation),
                          _DetailRow('부서', props.department),
                          _DetailRow('위치', props.location),
                        ],
                        colorTheme: colorTheme,
                        textTheme: textTheme,
                        controller: controller,
                        isUpdating: isUpdating,
                        onEdit: (row) => _showEditPropertyDialog(context, row),
                      ),
                      const SizedBox(height: CustomSpacing.spacing500),
                      _AssetDetailSection(
                        title: '하드웨어 · 스펙',
                        rows: [
                          _DetailRow('제조사', props.manufacturer),
                          _DetailRow('모델명', props.modelName),
                          _DetailRow('CPU', props.CPU),
                          _DetailRow('RAM', props.RAM),
                          _DetailRow('시리얼 넘버', props.serialNumber),
                        ],
                        colorTheme: colorTheme,
                        textTheme: textTheme,
                        controller: controller,
                        isUpdating: isUpdating,
                        onEdit: (row) => _showEditPropertyDialog(context, row),
                      ),
                      const SizedBox(height: CustomSpacing.spacing500),
                      _AssetDetailSection(
                        title: '일정 · 이력',
                        rows: [
                          _DetailRow('구매일자', props.purchaseDate),
                          _DetailRow('사용일자', props.usageDate),
                          _DetailRow('반납일자', props.returnDate),
                          _DetailRow('수리일자', props.repairDate),
                        ],
                        colorTheme: colorTheme,
                        textTheme: textTheme,
                        controller: controller,
                        isUpdating: isUpdating,
                        onEdit: (row) => _showEditPropertyDialog(context, row),
                      ),
                      const SizedBox(height: CustomSpacing.spacing500),
                      _AssetDetailSection(
                        title: '비용 정보',
                        rows: [
                          _DetailRow('단가', props.unitPrice),
                          _DetailRow('잔존가치', props.residualValue),
                        ],
                        colorTheme: colorTheme,
                        textTheme: textTheme,
                        controller: controller,
                        isUpdating: isUpdating,
                        onEdit: (row) => _showEditPropertyDialog(context, row),
                      ),
                      const SizedBox(height: CustomSpacing.spacing500),
                      _AssetDetailSection(
                        title: '진행 상태',
                        rows: [
                          _DetailRow(
                            '자산 상태',
                            props.status,
                            propertyName: '사용/재고/폐기/기타',
                          ),
                          _DetailRow(
                            '출고 진행 상황',
                            props.shipmentStatus,
                            propertyName: '출고진행상황',
                          ),
                          _DetailRow(
                            '수리 진행 상황',
                            props.repairStatus,
                            propertyName: '수리진행상황',
                          ),
                          _DetailRow('반납 진행 상황', props.returnProgress),
                        ],
                        colorTheme: colorTheme,
                        textTheme: textTheme,
                        controller: controller,
                        isUpdating: isUpdating,
                        onEdit: (row) => _showEditPropertyDialog(context, row),
                      ),
                      const SizedBox(height: CustomSpacing.spacing500),
                      _AssetDetailSection(
                        title: '수리 · 반납 관리',
                        rows: [
                          _DetailRow('수리 작업 유형', props.repairWorkTypes),
                          _DetailRow(
                            '수리 담당자',
                            props.repairManager,
                            propertyName: '수리담당자',
                          ),
                          _DetailRow(
                            '반납 사유',
                            props.returnReason,
                            propertyName: '반납사유',
                          ),
                        ],
                        colorTheme: colorTheme,
                        textTheme: textTheme,
                        controller: controller,
                        isUpdating: isUpdating,
                        onEdit: (row) => _showEditPropertyDialog(context, row),
                      ),
                      const SizedBox(height: CustomSpacing.spacing500),
                      _AssetDetailSection(
                        title: '기타',
                        rows: [
                          _DetailRow('메모', props.note, propertyName: '기타'),
                          _DetailRow('파일 첨부', props.attachments),
                          _DetailRow('업데이트 시간', props.updatedTime),
                          _DetailRow('최종 편집자', props.editor),
                          _DetailRow('누락 사항', props.missingItems),
                        ],
                        colorTheme: colorTheme,
                        textTheme: textTheme,
                        controller: controller,
                        isUpdating: isUpdating,
                        onEdit: (row) => _showEditPropertyDialog(context, row),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _showEditPropertyDialog(
    BuildContext context,
    _DetailRow row,
  ) async {
    final NotionPropertyField? field = controller.propertyField(
      row.propertyName,
    );
    if (field == null || !field.isEditable) return;

    if (field.type == 'date') {
      await _showDateEditDialog(context, row);
      return;
    }

    if (field.type == 'select' || field.type == 'status') {
      final handled = await _showSingleSelectSheet(context, row);
      if (handled) return;
    }

    if (field.type == 'multi_select') {
      final handled = await _showMultiSelectDialog(context, row);
      if (handled) return;
    }

    await _showTextEditDialog(context, row, field);
  }

  Future<void> _showTextEditDialog(
    BuildContext context,
    _DetailRow row,
    NotionPropertyField field,
  ) async {
    final String hint = field.inputHint;
    final textController = TextEditingController(text: row.value);

    final TextInputType keyboardType;
    List<TextInputFormatter>? inputFormatters;
    switch (field.type) {
      case 'number':
        keyboardType = const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        );
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
        ];
        break;
      case 'phone_number':
        keyboardType = TextInputType.phone;
        break;
      case 'email':
        keyboardType = TextInputType.emailAddress;
        break;
      case 'url':
        keyboardType = TextInputType.url;
        break;
      default:
        keyboardType = TextInputType.text;
    }

    final String? updatedValue = await showStandardBottomSheet<String>(
      context,
      (sheetContext, colorTheme, textTheme) {
        return StandardSheetContentWrapper(
          title: '${row.label} 수정',
          colorTheme: colorTheme,
          textTheme: textTheme,
          onClose: () => Navigator.of(sheetContext).maybePop(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                maxLines: field.type == 'rich_text' ? 5 : 1,
                minLines: field.type == 'rich_text' ? 3 : 1,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                decoration: InputDecoration(
                  labelText: row.label,
                  hintText: hint.isEmpty ? null : hint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CustomRadius.radius600),
                  ),
                ),
              ),
              if (hint.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: CustomSpacing.spacing200),
                  child: Text(
                    hint,
                    style: textTheme.caption.copyWith(
                      color: colorTheme.contentStandardSecondary,
                    ),
                  ),
                ),
              const SizedBox(height: CustomSpacing.spacing400),
              Row(
                children: [
                  StandardSheetActionButton(
                    label: '취소',
                    onPressed: () => Navigator.of(sheetContext).maybePop(),
                    colorTheme: colorTheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(width: CustomSpacing.spacing200),
                  StandardSheetActionButton(
                    label: '저장',
                    primary: true,
                    onPressed: () => Navigator.of(
                      sheetContext,
                    ).pop(textController.text.trim()),
                    colorTheme: colorTheme,
                    textTheme: textTheme,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (updatedValue == null) return;

    await _submitUpdate(context, row.propertyName, updatedValue);
  }

  Future<bool> _showSingleSelectSheet(
    BuildContext context,
    _DetailRow row,
  ) async {
    final List<NotionPropertyOption> options = await controller
        .fetchPropertyOptions(row.propertyName);
    if (options.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('선택 가능한 항목이 없습니다.')));
      return false;
    }

    final String? selected = await showStandardBottomSheet<String>(context, (
      sheetContext,
      colorTheme,
      textTheme,
    ) {
      final double maxHeight = MediaQuery.of(sheetContext).size.height * 0.6;
      return StandardSheetContentWrapper(
        title: '${row.label} 선택',
        colorTheme: colorTheme,
        textTheme: textTheme,
        onClose: () => Navigator.of(sheetContext).maybePop(),
        child: StandardSheetCard(
          colorTheme: colorTheme,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StandardSheetListTile(
                icon: Icons.remove_circle_outline,
                label: '선택 해제',
                colorTheme: colorTheme,
                textTheme: textTheme,
                destructive: true,
                onTap: () => Navigator.of(sheetContext).pop(''),
              ),
              const Divider(height: 0),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 0, color: colorTheme.lineOutline),
                  itemBuilder: (_, index) {
                    final option = options[index];
                    final bool isSelected =
                        row.value.trim() == option.name.trim();
                    return StandardSheetListTile(
                      icon: isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      label: option.name,
                      colorTheme: colorTheme,
                      textTheme: textTheme,
                      onTap: () => Navigator.of(sheetContext).pop(option.name),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });

    if (selected == null) return true;

    await _submitUpdate(context, row.propertyName, selected);
    return true;
  }

  Future<bool> _showMultiSelectDialog(
    BuildContext context,
    _DetailRow row,
  ) async {
    final List<NotionPropertyOption> options = await controller
        .fetchPropertyOptions(row.propertyName);
    if (options.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('선택 가능한 항목이 없습니다.')));
      return false;
    }

    final Set<String> initialSelections = row.value
        .split(',')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toSet();

    final Set<String>? result = await showStandardBottomSheet<Set<String>>(
      context,
      (sheetContext, colorTheme, textTheme) {
        final Set<String> selections = {...initialSelections};
        final double maxHeight = MediaQuery.of(sheetContext).size.height * 0.6;
        return StatefulBuilder(
          builder: (context, setState) {
            return StandardSheetContentWrapper(
              title: '${row.label} 수정',
              colorTheme: colorTheme,
              textTheme: textTheme,
              onClose: () => Navigator.of(sheetContext).maybePop(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StandardSheetCard(
                    colorTheme: colorTheme,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: maxHeight),
                      child: ListView(
                        shrinkWrap: true,
                        children: options
                            .map(
                              (option) => CheckboxListTile(
                                value: selections.contains(option.name),
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked == true) {
                                      selections.add(option.name);
                                    } else {
                                      selections.remove(option.name);
                                    }
                                  });
                                },
                                title: Text(option.name),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: CustomSpacing.spacing400),
                  Row(
                    children: [
                      StandardSheetActionButton(
                        label: '취소',
                        onPressed: () => Navigator.of(sheetContext).maybePop(),
                        colorTheme: colorTheme,
                        textTheme: textTheme,
                      ),
                      const SizedBox(width: CustomSpacing.spacing200),
                      StandardSheetActionButton(
                        label: '지우기',
                        destructive: true,
                        onPressed: () =>
                            Navigator.of(sheetContext).pop(<String>{}),
                        colorTheme: colorTheme,
                        textTheme: textTheme,
                      ),
                      const SizedBox(width: CustomSpacing.spacing200),
                      StandardSheetActionButton(
                        label: '저장',
                        primary: true,
                        onPressed: () =>
                            Navigator.of(sheetContext).pop(selections),
                        colorTheme: colorTheme,
                        textTheme: textTheme,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result == null) return true;

    final String value = result.isEmpty ? '' : result.join(', ');
    await _submitUpdate(context, row.propertyName, value);
    return true;
  }

  Future<void> _showDateEditDialog(BuildContext context, _DetailRow row) async {
    final _DateDialogResult? result =
        await showStandardBottomSheet<_DateDialogResult>(context, (
          sheetContext,
          colorTheme,
          textTheme,
        ) {
          DateTimeRange? selectedRange = _parseDateRange(row.value);
          return StatefulBuilder(
            builder: (context, setState) {
              return StandardSheetContentWrapper(
                title: '${row.label} 수정',
                colorTheme: colorTheme,
                textTheme: textTheme,
                onClose: () => Navigator.of(sheetContext).maybePop(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StandardSheetCard(
                      colorTheme: colorTheme,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedRange == null
                                ? '선택된 날짜 없음'
                                : _formatDateRange(selectedRange!),
                            style: textTheme.body.copyWith(
                              color: colorTheme.contentStandardPrimary,
                            ),
                          ),
                          const SizedBox(height: CustomSpacing.spacing300),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final DateTime now = DateTime.now();
                                final DateTimeRange initialRange =
                                    selectedRange ??
                                    DateTimeRange(start: now, end: now);
                                final DateTimeRange? picked =
                                    await showDateRangePicker(
                                      context: sheetContext,
                                      initialDateRange: initialRange,
                                      firstDate: DateTime(2000, 1, 1),
                                      lastDate: DateTime(2100, 12, 31),
                                    );
                                if (picked != null) {
                                  setState(() {
                                    selectedRange = picked;
                                  });
                                }
                              },
                              icon: const Icon(Icons.calendar_today_outlined),
                              label: const Text('날짜 선택'),
                            ),
                          ),
                          const SizedBox(height: CustomSpacing.spacing200),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedRange = null;
                              });
                            },
                            child: const Text('날짜 지우기'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: CustomSpacing.spacing400),
                    Row(
                      children: [
                        StandardSheetActionButton(
                          label: '취소',
                          onPressed: () =>
                              Navigator.of(sheetContext).maybePop(),
                          colorTheme: colorTheme,
                          textTheme: textTheme,
                        ),
                        const SizedBox(width: CustomSpacing.spacing200),
                        StandardSheetActionButton(
                          label: '저장',
                          primary: true,
                          onPressed: () {
                            final result = selectedRange == null
                                ? const _DateDialogResult(clear: true)
                                : _DateDialogResult(
                                    clear: false,
                                    range: selectedRange!,
                                  );
                            Navigator.of(sheetContext).pop(result);
                          },
                          colorTheme: colorTheme,
                          textTheme: textTheme,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });

    if (result == null) return;

    String newValue;
    if (result.clear) {
      newValue = '';
    } else {
      final DateTimeRange? range = result.range;
      if (range == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('날짜를 선택해주세요.')));
        return;
      }
      newValue = _formatDateRange(range);
    }

    await _submitUpdate(context, row.propertyName, newValue);
  }

  DateTimeRange? _parseDateRange(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    final parts = trimmed.split('~');
    DateTime? start = DateTime.tryParse(parts.first.trim());
    DateTime? end;
    if (parts.length > 1) {
      end = DateTime.tryParse(parts[1].trim());
    }
    end ??= start;
    if (start == null || end == null) return null;
    if (end.isBefore(start)) {
      final DateTime temp = start;
      start = end;
      end = temp;
    }
    return DateTimeRange(start: start, end: end);
  }

  String _formatDateRange(DateTimeRange range) {
    final String start = _formatDate(range.start);
    final String end = _formatDate(range.end);
    if (start == end) return start;
    return '$start ~ $end';
  }

  String _formatDate(DateTime date) {
    final String year = date.year.toString().padLeft(4, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<void> _submitUpdate(
    BuildContext context,
    String propertyName,
    String value,
  ) async {
    final bool success = await controller.updateProperty(propertyName, value);
    final messenger = ScaffoldMessenger.of(context);
    final String message = success ? '수정되었습니다.' : '수정에 실패했습니다.';
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

class _DateDialogResult {
  final bool clear;
  final DateTimeRange? range;

  const _DateDialogResult({required this.clear, this.range});
}

class _AssetDetailSummary extends StatelessWidget {
  final NotionProperties props;
  final CustomColors colorTheme;
  final CustomTypography textTheme;

  const _AssetDetailSummary({
    required this.props,
    required this.colorTheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(props.status, colorTheme);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(CustomSpacing.spacing550),
      decoration: BoxDecoration(
        color: colorTheme.componentsFillStandardPrimary,
        borderRadius: BorderRadius.circular(CustomRadius.radius600),
        border: Border.all(color: colorTheme.lineOutline.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  props.assetNumber.isEmpty ? '자산번호 없음' : props.assetNumber,
                  style: textTheme.title.copyWith(
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
                  props.status.isEmpty ? '-' : props.status,
                  style: textTheme.footnote.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: CustomSpacing.spacing400),
          _SummaryItem(
            label: '제조사',
            value: props.manufacturer,
            textTheme: textTheme,
            colorTheme: colorTheme,
          ),
          const SizedBox(height: CustomSpacing.spacing200),
          _SummaryItem(
            label: 'CPU',
            value: props.CPU,
            textTheme: textTheme,
            colorTheme: colorTheme,
          ),
          const SizedBox(height: CustomSpacing.spacing200),
          _SummaryItem(
            label: 'RAM',
            value: props.RAM,
            textTheme: textTheme,
            colorTheme: colorTheme,
          ),
          const SizedBox(height: CustomSpacing.spacing200),
          _SummaryItem(
            label: '사용자',
            value: props.user,
            textTheme: textTheme,
            colorTheme: colorTheme,
          ),
        ],
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
    if (normalized.contains('폐기') || normalized.contains('고장')) {
      return colorTheme.coreStatusNegative;
    }
    return colorTheme.contentStandardSecondary;
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final CustomTypography textTheme;
  final CustomColors colorTheme;

  const _SummaryItem({
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
          width: 64,
          child: Text(
            label,
            style: textTheme.label.copyWith(
              color: colorTheme.contentStandardTertiary,
            ),
          ),
        ),
        const SizedBox(width: CustomSpacing.spacing200),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            style: textTheme.body.copyWith(
              color: colorTheme.contentStandardPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _AssetDetailSection extends StatelessWidget {
  final String title;
  final List<_DetailRow> rows;
  final CustomColors colorTheme;
  final CustomTypography textTheme;
  final AssetDetailController controller;
  final bool isUpdating;
  final void Function(_DetailRow row) onEdit;

  const _AssetDetailSection({
    required this.title,
    required this.rows,
    required this.colorTheme,
    required this.textTheme,
    required this.controller,
    required this.isUpdating,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(CustomSpacing.spacing500),
      decoration: BoxDecoration(
        color: colorTheme.componentsFillStandardPrimary,
        borderRadius: BorderRadius.circular(CustomRadius.radius600),
        border: Border.all(color: colorTheme.lineOutline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.heading.copyWith(
              color: colorTheme.contentStandardPrimary,
            ),
          ),
          const SizedBox(height: CustomSpacing.spacing400),
          ...rows.map((row) {
            final bool editable = controller.canEdit(row.propertyName);
            return Padding(
              padding: const EdgeInsets.only(bottom: CustomSpacing.spacing300),
              child: _DetailItem(
                row: row,
                textTheme: textTheme,
                colorTheme: colorTheme,
                editable: editable,
                isUpdating: isUpdating,
                onEdit: editable ? () => onEdit(row) : null,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DetailRow {
  final String label;
  final String value;
  final String propertyName;

  const _DetailRow(this.label, this.value, {String? propertyName})
    : propertyName = propertyName ?? label;
}

class _DetailItem extends StatelessWidget {
  final _DetailRow row;
  final CustomTypography textTheme;
  final CustomColors colorTheme;
  final bool editable;
  final bool isUpdating;
  final VoidCallback? onEdit;

  const _DetailItem({
    required this.row,
    required this.textTheme,
    required this.colorTheme,
    required this.editable,
    required this.isUpdating,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          row.label,
          style: textTheme.label.copyWith(
            color: colorTheme.contentStandardTertiary,
          ),
        ),
        const SizedBox(height: CustomSpacing.spacing100),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                row.value.isEmpty ? '-' : row.value,
                style: textTheme.body.copyWith(
                  color: colorTheme.contentStandardPrimary,
                ),
              ),
            ),
            if (editable)
              Padding(
                padding: const EdgeInsets.only(left: CustomSpacing.spacing200),
                child: _EditActionButton(
                  label: '수정',
                  onPressed: isUpdating ? null : onEdit,
                  colorTheme: colorTheme,
                  textTheme: textTheme,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _EditActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final CustomColors colorTheme;
  final CustomTypography textTheme;

  const _EditActionButton({
    required this.label,
    required this.onPressed,
    required this.colorTheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: CustomSpacing.spacing300,
          vertical: CustomSpacing.spacing150,
        ),
        backgroundColor: colorTheme.componentsFillStandardSecondary,
        foregroundColor: colorTheme.contentStandardPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CustomRadius.radius500),
          side: BorderSide(color: colorTheme.lineOutline.withOpacity(0.3)),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: const Icon(Icons.edit_outlined, size: 16),
      label: Text(
        label,
        style: textTheme.label.copyWith(
          color: colorTheme.contentStandardPrimary,
        ),
      ),
    );
  }
}
