# Synology Container Manager チュートリアル

[English](synology-container-manager.md) | [Español](synology-container-manager.es.md) | [Français](synology-container-manager.fr.md) | [Nederlands](synology-container-manager.nl.md) | [Português](synology-container-manager.pt.md) | [Русский](synology-container-manager.ru.md) | [简体中文](synology-container-manager.zh-CN.md) | [日本語](synology-container-manager.ja.md) | [한국어](synology-container-manager.ko.md) | [Bahasa Indonesia](synology-container-manager.id.md) | [Bahasa Melayu](synology-container-manager.ms.md)

このガイドでは、Container Manager を使って無料の Docker サーバーと Web UI をインストールします。別途テスト済みのネイティブ DSM パッケージについては、[Synology パッケージガイド](synology-package.ja.md)をご覧ください。

## 要件

- Container Manager を搭載した DSM 7
- 公開イメージに対応する Intel/AMD 64 ビットまたは ARM64 モデル
- 共有フォルダと Container Manager プロジェクトを作成する権限

## 1. フォルダを作成する

File Station で次を作成します。

```text
docker/bibliofuse/config
docker/bibliofuse/cache
```

プロジェクトは DSM `/volume1` を読み取り専用でマウントします。設定には、構成した DSM アカウントが実際に読み取れる共有フォルダが表示されます。自動的に接続されることはありません。

## 2. コンテナユーザーを選択する

コンテナには、設定/キャッシュへの書き込みとライブラリの読み取りが必要です。これらの権限を持つ専用 DSM アカウントの数値 UID と GID を使用してください。SSH で次を実行します。

```sh
id <username>
```

デフォルトの `1026:100` は例であり、お使いの NAS と一致しない場合があります。

## 3. プロジェクトを作成する

1. `synology/compose.yaml` をダウンロードします。
2. Container Manager → Project → Create を開きます。
3. `bibliofuse` などのプロジェクト名を選びます。
4. Compose ファイルをアップロードまたは貼り付けます。
5. 次を設定します。
   - `CONFIG_PATH`、例: `/volume1/docker/bibliofuse/config`
   - `CACHE_PATH`、例: `/volume1/docker/bibliofuse/cache`
   - `PUID` と `PGID`
   - `BF_TIME_ZONE`、例: `Asia/Kuala_Lumpur`
6. プロジェクトをビルド/開始します。

## 4. 初期設定

次を開きます。

```text
http://<nas-ip>:7343
```

12 文字以上の管理者パスワードを作成します。設定で **Attach library** を選び、表示された DSM 共有フォルダまたは書籍サブフォルダを選択してから Refresh を選びます。DSM パスやコンテナパスを入力する必要はありません。選択画面では、選択したコンテナ UID/GID に基づいて読み取れない共有フォルダが除外されます。

ルートは変更、無効化、削除できます。無効化するとカタログデータは保持されます。削除すると、そのルートの BiblioFuse カタログ、メタデータ、読書進捗が消去されますが、ファイルやフォルダは削除されません。最後のルートを削除しても、有効な空のライブラリは残ります。

## 5. 読書と更新

更新ではマウントされたツリー全体を確認し、新規、変更、名前変更、削除された書籍をインデックス化します。自動更新は既定で無効です。設定から毎日または毎週の更新を予約できます。

連続コミックモードではページが段階的に読み込まれます。DS923+ などの NAS では、キャッシュされていないアーカイブページで短い読み込み遅延が発生することがあります。Mac または PC ホストなら、CPU がページをより速く展開・準備できるため、一般により滑らかなネイティブストリーミングを利用できます。

## 6. バックアップとアップグレード

- Hyper Backup に設定フォルダを含めます。
- キャッシュは除外できます。
- アップグレード前に、設定から BiblioFuse バックアップをダウンロードします。
- データベース移行は前方互換のみの場合があるため、以前の設定バックアップを保持します。
- フォルダマッピングを変更せずに新しいイメージを取得し、プロジェクトを再作成します。

マッピング済みの設定またはライブラリフォルダを削除するアンインストールオプションは絶対に選択しないでください。

Container Manager を初期化するには、プロジェクトを停止し、構成済みの設定・キャッシュフォルダをバックアップして名前変更します。元の名前と権限で新しい空フォルダを作成してから、再起動します。このクリーンアップにライブラリフォルダを含めないでください。

## 7. ネットワーク境界

- `7343`: 信頼できる LAN 上の無料ブラウザー UI
- `7342`: Bonjour によりローカル Wi-Fi で検出される、固定されたネイティブクライアント HTTPS API
- `7341`: 公開しないでください

Container Manager とネイティブ `.spk` は、Bonjour を介してローカル Wi-Fi 上でリリース済み iOS/visionOS アプリとペアリングします。ネイティブストリーミングは引き続きネイティブアプリの Premium 機能範囲に従います。Docker は手動/Tailscale のネイティブルートを提供しません。

この Container Manager プロジェクトを、同じ NAS 上のネイティブ BiblioFuse Synology パッケージと並行して実行しないでください。両サービスは `7342` と `7343` をバインドします。どちらか一方のインストール方法を選択してください。
