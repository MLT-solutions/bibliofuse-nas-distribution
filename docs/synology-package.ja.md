[English](synology-package.md) | [Español](synology-package.es.md) | [Français](synology-package.fr.md) | [Nederlands](synology-package.nl.md) | [Português](synology-package.pt.md) | [Русский](synology-package.ru.md) | [简体中文](synology-package.zh-CN.md) | [日本語](synology-package.ja.md) | [한국어](synology-package.ko.md) | [Bahasa Indonesia](synology-package.id.md) | [Bahasa Melayu](synology-package.ms.md)

# ネイティブ Synology パッケージ

## 現在の状態

> **重要：** `0.1.0-0056` は、[BiblioFuse for iOS 2.1.8 (105) 以降](https://appstoreconnect.apple.com/teams/94c57d4b-571f-4fc1-bee8-61d285a65029/apps/6758330093/testflight/visionos/768998c3-02f2-45e6-b22a-30599d0485ae) でのみインストールしてください。

`0.1.0-0056` x86-64 パッケージは DSM 7 リリースです。共有フォルダ名、NAS アドレス、ライブラリパスをパッケージに埋め込みません。書籍は既存 DSM 共有フォルダに残り、BiblioFuse は自ら権限を付与したり DSM 権限を変更したりできません。設定は制限されたパッケージアカウントへの読み取り専用権限を案内します。Attach と Detach は索引だけを制御し、ライブラリファイルを削除しません。これはコンテナではなく、Package Center がライフサイクル、メインメニューアイコン、制限された内部アカウントを管理します。

## ブラウザの言語

設定の **Language** でシステム言語に従うか、英語、スペイン語、フランス語、オランダ語、ポルトガル語、ロシア語、簡体字中国語、日本語、韓国語、インドネシア語、マレー語を選べます。選択はこのブラウザだけに保存され、パッケージ更新後も残ります。

## インストールとアクセス権

1. Package Center → Manual Install から x86-64 `.spk` をインストールします。
2. BiblioFuse NAS を開き、12 文字以上の管理者を作成します。
3. 設定 → **Show the 6 steps** を開くか、次を実行します。
   1. DSM **Control Panel** → **Shared Folder** を開きます。
   2. 書籍を含む既存共有フォルダを選び **Edit** を選びます。
   3. **Permissions** を開きます。
   4. ドロップダウンを **System internal user** にします。
   5. `BiblioFuseNAS` を見つけ、**Read only** を許可して保存します。
   6. BiblioFuse → **Attach library** → **Refresh access** に戻り、共有または書籍サブフォルダを選びます。
4. **Refresh books** を選びます。

`/volume1/...` や `/var/packages/...` を入力する必要はなく、権限付与後のパッケージ再起動も不要です。

## データのライフサイクル

- **Disable：** カタログを保持し、再度有効にできます。
- **Detach：** その接続の BiblioFuse カタログ、メタデータ、読書位置を消去します。
- **Upgrade package：** アカウント、証明書 ID、設定、カタログ、cache を保持します。
- **Uninstall package：** BiblioFuse 所有のアカウント、パスワード、ID、設定、カタログ、ログ、cache をすべて消去します。
- **Library：** 常にパッケージデータの外にあり、削除されません。

プライベート v8 テストパッケージからのアップグレードは、ルート ID を保持したまま package-share エイリアスを通常の DSM volume パスへ移行します。

## ネットワークと現在のサポート境界

- `7343/tcp`：信頼できる LAN 上の無料ブラウザライブラリとリーダー。
- `7342/tcp`：ピン留め HTTPS ネイティブクライアントリスナー。
- `7341/tcp`：予約済みで未使用。

起動時に DSM から有効なプライベート LAN アドレスを導出し、NAS ホストから Bonjour を直接広告します。DSM Tailscale が有効なら `tailscale0` アドレスを任意の手動接続候補として表示します。大きなネイティブ JSON 応答には、公開済み Apple のピン留め転送との互換性のため `Content-Length` が含まれます。公開済み iOS/visionOS アプリは Bonjour とピン留め HTTPS によるローカル Wi-Fi ペアリングをサポートしますが、ネイティブ配信にはアプリの Premium 境界が適用されます。

## アーキテクチャ

初期パッケージは Synology x86-64 をサポートします。ARM64 は未ビルド、未テストです。ダウンロード前に NAS CPU アーキテクチャを確認してください。
