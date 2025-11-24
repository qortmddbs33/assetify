/// Assetify 앱의 메인 진입점
/// Notion 기반 자산 관리 시스템의 Flutter 클라이언트

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/theme/inapp/light.dart';
import 'app/core/utils/loader.dart';
import 'app/routes/pages.dart';
import 'app/routes/routes.dart';

/// 앱 시작 함수
void main() async {
  // 앱 초기화 (서비스 등록, 설정 로드 등)
  await AppLoader().load();

  runApp(
    GetMaterialApp(
      title: 'Assetify',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      // 릴리즈 모드에서는 홈, 디버그 모드에서는 테스트 페이지로 시작
      initialRoute: kReleaseMode ? Routes.HOME : Routes.TEST,
      getPages: AppPages.pages,
      // 웹 프레임을 위한 최대 너비 제한 (768px)
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 768),
            child: child,
          ),
        );
      },
    ),
  );
}
