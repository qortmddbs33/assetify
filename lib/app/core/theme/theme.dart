/// 커스텀 테마를 구성하는 기본 클래스

import 'colors.dart';
import 'typography.dart';

/// 색상과 타이포그래피를 결합한 테마 클래스
/// 라이트/다크 테마 정의 시 사용
class CustomTheme {
  final CustomColors colors;        // 색상 테마
  final CustomTypography textStyle; // 텍스트 스타일 테마

  CustomTheme({required this.colors, required this.textStyle});
}
