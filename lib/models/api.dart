import 'dart:convert';
import 'package:http/http.dart' as http;
import 'surah.dart';
import 'surah_detail.dart';
import 'jadwal_sholat.dart';

Future<List<Surah>> getSurahList() async {
  late http.Response response;
  try {
    response = await http.get(
      Uri.parse('https://equran.id/api/v2/surat'),
    );
  } catch (e) {
    throw Exception('Tidak dapat terhubung dengan server, gagal mengambil data surah');
  }

  if (response.statusCode == 200) {
    Map<String, dynamic> result = jsonDecode(response.body);
    List<dynamic> data = result['data'];
    return data.map((item) => Surah.fromJson(item)).toList();
  } else {
    throw Exception('Gagal mengambil data surah');
  }
}

Future<SurahDetail> getSurahDetail(int number) async {
  late http.Response response;
  try {
    response = await http.get(
      Uri.parse('https://equran.id/api/v2/surat/$number'),
    );
  } catch (e) {
    throw Exception('Tidak dapat terhubung dengan server, gagal mengambil detail surah');
  }

  if (response.statusCode == 200) {
    Map<String, dynamic> result = jsonDecode(response.body);
    Map<String, dynamic> data = result['data'];
    return SurahDetail.fromJson(data);
  } else {
    throw Exception('Gagal mengambil detail surah');
  }
}

Future<List<Kota>> cariKota(String keyword) async {
  late http.Response response;
  try {
    response = await http.get(
      Uri.parse('https://api.myquran.com/v2/sholat/kota/cari/$keyword'),
    );
  } catch (e) {
    throw Exception('Tidak dapat terhubung dengan server, gagal mencari kota');
  }

  if (response.statusCode == 200) {
    Map<String, dynamic> result = jsonDecode(response.body);
    List<dynamic> data = result['data'];
    return data.map((item) => Kota.fromJson(item)).toList();
  } else {
    throw Exception('Gagal mencari kota');
  }
}

Future<JadwalSholat> getJadwalSholat(String idKota, DateTime tanggal) async {
  final tahun = tanggal.year;
  final bulan = tanggal.month;
  final hari = tanggal.day;

  late http.Response response;
  try {
    response = await http.get(
      Uri.parse('https://api.myquran.com/v2/sholat/jadwal/$idKota/$tahun/$bulan/$hari'),
    );
  } catch (e) {
    throw Exception('Tidak dapat terhubung dengan server, gagal mengambil jadwal sholat');
  }

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return JadwalSholat.fromJson(data);
  } else {
    throw Exception('Gagal mengambil jadwal sholat');
  }
}

class BaseUrl {
  static String tambah = "http://192.168.137.1/biodata/create.php";
  static String lihat = "http://192.168.137.1/biodata/details.php";
  static String edit = "http://192.168.137.1/biodata/update.php";
  static String hapus = "http://192.168.137.1/biodata/delete.php";
  static String data = "http://192.168.137.1/biodata/list.php";
}