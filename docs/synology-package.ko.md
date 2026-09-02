[English](synology-package.md) | [Español](synology-package.es.md) | [Français](synology-package.fr.md) | [Nederlands](synology-package.nl.md) | [Português](synology-package.pt.md) | [Русский](synology-package.ru.md) | [简体中文](synology-package.zh-CN.md) | [日本語](synology-package.ja.md) | [한국어](synology-package.ko.md) | [Bahasa Indonesia](synology-package.id.md) | [Bahasa Melayu](synology-package.ms.md)

# 네이티브 Synology 패키지

## 현재 상태

> **중요:** `0.1.0-0057`는 [BiblioFuse for iOS 2.1.8 (105) 이상](https://appstoreconnect.apple.com/teams/94c57d4b-571f-4fc1-bee8-61d285a65029/apps/6758330093/testflight/visionos/768998c3-02f2-45e6-b22a-30599d0485ae)에서만 설치하세요.

`0.1.0-0057` x86-64 패키지는 DSM 7 릴리스입니다. 공유 폴더 이름, NAS 주소 또는 라이브러리 경로를 패키지에 넣지 않습니다. 책은 기존 DSM 공유 폴더에 남고 BiblioFuse는 스스로 권한을 부여하거나 DSM 권한을 바꿀 수 없습니다. 설정은 제한된 패키지 계정에 읽기 전용 권한을 부여하는 방법을 안내합니다. Attach와 Detach는 인덱싱만 제어하며 라이브러리 파일을 삭제하지 않습니다. 이는 컨테이너가 아니며 Package Center가 수명 주기, 메인 메뉴 아이콘, 제한된 시스템 내부 계정을 관리합니다.

## 브라우저 언어

설정의 **Language**에서 시스템 언어를 따르거나 영어, 스페인어, 프랑스어, 네덜란드어, 포르투갈어, 러시아어, 중국어 간체, 일본어, 한국어, 인도네시아어, 말레이어를 선택합니다. 선택은 해당 브라우저에만 저장되고 패키지 업그레이드 후에도 유지됩니다.

## 설치 및 접근 권한 부여

1. Package Center → Manual Install에서 x86-64 `.spk`를 설치합니다.
2. BiblioFuse NAS를 열고 12자 이상의 관리자를 만듭니다.
3. 설정 → **Show the 6 steps**를 열거나 다음을 실행합니다.
   1. DSM **Control Panel** → **Shared Folder**를 엽니다.
   2. 책이 있는 기존 공유 폴더를 선택하고 **Edit**를 누릅니다.
   3. **Permissions**를 엽니다.
   4. 드롭다운을 **System internal user**로 바꿉니다.
   5. `BiblioFuseNAS`를 찾아 **Read only**를 허용하고 저장합니다.
   6. BiblioFuse → **Attach library** → **Refresh access**로 돌아가 공유 또는 책 하위 폴더를 선택합니다.
4. **Refresh books**를 선택합니다.

`/volume1/...` 또는 `/var/packages/...` 경로를 입력하거나 권한 부여 뒤 패키지를 재시작할 필요가 없습니다.

## 데이터 수명 주기

- **Disable:** 카탈로그를 유지하고 나중에 다시 활성화합니다.
- **Detach:** 해당 연결의 BiblioFuse 카탈로그, 메타데이터, 읽기 진행을 삭제합니다.
- **Upgrade package:** 계정, 인증서 ID, 설정, 카탈로그, cache를 유지합니다.
- **Uninstall package:** BiblioFuse가 소유한 계정, 비밀번호, ID, 설정, 카탈로그, 로그, cache를 모두 삭제합니다.
- **Library:** 항상 패키지 데이터 밖에 있고 삭제되지 않습니다.

비공개 v8 테스트 패키지에서 업그레이드하면 루트 ID를 유지하며 package-share 별칭을 정상 DSM volume 경로로 옮깁니다.

## 네트워크 및 지원 경계

- `7343/tcp`: 신뢰할 수 있는 LAN의 무료 브라우저 라이브러리와 리더
- `7342/tcp`: 고정 HTTPS 네이티브 클라이언트 리스너
- `7341/tcp`: 예약됨, 사용 안 함

시작 시 DSM에서 활성 사설 LAN 주소를 도출하고 NAS 호스트에서 Bonjour를 직접 알립니다. DSM Tailscale이 활성화되면 `tailscale0` 주소가 선택적 수동 연결 힌트로 포함됩니다. 큰 네이티브 JSON 응답에는 출시된 Apple 고정 전송 호환성을 위한 `Content-Length`가 포함됩니다. 출시된 iOS/visionOS 앱은 Bonjour와 고정 HTTPS를 통한 로컬 Wi-Fi 페어링을 지원하지만 네이티브 스트리밍에는 앱 Premium 경계가 적용됩니다.

## 아키텍처

초기 패키지는 Synology x86-64를 지원합니다. ARM64는 빌드 및 테스트되지 않았습니다. 다운로드 전에 NAS CPU 아키텍처를 확인하세요.
