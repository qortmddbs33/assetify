/// Notion API 비즈니스 로직 서비스
/// 자산 조회, 수정, 속성 옵션 조회 등 담당
library;

import 'dart:developer';

import 'package:get/get.dart';

import '../../core/utils/notion_environment.dart';
import 'model.dart';
import 'repository.dart';

/// Notion 서비스 컨트롤러
/// Repository를 통해 Notion API와 통신하고 비즈니스 로직 처리
class NotionService extends GetxController {
  final NotionRepository repository;
  final Map<String, Map<String, NotionPropertyDefinition>> _schemaCache = {};

  NotionService({NotionRepository? repository})
    : repository = repository ?? NotionRepository();

  /// 자산번호로 자산 조회
  Future<NotionPage?> fetchAssetByNumber(String assetNumber) async {
    try {
      final NotionDatabase data = await repository.fetchNotionItems(
        assetNumber: assetNumber,
      );
      if (data.results.isNotEmpty) {
        return data.results.first;
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  /// 페이지 ID로 자산 조회
  Future<NotionPage?> fetchAssetById(String pageId) async {
    try {
      return await repository.fetchPageById(pageId);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  /// 자산 속성 업데이트
  Future<NotionPage?> updateAssetProperties({
    required NotionPage page,
    required Map<String, String> updates,
  }) async {
    if (page.id.isEmpty || updates.isEmpty) {
      return null;
    }

    final Map<String, dynamic> properties = {};

    updates.forEach((propertyName, value) {
      final NotionPropertyField? field = page.field(propertyName);
      if (field == null || !field.isEditable) return;
      final Map<String, dynamic>? payload = _buildPropertyPayload(field, value);
      if (payload != null) {
        properties[propertyName] = payload;
      }
    });

    if (properties.isEmpty) {
      return null;
    }

    try {
      return await repository.updatePage(
        pageId: page.id,
        properties: properties,
      );
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  /// 속성의 선택 가능한 옵션 목록 조회
  Future<List<NotionPropertyOption>> fetchPropertyOptions(
    NotionPage page,
    String propertyName,
  ) async {
    final String? databaseId = page.parentDatabaseId?.isNotEmpty == true
        ? page.parentDatabaseId
        : NotionEnvironment.databaseId;
    if (databaseId == null || databaseId.isEmpty) return [];

    try {
      final Map<String, NotionPropertyDefinition> schema =
          await _getDatabaseSchema(databaseId);
      final NotionPropertyDefinition? definition = _definitionFor(
        schema,
        propertyName,
      );
      if (definition == null) return [];
      return definition.options;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<NotionPropertyOption>> fetchPropertyOptionsByName(
    String propertyName,
  ) async {
    final String? databaseId =
        NotionEnvironment.databaseId ?? pageDatabaseFallback();
    if (databaseId == null || databaseId.isEmpty) {
      return [];
    }
    try {
      final Map<String, NotionPropertyDefinition> schema =
          await _getDatabaseSchema(databaseId);
      final NotionPropertyDefinition? definition = _definitionFor(
        schema,
        propertyName,
      );
      if (definition == null) return [];
      return definition.options;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  String? pageDatabaseFallback() {
    if (_schemaCache.isNotEmpty) {
      return _schemaCache.keys.first;
    }
    return null;
  }

  /// Notion API 형식의 속성 페이로드 생성
  Map<String, dynamic>? _buildPropertyPayload(
    NotionPropertyField field,
    String value,
  ) {
    final String trimmed = value.trim();

    switch (field.type) {
      case 'title':
        return {'title': _buildRichText(trimmed)};
      case 'rich_text':
        return {'rich_text': _buildRichText(trimmed)};
      case 'number':
        if (trimmed.isEmpty) {
          return {'number': null};
        }
        final num? parsed = num.tryParse(trimmed);
        if (parsed == null) return null;
        return {'number': parsed};
      case 'select':
        if (trimmed.isEmpty) {
          return {'select': null};
        }
        return {
          'select': {'name': trimmed},
        };
      case 'status':
        if (trimmed.isEmpty) {
          return {'status': null};
        }
        return {
          'status': {'name': trimmed},
        };
      case 'multi_select':
        if (trimmed.isEmpty) {
          return {'multi_select': <Map<String, String>>[]};
        }
        final List<Map<String, String>> options = trimmed
            .split(',')
            .map((option) => option.trim())
            .where((option) => option.isNotEmpty)
            .map((option) => {'name': option})
            .toList();
        return {'multi_select': options};
      case 'date':
        if (trimmed.isEmpty) {
          return {'date': null};
        }
        final parts = trimmed.split('~');
        final String start = parts.first.trim();
        final String? end = parts.length > 1 ? parts[1].trim() : null;
        if (start.isEmpty && (end == null || end.isEmpty)) {
          return {'date': null};
        }
        return {
          'date': {
            'start': start.isEmpty ? null : start,
            'end': (end == null || end.isEmpty) ? null : end,
          },
        };
      case 'phone_number':
        return {'phone_number': trimmed.isEmpty ? null : trimmed};
      case 'email':
        return {'email': trimmed.isEmpty ? null : trimmed};
      case 'url':
        return {'url': trimmed.isEmpty ? null : trimmed};
      case 'checkbox':
        final normalized = trimmed.toLowerCase();
        if (normalized.isEmpty) return {'checkbox': false};
        final bool value =
            normalized == 'true' || normalized == '1' || normalized == 'yes';
        return {'checkbox': value};
      default:
        return null;
    }
  }

  List<Map<String, dynamic>> _buildRichText(String value) {
    if (value.isEmpty) return [];
    return [
      {
        'type': 'text',
        'text': {'content': value},
      },
    ];
  }

  Future<Map<String, NotionPropertyDefinition>> _getDatabaseSchema(
    String databaseId,
  ) async {
    final cached = _schemaCache[databaseId];
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    final Map<String, NotionPropertyDefinition> schema = await repository
        .fetchDatabaseSchema(databaseId);
    _schemaCache[databaseId] = schema;
    return schema;
  }

  NotionPropertyDefinition? _definitionFor(
    Map<String, NotionPropertyDefinition> schema,
    String propertyName,
  ) {
    final direct = schema[propertyName];
    if (direct != null) return direct;
    final normalized = _normalize(propertyName);
    for (final definition in schema.values) {
      if (definition.normalizedName == normalized) {
        return definition;
      }
    }
    return null;
  }

  String _normalize(String value) => value.replaceAll(RegExp(r'\s+'), '');
}
