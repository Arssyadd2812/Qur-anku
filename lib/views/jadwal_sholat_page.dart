import 'package:flutter/material.dart';
import '../models/jadwal_sholat.dart';
import '../models/api.dart';
import '../theme/app_theme.dart';
import '../utils/arabic_numbers.dart';

class JadwalSholatPage extends StatefulWidget {
  const JadwalSholatPage({super.key});

  @override
  State<JadwalSholatPage> createState() => _JadwalSholatPageState();
}

class _JadwalSholatPageState extends State<JadwalSholatPage> {
  final TextEditingController searchController = TextEditingController();

  List<Kota> hasilPencarian = [];
  bool isSearching = false;
  String? searchError;

  Kota? kotaTerpilih;
  JadwalSholat? jadwal;
  bool isLoadingJadwal = false;
  String? jadwalError;

  @override
  void initState() {
    super.initState();
    _loadDefaultCity();
  }

  Future<void> _loadDefaultCity() async {
    try {
      final hasil = await cariKota('malang');
      if (hasil.isNotEmpty) {
        // Utamakan "KOTA MALANG", kalau tidak ada, pakai hasil pertama saja
        final kotaMalang = hasil.firstWhere(
          (k) => k.lokasi.toUpperCase().contains('KOTA MALANG'),
          orElse: () => hasil.first,
        );
        await _pilihKota(kotaMalang);
      }
    } catch (e) {
      setState(() => jadwalError = 'Gagal memuat jadwal default');
    }
  }

  Future<void> _cari() async {
    final keyword = searchController.text.trim();
    if (keyword.isEmpty) return;

    setState(() {
      isSearching = true;
      searchError = null;
      hasilPencarian = [];
    });

    try {
      final result = await cariKota(keyword);
      setState(() => hasilPencarian = result);
    } catch (e) {
      setState(() => searchError = 'Gagal mencari kota');
    } finally {
      setState(() => isSearching = false);
    }
  }

  Future<void> _pilihKota(Kota kota) async {
    setState(() {
      kotaTerpilih = kota;
      isLoadingJadwal = true;
      jadwalError = null;
      jadwal = null;
      hasilPencarian = []; // tutup daftar hasil pencarian
    });

    try {
      final result = await getJadwalSholat(kota.id, DateTime.now());
      setState(() => jadwal = result);
    } catch (e) {
      setState(() => jadwalError = 'Gagal mengambil jadwal sholat');
    } finally {
      setState(() => isLoadingJadwal = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Sholat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari kota/kabupaten...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _cari(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isSearching ? null : _cari,
                  child: const Text('Cari'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (isSearching) const Center(child: CircularProgressIndicator()),
            if (searchError != null)
              Text(searchError!, style: const TextStyle(color: Colors.red)),

            if (hasilPencarian.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: hasilPencarian.length,
                  itemBuilder: (context, index) {
                    final kota = hasilPencarian[index];
                    return ListTile(
                      title: Text(kota.lokasi),
                      onTap: () => _pilihKota(kota),
                    );
                  },
                ),
              ),

            if (isLoadingJadwal)
              const Center(child: CircularProgressIndicator()),
            if (jadwalError != null)
              Text(jadwalError!, style: const TextStyle(color: Colors.red)),

            if (jadwal != null) Expanded(child: _JadwalCard(jadwal: jadwal!)),
          ],
        ),
      ),
    );
  }
}

class _JadwalCard extends StatelessWidget {
  final JadwalSholat jadwal;

  const _JadwalCard({required this.jadwal});

  Widget _baris(String label, String jam) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            toArabicNumerals(jam),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.only(top: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jadwal.lokasi,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                jadwal.daerah,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              Text(
                toArabicNumerals(jadwal.tanggal),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const Divider(height: 24),
              _baris('Imsak', jadwal.imsak),
              _baris('Subuh', jadwal.subuh),
              _baris('Terbit', jadwal.terbit),
              _baris('Dhuha', jadwal.dhuha),
              _baris('Dzuhur', jadwal.dzuhur),
              _baris('Ashar', jadwal.ashar),
              _baris('Maghrib', jadwal.maghrib),
              _baris('Isya', jadwal.isya),
            ],
          ),
        ),
      ),
    );
  }
}
