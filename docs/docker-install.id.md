[English](docker-install.md) | [Español](docker-install.es.md) | [Français](docker-install.fr.md) | [Nederlands](docker-install.nl.md) | [Português](docker-install.pt.md) | [Русский](docker-install.ru.md) | [简体中文](docker-install.zh-CN.md) | [日本語](docker-install.ja.md) | [한국어](docker-install.ko.md) | [Bahasa Indonesia](docker-install.id.md) | [Bahasa Melayu](docker-install.ms.md)

# Instalasi dan operasi Docker

## Bahasa browser

Setelah instalasi buka Settings dan pilih **Language**. Browser dapat mengikuti sistem atau memakai English, Spanish, French, Dutch, Portuguese, Russian, Simplified Chinese, Japanese, Korean, Indonesian, atau Malay. Pilihan hanya disimpan di browser dan tidak memengaruhi kontainer atau metadata pustaka.

## 1. Pilih folder

| Tujuan | Jalur kontainer | Akses | Cadangan |
| --- | --- | --- | --- |
| Akun, identitas, katalog, setelan | `/config` | Baca/tulis | Ya |
| Halaman dan thumbnail siap | `/cache` | Baca/tulis | Tidak |
| Pustaka buku | `/library` | Baca-saja | Terpisah |

Jalur kontainer tetap. `CONFIG_PATH`, `CACHE_PATH`, dan `LIBRARY_PATH` memilih folder sebenarnya pada host. Docker tidak menemukan pustaka sendiri: petakan folder sebelum pertama kali berjalan dan pilih folder yang akan dilampirkan di Settings.

## 2. Konfigurasi Compose

Unduh berkas di `docker/`, salin `.env.example` menjadi `.env`, edit dengan jalur absolut. Di Linux, cari ID pengguna dan grup numerik dengan:

```sh
id
```

Atur `PUID` dan `PGID` ke identitas yang dapat menulis config/cache dan membaca pustaka. BiblioFuse berjalan tanpa root.

## 3. Jalankan dan verifikasi

```sh
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail=100 bibliofuse
```

Buka `http://<server-ip>:7343`, buat administrator, lalu pilih **Attach library** di Settings. Pemilih menunjukkan mount **Library** serta subfoldernya, tetapi instalasi baru tidak memiliki akar terlampir sampai dipilih dan di-refresh. Jangan jalankan layanan Docker host-network ini bersama paket Synology native pada NAS yang sama: keduanya mengikat HTTPS native `7342` dan UI `7343`. Refresh pertama menelusuri seluruh pustaka; refresh berikutnya tetap memeriksa pohon folder tetapi memakai ulang metadata arsip tak berubah.

## 4. Tambahkan folder pustaka lain

Setiap Library Root harus menunjuk ke jalur yang ada di dalam kontainer. Tambahkan mount baca-saja ke `compose.yaml`, misalnya:

```yaml
volumes:
  - "/srv/books:/library:ro"
  - "/srv/manga:/books/manga:ro"
environment:
  BF_LIBRARY_BROWSE_ROOTS: >-
    [{"name":"Library","path":"/library"},{"name":"Manga","path":"/books/manga"}]
```

Buat ulang kontainer lalu pilih **Manga** di Settings → Attach library. Jangan ketik `/books/manga` atau jalur host `/srv/manga` di UI web. Gunakan **Change** saat mount diganti nama untuk menjaga identitas katalog; **Disable** mempertahankan data; **Detach** termasuk akar terakhir menghapus katalog, metadata, dan progres tanpa menghapus buku/folder.

## 5. Jadwal refresh

Settings mendukung Disabled, Daily, dan Weekly pada interval 30 menit. Atur `BF_TIME_ZONE` ke zona IANA valid, misalnya `Asia/Kuala_Lumpur`.

## 6. Pembaruan

Gunakan tag image bernomor untuk deployment terkendali. Cadangkan `/config`, lalu:

```sh
docker compose pull
docker compose up -d
docker image prune
```

`docker image prune` opsional dan menghapus data image yang tak dipakai, bukan buku.

## 7. Hentikan atau hapus instalasi

```sh
docker compose down
```

Ini menghapus kontainer dan jaringan, bukan folder config, cache, atau pustaka pada host. Untuk reset eksplisit: jalankan `docker compose down`, cadangkan folder `CONFIG_PATH` dan `CACHE_PATH`, ganti namanya sebagai cadangan, buat folder kosong dengan nama dan izin semula, kemudian jalankan `docker compose up -d` dan buat administrator baru. Jangan pernah mengganti nama, mengosongkan, atau menghapus `LIBRARY_PATH`; BiblioFuse memasangnya baca-saja.

## Akses di luar rumah dan pemecahan masalah

Jangan teruskan `7343` langsung dari router. Gunakan proxy balik HTTPS tepercaya dengan autentikasi dan sertifikat valid, atau VPN/Tailscale Anda. Akses browser Tailscale memakai alamat Tailscale NAS/server diikuti `:7343`; ini tidak menambahkan pairing Docker ke aplikasi iOS/visionOS rilis. Jika pemilih pustaka kosong, periksa `LIBRARY_PATH`, mount `/library:ro` dari `docker compose config`, izin baca `PUID:PGID`, lalu buat ulang kontainer setelah perubahan mount. **Permission denied** berarti perbaiki izin host atau `PUID`/`PGID`, bukan menjalankan root. Jeda halaman dapat berasal dari CPU/disk dan dekompresi; cache membantu pembacaan ulang. Untuk kontainer yang terus restart, periksa mount, izin config/cache, konflik port, dan `.env` dengan:

```sh
docker compose ps
docker compose logs --tail=200 bibliofuse
```

Tidak ada pemulihan kata sandi lewat email. Membuat ulang kontainer tidak mereset kata sandi karena verifier berada di `/config`; gunakan reset eksplisit di atas hanya jika akun, identitas, katalog, dan pengaturan BiblioFuse yang ada boleh hilang. Pustaka tetap tidak tersentuh.
