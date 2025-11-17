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
    <String, dynamic>{'results': instance.results};

NotionPage _$NotionPageFromJson(Map<String, dynamic> json) => NotionPage(
  id: json['id'] as String,
  properties: NotionProperties.fromJson(
    json['properties'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$NotionPageToJson(NotionPage instance) =>
    <String, dynamic>{'id': instance.id, 'properties': instance.properties};
