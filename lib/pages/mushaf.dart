import 'package:emushaf/pages/surah_detail.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final String audio;

  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audio,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['nama_latin'] ?? '',
      jumlahAyat: json['jumlah_ayat'] ?? 0,
      tempatTurun: json['tempat_turun'] ?? '',
      arti: json['arti'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      audio: json['audio'] ?? '',
    );
  }
}

class SurahListPage extends StatefulWidget {
  @override
  _SurahListPageState createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  final Dio _dio = Dio();
  late Future<List<Surah>> surahFuture;

  @override
  void initState() {
    super.initState();
    surahFuture = fetchSurahList();
  }

  Future<List<Surah>> fetchSurahList() async {
    try {
      final response = await _dio.get('https://quran-api.santrikoding.com/api/surah');
      List<dynamic> data = response.data;
      return data.map((json) => Surah.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching surah list: $e');
      throw Exception('Gagal mengambil data surah.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Surah")),
      body: FutureBuilder<List<Surah>>(
        future: surahFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Data tidak ditemukan."));
          }
          
          final surahList = snapshot.data!;
          return ListView.builder(
            itemCount: surahList.length,
            itemBuilder: (context, index) {
              final surah = surahList[index];
              return ListTile(
                title: Text(surah.namaLatin),
                subtitle: Text("Ayat: ${surah.jumlahAyat}, Turun: ${surah.tempatTurun}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahDetailPage(nomor: surah.nomor),
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

