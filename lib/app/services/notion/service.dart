import 'dart:developer';

import 'package:get/get.dart';

import 'model.dart';
import 'repository.dart';

class NotionService extends GetxController {
  final NotionRepository repository;

  NotionService({NotionRepository? repository})
      : repository = repository ?? NotionRepository();

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
}
