import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';

class SurahDetailPage extends StatefulWidget {
  final int nomor;
  SurahDetailPage({required this.nomor});

  @override
  _SurahDetailPageState createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  final Dio _dio = Dio();
  final AudioPlayer _audioPlayer = AudioPlayer();
  late Future<Surah> surahFuture;
  List<dynamic> ayatList = [];

  @override
  void initState() {
    super.initState();
    surahFuture = fetchSurahDetail();
  }

  Future<Surah> fetchSurahDetail() async {
    try {
      final response =
          await _dio.get('https://quran-api.santrikoding.com/api/surah/${widget.nomor}');
      setState(() {
        ayatList = response.data['ayat'] ?? [];
      });
      return Surah.fromJson(response.data);
    } catch (e) {
      print('Error fetching surah detail: $e');
      throw Exception('Gagal mengambil detail surah.');
    }
  }

  void playAudio(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Surah")),
      body: FutureBuilder<Surah>(
        future: surahFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("Data tidak ditemukan."));
          }

          final surah = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${surah.namaLatin} - ${surah.nama}",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("Arti: ${surah.arti}", style: TextStyle(fontSize: 16)),
                Text("Tempat Turun: ${surah.tempatTurun}",
                    style: TextStyle(fontSize: 16)),
                Text("Jumlah Ayat: ${surah.jumlahAyat}",
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => playAudio(surah.audio),
                  child: Text("Putar Audio"),
                ),
                SizedBox(height: 20),
                Column(
                  children: ayatList.map((ayat) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${ayat['ar']}",
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "${ayat['id']}",
                              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String audio;

  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
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
      audio: json['audio'] ?? '',
    );
  }
}
