import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class CredentialsService extends GetxService {
  static const String _notionKeyStorageKey = 'notion_api_key';

  final FlutterSecureStorage storage;
  final RxnString _cachedNotionApiKey = RxnString();

  CredentialsService({FlutterSecureStorage? storage})
    : storage = storage ?? const FlutterSecureStorage();

  String? get notionApiKey => _cachedNotionApiKey.value;

  Future<CredentialsService> init() async {
    final String? stored = await storage.read(key: _notionKeyStorageKey);
    _cachedNotionApiKey.value = stored != null && stored.isNotEmpty
        ? stored
        : null;
    return this;
  }

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

  Future<void> clearNotionApiKey() async {
    await storage.delete(key: _notionKeyStorageKey);
    _cachedNotionApiKey.value = null;
  }
}
