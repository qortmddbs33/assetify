/// 앱 초기화 및 서비스 로더
/// 앱 시작 시 필요한 설정과 서비스를 초기화

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';

import '../../provider/api.dart';
import '../../provider/api_interface.dart';
import '../../services/credentials/service.dart';

/// 앱 초기화 로더 클래스
class AppLoader {
  /// 앱 초기화 실행
  /// 스플래시 화면, 서비스 등록, 화면 방향 설정 등 처리
  Future<void> load() async {
    // Flutter 바인딩 초기화 및 스플래시 화면 유지
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // 웹에서 해시 없는 URL 전략 사용
    setPathUrlStrategy();

    // 인증 정보 서비스 초기화 및 등록
    await Get.putAsync<CredentialsService>(() => CredentialsService().init());

    // API 프로바이더 등록
    Get.put<ApiProvider>(ProdApiProvider());

    // 세로 모드만 허용
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Android에서 고주사율 디스플레이 모드 설정
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        await FlutterDisplayMode.setHighRefreshRate();
      }
    }

    // 스플래시 화면 제거
    FlutterNativeSplash.remove();
  }
}
