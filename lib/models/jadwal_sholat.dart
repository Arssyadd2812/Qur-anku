class Kota {
  final String id;
  final String lokasi;

  Kota({required this.id, required this.lokasi});

  factory Kota.fromJson(Map<String, dynamic> json) {
    return Kota(
      id: json['id'],
      lokasi: json['lokasi'],
    );
  }
}

class JadwalSholat {
  final String lokasi;
  final String daerah;
  final String tanggal;
  final String imsak;
  final String subuh;
  final String terbit;
  final String dhuha;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;

  JadwalSholat({
    required this.lokasi,
    required this.daerah,
    required this.tanggal,
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dhuha,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });

  factory JadwalSholat.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final jadwal = data['jadwal'];
    return JadwalSholat(
      lokasi: data['lokasi'],
      daerah: data['daerah'],
      tanggal: jadwal['tanggal'],
      imsak: jadwal['imsak'],
      subuh: jadwal['subuh'],
      terbit: jadwal['terbit'],
      dhuha: jadwal['dhuha'],
      dzuhur: jadwal['dzuhur'],
      ashar: jadwal['ashar'],
      maghrib: jadwal['maghrib'],
      isya: jadwal['isya'],
    );
  }
}