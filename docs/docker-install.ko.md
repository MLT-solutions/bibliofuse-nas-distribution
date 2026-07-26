[English](docker-install.md) | [Español](docker-install.es.md) | [Français](docker-install.fr.md) | [Nederlands](docker-install.nl.md) | [Português](docker-install.pt.md) | [Русский](docker-install.ru.md) | [简体中文](docker-install.zh-CN.md) | [日本語](docker-install.ja.md) | [한국어](docker-install.ko.md) | [Bahasa Indonesia](docker-install.id.md) | [Bahasa Melayu](docker-install.ms.md)

# Docker 설치 및 운영

## 브라우저 언어

설치 후 설정에서 **Language**를 고릅니다. 시스템 언어 또는 영어, 스페인어, 프랑스어, 네덜란드어, 포르투갈어, 러시아어, 중국어 간체, 일본어, 한국어, 인도네시아어, 말레이어를 선택할 수 있으며 선택은 이 브라우저에만 저장됩니다.

## 1. 폴더 선택

| 용도 | 컨테이너 경로 | 필요 접근 | 백업 |
| --- | --- | --- | --- |
| 계정, ID, 카탈로그, 설정 | `/config` | 읽기/쓰기 | 예 |
| 준비된 페이지와 썸네일 | `/cache` | 읽기/쓰기 | 아니요 |
| 책 라이브러리 | `/library` | 읽기 전용 | 별도 |

컨테이너 경로는 고정입니다. `CONFIG_PATH`, `CACHE_PATH`, `LIBRARY_PATH`가 호스트의 실제 폴더를 지정합니다. Docker는 라이브러리를 자동으로 찾지 않으므로 첫 실행 전에 마운트하고 설정에서 연결할 폴더를 선택합니다.

## 2. Compose 구성

`docker/` 파일을 내려받아 `.env.example`을 `.env`로 복사하고 절대 경로를 설정합니다. Linux의 숫자 사용자/그룹 ID는 다음으로 찾습니다.

```sh
id
```

`PUID`와 `PGID`는 config/cache에 쓰고 라이브러리를 읽을 수 있는 ID로 설정합니다. BiblioFuse는 root로 실행하지 않습니다.

## 3. 시작 및 확인

```sh
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail=100 bibliofuse
```

`http://<server-ip>:7343`를 열어 관리자를 만들고 설정에서 **Attach library**를 선택합니다. 선택기에는 구성된 **Library** 마운트와 하위 폴더가 표시되지만 선택 후 Refresh 전에는 연결된 루트가 없습니다. 같은 NAS에서 네이티브 Synology 패키지와 이 host-network Docker 서비스를 함께 실행하지 마세요. 둘 다 `7342`, `7343`을 사용합니다. 첫 Refresh는 전체 트리를 검사하고 이후에는 변경되지 않은 아카이브 메타데이터를 재사용합니다.

## 4. 다른 라이브러리 추가

Library Root는 컨테이너 안에 존재하는 경로여야 합니다. 먼저 `compose.yaml`에 읽기 전용 마운트를 추가합니다.

```yaml
volumes:
  - "/srv/books:/library:ro"
  - "/srv/manga:/books/manga:ro"
environment:
  BF_LIBRARY_BROWSE_ROOTS: >-
    [{"name":"Library","path":"/library"},{"name":"Manga","path":"/books/manga"}]
```

컨테이너를 다시 만들고 설정 → Attach library에서 **Manga**를 선택합니다. 웹 UI에 `/books/manga` 또는 호스트 경로 `/srv/manga`를 입력하지 않습니다. 마운트 이름 변경은 **Change**로 카탈로그 ID를 보존하고, **Disable**은 카탈로그를 유지하며, **Detach**는 마지막 루트에서도 카탈로그/메타데이터/진행을 지우되 책과 폴더는 지우지 않습니다.

## 5. Refresh 일정

설정은 Disabled, Daily, Weekly를 지원하며 시간은 30분 단위입니다. `BF_TIME_ZONE`에 `Asia/Kuala_Lumpur` 같은 유효한 IANA 시간대를 설정합니다.

## 6. 업데이트

제어된 배포에는 번호가 있는 이미지 태그를 권장합니다. `/config`를 백업한 뒤 실행합니다.

```sh
docker compose pull
docker compose up -d
docker image prune
```

`docker image prune`은 선택 사항이며 사용하지 않는 이미지 데이터만 제거하고 책은 제거하지 않습니다.

## 7. 중지 또는 제거

```sh
docker compose down
```

컨테이너와 네트워크만 제거하며 호스트 config, cache, 라이브러리는 삭제하지 않습니다. 명시적 초기화는 `docker compose down` 실행 후 `CONFIG_PATH`, `CACHE_PATH`를 백업하고 보관용으로 이름을 바꾼 뒤 같은 이름·권한의 빈 폴더를 만들고 `docker compose up -d`로 새 관리자를 만드는 방식입니다. 읽기 전용으로 마운트된 `LIBRARY_PATH`는 절대 이름 변경, 비우기, 삭제하지 마세요.

## 집 밖의 브라우저 접근 및 문제 해결

라우터에서 `7343`을 직접 포워딩하지 마세요. 인증과 유효한 인증서가 있는 HTTPS 리버스 프록시 또는 자신의 VPN/Tailscale을 사용합니다. Tailscale 브라우저 접근은 NAS/서버 Tailscale 주소 뒤 `:7343`이며 출시된 iOS/visionOS 앱에 Docker 페어링을 추가하지 않습니다. 라이브러리 선택기가 비면 `LIBRARY_PATH`, `docker compose config`의 `/library:ro`, `PUID:PGID` 읽기 권한을 확인하고 마운트 변경 후 컨테이너를 재생성합니다. **Permission denied**는 호스트 권한 또는 `PUID`/`PGID`를 고치며 root 실행은 첫 해결책이 아닙니다. 읽기 중 멈춤은 CPU/디스크와 압축 해제 때문일 수 있고 cache가 반복 읽기를 돕습니다. 재시작 반복은 다음 로그로 마운트 경로, 쓰기 권한, 포트 충돌, `.env`를 점검합니다.

```sh
docker compose ps
docker compose logs --tail=200 bibliofuse
```

관리자 비밀번호에는 이메일 복구가 없습니다. 검증 정보는 `/config`에 있으므로 컨테이너 재생성만으로 초기화되지 않습니다. 기존 계정, ID, 카탈로그, 설정을 잃어도 될 때만 위 초기화 절차를 사용하며 라이브러리 자체는 남습니다.
