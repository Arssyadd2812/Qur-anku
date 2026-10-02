class Surah {
  final String name;
  final String nameId;
  final String nameEn;
  final String nameAr;
  final int numberOfAyah;
  final int numberOfSurah;
  final String place;
  final String recitation;
  final String type;

  Surah({
    required this.name,
    required this.nameId,
    required this.nameEn,
    required this.nameAr,
    required this.numberOfAyah,
    required this.numberOfSurah,
    required this.place,
    required this.recitation,
    required this.type,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      name: json['namaLatin'],
      nameId: json['arti'],
      nameEn: json['arti'],
      nameAr: json['nama'],
      numberOfAyah: json['jumlahAyat'],
      numberOfSurah: json['nomor'],
      place: json['tempatTurun'],
      recitation: '',
      type: json['tempatTurun'],
    );
  }
}