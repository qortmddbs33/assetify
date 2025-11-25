/// 프로덕션용 API 프로바이더
/// 로그 인터셉터가 추가된 API 클라이언트
library;

import 'api_interface.dart';
import 'interceptors/log.dart';

/// 프로덕션 환경 API 프로바이더
/// 모든 요청/응답에 대한 로깅 기능 포함
class ProdApiProvider extends ApiProvider {
  ProdApiProvider() : super() {
    // 로그 인터셉터 추가
    dio.interceptors.add(LogInterceptor());
  }
}
