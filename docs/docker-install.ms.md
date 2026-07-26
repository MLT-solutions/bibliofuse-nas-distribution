[English](docker-install.md) | [Español](docker-install.es.md) | [Français](docker-install.fr.md) | [Nederlands](docker-install.nl.md) | [Português](docker-install.pt.md) | [Русский](docker-install.ru.md) | [简体中文](docker-install.zh-CN.md) | [日本語](docker-install.ja.md) | [한국어](docker-install.ko.md) | [Bahasa Indonesia](docker-install.id.md) | [Bahasa Melayu](docker-install.ms.md)

# Pemasangan dan operasi Docker

## Bahasa pelayar

Selepas pemasangan, buka Settings dan pilih **Language**. Pelayar boleh mengikut sistem atau menggunakan English, Spanish, French, Dutch, Portuguese, Russian, Simplified Chinese, Japanese, Korean, Indonesian, atau Malay. Pilihan hanya disimpan dalam pelayar dan tidak mempengaruhi kontena atau metadata pustaka.

## 1. Pilih folder

| Tujuan | Laluan kontena | Akses diperlukan | Sandaran |
| --- | --- | --- | --- |
| Akaun, identiti, katalog dan tetapan | `/config` | Baca/tulis | Ya |
| Halaman dan thumbnail yang disediakan | `/cache` | Baca/tulis | Tidak |
| Pustaka buku | `/library` | Baca sahaja | Berasingan |

Laluan kontena kekal sama. `CONFIG_PATH`, `CACHE_PATH` dan `LIBRARY_PATH` memilih folder sebenar pada hos. Docker tidak mencari pustaka sendiri: pasang folder sebelum pelancaran pertama, kemudian pilih folder untuk dilampirkan dalam Settings.

## 2. Konfigurasi Compose

Muat turun fail dalam `docker/`, salin `.env.example` kepada `.env`, dan edit dengan laluan mutlak. Dalam Linux, cari ID pengguna dan kumpulan angka dengan:

```sh
id
```

Tetapkan `PUID` dan `PGID` kepada identiti yang boleh menulis config/cache dan membaca pustaka. BiblioFuse berjalan tanpa root.

## 3. Mula dan sahkan

```sh
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail=100 bibliofuse
```

Buka `http://<server-ip>:7343`, cipta pentadbir, dan pilih **Attach library** dalam Settings. Pemilih menunjukkan mount **Library** yang dikonfigurasi serta subfolder, tetapi pemasangan baharu tiada akar dilampirkan sehingga dipilih dan di-refresh. Jangan jalankan perkhidmatan Docker host-network ini bersama pakej Synology asli pada NAS yang sama: kedua-duanya mengikat HTTPS asli `7342` dan UI `7343`. Refresh pertama menelusuri keseluruhan pustaka; seterusnya masih memeriksa pepohon folder tetapi menggunakan semula metadata arkib yang tidak berubah.

## 4. Tambah folder pustaka lain

Setiap Library Root mesti menunjuk kepada laluan dalam kontena. Tambahkan mount baca sahaja ke `compose.yaml`, contohnya:

```yaml
volumes:
  - "/srv/books:/library:ro"
  - "/srv/manga:/books/manga:ro"
environment:
  BF_LIBRARY_BROWSE_ROOTS: >-
    [{"name":"Library","path":"/library"},{"name":"Manga","path":"/books/manga"}]
```

Bina semula kontena dan pilih **Manga** dalam Settings → Attach library. Jangan taip `/books/manga` atau laluan hos `/srv/manga` dalam UI web. **Change** mengekalkan identiti katalog jika mount ditukar nama; **Disable** menyimpan data; **Detach**, termasuk akar terakhir, memadam katalog, metadata dan kemajuan tanpa memadam buku/folder.

## 5. Jadual Refresh

Settings menyokong Disabled, Daily dan Weekly pada sela 30 minit. Tetapkan `BF_TIME_ZONE` kepada zon IANA yang sah seperti `Asia/Kuala_Lumpur`.

## 6. Kemas kini

Gunakan tag imej bernombor untuk penggunaan terkawal. Sandarkan `/config`, kemudian jalankan:

```sh
docker compose pull
docker compose up -d
docker image prune
```

`docker image prune` adalah pilihan dan hanya membuang data imej tidak digunakan, bukan buku.

## 7. Henti atau nyahpasang

```sh
docker compose down
```

Ini membuang kontena dan rangkaian, bukan folder config, cache atau pustaka pada hos. Untuk tetapan semula jelas: jalankan `docker compose down`, sandarkan folder `CONFIG_PATH` dan `CACHE_PATH`, namakannya semula sebagai sandaran, cipta folder kosong dengan nama dan kebenaran asal, kemudian jalankan `docker compose up -d` dan cipta pentadbir baharu. Jangan sesekali menamakan semula, mengosongkan atau memadam `LIBRARY_PATH`; BiblioFuse memasangnya baca sahaja.

## Akses luar rumah dan penyelesaian masalah

Jangan teruskan `7343` terus daripada penghala. Gunakan proksi songsang HTTPS dipercayai dengan pengesahan dan sijil sah, atau VPN/Tailscale sendiri. Akses pelayar Tailscale menggunakan alamat Tailscale NAS/pelayan diikuti `:7343`; ini tidak menambah pairing Docker kepada aplikasi iOS/visionOS yang dikeluarkan. Jika pemilih pustaka kosong, semak `LIBRARY_PATH`, mount `/library:ro` daripada `docker compose config`, kebenaran baca `PUID:PGID`, dan bina semula kontena selepas perubahan mount. **Permission denied** bermaksud betulkan kebenaran hos atau `PUID`/`PGID`, bukan jalankan root. Jeda halaman boleh berpunca daripada CPU/disk dan nyahmampat; cache membantu bacaan berulang. Untuk kontena yang berulang kali mula semula, semak mount, kebenaran config/cache, konflik port dan `.env` dengan:

```sh
docker compose ps
docker compose logs --tail=200 bibliofuse
```

Tiada pemulihan kata laluan e-mel. Mencipta semula kontena tidak menetapkan semula kata laluan kerana pengesah berada dalam `/config`; gunakan tetapan semula jelas di atas hanya jika akaun, identiti, katalog dan tetapan BiblioFuse sedia ada boleh hilang. Pustaka kekal tidak disentuh.
