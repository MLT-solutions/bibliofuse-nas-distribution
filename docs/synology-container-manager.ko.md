# Synology Container Manager 안내서

[English](synology-container-manager.md) | [Español](synology-container-manager.es.md) | [Français](synology-container-manager.fr.md) | [Nederlands](synology-container-manager.nl.md) | [Português](synology-container-manager.pt.md) | [Русский](synology-container-manager.ru.md) | [简体中文](synology-container-manager.zh-CN.md) | [日本語](synology-container-manager.ja.md) | [한국어](synology-container-manager.ko.md) | [Bahasa Indonesia](synology-container-manager.id.md) | [Bahasa Melayu](synology-container-manager.ms.md)

이 안내서에서는 Container Manager로 무료 Docker 서버와 웹 UI를 설치합니다. 별도로 테스트된 네이티브 DSM 패키지는 [Synology 패키지 안내서](synology-package.md)를 참조하세요.

## 요구 사항

- Container Manager가 포함된 DSM 7
- 공개 이미지에서 지원하는 Intel/AMD 64비트 또는 ARM64 모델
- 공유 폴더와 Container Manager 프로젝트를 생성할 권한

## 1. 폴더 만들기

File Station에서 다음을 만드세요.

```text
docker/bibliofuse/config
docker/bibliofuse/cache
```

프로젝트는 DSM `/volume1`을 읽기 전용으로 마운트합니다. 설정에는 구성한 DSM 계정이 실제로 읽을 수 있는 공유 폴더가 표시되며, 어떤 폴더도 자동으로 연결하지 않습니다.

## 2. 컨테이너 사용자 선택

컨테이너는 구성/캐시를 쓰고 라이브러리를 읽을 수 있어야 합니다. 이 권한이 있는 전용 DSM 계정의 숫자 UID와 GID를 사용하세요. SSH에서 실행합니다.

```sh
id <username>
```

기본값 `1026:100`은 예시일 뿐이며 NAS와 일치하지 않을 수 있습니다.

## 3. 프로젝트 만들기

1. `synology/compose.yaml`을 다운로드합니다.
2. Container Manager → Project → Create를 엽니다.
3. `bibliofuse` 같은 프로젝트 이름을 선택합니다.
4. Compose 파일을 업로드하거나 붙여넣습니다.
5. 다음을 설정합니다.
   - `CONFIG_PATH`, 예: `/volume1/docker/bibliofuse/config`
   - `CACHE_PATH`, 예: `/volume1/docker/bibliofuse/cache`
   - `PUID` 및 `PGID`
   - `BF_TIME_ZONE`, 예: `Asia/Kuala_Lumpur`
6. 프로젝트를 빌드/시작합니다.

## 4. 최초 설정

다음을 엽니다.

```text
http://<nas-ip>:7343
```

12자 이상인 관리자 비밀번호를 만드세요. 설정에서 **Attach library**를 선택하고 표시된 DSM 공유 폴더 또는 도서 하위 폴더를 선택한 다음 Refresh를 선택합니다. DSM 또는 컨테이너 경로를 입력할 필요가 없습니다. 선택기는 선택한 컨테이너 UID/GID를 기준으로 읽을 수 없는 공유 폴더를 걸러냅니다.

루트는 변경, 비활성화 또는 제거할 수 있습니다. 비활성화하면 카탈로그 데이터가 유지됩니다. 제거하면 파일이나 폴더는 삭제하지 않고 해당 루트의 BiblioFuse 카탈로그, 메타데이터 및 읽기 진행 상황을 삭제합니다. 마지막 루트를 제거해도 유효한 빈 라이브러리는 남습니다.

## 5. 읽기 및 새로 고침

새로 고침은 마운트된 전체 트리를 검사하고 새로 추가, 변경, 이름 변경 또는 제거된 도서를 색인화합니다. 자동 새로 고침은 기본적으로 비활성화되어 있으며 설정에서 매일 또는 매주 새로 고침을 예약할 수 있습니다.

연속 만화 모드는 페이지를 점진적으로 불러옵니다. DS923+ 또는 유사 NAS에서는 캐시되지 않은 아카이브 페이지에 잠시 로딩 지연이 발생할 수 있습니다. Mac 또는 PC 호스트는 CPU가 페이지를 더 빨리 압축 해제하고 준비할 수 있으므로 일반적으로 더 매끄러운 네이티브 스트리밍 경험을 제공합니다.

## 6. 백업 및 업그레이드

- Hyper Backup에 구성 폴더를 포함합니다.
- 캐시는 제외할 수 있습니다.
- 업그레이드 전에 설정에서 BiblioFuse 백업을 다운로드합니다.
- 데이터베이스 마이그레이션은 앞으로만 가능할 수 있으므로 이전 구성 백업을 보관합니다.
- 폴더 매핑을 변경하지 않고 새 이미지를 가져와 프로젝트를 다시 만듭니다.

매핑된 구성 또는 라이브러리 폴더를 삭제하는 제거 옵션은 절대 선택하지 마세요.

Container Manager를 초기화하려면 프로젝트를 중지하고 구성된 구성 및 캐시 폴더를 백업한 뒤 이름을 변경합니다. 원래 이름과 권한으로 새 빈 폴더를 만들고 다시 시작합니다. 이 정리에 라이브러리 폴더를 포함하지 마세요.

## 7. 네트워크 경계

- `7343`: 신뢰할 수 있는 LAN의 무료 브라우저 UI
- `7342`: Bonjour로 로컬 Wi-Fi에서 검색되는 고정 네이티브 클라이언트 HTTPS API
- `7341`: 게시하지 마세요

Container Manager와 네이티브 `.spk`는 Bonjour를 통해 로컬 Wi-Fi에서 출시된 iOS/visionOS 앱과 페어링됩니다. 네이티브 스트리밍은 계속 네이티브 앱의 Premium 기능 경계에 적용됩니다. Docker는 수동/Tailscale 네이티브 경로를 제공하지 않습니다.

이 Container Manager 프로젝트를 동일 NAS의 네이티브 BiblioFuse Synology 패키지와 함께 실행하지 마세요. 두 서비스가 모두 `7342`와 `7343`을 바인딩하므로 한 설치 방법만 선택하세요.
