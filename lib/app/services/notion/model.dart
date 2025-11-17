import 'package:json_annotation/json_annotation.dart';

import 'property_parser.dart';

part 'model.g.dart';

@JsonSerializable()
class NotionDatabase {
  final List<NotionPage> results;

  NotionDatabase({required this.results});

  factory NotionDatabase.fromJson(Map<String, dynamic> json) =>
      _$NotionDatabaseFromJson(json);

  Map<String, dynamic> toJson() => _$NotionDatabaseToJson(this);
}

@JsonSerializable()
class NotionPage {
  final String id;
  final NotionProperties properties;

  NotionPage({required this.id, required this.properties});

  factory NotionPage.fromJson(Map<String, dynamic> json) =>
      _$NotionPageFromJson(json);

  Map<String, dynamic> toJson() => _$NotionPageToJson(this);
}

class NotionProperties {
  final String user;
  final String assetNumber;
  final String modelName;
  final String CPU;
  final String RAM;
  final String location;
  final String corporation;
  final String manufacturer;
  final String status;
  final String usageDate;
  final String returnReason;
  final String note;
  final String repairManager;
  final String serialNumber;
  final String unitPrice;
  final String purchaseDate;
  final String repairStatus;
  final String shipmentStatus;
  final String missingItems;
  final String returnDate;
  final String repairDate;
  final String updatedTime;
  final String editor;
  final String returnProgress;
  final String attachments;
  final String residualValue;
  final String repairWorkTypes;
  final String department;

  NotionProperties({
    required this.user,
    required this.assetNumber,
    required this.modelName,
    required this.CPU,
    required this.RAM,
    required this.location,
    required this.corporation,
    required this.manufacturer,
    required this.status,
    required this.usageDate,
    required this.returnReason,
    required this.note,
    required this.repairManager,
    required this.serialNumber,
    required this.unitPrice,
    required this.purchaseDate,
    required this.repairStatus,
    required this.shipmentStatus,
    required this.missingItems,
    required this.returnDate,
    required this.repairDate,
    required this.updatedTime,
    required this.editor,
    required this.returnProgress,
    required this.attachments,
    required this.residualValue,
    required this.repairWorkTypes,
    required this.department,
  });

  factory NotionProperties.fromJson(Map<String, dynamic> json) {
    return NotionProperties(
      user: NotionPropertyParser.asPlainString(json['사용자']),
      assetNumber: NotionPropertyParser.asPlainString(json['자산번호']),
      modelName: NotionPropertyParser.asPlainString(json['모델명']),
      CPU: NotionPropertyParser.asPlainString(json['CPU']),
      RAM: NotionPropertyParser.asPlainString(json['RAM']),
      location: NotionPropertyParser.asPlainString(json['위치']),
      corporation: NotionPropertyParser.asPlainString(json['법인명']),
      manufacturer: NotionPropertyParser.asPlainString(json['제조사']),
      status: NotionPropertyParser.asPlainString(json['사용/재고/폐기/기타']),
      usageDate: NotionPropertyParser.asPlainString(json['사용일자']),
      returnReason: NotionPropertyParser.asPlainString(json['반납사유']),
      note: NotionPropertyParser.asPlainString(json['기타']),
      repairManager: NotionPropertyParser.asPlainString(json['수리담당자']),
      serialNumber: NotionPropertyParser.asPlainString(json['시리얼 넘버']),
      unitPrice: NotionPropertyParser.asPlainString(json['단가']),
      purchaseDate: NotionPropertyParser.asPlainString(json['구매일자']),
      repairStatus: NotionPropertyParser.asPlainString(json['수리진행상황']),
      shipmentStatus: NotionPropertyParser.asPlainString(json['출고진행상황']),
      missingItems: NotionPropertyParser.asPlainString(json['누락 사항']),
      returnDate: NotionPropertyParser.asPlainString(json['반납일자']),
      repairDate: NotionPropertyParser.asPlainString(json['수리일자']),
      updatedTime: NotionPropertyParser.asPlainString(json['업데이트 시간']),
      editor: NotionPropertyParser.asPlainString(json['최종 편집자']),
      returnProgress: NotionPropertyParser.asPlainString(json['반납 진행 상황']),
      attachments: NotionPropertyParser.asPlainString(json['파일 첨부']),
      residualValue: NotionPropertyParser.asPlainString(json['잔존가치']),
      repairWorkTypes: NotionPropertyParser.asPlainString(json['수리 작업 유형']),
      department: NotionPropertyParser.asPlainString(json['부서']),
    );
  }

  Map<String, dynamic> toJson() => {
    '사용자': user,
    '자산번호': assetNumber,
    '모델명': modelName,
    'CPU': CPU,
    'RAM': RAM,
    '위치': location,
    '법인명': corporation,
    '제조사': manufacturer,
    '사용/재고/폐기/기타': status,
    '사용일자': usageDate,
    '반납사유': returnReason,
    '기타': note,
    '수리담당자': repairManager,
    '시리얼 넘버': serialNumber,
    '단가': unitPrice,
    '구매일자': purchaseDate,
    '수리진행상황': repairStatus,
    '출고진행상황': shipmentStatus,
    '누락 사항': missingItems,
    '반납일자': returnDate,
    '수리일자': repairDate,
    '업데이트 시간': updatedTime,
    '최종 편집자': editor,
    '반납 진행 상황': returnProgress,
    '파일 첨부': attachments,
    '잔존가치': residualValue,
    '수리 작업 유형': repairWorkTypes,
    '부서': department,
  };
}
