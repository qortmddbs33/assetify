/// 사용자 인증 정보 관리 서비스
/// Notion API 키를 안전하게 저장하고 관리
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

/// 인증 정보 서비스
/// 보안 저장소를 사용하여 API 키를 암호화 저장
class CredentialsService extends GetxService {
  static const String _notionKeyStorageKey = 'notion_api_key';

  final FlutterSecureStorage storage;
  final RxnString _cachedNotionApiKey = RxnString();

  CredentialsService({FlutterSecureStorage? storage})
    : storage = storage ?? const FlutterSecureStorage();

  String? get notionApiKey => _cachedNotionApiKey.value;

  /// 서비스 초기화 - 저장된 API 키 로드
  Future<CredentialsService> init() async {
    final String? stored = await storage.read(key: _notionKeyStorageKey);
    _cachedNotionApiKey.value = stored != null && stored.isNotEmpty
        ? stored
        : null;
    return this;
  }

  /// API 키 저장
  Future<void> saveNotionApiKey(String key) async {
    final String trimmed = key.trim();
    if (trimmed.isEmpty) {
      await storage.delete(key: _notionKeyStorageKey);
      _cachedNotionApiKey.value = null;
      return;
    }
    await storage.write(key: _notionKeyStorageKey, value: trimmed);
    _cachedNotionApiKey.value = trimmed;
  }

  /// API 키 삭제
  Future<void> clearNotionApiKey() async {
    await storage.delete(key: _notionKeyStorageKey);
    _cachedNotionApiKey.value = null;
  }
}
