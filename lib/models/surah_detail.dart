class Verse {
  final int number;
  final String text;
  final String translationId;

  Verse({
    required this.number,
    required this.text,
    required this.translationId,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      number: json['nomorAyat'],
      text: json['teksArab'],
      translationId: json['teksIndonesia'],
    );
  }
}

class Recitation {
  final String name;
  final String audioUrl;

  Recitation({required this.name, required this.audioUrl});
}

class SurahDetail {
  final String name;
  final String nameId;
  final int numberOfSurah;
  final int numberOfAyah;
  final String place;
  final String type;
  final List<Verse> verses;
  final List<Recitation> recitations;

  SurahDetail({
    required this.name,
    required this.nameId,
    required this.numberOfSurah,
    required this.numberOfAyah,
    required this.place,
    required this.type,
    required this.verses,
    required this.recitations,
  });

 factory SurahDetail.fromJson(Map<String, dynamic> json) {
    var verseList = json['ayat'] as List;
    int nomorSurah = json['nomor'];
    String nomorPadded = nomorSurah.toString().padLeft(3, '0');

    return SurahDetail(
      name: json['namaLatin'],
      nameId: json['arti'],
      numberOfSurah: nomorSurah,
      numberOfAyah: json['jumlahAyat'],
      place: json['tempatTurun'],
      type: json['tempatTurun'],
      verses: verseList.map((v) => Verse.fromJson(v)).toList(),
      recitations: [
        Recitation(
          name: 'Mishari Rashid al-\'Afasy',
          audioUrl:
              'https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/$nomorPadded.mp3',
        ),
      ],
    );
  }
}