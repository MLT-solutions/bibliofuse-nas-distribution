[English](synology-package.md) | [Español](synology-package.es.md) | [Français](synology-package.fr.md) | [Nederlands](synology-package.nl.md) | [Português](synology-package.pt.md) | [Русский](synology-package.ru.md) | [简体中文](synology-package.zh-CN.md) | [日本語](synology-package.ja.md) | [한국어](synology-package.ko.md) | [Bahasa Indonesia](synology-package.id.md) | [Bahasa Melayu](synology-package.ms.md)

# Paket Synology native

## Status saat ini

> **Penting:** Instal `0.1.0-0050` hanya dengan [BiblioFuse untuk iOS 2.1.8 (105) atau yang lebih baru](https://appstoreconnect.apple.com/teams/94c57d4b-571f-4fc1-bee8-61d285a65029/apps/6758330093/testflight/visionos/768998c3-02f2-45e6-b22a-30599d0485ae).

Paket x86-64 `0.1.0-0050` adalah rilis DSM 7. Nama shared folder, alamat NAS, dan jalur pustaka tidak ditanamkan ke paket. Buku tetap di shared folder DSM yang ada; BiblioFuse tidak dapat memberi dirinya akses atau mengubah izin DSM. Settings menjelaskan pemberian izin baca-saja untuk akun paket terbatas; Attach dan Detach hanya mengatur pengindeksan dan tidak pernah menghapus berkas pustaka. Paket ini bukan kontainer: Package Center mengelola siklus hidup, ikon menu utama, dan akun internal sistem yang dibatasi.

## Bahasa browser

Di Settings pilih **Language** untuk mengikuti bahasa sistem atau memilih English, Spanish, French, Dutch, Portuguese, Russian, Simplified Chinese, Japanese, Korean, Indonesian, atau Malay. Pilihan hanya tersimpan di browser tersebut dan tetap ada setelah upgrade paket.

## Instal dan beri akses

1. Instal `.spk` x86-64 melalui Package Center → Manual Install.
2. Buka BiblioFuse NAS dan buat administrator dengan minimal 12 karakter.
3. Buka Settings → **Show the 6 steps**, atau lakukan berikut:
   1. Buka DSM **Control Panel** → **Shared Folder**.
   2. Pilih shared folder yang berisi buku lalu pilih **Edit**.
   3. Buka **Permissions**.
   4. Ubah menu ke **System internal user**.
   5. Temukan `BiblioFuseNAS`, beri **Read only**, lalu simpan.
   6. Kembali ke BiblioFuse → **Attach library** → **Refresh access**, lalu pilih share atau subfolder buku.
4. Pilih **Refresh books**.

Tidak perlu mengetik jalur `/volume1/...` atau `/var/packages/...`, dan paket tidak perlu dimulai ulang setelah izin diberikan.

## Siklus data

- **Disable:** mempertahankan katalog agar dapat diaktifkan lagi.
- **Detach:** menghapus katalog, metadata, dan progres baca BiblioFuse pada lampiran itu.
- **Upgrade package:** mempertahankan akun, identitas sertifikat, pengaturan, katalog, dan cache.
- **Uninstall package:** menghapus data milik BiblioFuse: akun, kata sandi, identitas, pengaturan, katalog, log, dan cache.
- **Library:** selalu di luar data paket dan tidak pernah dihapus.

Upgrade dari paket uji privat v8 memigrasikan alias package-share ke jalur volume DSM normal sambil mempertahankan identitas akar.

## Jaringan dan batas dukungan

- `7343/tcp`: pustaka browser dan pembaca gratis di LAN tepercaya.
- `7342/tcp`: listener klien native HTTPS yang dipin.
- `7341/tcp`: dicadangkan dan tidak pernah digunakan.

Saat mulai, paket memperoleh alamat LAN privat aktif dari DSM dan mengiklankan Bonjour langsung dari host NAS. Jika DSM Tailscale aktif, alamat `tailscale0` disertakan sebagai saran koneksi manual opsional. Respons JSON native besar memiliki `Content-Length` untuk kompatibilitas transport Apple yang dipin. Pairing Wi-Fi lokal aplikasi iOS/visionOS rilis didukung melalui Bonjour dan HTTPS dipin; streaming native tetap tunduk pada batas Premium aplikasi native.

## Arsitektur

Paket awal mendukung Synology x86-64. ARM64 belum dibangun atau diuji; periksa arsitektur CPU NAS sebelum mengunduh.
