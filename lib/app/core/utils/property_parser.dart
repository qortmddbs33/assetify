/// Notion API 응답에서 속성 값을 파싱하는 유틸리티
/// 다양한 Notion 속성 타입을 문자열로 변환
library;

class NotionPropertyParser {
  const NotionPropertyParser._();

  /// Notion 속성을 일반 문자열로 변환
  /// title, rich_text, select, status, multi_select, number, date 등 지원
  static String asPlainString(dynamic property) {
    final Map<String, dynamic>? data = _asMap(property);
    if (data == null) return '';

    final type = data['type'];
    if (type is! String) return '';

    switch (type) {
      case 'title':
      case 'rich_text':
        return _plainTextFromList(data[type]);
      case 'select':
      case 'status':
        return _nameFromMap(data[type]);
      case 'multi_select':
        return _namesFromList(data['multi_select']);
      case 'people':
        return _namesFromList(data['people']);
      case 'number':
        final number = data['number'];
        return number == null ? '' : number.toString();
      case 'date':
        final dateMap = _asMap(data['date']);
        if (dateMap == null) return '';
        final start = dateMap['start'];
        final end = dateMap['end'];
        if (start is String && end is String && end.isNotEmpty) {
          return '$start ~ $end';
        }
        return start is String ? start : '';
      case 'formula':
        final formula = _asMap(data['formula']);
        if (formula == null) return '';
        final formulaType = formula['type'];
        if (formulaType == 'string') {
          final value = formula['string'];
          return value is String ? value : '';
        }
        if (formulaType == 'number') {
          final value = formula['number'];
          return value == null ? '' : value.toString();
        }
        return '';
      case 'files':
        return _fileNamesFromList(data['files']);
      case 'last_edited_time':
        final time = data['last_edited_time'];
        return time is String ? time : '';
      case 'last_edited_by':
        return _nameFromMap(data['last_edited_by']);
      default:
        return '';
    }
  }

  /// 동적 타입을 Map으로 변환
  static Map<String, dynamic>? _asMap(dynamic source) {
    if (source == null) return null;
    if (source is Map<String, dynamic>) return source;
    if (source is Map) return Map<String, dynamic>.from(source);
    return null;
  }

  /// rich_text 배열에서 plain_text 추출
  static String _plainTextFromList(dynamic raw) {
    if (raw is! List) return '';
    return raw
        .map((item) {
          if (item is Map<String, dynamic>) {
            final text = item['plain_text'];
            if (text is String) {
              return text;
            }
            if (item.containsKey('text')) {
              final textNode = item['text'];
              if (textNode is Map && textNode['content'] is String) {
                return textNode['content'] as String;
              }
            }
          }
          return '';
        })
        .where((segment) => segment.isNotEmpty)
        .join('');
  }

  /// select/status 타입에서 name 추출
  static String _nameFromMap(dynamic raw) {
    final map = _asMap(raw);
    final name = map?['name'];
    return name is String ? name : '';
  }

  /// multi_select/people 타입에서 이름 목록 추출
  static String _namesFromList(dynamic raw) {
    if (raw is! List) return '';
    return raw
        .map((item) => _nameFromMap(item))
        .where((name) => name.isNotEmpty)
        .join(', ');
  }

  /// files 타입에서 파일명 또는 URL 추출
  static String _fileNamesFromList(dynamic raw) {
    if (raw is! List) return '';
    return raw
        .map((item) {
          final map = _asMap(item);
          if (map == null) return '';
          final name = map['name'];
          if (name is String && name.isNotEmpty) {
            return name;
          }
          final fileData = map['file'] ?? map['external'];
          final fileMap = _asMap(fileData);
          if (fileMap == null) return '';
          final url = fileMap['url'];
          return url is String ? url : '';
        })
        .where((value) => value.isNotEmpty)
        .join(', ');
  }
}
