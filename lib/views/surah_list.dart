import 'package:flutter/material.dart';
import '../models/surah.dart';
import '../models/api.dart';
import 'surah_detail_page.dart';
import '../utils/arabic_numbers.dart';

class SurahListPage extends StatefulWidget {
  const SurahListPage({super.key});

  @override
  State<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  late Future<List<Surah>> futureSurahList;

  @override
  void initState() {
    super.initState();
    futureSurahList = getSurahList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Al-Quran')),
      body: FutureBuilder<List<Surah>>(
        future: futureSurahList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
           return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data surah tidak ditemukan'));
          }

          final surahList = snapshot.data!;
          return ListView.builder(
            itemCount: surahList.length,
            itemBuilder: (context, index) {
              final surah = surahList[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(toArabicNumerals(surah.numberOfSurah)),
                ),
                title: Text(surah.name),
                subtitle: Text(
                  '${surah.nameId} • ${toArabicNumerals(surah.numberOfAyah)} Ayat • ${surah.place}',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SurahDetailPage(numberOfSurah: surah.numberOfSurah),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
