[English](README.md) | [Español](README.es.md) | [Français](README.fr.md) | [Nederlands](README.nl.md) | [Português](README.pt.md) | [Русский](README.ru.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Bahasa Indonesia](README.id.md) | [Bahasa Melayu](README.ms.md)

<p align="center"><img src="assets/bibliofuse-logo.png" alt="BiblioFuse 로고" width="180"></p>

# BiblioFuse NAS

Docker 및 Synology NAS용 비공개 자체 호스팅 전자책·만화 라이브러리입니다. [BiblioFuse 웹사이트](https://bibliofuse.com)

## 무료 호스팅 및 브라우저 읽기

BiblioFuse NAS는 Docker 또는 Synology Container Manager에서 무료로 호스팅할 수 있으며 웹 라이브러리와 리더도 무료입니다. 이 공개 배포 저장소에는 설치 파일과 문서만 있으며 서버 소스 코드는 포함되지 않습니다.

## 제품 상태

| 호스트 또는 클라이언트 | 제공 상태 | 읽기 및 연결 지원 |
| --- | --- | --- |
| Docker / Synology Container Manager | 공개 베타 `0.1.10` | 무료 서버, 브라우저 UI, 로컬 Wi-Fi 네이티브 스트리밍 |
| BiblioFuse 웹 리더 | 포함 | CBZ, ZIP, CBR, RAR, EPUB, TXT, TEXT, Markdown |
| Docker 지원 iOS / visionOS 앱 | 로컬 Wi-Fi | Bonjour 검색과 고정 HTTPS 스트리밍, Premium은 네이티브 앱에서 적용 |
| Synology Package Center 앱(`.spk`) | 공개 x86-64 릴리스 | non-root 패키지, 기존 DSM 공유 폴더 읽기 전용 접근 안내 |
| Synology 앱의 iOS / visionOS 스트리밍 | 로컬 Wi-Fi | Bonjour 검색과 고정 HTTPS 스트리밍, Premium은 네이티브 앱에서 적용 |
| BiblioFuse Mac / PC 호스트 | 별도 제품 | 가장 부드러운 네이티브 스트리밍에 권장 |

Docker와 브라우저 리더는 무료입니다. 네이티브 스트리밍은 같은 로컬 Wi-Fi의 iOS/visionOS 앱 Premium 기능입니다.

## 브라우저 언어

브라우저 앱은 시스템 언어를 따르거나 설정에서 영어, 스페인어, 프랑스어, 네덜란드어, 포르투갈어, 러시아어, 중국어 간체, 일본어, 한국어, 인도네시아어, 말레이어를 선택할 수 있습니다. 선택은 해당 브라우저에만 저장되며 서버 설정, 라이브러리 메타데이터, 네이티브 클라이언트를 바꾸지 않습니다.

## 성능 예상

상시 NAS는 편리하고 전력 효율적이지만 만화/아카이브 페이지 준비는 현대 Mac/PC보다 보통 느립니다. Mac/PC는 부드러운 네이티브 읽기에, NAS는 항상 이용 가능한 개인 라이브러리에 적합합니다. CPU는 인덱싱, 압축 해제, 썸네일, 다음 페이지 준비에 영향을 줍니다. SSD/NVMe는 콜드 읽기와 반복 접근을 개선하지만 저전력 NAS CPU를 데스크톱 CPU처럼 만들지는 않습니다. 연속 만화 모드는 페이지를 점진적으로 로드하므로 캐시되지 않은 다음 페이지에서 짧은 공백이 정상일 수 있습니다. 서버는 준비된 페이지를 캐시하고 다음 페이지를 미리 준비합니다.

## 시작 전 준비

64비트 Intel/AMD 또는 ARM64 Docker Compose 호스트, 또는 Container Manager 지원 Synology, 영구 config 폴더, 삭제 가능한 cache 폴더, 책 폴더 및 사용 가능한 TCP `7343`이 필요합니다. Synology 예시는 다음과 같습니다.

```text
/volume1/docker/bibliofuse/config
/volume1/docker/bibliofuse/cache
/volume1/books
```

경로는 달라도 됩니다. BiblioFuse는 책 폴더 쓰기 권한을 필요로 하지 않습니다.

## Docker Compose 설치

1. 이 저장소의 `docker/compose.yaml` 및 `docker/.env.example`을 받고 후자를 `.env`로 복사합니다.
2. `CONFIG_PATH`, `CACHE_PATH`, `LIBRARY_PATH`, `PUID`, `PGID`, `BF_TIME_ZONE`을 설정합니다. `LIBRARY_PATH`는 사용자의 실제 호스트 폴더입니다.
3. 시작합니다.

```sh
docker compose up -d
```

4. `http://<server-ip>:7343`를 열어 첫 관리자를 만들고 설정에서 **Attach library** → 표시된 **Library** 또는 하위 폴더 → **Refresh**를 선택합니다.

Compose는 선택한 `LIBRARY_PATH`만 친숙한 **Library**로 제공합니다. 새 설치는 폴더를 자동 연결하지 않습니다. 자세한 내용은 [Docker 설치 가이드](docs/docker-install.ko.md)를 보세요.

## Synology Container Manager 설치

`synology/compose.yaml`을 Container Manager 프로젝트로 사용하고 변수에 절대 Synology 경로를 설정한 뒤 시작합니다.

```text
http://<nas-ip>:7343
```

이 프로젝트는 DSM `/volume1`을 읽기 전용으로 마운트하며 선택한 `PUID`/`PGID`가 실제로 읽을 수 있는 공유 폴더만 표시합니다. 관리자가 설정에서 선택하기 전에는 폴더가 연결되지 않습니다. config와 cache는 쓰기 가능해야 합니다. 설정에서 라이브러리를 변경, 비활성화, 분리할 수 있습니다. 분리는 해당 루트의 카탈로그, 메타데이터, 읽기 진행을 지우지만 책은 삭제하지 않습니다. [Synology 튜토리얼](docs/synology-container-manager.ko.md)을 참조하세요. 같은 NAS에서 Docker 프로젝트와 네이티브 패키지를 동시에 실행하지 마세요. 둘 다 `7342` 및 `7343`을 사용합니다.

## 네이티브 Synology 패키지

일반 x86-64 패키지는 제한된 DSM 계정 `BiblioFuseNAS`로 실행되며 라이브러리를 만들거나 이동하거나 가정하지 않습니다. 설정에서 기존 공유 폴더에 읽기 전용 권한을 부여하는 방법을 안내하며 선택기에는 실제로 읽을 수 있는 공유만 표시됩니다. [네이티브 Synology 패키지 가이드](docs/synology-package.ko.md)를 보세요.

## 새로 고침, 형식 및 보안

**Refresh**는 전체 폴더 트리의 추가, 제거, 이름 변경을 확인하고 새롭거나 변경된 책만 재인덱싱합니다. 자동 새로 고침은 기본적으로 꺼져 있으며 매일 또는 매주 선택할 수 있고 `BF_TIME_ZONE`을 사용합니다. 웹 리더는 CBZ/ZIP/CBR/RAR, EPUB, TXT/TEXT/Markdown을 지원하며 PDF는 아직 지원하지 않습니다. 첫 관리자 비밀번호는 12자 이상이어야 합니다. `7343`은 브라우저 UI이므로 신뢰할 수 있는 LAN 또는 HTTPS 리버스 프록시 뒤에 두고 라우터 포트 포워딩으로 노출하지 마세요. `7342`는 고정 네이티브 클라이언트 HTTPS API이고 `7341`은 예약되어 게시하면 안 됩니다.

## 백업, 업데이트 및 다운로드

영구 config 폴더 전체를 백업합니다. cache는 삭제 가능하고 라이브러리는 자신의 NAS/호스트 폴더에 남습니다. 업데이트 전 설정에서 BiblioFuse 백업을 내려받고 config 사본을 보관합니다.

```sh
docker compose pull
docker compose up -d
```

같은 config 폴더를 계속 마운트하면 컨테이너 재생성으로 계정이나 카탈로그가 삭제되지 않습니다. 라이브러리를 분리하면 해당 루트의 카탈로그, 주석, 진행이 삭제됩니다.

- **Docker 이미지:** `ghcr.io/mlt-solutions/bibliofuse-nas:0.1.10`
- **Docker/Container Manager 템플릿:** 이 저장소
- **버전 노트 및 다운로드 자산:** GitHub Releases
- **Synology `.spk`:** GitHub Releases (`x86-64` DSM 7)
- **제품 개요 및 네이티브 앱:** [bibliofuse.com](https://bibliofuse.com)

Docker 이미지는 공개 베타입니다. 두 호스트 방식은 로컬 Wi-Fi Bonjour 네이티브 검색을 지원하며 Docker에는 Tailscale/수동 네이티브 경로가 없습니다.

## 도움말

[Docker 설치 및 운영](docs/docker-install.ko.md), [Synology Container Manager 튜토리얼](docs/synology-container-manager.ko.md), [네이티브 Synology 패키지](docs/synology-package.ko.md), [성능 가이드](docs/performance.md), [릴리스 채널 및 네이티브 앱](docs/releases-and-native-apps.md)부터 확인하세요. 지원 요청에는 NAS/호스트 모델, CPU 아키텍처, Docker 버전, 책 형식, 최근 컨테이너 로그를 포함하고 비밀번호, 개인 키, 민감한 파일명, config 내용은 게시하지 마세요.
