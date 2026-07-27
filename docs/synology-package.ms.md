[English](synology-package.md) | [Español](synology-package.es.md) | [Français](synology-package.fr.md) | [Nederlands](synology-package.nl.md) | [Português](synology-package.pt.md) | [Русский](synology-package.ru.md) | [简体中文](synology-package.zh-CN.md) | [日本語](synology-package.ja.md) | [한국어](synology-package.ko.md) | [Bahasa Indonesia](synology-package.id.md) | [Bahasa Melayu](synology-package.ms.md)

# Pakej Synology asli

## Status semasa

Pakej x86-64 `0.1.0-0021` ialah keluaran DSM 7. Nama folder kongsi, alamat NAS dan laluan pustaka tidak dimasukkan ke dalam pakej. Buku kekal dalam folder kongsi DSM sedia ada; BiblioFuse tidak dapat memberi akses kepada dirinya atau mengubah kebenaran DSM. Settings menerangkan pemberian akses baca sahaja kepada akaun pakej terhad; Attach dan Detach hanya mengawal pengindeksan dan tidak memadam fail pustaka. Ini bukan kontena: Package Center mengurus kitar hayat, ikon menu utama dan akaun dalaman sistem yang terhad.

## Bahasa pelayar

Dalam Settings, pilih **Language** untuk mengikut bahasa sistem atau memilih English, Spanish, French, Dutch, Portuguese, Russian, Simplified Chinese, Japanese, Korean, Indonesian, atau Malay. Pilihan disimpan dalam pelayar itu sahaja dan kekal selepas naik taraf pakej.

## Pasang dan beri akses

1. Pasang `.spk` x86-64 melalui Package Center → Manual Install.
2. Buka BiblioFuse NAS dan cipta pentadbir sekurang-kurangnya 12 aksara.
3. Buka Settings → **Show the 6 steps**, atau lakukan langkah berikut:
   1. Buka DSM **Control Panel** → **Shared Folder**.
   2. Pilih folder kongsi sedia ada yang mengandungi buku dan pilih **Edit**.
   3. Buka **Permissions**.
   4. Tukar menu lungsur kepada **System internal user**.
   5. Cari `BiblioFuseNAS`, berikan **Read only**, dan simpan.
   6. Kembali ke BiblioFuse → **Attach library** → **Refresh access**, kemudian pilih perkongsian atau subfolder buku.
4. Pilih **Refresh books**.

Tidak perlu menaip laluan `/volume1/...` atau `/var/packages/...`, dan tiada mula semula pakej diperlukan selepas kebenaran diberikan.

## Kitar hayat data

- **Disable:** simpan katalog dan benarkan ia diaktifkan semula.
- **Detach:** padam katalog, metadata dan kemajuan membaca BiblioFuse bagi lampiran tersebut.
- **Upgrade package:** simpan akaun, identiti sijil, tetapan, katalog dan cache.
- **Uninstall package:** padam semua data milik BiblioFuse: akaun, kata laluan, identiti, tetapan, katalog, log dan cache.
- **Library:** sentiasa berada di luar data pakej dan tidak pernah dipadam.

Naik taraf daripada pakej ujian peribadi v8 memindahkan alias package-share ke laluan volume DSM biasa sambil mengekalkan identiti akar.

## Rangkaian dan sempadan sokongan

- `7343/tcp`: pustaka dan pembaca pelayar percuma pada LAN dipercayai.
- `7342/tcp`: pendengar klien asli HTTPS dipin.
- `7341/tcp`: dikhaskan dan tidak pernah digunakan.

Semasa mula, pakej memperoleh alamat LAN peribadi aktif daripada DSM dan mengiklankan Bonjour terus daripada hos NAS. Jika DSM Tailscale aktif, alamat `tailscale0` disertakan sebagai cadangan sambungan manual pilihan. Respons JSON asli besar mengandungi `Content-Length` untuk keserasian pengangkutan Apple dipin yang dikeluarkan. Pairing Wi-Fi setempat aplikasi iOS/visionOS yang dikeluarkan disokong melalui Bonjour dan HTTPS dipin; penstriman asli masih tertakluk pada sempadan Premium aplikasi asli.

## Seni bina

Pakej awal menyokong Synology x86-64. ARM64 belum dibina atau diuji; semak seni bina CPU NAS sebelum memuat turun.
