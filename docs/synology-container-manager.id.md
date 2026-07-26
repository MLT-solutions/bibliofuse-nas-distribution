# Panduan Synology Container Manager

[English](synology-container-manager.md) | [Español](synology-container-manager.es.md) | [Français](synology-container-manager.fr.md) | [Nederlands](synology-container-manager.nl.md) | [Português](synology-container-manager.pt.md) | [Русский](synology-container-manager.ru.md) | [简体中文](synology-container-manager.zh-CN.md) | [日本語](synology-container-manager.ja.md) | [한국어](synology-container-manager.ko.md) | [Bahasa Indonesia](synology-container-manager.id.md) | [Bahasa Melayu](synology-container-manager.ms.md)

Panduan ini memasang server Docker gratis dan UI web melalui Container Manager. Untuk paket DSM native yang diuji secara terpisah, lihat [panduan paket Synology](synology-package.id.md).

## Persyaratan

- DSM 7 dengan Container Manager
- Model Intel/AMD 64-bit atau ARM64 yang didukung oleh image yang diterbitkan
- Izin untuk membuat folder bersama dan proyek Container Manager

## 1. Buat folder

Di File Station, buat:

```text
docker/bibliofuse/config
docker/bibliofuse/cache
```

Proyek memasang DSM `/volume1` sebagai hanya-baca. Settings akan menampilkan folder bersama yang benar-benar dapat dibaca oleh akun DSM yang dikonfigurasi; tidak ada yang dilampirkan secara otomatis.

## 2. Pilih pengguna kontainer

Kontainer harus dapat menulis config/cache dan membaca pustaka. Gunakan UID dan GID numerik akun DSM khusus yang memiliki izin tersebut. Melalui SSH:

```sh
id <username>
```

Nilai default `1026:100` hanya contoh dan mungkin tidak cocok dengan NAS Anda.

## 3. Buat proyek

1. Unduh `synology/compose.yaml`.
2. Buka Container Manager → Project → Create.
3. Pilih nama proyek seperti `bibliofuse`.
4. Unggah atau tempel file Compose.
5. Atur:
   - `CONFIG_PATH`, misalnya `/volume1/docker/bibliofuse/config`
   - `CACHE_PATH`, misalnya `/volume1/docker/bibliofuse/cache`
   - `PUID` dan `PGID`
   - `BF_TIME_ZONE`, misalnya `Asia/Kuala_Lumpur`
6. Build/mulai proyek.

## 4. Pengaturan pertama

Buka:

```text
http://<nas-ip>:7343
```

Buat kata sandi administrator minimal 12 karakter. Di Settings, pilih **Attach library**, pilih folder bersama DSM yang ditampilkan atau subfolder buku, lalu pilih Refresh. Tidak perlu mengetik jalur DSM atau kontainer. Pemilih menyaring berbagi yang tidak dapat dibaca berdasarkan UID/GID kontainer yang dipilih.

Root dapat diubah, dinonaktifkan, atau dihapus. Menonaktifkan mempertahankan data katalog. Menghapus akan membersihkan katalog BiblioFuse, metadata, dan progres membaca root tersebut tanpa menghapus file atau folder; menghapus root terakhir akan menyisakan pustaka kosong yang valid.

## 5. Membaca dan menyegarkan

Refresh memeriksa seluruh pohon yang dipasang dan mengindeks buku baru, berubah, diganti nama, atau dihapus. Refresh otomatis dinonaktifkan secara default; Settings dapat menjadwalkan refresh harian atau mingguan.

Mode komik berkelanjutan memuat halaman secara bertahap. Pada DS923+ atau NAS serupa, jeda pemuatan singkat masih dapat terjadi pada halaman arsip yang tidak di-cache. Host Mac atau PC umumnya memberi pengalaman streaming native yang lebih mulus karena CPU-nya dapat mendekompresi dan menyiapkan halaman lebih cepat.

## 6. Cadangan dan peningkatan

- Sertakan folder config dalam Hyper Backup.
- Cache dapat dikecualikan.
- Unduh cadangan BiblioFuse di Settings sebelum meningkatkan versi.
- Simpan cadangan config sebelumnya karena migrasi database mungkin hanya dapat maju.
- Tarik image baru dan buat ulang proyek tanpa mengubah pemetaan folder.

Jangan pernah memilih opsi copot pemasangan yang menghapus folder config atau pustaka yang dipetakan.

Untuk reset pabrik Container Manager, hentikan proyek, cadangkan dan ganti nama folder config serta cache yang dikonfigurasi, buat folder kosong baru dengan nama dan izin asli, lalu mulai ulang. Jangan pernah menyertakan folder pustaka dalam pembersihan ini.

## 7. Batas jaringan

- `7343`: UI browser gratis pada LAN tepercaya
- `7342`: API HTTPS klien native yang dipatok, ditemukan melalui Bonjour di Wi-Fi lokal
- `7341`: jangan diterbitkan

Container Manager dan `.spk` native berpasangan dengan app iOS/visionOS yang telah dirilis pada Wi-Fi lokal melalui Bonjour. Streaming native tetap tunduk pada batas fitur Premium app native; Docker tidak menyediakan rute native manual/Tailscale.

Jangan menjalankan proyek Container Manager ini berdampingan dengan paket BiblioFuse Synology native pada NAS yang sama. Kedua layanan mengikat `7342` dan `7343`; pilih satu metode pemasangan.
