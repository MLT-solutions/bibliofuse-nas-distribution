[English](docker-install.md) | [Español](docker-install.es.md) | [Français](docker-install.fr.md) | [Nederlands](docker-install.nl.md) | [Português](docker-install.pt.md) | [Русский](docker-install.ru.md) | [简体中文](docker-install.zh-CN.md) | [日本語](docker-install.ja.md) | [한국어](docker-install.ko.md) | [Bahasa Indonesia](docker-install.id.md) | [Bahasa Melayu](docker-install.ms.md)

# Docker のインストールと運用

## ブラウザの言語

セットアップ後、設定で **Language** を選びます。システム言語または英語、スペイン語、フランス語、オランダ語、ポルトガル語、ロシア語、簡体字中国語、日本語、韓国語、インドネシア語、マレー語を選択できます。選択はこのブラウザだけに保存され、コンテナとライブラリメタデータには影響しません。

## 1. フォルダを選ぶ

| 用途 | コンテナパス | 必要なアクセス | バックアップ |
| --- | --- | --- | --- |
| アカウント、ID、カタログ、設定 | `/config` | 読み書き | 必要 |
| 準備済みページとサムネイル | `/cache` | 読み書き | 不要 |
| 書籍ライブラリ | `/library` | 読み取り専用 | 別途実施 |

コンテナパスは固定です。`CONFIG_PATH`、`CACHE_PATH`、`LIBRARY_PATH` はホスト上の実フォルダを指定します。Docker はライブラリを自動検出しません。初回起動前にマウントし、その後設定で接続するフォルダを選びます。

## 2. Compose を設定

`docker/` のファイルをダウンロードし、`.env.example` を `.env` にコピーして編集します。サーバーでは絶対パスを使います。Linux の数値ユーザー/グループ ID は次で確認できます。

```sh
id
```

`PUID` と `PGID` は config/cache に書き込み、ライブラリを読める ID に設定します。BiblioFuse は root では動作しません。

## 3. 起動と確認

```sh
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail=100 bibliofuse
```

`http://<server-ip>:7343` を開き、管理者を作成して設定で **Attach library** を選びます。ピッカーには設定済み **Library** マウントとサブフォルダが表示されますが、新規インストールには選択して Refresh するまで接続済みルートがありません。同一 NAS でネイティブ Synology パッケージとこの host-network Docker サービスを併用しないでください。両者は `7342` と `7343` を使用します。最初の Refresh は全ツリーを走査し、その後は未変更アーカイブのメタデータを再利用します。

## 4. 別のライブラリを追加

Library Root はコンテナ内に存在するパスでなければなりません。まず `compose.yaml` に読み取り専用マウントを追加します。

```yaml
volumes:
  - "/srv/books:/library:ro"
  - "/srv/manga:/books/manga:ro"
environment:
  BF_LIBRARY_BROWSE_ROOTS: >-
    [{"name":"Library","path":"/library"},{"name":"Manga","path":"/books/manga"}]
```

コンテナを再作成してから設定 → Attach library で **Manga** を選びます。Web UI に `/books/manga` やホストパス `/srv/manga` を入力しません。マウント名を変えた場合は **Change** を使うとカタログ ID を保てます。**Disable** はカタログを保持し、**Detach** は最後のルートでもカタログ、メタデータ、読書位置を消去しますが、書籍やフォルダは削除しません。

## 5. Refresh の予定

設定は Disabled、Daily、Weekly をサポートし、時刻は 30 分単位です。`BF_TIME_ZONE` に `Asia/Kuala_Lumpur` などの有効な IANA タイムゾーンを設定します。

## 6. 更新

管理された展開には番号付きイメージタグを推奨します。`/config` をバックアップしてから実行します。

```sh
docker compose pull
docker compose up -d
docker image prune
```

`docker image prune` は任意で、未使用イメージデータだけを削除し、書籍は削除しません。

## 7. 停止またはアンインストール

```sh
docker compose down
```

これはコンテナとネットワークを削除しますが、ホストの config、cache、ライブラリは削除しません。明示的な初期化では、`docker compose down` を実行し、`CONFIG_PATH` と `CACHE_PATH` をバックアップして保持用にリネームし、同名で権限の正しい空フォルダを作ってから `docker compose up -d` を実行し、新しい管理者を作成します。`LIBRARY_PATH` は絶対にリネーム、空にする、削除しないでください。読み取り専用でマウントされています。

## 自宅外からのブラウザアクセス

ルーターで `7343` を直接転送しないでください。認証と有効な証明書を持つ信頼できる HTTPS リバースプロキシ、または自分の VPN/Tailscale を使います。Tailscale のブラウザアクセスは NAS/サーバーの Tailscale アドレスと `:7343` を使います。現在公開済み iOS/visionOS アプリに Docker ペアリングを追加するものではありません。

## トラブルシューティング

### ライブラリピッカーが空

- `LIBRARY_PATH` が実際のホストフォルダであり、`docker compose up` 前に設定されていることを確認します。
- `docker compose config` を実行して `/library:ro` マウントを確認します。
- `PUID:PGID` がホストフォルダを読めることを確認します。
- マウント変更後はコンテナを再作成し、設定を開き直します。

### Permission denied

選択した数値ユーザー/グループがマウント済みフォルダへアクセスできません。ホスト権限を修正するか、正しい `PUID`/`PGID` を選びます。最初の対策として root 実行にしないでください。

### 読書中にページが止まる

CPU とディスク使用状況を確認します。コールドアーカイブページは展開と準備が必要です。サーバーは次ページを先読みしますが、低電力 NAS CPU では短い間隔が発生することがあります。繰り返し読書は永続 cache の恩恵を受けます。

### コンテナが繰り返し再起動する

```sh
docker compose ps
docker compose logs --tail=200 bibliofuse
```

無効なマウントパス、config/cache 書き込み権限、ポート競合、破損または不完全な `.env` を確認します。

### 管理者パスワードを忘れた

メール復旧はありません。検証情報は `/config` にあるため、コンテナの再作成だけではパスワードはリセットされません。既存 BiblioFuse アカウント、ID、カタログ、設定を失ってもよい場合だけ、上記の明示的初期化を使ってください。ライブラリ自体はそのまま残ります。
