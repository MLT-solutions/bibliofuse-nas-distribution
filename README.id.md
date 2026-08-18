[English](README.md) | [Español](README.es.md) | [Français](README.fr.md) | [Nederlands](README.nl.md) | [Português](README.pt.md) | [Русский](README.ru.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Bahasa Indonesia](README.id.md) | [Bahasa Melayu](README.ms.md)

<p align="center"><img src="assets/bibliofuse-logo.png" alt="Logo BiblioFuse" width="180"></p>

# BiblioFuse NAS

Perpustakaan ebook dan komik pribadi yang di-host sendiri untuk Docker dan Synology NAS. [Situs BiblioFuse](https://bibliofuse.com)

## Gratis untuk di-host dan dibaca di browser

BiblioFuse NAS gratis di-host dalam Docker atau Synology Container Manager; pustaka web dan pembaca browser juga gratis. Repositori distribusi publik ini hanya berisi berkas instalasi dan dokumentasi, bukan kode sumber server.

## Status produk

| Host atau klien | Ketersediaan | Dukungan membaca dan koneksi |
| --- | --- | --- |
| Docker / Synology Container Manager | Beta publik `0.1.11` | Server gratis, UI browser, streaming native Wi-Fi lokal |
| Pembaca web BiblioFuse | Termasuk | CBZ, ZIP, CBR, RAR, EPUB, TXT, TEXT, Markdown |
| Aplikasi iOS / visionOS yang dirilis dengan Docker | Wi-Fi lokal | Penemuan Bonjour dan streaming HTTPS yang dipin; Premium diterapkan aplikasi native |
| Aplikasi Synology Package Center (`.spk`) | Rilis x86-64 publik | Paket non-root dengan panduan akses baca-saja ke folder DSM yang ada |
| Streaming iOS / visionOS dari aplikasi Synology | Wi-Fi lokal | Penemuan Bonjour dan HTTPS dipin; Premium diterapkan aplikasi native |
| Host BiblioFuse Mac / PC | Produk terpisah | Disarankan untuk streaming native paling lancar |

Docker dan pembaca browser tetap gratis. Streaming native adalah fitur Premium aplikasi iOS/visionOS pada Wi-Fi lokal yang sama.

## Bahasa browser

Aplikasi browser dapat mengikuti bahasa sistem atau memilih English, Spanish, French, Dutch, Portuguese, Russian, Simplified Chinese, Japanese, Korean, Indonesian, atau Malay di Settings. Pilihan hanya disimpan di browser dan tidak mengubah konfigurasi server, metadata pustaka, atau klien native.

## Harapan performa

NAS yang selalu hidup nyaman, privat, dan hemat daya, tetapi biasanya lebih lambat daripada Mac/PC modern dalam menyiapkan halaman komik/arsip. Mac/PC terbaik untuk pembacaan native mulus; NAS ideal untuk pustaka pribadi yang selalu tersedia. CPU memengaruhi pengindeksan, dekompresi, thumbnail, dan persiapan halaman berikutnya. SSD/NVMe dapat membantu pembacaan dingin dan akses berulang, tetapi tidak membuat CPU NAS berdaya rendah setara desktop. Mode komik berkelanjutan memuat halaman bertahap; jeda singkat pada halaman berikut yang belum di-cache adalah normal. Server melakukan cache dan pra-persiapan halaman berikutnya.

## Sebelum memulai

Anda memerlukan host Docker Compose 64-bit Intel/AMD atau ARM64, atau Synology dengan Container Manager; folder config persisten, folder cache yang boleh dibuang, folder buku, dan TCP `7343` tersedia. Contoh folder Synology:

```text
/volume1/docker/bibliofuse/config
/volume1/docker/bibliofuse/cache
/volume1/books
```

Jalur dapat berbeda; BiblioFuse tidak pernah memerlukan akses tulis ke folder buku.

## Instal dengan Docker Compose

1. Unduh `docker/compose.yaml` dan `docker/.env.example`, lalu salin `.env.example` menjadi `.env`.
2. Atur `CONFIG_PATH`, `CACHE_PATH`, `LIBRARY_PATH`, `PUID`, `PGID`, dan `BF_TIME_ZONE`. `LIBRARY_PATH` adalah folder host Anda sendiri.
3. Jalankan:

```sh
docker compose up -d
```

4. Buka `http://<server-ip>:7343`, buat administrator pertama, lalu di Settings pilih **Attach library**, lokasi **Library** atau subfolder, kemudian **Refresh**.

Compose hanya menyediakan `LIBRARY_PATH` sebagai **Library** dan pemasangan baru tidak otomatis melampirkan folder. Lihat [panduan instalasi Docker](docs/docker-install.id.md).

## Instal dengan Synology Container Manager

Gunakan `synology/compose.yaml` sebagai proyek Container Manager, atur variabel ke jalur Synology absolut, lalu buka:

```text
http://<nas-ip>:7343
```

Proyek memasang DSM `/volume1` sebagai baca-saja dan hanya menampilkan share yang benar-benar dapat dibaca `PUID`/`PGID` terpilih. Tidak ada folder yang dilampirkan sebelum administrator memilihnya di Settings; config dan cache harus dapat ditulis. Pustaka dapat diubah, dinonaktifkan, atau dilepas; pelepasan menghapus katalog, metadata, dan progres akar itu tanpa menghapus buku. Lihat [tutorial Synology](docs/synology-container-manager.id.md). Jangan jalankan proyek Docker dan paket Synology native bersamaan pada NAS yang sama karena keduanya memakai `7342` dan `7343`.

## Paket Synology native

Paket x86-64 umum berjalan sebagai akun DSM terbatas `BiblioFuseNAS`, tidak membuat, memindahkan, atau mengasumsikan pustaka. Settings memandu pemberian izin baca-saja ke share yang ada dan pemilih hanya menampilkan share yang benar-benar dapat dibaca. Lihat [panduan paket Synology native](docs/synology-package.id.md).

## Refresh, format, dan keamanan

**Refresh** memeriksa seluruh pohon folder untuk penambahan, penghapusan, dan penggantian nama, serta hanya mengindeks ulang buku baru/berubah. Refresh otomatis awalnya nonaktif; pilih harian atau mingguan dan waktu memakai `BF_TIME_ZONE`. Pembaca web mendukung CBZ/ZIP/CBR/RAR, EPUB, TXT/TEXT/Markdown; PDF belum tersedia. Kata sandi admin pertama minimal 12 karakter. `7343` adalah UI browser: gunakan LAN tepercaya atau proxy balik HTTPS tepercaya, jangan teruskan dari router. `7342` adalah API HTTPS klien native yang dipin; `7341` dicadangkan dan tidak boleh dipublikasikan.

## Cadangan, pembaruan, dan unduhan

Cadangkan seluruh folder config persisten; cache dapat dibuang dan pustaka tetap berada di folder NAS/host sendiri. Sebelum memperbarui, unduh cadangan BiblioFuse dari Settings dan simpan salinan config.

```sh
docker compose pull
docker compose up -d
```

Membuat ulang kontainer dengan folder config yang sama tidak menghapus akun atau katalog; melepas pustaka menghapus katalog, anotasi, dan progres akar tersebut.

- **Image Docker:** `ghcr.io/mlt-solutions/bibliofuse-nas:0.1.11`
- **Templat Docker dan Container Manager:** repositori ini
- **Catatan versi dan aset unduhan:** GitHub Releases
- **Synology `.spk`:** GitHub Releases (`x86-64` DSM 7)
- **Ikhtisar produk dan aplikasi native:** [bibliofuse.com](https://bibliofuse.com)

Image Docker adalah beta publik. Kedua metode host mendukung penemuan native Bonjour Wi-Fi lokal; Docker tidak menyediakan rute native Tailscale/manual.

## Bantuan

Mulai dari [instalasi dan operasi Docker](docs/docker-install.id.md), [tutorial Synology Container Manager](docs/synology-container-manager.id.md), [paket Synology native](docs/synology-package.id.md), [panduan performa](docs/performance.md), dan [kanal rilis serta aplikasi native](docs/releases-and-native-apps.md). Saat meminta bantuan, sertakan model NAS/host, arsitektur CPU, versi Docker, format buku, dan log kontainer terbaru; jangan publikasikan kata sandi, kunci privat, nama berkas sensitif, atau isi config.
