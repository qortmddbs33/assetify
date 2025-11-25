/// 앱 전체에서 사용하는 커스텀 예외 클래스
library;

/// 커스텀 예외
/// 에러 메시지를 포함하여 예외 상황을 표현
class CustomException implements Exception {
  final String message; // 예외 메시지

  CustomException(this.message);
}