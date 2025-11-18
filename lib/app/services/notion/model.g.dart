// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotionDatabase _$NotionDatabaseFromJson(Map<String, dynamic> json) =>
    NotionDatabase(
      results: (json['results'] as List<dynamic>)
          .map((e) => NotionPage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotionDatabaseToJson(NotionDatabase instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

NotionPage _$NotionPageFromJson(Map<String, dynamic> json) {
  final Map<String, dynamic> rawProperties =
      Map<String, dynamic>.from(json['properties'] as Map);
  String? parentDatabaseId;
  final dynamic parent = json['parent'];
  if (parent is Map<String, dynamic>) {
    if (parent['type'] == 'database_id' && parent['database_id'] is String) {
      parentDatabaseId = parent['database_id'] as String;
    }
  } else if (parent is Map) {
    final parentMap = Map<String, dynamic>.from(parent as Map);
    if (parentMap['type'] == 'database_id' &&
        parentMap['database_id'] is String) {
      parentDatabaseId = parentMap['database_id'] as String;
    }
  }
  return NotionPage(
    id: json['id'] as String,
    properties: NotionProperties.fromJson(rawProperties),
    propertyFields: NotionPropertyField.mapFromJson(rawProperties),
    parentDatabaseId: parentDatabaseId,
  );
}

Map<String, dynamic> _$NotionPageToJson(NotionPage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'properties': NotionPropertyField.mapToJson(instance.propertyFields),
      'parent': instance.parentDatabaseId == null
          ? null
          : {
              'type': 'database_id',
              'database_id': instance.parentDatabaseId,
            },
    };
