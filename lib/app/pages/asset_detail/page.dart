import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/static.dart';
import '../../core/theme/typography.dart';
import '../../services/notion/model.dart';
import 'controller.dart';

class AssetDetailPage extends GetView<AssetDetailController> {
  const AssetDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<CustomColors>()!;
    final textTheme = Theme.of(context).extension<CustomTypography>()!;
    final NotionProperties props = controller.page.properties;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          props.assetNumber.isEmpty ? '자산 상세' : props.assetNumber,
          style:
              textTheme.heading.copyWith(color: colorTheme.contentStandardPrimary),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
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
                _DetailRow('모델명', props.modelName),
                _DetailRow('법인명', props.corporation),
                _DetailRow('부서', props.department),
                _DetailRow('위치', props.location),
              ],
              colorTheme: colorTheme,
              textTheme: textTheme,
            ),
            const SizedBox(height: CustomSpacing.spacing500),
            _AssetDetailSection(
              title: '하드웨어 및 식별',
              rows: [
                _DetailRow('시리얼 넘버', props.serialNumber),
                _DetailRow('누락 사항', props.missingItems),
              ],
              colorTheme: colorTheme,
              textTheme: textTheme,
            ),
            const SizedBox(height: CustomSpacing.spacing500),
            _AssetDetailSection(
              title: '일정 · 비용',
              rows: [
                _DetailRow('사용일자', props.usageDate),
                _DetailRow('구매일자', props.purchaseDate),
                _DetailRow('반납일자', props.returnDate),
                _DetailRow('수리일자', props.repairDate),
                _DetailRow('단가', props.unitPrice),
                _DetailRow('잔존가치', props.residualValue),
              ],
              colorTheme: colorTheme,
              textTheme: textTheme,
            ),
            const SizedBox(height: CustomSpacing.spacing500),
            _AssetDetailSection(
              title: '진행 상황',
              rows: [
                _DetailRow('사용/재고/폐기/기타', props.status),
                _DetailRow('출고 진행 상황', props.shipmentStatus),
                _DetailRow('수리 진행 상황', props.repairStatus),
                _DetailRow('반납 진행 상황', props.returnProgress),
                _DetailRow('수리 작업 유형', props.repairWorkTypes),
                _DetailRow('수리 담당자', props.repairManager),
              ],
              colorTheme: colorTheme,
              textTheme: textTheme,
            ),
            const SizedBox(height: CustomSpacing.spacing500),
            _AssetDetailSection(
              title: '기타',
              rows: [
                _DetailRow('반납 사유', props.returnReason),
                _DetailRow('메모', props.note),
                _DetailRow('파일 첨부', props.attachments),
                _DetailRow('업데이트 시간', props.updatedTime),
                _DetailRow('최종 편집자', props.editor),
              ],
              colorTheme: colorTheme,
              textTheme: textTheme,
            ),
          ],
        ),
      ),
    );
  }
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
                  props.status,
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

  const _AssetDetailSection({
    required this.title,
    required this.rows,
    required this.colorTheme,
    required this.textTheme,
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
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: CustomSpacing.spacing300),
              child: _DetailItem(
                label: row.label,
                value: row.value,
                textTheme: textTheme,
                colorTheme: colorTheme,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final CustomTypography textTheme;
  final CustomColors colorTheme;

  const _DetailItem({
    required this.label,
    required this.value,
    required this.textTheme,
    required this.colorTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.label.copyWith(
            color: colorTheme.contentStandardTertiary,
          ),
        ),
        const SizedBox(height: CustomSpacing.spacing100),
        Text(
          value.isEmpty ? '-' : value,
          style: textTheme.body.copyWith(
            color: colorTheme.contentStandardPrimary,
          ),
        ),
      ],
    );
  }
}
