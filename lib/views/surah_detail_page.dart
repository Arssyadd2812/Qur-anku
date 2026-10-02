import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/surah_detail.dart';
import '../models/api.dart';
import '../theme/app_theme.dart';
import '../utils/arabic_numbers.dart';

class SurahDetailPage extends StatefulWidget {
  final int numberOfSurah;

  const SurahDetailPage({super.key, required this.numberOfSurah});

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late Future<SurahDetail> futureSurahDetail;
  final AudioPlayer audioPlayer = AudioPlayer();

  // null = tidak ada yang sedang diputar.
  // 'surah' = audio surah penuh sedang diputar.
  // 'ayah_<nomor>' = audio ayat tertentu sedang diputar.
  String? playingId;

  @override
  void initState() {
    super.initState();
    futureSurahDetail = getSurahDetail(widget.numberOfSurah);

    // Kalau audio selesai sendiri, reset ikon play/pause.
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() => playingId = null);
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String _ayahAudioUrl(int surahNumber, int ayahNumber) {
    final s = surahNumber.toString().padLeft(3, '0');
    final a = ayahNumber.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/Alafasy_128kbps/$s$a.mp3';
  }

  Future<void> _toggleAudio(String id, String url) async {
    if (playingId == id) {
      await audioPlayer.stop();
      setState(() => playingId = null);
    } else {
      await audioPlayer.stop();
      await audioPlayer.play(UrlSource(url));
      setState(() => playingId = id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<SurahDetail>(
        future: futureSurahDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'.replaceFirst('Exception: ', '')));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          final surah = snapshot.data!;

          // Pisahkan Basmalah dari ayat 1 (kecuali Al-Fatihah), berdasarkan
          // fakta bahwa Basmalah selalu 4 kata pertama.
          String? bismillahText;
          List<Verse> displayVerses = surah.verses;

          if (surah.numberOfSurah != 1 && surah.verses.isNotEmpty) {
            final firstVerse = surah.verses[0];
            final words = firstVerse.text.trim().split(RegExp(r'\s+'));

            if (words.length > 4) {
              bismillahText = words.sublist(0, 4).join(' ');
              final strippedText = words.sublist(4).join(' ');
              final strippedVerse = Verse(
                number: firstVerse.number,
                text: strippedText,
                translationId: firstVerse.translationId,
              );
              displayVerses = [strippedVerse, ...surah.verses.sublist(1)];
            }
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('${surah.name} (${surah.nameId})'),
                pinned: true,
                actions: [
                  if (surah.recitations.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        playingId == 'surah'
                            ? Icons.pause_circle
                            : Icons.play_circle,
                      ),
                      tooltip: 'Putar surah penuh',
                      onPressed: () =>
                          _toggleAudio('surah', surah.recitations[0].audioUrl),
                    ),
                ],
              ),
              if (bismillahText != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      bismillahText,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final verse = displayVerses[index];
                  final ayahId = 'ayah_${verse.number}';
                  final isPlayingThisAyah = playingId == ayahId;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              iconSize: 22,
                              icon: Icon(
                                isPlayingThisAyah
                                    ? Icons.pause_circle_outline
                                    : Icons.play_circle_outline,
                              ),
                              onPressed: () => _toggleAudio(
                                ayahId,
                                _ayahAudioUrl(
                                  surah.numberOfSurah,
                                  verse.number,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            CircleAvatar(
                              radius: 14,
                              child: Text(
                                toArabicNumerals(verse.number),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                verse.text,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 22,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          verse.translationId,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Divider(height: 24),
                      ],
                    ),
                  );
                }, childCount: displayVerses.length),
              ),
            ],
          );
        },
      ),
    );
  }
}
