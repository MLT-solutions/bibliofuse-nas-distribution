# Panduan Synology Container Manager

[English](synology-container-manager.md) | [Español](synology-container-manager.es.md) | [Français](synology-container-manager.fr.md) | [Nederlands](synology-container-manager.nl.md) | [Português](synology-container-manager.pt.md) | [Русский](synology-container-manager.ru.md) | [简体中文](synology-container-manager.zh-CN.md) | [日本語](synology-container-manager.ja.md) | [한국어](synology-container-manager.ko.md) | [Bahasa Indonesia](synology-container-manager.id.md) | [Bahasa Melayu](synology-container-manager.ms.md)

Panduan ini memasang pelayan Docker percuma dan UI web melalui Container Manager. Untuk pakej DSM natif yang diuji secara berasingan, lihat [panduan pakej Synology](synology-package.ms.md).

## Keperluan

- DSM 7 dengan Container Manager
- Model Intel/AMD 64-bit atau ARM64 yang disokong oleh imej yang diterbitkan
- Kebenaran untuk mencipta folder kongsi dan projek Container Manager

## 1. Cipta folder

Dalam File Station, cipta:

```text
docker/bibliofuse/config
docker/bibliofuse/cache
```

Projek memasang DSM `/volume1` sebagai baca sahaja. Settings akan menyenaraikan folder kongsi sebenar yang boleh dibaca oleh akaun DSM yang dikonfigurasikan; tiada satupun dilampirkan secara automatik.

## 2. Pilih pengguna kontena

Kontena perlu menulis config/cache dan membaca pustaka. Gunakan UID dan GID berangka bagi akaun DSM khusus yang mempunyai kebenaran tersebut. Melalui SSH:

```sh
id <username>
```

Nilai lalai `1026:100` hanyalah contoh dan mungkin tidak sepadan dengan NAS anda.

## 3. Cipta projek

1. Muat turun `synology/compose.yaml`.
2. Buka Container Manager → Project → Create.
3. Pilih nama projek seperti `bibliofuse`.
4. Muat naik atau tampal fail Compose.
5. Tetapkan:
   - `CONFIG_PATH`, contohnya `/volume1/docker/bibliofuse/config`
   - `CACHE_PATH`, contohnya `/volume1/docker/bibliofuse/cache`
   - `PUID` dan `PGID`
   - `BF_TIME_ZONE`, contohnya `Asia/Kuala_Lumpur`
6. Bina/mulakan projek.

## 4. Persediaan pertama

Buka:

```text
http://<nas-ip>:7343
```

Cipta kata laluan pentadbir sekurang-kurangnya 12 aksara. Dalam Settings, pilih **Attach library**, pilih folder kongsi DSM yang dipaparkan atau subfolder buku, kemudian pilih Refresh. Tiada laluan DSM atau kontena perlu ditaip. Pemilih menapis perkongsian yang tidak boleh dibaca menggunakan UID/GID kontena yang dipilih.

Root boleh diubah, dinyahdayakan atau dibuang. Nyahdaya mengekalkan data katalog. Buang akan mengosongkan katalog BiblioFuse, metadata dan kemajuan membaca root itu tanpa memadam fail atau folder; membuang root terakhir masih meninggalkan pustaka kosong yang sah.

## 5. Membaca dan muat semula

Refresh memeriksa keseluruhan pepohon yang dipasang dan mengindeks buku baharu, berubah, dinamakan semula atau dibuang. Muat semula automatik dinyahdayakan secara lalai; Settings boleh menjadualkan muat semula harian atau mingguan.

Mod komik berterusan memuatkan halaman secara beransur-ansur. Pada DS923+ atau NAS yang serupa, sedikit lengah pemuatan masih boleh berlaku bagi halaman arkib yang tidak dicache. Hos Mac atau PC biasanya memberi pengalaman penstriman natif yang lebih lancar kerana CPUnya boleh menyahmampat dan menyediakan halaman dengan lebih cepat.

## 6. Sandaran dan naik taraf

- Sertakan folder config dalam Hyper Backup.
- Cache boleh dikecualikan.
- Muat turun sandaran BiblioFuse dalam Settings sebelum naik taraf.
- Simpan sandaran config terdahulu kerana migrasi pangkalan data mungkin hanya boleh bergerak ke hadapan.
- Tarik imej baharu dan cipta semula projek tanpa mengubah pemetaan folder.

Jangan sekali-kali memilih pilihan nyahpasang yang memadam folder config atau pustaka yang dipetakan.

Untuk tetapan semula kilang Container Manager, hentikan projek, sandarkan dan namakan semula folder config serta cache yang dikonfigurasikan, cipta folder kosong baharu dengan nama dan kebenaran asal, kemudian mulakan semula. Jangan sekali-kali sertakan folder pustaka dalam pembersihan ini.

## 7. Sempadan rangkaian

- `7343`: UI pelayar percuma pada LAN yang dipercayai
- `7342`: API HTTPS klien natif yang dipinkan, ditemui melalui Bonjour pada Wi-Fi setempat
- `7341`: jangan dedahkan

Container Manager dan `.spk` natif berpasangan dengan app iOS/visionOS yang diterbitkan pada Wi-Fi setempat melalui Bonjour. Penstriman natif masih tertakluk pada sempadan ciri Premium app natif; Docker tidak menyediakan laluan natif manual/Tailscale.

Jangan jalankan projek Container Manager ini bersama pakej BiblioFuse Synology natif pada NAS yang sama. Kedua-dua perkhidmatan mengikat `7342` dan `7343`; pilih satu kaedah pemasangan.
