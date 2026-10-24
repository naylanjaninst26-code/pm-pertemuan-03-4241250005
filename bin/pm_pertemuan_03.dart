import 'dart:io';

// Satu baris data mata kuliah (Record)
typedef MataKuliah = ({String nama, int sks, String nilai});

// Bobot nilai huruf
const bobot = {'A': 4, 'B': 3, 'C': 2, 'D': 1, 'E': 0};

// Fungsi 1: tampilkan label, lalu baca satu baris input.
// {lebar} adalah parameter bernama dengan nilai default.
String tanya(String label, {int lebar = 8}) {
  stdout.write('${label.padRight(lebar)}: ');
  return (stdin.readLineSync() ?? '').trim(); // null diganti teks kosong
}

// Fungsi 2: ubah teks jadi SKS, lempar error bila tidak valid
int bacaSks(String teks) {
  final sks = int.tryParse(teks);
  if (sks == null || sks < 1 || sks > 6) {
    throw FormatException('SKS harus 1-6');
  }
  return sks;
}

// Fungsi 3: pastikan nilai huruf valid, lempar error bila tidak
String bacaNilai(String teks) {
  final nilai = teks.toUpperCase();
  if (!bobot.containsKey(nilai)) {
    throw FormatException('Nilai harus A, B, C, D, atau E');
  }
  return nilai;
}

// Fungsi 4: hitung IP memakai fold
double hitungIp(List<MataKuliah> daftar) {
  final totalSks = daftar.fold<int>(0, (s, mk) => s + mk.sks);
  if (totalSks == 0) return 0;
  final totalMutu = daftar.fold<int>(
    0,
    (s, mk) => s + mk.sks * (bobot[mk.nilai] ?? 0),
  );
  return totalMutu / totalSks;
}

// Fungsi 5: predikat IP (switch expression)
String predikat(double ip) => switch (ip) {
  >= 3.5 => 'Sangat Memuaskan',
  >= 3.0 => 'Memuaskan',
  >= 2.0 => 'Cukup',
  _ => 'Kurang',
};

// Fungsi 6: MK yang perlu diperbaiki (bobot di bawah {batas}) memakai where
List<MataKuliah> perluDiperbaiki(List<MataKuliah> daftar, {int batas = 2}) =>
    daftar.where((mk) => (bobot[mk.nilai] ?? 0) < batas).toList();

// Fungsi 7: pembanding untuk sort (nilai tertinggi dulu, lalu nama A-Z)
int bandingkan(MataKuliah a, MataKuliah b) {
  final selisih = (bobot[b.nilai] ?? 0).compareTo(bobot[a.nilai] ?? 0);
  return selisih != 0 ? selisih : a.nama.compareTo(b.nama);
}

void main() {
  final daftar = <MataKuliah>[];

  while (true) {
    final nama = tanya('Nama MK');
    if (nama.isEmpty) break; // nama kosong = selesai input

    try {
      final sks = bacaSks(tanya('SKS'));
      final nilai = bacaNilai(tanya('Nilai'));
      daftar.add((nama: nama, sks: sks, nilai: nilai));
    } on FormatException catch (e) {
      print('Data diabaikan: ${e.message}');
    }
  }

  if (daftar.isEmpty) {
    print('\nTidak ada data valid.');
    return;
  }

  daftar.sort(bandingkan);

  print('\n=== DAFTAR (nilai tertinggi dulu) ===');
  for (final mk in daftar) {
    print('${mk.nama.padRight(24)}${mk.sks} SKS  ${mk.nilai}');
  }

  final totalSks = daftar.fold<int>(0, (s, mk) => s + mk.sks);
  final ip = hitungIp(daftar);
  print('\nTotal SKS : $totalSks');
  print('IP        : ${ip.toStringAsFixed(2)} (${predikat(ip)})');

  final perbaiki = perluDiperbaiki(daftar);
  if (perbaiki.isNotEmpty) {
    print('Perlu diperbaiki: ${perbaiki.map((mk) => mk.nama).join(', ')}');
  }
}
