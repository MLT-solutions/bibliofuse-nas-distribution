[English](README.md) | [Español](README.es.md) | [Français](README.fr.md) | [Nederlands](README.nl.md) | [Português](README.pt.md) | [Русский](README.ru.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Bahasa Indonesia](README.id.md) | [Bahasa Melayu](README.ms.md)

<p align="center"><img src="assets/bibliofuse-logo.png" alt="Logo BiblioFuse" width="180"></p>

# BiblioFuse NAS

Perpustakaan ebook dan komik persendirian yang dihos sendiri untuk Docker dan Synology NAS. [Laman web BiblioFuse](https://bibliofuse.com)

## Percuma untuk dihos dan dibaca dalam pelayar

BiblioFuse NAS percuma untuk dihos dalam Docker atau Synology Container Manager; pustaka web dan pembaca pelayar juga percuma. Repositori pengedaran awam ini hanya mengandungi fail pemasangan dan dokumentasi, bukan kod sumber pelayan.

## Status produk

| Hos atau klien | Ketersediaan | Sokongan membaca dan sambungan |
| --- | --- | --- |
| Docker / Synology Container Manager | Beta awam `0.1.8` | Pelayan percuma, UI pelayar, penstriman asli Wi-Fi setempat |
| Pembaca web BiblioFuse | Termasuk | CBZ, ZIP, CBR, RAR, EPUB, TXT, TEXT, Markdown |
| Aplikasi iOS / visionOS yang dikeluarkan dengan Docker | Wi-Fi setempat | Penemuan Bonjour dan penstriman HTTPS dipin; Premium dikuatkuasakan aplikasi asli |
| Aplikasi Synology Package Center (`.spk`) | Keluaran x86-64 awam | Pakej bukan root dengan panduan akses baca sahaja ke folder DSM sedia ada |
| Penstriman iOS / visionOS daripada aplikasi Synology | Wi-Fi setempat | Penemuan Bonjour dan HTTPS dipin; Premium dikuatkuasakan aplikasi asli |
| Hos BiblioFuse Mac / PC | Produk berasingan | Disyorkan untuk penstriman asli paling lancar |

Docker dan pembaca pelayar kekal percuma. Penstriman asli ialah ciri Premium aplikasi iOS/visionOS pada Wi-Fi setempat yang sama.

## Bahasa pelayar

Aplikasi pelayar boleh mengikut bahasa sistem atau memilih English, Spanish, French, Dutch, Portuguese, Russian, Simplified Chinese, Japanese, Korean, Indonesian, atau Malay dalam Settings. Pilihan disimpan dalam pelayar itu sahaja dan tidak mengubah konfigurasi pelayan, metadata pustaka atau klien asli.

## Jangkaan prestasi

NAS yang sentiasa hidup adalah mudah, peribadi dan jimat kuasa, tetapi biasanya lebih perlahan daripada Mac/PC moden ketika menyediakan halaman komik atau arkib. Mac/PC terbaik untuk pembacaan asli yang lancar; NAS sesuai untuk pustaka peribadi yang sentiasa tersedia. CPU mempengaruhi pengindeksan, nyahmampat, thumbnail dan penyediaan halaman seterusnya. SSD/NVMe membantu bacaan sejuk dan akses berulang tetapi tidak menjadikan CPU NAS kuasa rendah setara desktop. Mod komik berterusan memuat halaman secara beransur; jurang ringkas bagi halaman belum cache adalah normal. Pelayan menyimpan cache halaman dan menyediakan halaman seterusnya lebih awal.

## Sebelum bermula

Anda memerlukan hos Docker Compose Intel/AMD atau ARM64 64-bit, atau Synology dengan Container Manager; folder config kekal, folder cache boleh buang, folder buku dan TCP `7343` yang tersedia. Contoh Synology:

```text
/volume1/docker/bibliofuse/config
/volume1/docker/bibliofuse/cache
/volume1/books
```

Laluan boleh berbeza; BiblioFuse tidak pernah memerlukan akses tulis ke folder buku.

## Pasang dengan Docker Compose

1. Muat turun `docker/compose.yaml` dan `docker/.env.example`, kemudian salin yang terakhir sebagai `.env`.
2. Tetapkan `CONFIG_PATH`, `CACHE_PATH`, `LIBRARY_PATH`, `PUID`, `PGID`, dan `BF_TIME_ZONE`. `LIBRARY_PATH` ialah folder hos anda sendiri.
3. Mulakan:

```sh
docker compose up -d
```

4. Buka `http://<server-ip>:7343`, cipta pentadbir pertama, kemudian dalam Settings pilih **Attach library**, **Library** yang dipaparkan atau subfolder, dan **Refresh**.

Compose hanya menyediakan `LIBRARY_PATH` sebagai **Library**; pemasangan baharu tidak melampirkan folder secara automatik. Lihat [panduan pemasangan Docker](docs/docker-install.ms.md).

## Pasang dengan Synology Container Manager

Gunakan `synology/compose.yaml` sebagai projek Container Manager, tetapkan pemboleh ubah kepada laluan Synology mutlak, dan buka:

```text
http://<nas-ip>:7343
```

Projek ini memasang DSM `/volume1` sebagai baca sahaja dan hanya menyenaraikan perkongsian yang benar-benar boleh dibaca `PUID`/`PGID` terpilih. Tiada folder dilampirkan sehingga pentadbir memilihnya dalam Settings; config dan cache mesti boleh ditulis. Pustaka boleh diubah, dilumpuhkan atau ditanggalkan; penanggalan mengosongkan katalog, metadata dan kemajuan akar itu tanpa memadam buku. Lihat [tutorial Synology](docs/synology-container-manager.ms.md). Jangan jalankan projek Docker dan pakej Synology asli pada NAS yang sama kerana kedua-duanya menggunakan `7342` dan `7343`.

## Pakej Synology asli

Pakej x86-64 generik berjalan sebagai akaun DSM terhad `BiblioFuseNAS`, tidak mencipta, memindah atau menganggap pustaka. Settings menerangkan pemberian kebenaran baca sahaja pada perkongsian sedia ada, dan pemilih hanya memaparkan perkongsian yang benar-benar boleh dibaca. Lihat [panduan pakej Synology asli](docs/synology-package.ms.md).

## Refresh, format dan keselamatan

**Refresh** memeriksa seluruh pepohon folder untuk penambahan, penyingkiran dan penukaran nama, serta hanya mengindeks semula buku baharu/berubah. Refresh automatik dilumpuhkan secara lalai; pilih harian atau mingguan dan masa menggunakan `BF_TIME_ZONE`. Pembaca web menyokong CBZ/ZIP/CBR/RAR, EPUB, TXT/TEXT/Markdown; PDF belum disertakan. Kata laluan pentadbir pertama sekurang-kurangnya 12 aksara. `7343` ialah UI pelayar: kekalkan pada LAN dipercayai atau di belakang proksi songsang HTTPS dipercayai, dan jangan dedahkan melalui port forwarding penghala. `7342` ialah API HTTPS klien asli dipin; `7341` dikhaskan dan tidak boleh diterbitkan.

## Sandaran, kemas kini dan muat turun

Sandarkan seluruh folder config kekal; cache boleh dibuang dan pustaka kekal dalam folder NAS/hos sendiri. Sebelum kemas kini, muat turun sandaran BiblioFuse dari Settings dan simpan salinan config.

```sh
docker compose pull
docker compose up -d
```

Mencipta semula kontena dengan folder config sama tidak memadam akaun atau katalog; menanggalkan pustaka memadam katalog, anotasi dan kemajuan akar itu.

- **Imej Docker:** `ghcr.io/mlt-solutions/bibliofuse-nas:0.1.8`
- **Templat Docker dan Container Manager:** repositori ini
- **Nota versi dan aset muat turun:** GitHub Releases
- **Synology `.spk`:** GitHub Releases (`x86-64` DSM 7)
- **Gambaran produk dan aplikasi asli:** [bibliofuse.com](https://bibliofuse.com)

Imej Docker ialah beta awam. Kedua-dua kaedah hos menyokong penemuan asli Bonjour Wi-Fi setempat; Docker tidak menyediakan laluan asli Tailscale/manual.

## Bantuan

Mulakan dengan [pemasangan dan operasi Docker](docs/docker-install.ms.md), [tutorial Synology Container Manager](docs/synology-container-manager.ms.md), [pakej Synology asli](docs/synology-package.ms.md), [panduan prestasi](docs/performance.md), dan [saluran keluaran serta aplikasi asli](docs/releases-and-native-apps.md). Untuk bantuan, sertakan model NAS/hos, seni bina CPU, versi Docker, format buku dan log kontena terkini; jangan siarkan kata laluan, kunci peribadi, nama fail sensitif atau kandungan config.
