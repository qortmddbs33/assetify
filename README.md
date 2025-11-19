# Assetify

대웅그룹의 Notion 기반 NT/PC 데이터베이스를 모바일·태블릿에서 직접 조회하고 갱신할 수 있는 사내 자산 관리 앱입니다. Notion API + Flutter + GetX 조합으로 설계해, 현장 담당자가 바코드 스캔만으로 상태를 변경하고 세부 정보를 실시간으로 편집할 수 있도록 돕습니다.

- [프로젝트 개요](#프로젝트-개요)
- [주요 기능](#주요-기능)
- [화면 흐름](#화면-흐름)
- [아키텍처](#아키텍처)
- [Notion 연동 준비](#notion-연동-준비)
- [로컬 개발 및 실행](#로컬-개발-및-실행)
- [폴더 구조](#폴더-구조)

## 프로젝트 개요
- **목표**: Notion에 구축된 대웅그룹 NT/PC 자산 DB를 모바일 현장에서 빠르게 조회·수정.
- **플랫폼**: Flutter 3.10 (Android, iOS, Web 대응), GetX 기반 상태 관리 및 라우팅.
- **데이터 연동**: Cloudflare Workers 기반 Notion Proxy (`https://notion-proxy.sspyorea.workers.dev`)를 통해 Notion REST API 호출. 모든 호출은 `dio` 인터셉터로 인증 헤더 자동 부착.
- **보안**: Notion Integration 키는 디바이스 내 `flutter_secure_storage`에 암호화 저장. 앱 내부에서는 로그로 노출하지 않음.

## 주요 기능
1. **홈 & API 키 관리**
   - 기기에 저장된 Notion API 키 현황을 보여주고, Standard Bottom Sheet로 등록/수정/삭제.
   - API 키가 없으면 주요 메뉴 진입 전에 스낵바로 안내.
2. **자산 조회 (Asset Lookup)**
   - 자산번호 수동 입력 혹은 `ai_barcode_scanner`로 바코드 스캔 → Notion DB에서 페이지 조회.
   - 조회 실패 시 사용자 친화적인 오류 메시지 제공.
3. **자산 상세/편집 (Asset Detail)**
   - Notion 페이지의 25개+ 속성을 도메인 섹션(기본, 하드웨어, 일정, 비용, 상태, 수리 등)으로 렌더링.
   - 속성 타입(title/rich_text/select/multi/date/number 등)에 맞는 편집 UI를 동적으로 구성하고, Notion Property Schema 기반 옵션을 실시간 요청.
   - Pull-to-refresh 로 최신 데이터 동기화, 변경 시 LinearProgressIndicator 로 상태 표시.
4. **빠른 상태 변경 (Quick Status)**
   - 바코드 스캔 → 선택한 상태 값, 날짜 조작(오늘 기록/삭제), 사유/진행상황 옵션을 한 번에 기록.
   - 연속 처리 모드를 켜면 성공 시 스캐너가 즉시 다시 열려 현장 일괄처리 효율 향상.
   - 최근 20건까지 처리 내역 카드로 확인 가능.

## 화면 흐름
1. **Splash → Home**: `AppLoader`가 기본 의존성(CredentialsService, ApiProvider)과 화면 회전, 120Hz 설정 등을 마치면 Native Splash 제거.
2. **Home**: API 키 유무를 표시하고 두 가지 주요 플로우(자산 조회, 빠른 상태 변경)로 진입.
3. **Asset Lookup → Asset Detail**: 자산번호 탐색 후 상세 페이지에서 속성 편집·동기화.
4. **Quick Status**: 상태 옵션 로딩 → 바코드 스캔 → Notion 업데이트 → 결과 로그.

개발 모드(`kReleaseMode == false`)에서는 `Routes.TEST`가 초기 진입점이라 실험 화면을 쉽게 열 수 있습니다. 릴리즈 빌드에서는 자동으로 홈 화면을 사용합니다.

## 아키텍처
- **GetX DI & 상태관리**
  - 페이지별 `Binding`에서 Controller/Service를 지연 등록해, 라우팅 시 필요한 의존성만 메모리에 로드.
  - `CredentialsService`는 앱 시작 시 싱글톤으로 초기화되어 `ApiProvider` 가 Notion 토큰을 공급받음.
- **API 레이어**
  - `ApiProvider`가 dio 인스턴스를 생성하고 공통 헤더/에러를 관리. LogInterceptor 로 요청/응답 캡처.
  - `NotionRepository`가 REST endpoint(`/databases/{id}/query`, `/pages/{id}` ...) 호출을 캡슐화.
- **도메인 서비스**
  - `NotionService`는 Repository를 감싸 자산 조회/업데이트, Property Schema 캐시, 타입별 페이로드 빌더를 담당.
  - `NotionPropertyParser`와 `NotionPropertyField`는 Notion의 다양한 필드 타입을 앱 친화적인 값/힌트로 변환.
- **UI 계층**
  - 모든 화면은 `CustomColors`, `CustomTypography` Theme Extension을 사용해 브랜드 일관성을 유지.
  - Bottom Sheet, Action Button 등 공통 UI는 `app/widgets` 의 컴포넌트로 모듈화.

데이터 플로우:  
`Controller` → `NotionService` → `NotionRepository` → `ApiProvider(dio)` → Notion Proxy → Notion DB  
응답은 `NotionPage/NotionProperties` 모델로 역직렬화되어 다시 Controller/화면으로 전달됩니다.

## Notion 연동 준비
1. Notion에서 **Internal Integration** 생성 후 시크릿 토큰을 발급받습니다(`ntn_...`).
2. 자산 데이터베이스를 Integration에게 공유하고, DB ID를 확인합니다.
3. `lib/app/core/utils/notion_environment.dart`에서 프록시 URL과 Database ID를 조직 환경에 맞게 수정합니다. (기본값은 운영 프록시와 대웅그룹 DB ID)
4. 애플리케이션 설치 후 홈 화면의 API 키 입력 영역에서 토큰을 저장합니다. 저장 즉시 `flutter_secure_storage`에 암호화되어 이후 모든 API 호출에 자동 적용됩니다.

## 로컬 개발 및 실행
1. **필수 도구**
   - Flutter SDK 3.10 이상, Dart 3.4+
   - Android Studio / Xcode, 해당 플랫폼용 에뮬레이터 또는 실기기
2. **의존성 설치**
   ```bash
   flutter pub get
   ```
3. **런치**
   ```bash
   flutter run --flavor dev
   ```
   (기본 flavor가 있다면 제거 가능. iOS의 경우 `cd ios && pod install` 을 먼저 수행)
4. **테스트**
   ```bash
   flutter test
   ```
5. **릴리즈 빌드**
   - Android: `flutter build apk --release`
   - iOS: `flutter build ipa --release`

## 폴더 구조
```
lib/
├── main.dart                     # 앱 엔트리, GetMaterialApp 설정
├── app/
│   ├── core/                     # 테마, 유틸리티, 로더
│   ├── pages/                    # Home / Asset Lookup / Asset Detail / Quick Status / Test
│   ├── provider/                 # dio Provider + Response 모델 + 인터셉터
│   ├── routes/                   # Routes 상수, GetPage 정의
│   ├── services/
│   │   ├── credentials/          # Notion API 키 secure storage
│   │   └── notion/               # 모델, 레포지토리, 서비스
│   └── widgets/                  # Bottom Sheet, Gesture 컴포넌트 등 공용 UI
assets/
├── fonts/ WantedSans ...         # 커스텀 폰트
├── images/                       # 브랜드 이미지/아이콘
```
