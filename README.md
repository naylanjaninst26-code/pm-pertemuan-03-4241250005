# pm-pertemuan-03-4241250005

Tugas Rutin 3 - Pemrograman Mobile: Kalkulator IP

- Nama: Nayla Anjani Nasution
- NIM: 4241250005
- Kelas: PSIK 24C

Program console Dart untuk menghitung IP (Indeks Prestasi). Pengguna memasukkan nama mata kuliah, SKS, dan nilai huruf berulang kali sampai nama mata kuliah dikosongkan. Program lalu menampilkan daftar yang sudah diurutkan, total SKS, IP beserta predikatnya, dan mata kuliah yang perlu diperbaiki.

## Cara Menjalankan

```
dart run
```

Tekan Enter tanpa mengetik apa-apa pada `Nama MK` untuk mengakhiri input.

## Fungsi

| Fungsi | Tugas |
|---|---|
| `tanya(label, {lebar = 8})` | menampilkan label dan membaca satu baris input (parameter bernama `lebar`) |
| `bacaSks(teks)` | mengubah teks menjadi SKS, melempar error bila bukan 1-6 |
| `bacaNilai(teks)` | memastikan nilai A-E, melempar error bila tidak valid |
| `hitungIp(daftar)` | menghitung IP memakai `fold` |
| `predikat(ip)` | menentukan predikat IP dengan switch expression |
| `perluDiperbaiki(daftar, {batas = 2})` | menyaring mata kuliah bernilai rendah memakai `where` (parameter bernama `batas`) |
| `bandingkan(a, b)` | fungsi pembanding untuk `sort` |

Bobot nilai: A = 4, B = 3, C = 2, D = 1, E = 0. Mata kuliah dianggap perlu diperbaiki jika bobotnya di bawah 2 (nilai D atau E).

## Sesi Uji

### Sesi 1: ada input salah (SKS bukan angka)

```
Nama MK : Pemograman Mobile
SKS     : 3
Nilai   : A
Nama MK : Jaringan Komputer
SKS     : tiga
Data diabaikan: SKS harus 1-6
Nama MK : Jaringan Komputer
SKS     : 3
Nilai   : B
Nama MK : Pemograman Web Modern
SKS     : 3
Nilai   : A
Nama MK : 

=== DAFTAR (nilai tertinggi dulu) ===
Pemograman Mobile       3 SKS  A
Pemograman Web Modern   3 SKS  A
Jaringan Komputer       3 SKS  B

Total SKS : 9
IP        : 3.67 (Sangat Memuaskan)
```

Input `tiga` ditolak dengan pesan yang jelas, lalu program menanyakan data berikutnya tanpa crash. Perhitungan manual: (3x4 + 3x4 + 3x3) / 9 = 33 / 9 = 3.67.

### Sesi 2: ada mata kuliah yang perlu diperbaiki

```
Nama MK : Pemograman Mobile
SKS     : 3
Nilai   : A
Nama MK : Fisika Dasar
SKS     : 2
Nilai   : D
Nama MK : 

=== DAFTAR (nilai tertinggi dulu) ===
Pemograman Mobile       3 SKS  A
Fisika Dasar            2 SKS  D

Total SKS : 5
IP        : 2.80 (Cukup)
Perlu diperbaiki: Fisika Dasar
```

Perhitungan manual: (3x4 + 2x1) / 5 = 14 / 5 = 2.80.

## Penjelasan Higher-Order Function (HOF)

HOF adalah fungsi yang menerima fungsi lain sebagai parameter. Yang dipakai di program ini:

- `fold`: menggabungkan semua elemen menjadi satu nilai. Dipakai di `hitungIp` untuk menjumlahkan total SKS dan total nilai mutu (SKS dikali bobot). IP = total mutu / total SKS.
- `where`: menyaring elemen yang memenuhi syarat. Dipakai di `perluDiperbaiki` untuk mengambil mata kuliah dengan bobot di bawah batas.
- `sort` dengan fungsi pembanding `bandingkan`: mengurutkan nilai tertinggi lebih dulu, dan bila nilainya sama diurutkan berdasarkan nama A-Z.
- `map`: mengubah tiap elemen. Dipakai untuk mengambil nama mata kuliah sebelum digabung dengan `join`.

## Penjelasan Error Handling

- Fungsi `bacaSks` dan `bacaNilai` melempar `FormatException` dengan `throw` bila input tidak valid. Fungsi hanya bertugas memeriksa dan melapor, tidak menampilkan pesan sendiri.
- `main` menangkap error itu dengan `try ... on FormatException catch (e)`, lalu menampilkan `Data diabaikan: ...` dan melanjutkan perulangan. Jadi input salah tidak membuat program berhenti.
- Yang ditangkap adalah `Exception` (kondisi yang bisa diantisipasi, seperti input salah). `Error` (bug logika) tidak ditangkap, melainkan harus diperbaiki di kodenya.
- `int.tryParse` dipakai, bukan `int.parse`, karena `tryParse` mengembalikan `null` untuk teks yang bukan angka sehingga bisa dicek dengan rapi.
- Null safety: `stdin.readLineSync() ?? ''` dan `bobot[...] ?? 0` menangani kemungkinan `null`. Operator `!` tidak dipakai.

## Pernyataan Penggunaan AI

Saya menggunakan Claude (AI) untuk membantu menyusun kerangka kode, menjelaskan konsep Dart (fungsi, parameter bernama, `fold`, `where`, `sort`, dan error handling), serta memandu langkah penggunaan Git dan GitHub. Kode saya jalankan sendiri di laptop, saya uji dengan dua sesi di atas, dan saya pastikan `dart format` serta `dart analyze` bersih sebelum commit.